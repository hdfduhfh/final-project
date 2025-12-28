package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.math.BigDecimal;
import java.util.ArrayList;

@Stateless
public class Order1Facade extends AbstractFacade<Order1> implements Order1FacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected jakarta.persistence.EntityManager getEntityManager() {
        return em;
    }

    public Order1Facade() {
        super(Order1.class);
    }

    public List<Order1> findByUser(User user) {
        return em.createQuery(
                "SELECT o FROM Order1 o WHERE o.userID = :user ORDER BY o.createdAt DESC",
                Order1.class
        ).setParameter("user", user).getResultList();
    }

    /**
     * ✅ TÍNH TỔNG DOANH THU THỰC TẾ
     * 
     * Công thức: Tổng tiền đã thu - Tổng tiền hoàn lại
     * 
     * QUAN TRỌNG: 
     * - Lấy TẤT CẢ đơn có PaymentStatus = 'PAID' (Kể cả đã hủy)
     * - Trừ đi tổng RefundAmount (Tiền hoàn lại khách)
     */
    @Override
    public BigDecimal getTotalRevenue() {
        try {
            // ✅ BƯỚC 1: Tính tổng tiền đã thu (Tất cả đơn PAID - KỂ CẢ ĐÃ HỦY)
            // Không được WHERE status != 'CANCELLED' vì sẽ thiếu tiền
            BigDecimal totalCollected = em.createQuery(
                "SELECT COALESCE(SUM(o.finalAmount), 0) " +
                "FROM Order1 o " +
                "WHERE o.paymentStatus = 'PAID'",
                BigDecimal.class
            ).getSingleResult();
            
            // ✅ BƯỚC 2: Tính tổng tiền đã hoàn lại (Chỉ vé đã hủy)
            BigDecimal totalRefunded = em.createQuery(
                "SELECT COALESCE(SUM(o.refundAmount), 0) " +
                "FROM Order1 o " +
                "WHERE o.status = 'CANCELLED' " +
                "AND o.refundAmount IS NOT NULL " +
                "AND o.refundAmount > 0",
                BigDecimal.class
            ).getSingleResult();
            
            // ✅ BƯỚC 3: Doanh thu thực = Tiền thu - Tiền hoàn
            BigDecimal actualRevenue = totalCollected.subtract(totalRefunded);
            
            System.out.println("=== TÍNH DOANH THU ===");
            System.out.println("Tổng tiền thu (PAID):  " + totalCollected + " VNĐ");
            System.out.println("Tổng tiền hoàn (CANCELLED): " + totalRefunded + " VNĐ");
            System.out.println("Doanh thu thực:        " + actualRevenue + " VNĐ");
            
            return actualRevenue;
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi tính doanh thu:");
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }

    /**
     * ✅ TÍNH TỔNG GIẢM GIÁ
     */
    @Override
    public BigDecimal getTotalDiscount() {
        return em.createQuery(
                "SELECT COALESCE(SUM(o.discountAmount), 0) "
                + "FROM Order1 o WHERE o.paymentStatus = 'PAID'",
                BigDecimal.class
        ).getSingleResult();
    }

    /**
     * ✅ TÍNH TỔNG TIỀN ĐÃ HOÀN LẠI
     */
    @Override
    public BigDecimal getTotalRefund() {
        return em.createQuery(
                "SELECT COALESCE(SUM(o.refundAmount), 0) "
                + "FROM Order1 o WHERE o.refundAmount IS NOT NULL AND o.refundAmount > 0",
                BigDecimal.class
        ).getSingleResult();
    }
    
    /**
     * ✅ TÍNH TỔNG PHÍ HỦY VÉ (Doanh thu từ phí hủy)
     */
    @Override
    public BigDecimal getTotalCancellationFee() {
        try {
            // Phí hủy = Tiền đã trả - Tiền hoàn lại
            // Ví dụ: Trả 500k, hoàn 350k → Phí = 150k
            BigDecimal totalFee = em.createQuery(
                "SELECT COALESCE(SUM(o.finalAmount - o.refundAmount), 0) " +
                "FROM Order1 o " +
                "WHERE o.status = 'CANCELLED' " +
                "AND o.refundAmount IS NOT NULL " +
                "AND o.refundAmount > 0",
                BigDecimal.class
            ).getSingleResult();
            
            return totalFee;
        } catch (Exception e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
    }

    /**
     * ✅ ĐẾM SỐ ĐơN ĐÃ HỦY
     */
    @Override
    public Long countCancelledOrder() {
        return em.createQuery(
                "SELECT COUNT(o) FROM Order1 o WHERE o.status = 'CANCELLED'",
                Long.class
        ).getSingleResult();
    }

    /**
     * ✅ LẤY DANH SÁCH ĐƠN ĐÃ THANH TOÁN
     */
    @Override
    public List<Order1> findPaidOrders() {
        return em.createQuery(
                "SELECT o FROM Order1 o WHERE o.paymentStatus = 'PAID' ORDER BY o.paidAt",
                Order1.class
        ).getResultList();
    }

    /**
     * ✅ THỐNG KÊ DOANH THU THEO NGÀY (CHO BIỂU ĐỒ)
     * 
     * LƯU Ý: Doanh thu = Tiền thu - Tiền hoàn trong ngày
     * Trả về: [Ngày, Tổng thu, Tổng hoàn, Doanh thu thực]
     */
    @Override
    public List<Object[]> getRevenueByDate() {
        System.out.println("--- BẮT ĐẦU LẤY DỮ LIỆU THỐNG KÊ ---");

        // ✅ LẤY 7 NGÀY GẦN NHẤT CÓ GIAO DỊCH (KHÔNG CẦN STATUS = 'PAID')
        String sql = 
            "SELECT TOP 7 " +
            "   CAST(o.CreatedAt AS DATE) as ReportDate, " +
            "   COALESCE(SUM(CASE WHEN o.PaymentStatus = 'PAID' THEN o.FinalAmount ELSE 0 END), 0) as TotalCollected, " +
            "   COALESCE(SUM(CASE WHEN o.Status = 'CANCELLED' AND o.RefundAmount > 0 THEN o.RefundAmount ELSE 0 END), 0) as TotalRefunded, " +
            "   COALESCE(SUM(CASE WHEN o.PaymentStatus = 'PAID' THEN o.FinalAmount ELSE 0 END), 0) - " +
            "   COALESCE(SUM(CASE WHEN o.Status = 'CANCELLED' AND o.RefundAmount > 0 THEN o.RefundAmount ELSE 0 END), 0) as ActualRevenue " +
            "FROM [Order] o " +
            "GROUP BY CAST(o.CreatedAt AS DATE) " +
            "ORDER BY ReportDate DESC";

        try {
            List<Object[]> result = getEntityManager()
                .createNativeQuery(sql)
                .getResultList();

            if (result.isEmpty()) {
                System.out.println("⚠️ Không có dữ liệu doanh thu");
            } else {
                System.out.println("✅ Tìm thấy " + result.size() + " ngày có doanh thu");
                
                // In thử kết quả
                for (Object[] row : result) {
                    System.out.println(String.format(
                        "Ngày: %s | Thu: %s | Hoàn: %s | Thực: %s",
                        row[0], row[1], row[2], row[3]
                    ));
                }
            }

            return result;
        } catch (Exception e) {
            System.err.println("❌ LỖI SQL THỐNG KÊ:");
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * ✅ THỐNG KÊ THEO THÁNG
     */
    @Override
    public List<Object[]> getRevenueByMonth() {
        String sql = 
            "SELECT " +
            "   YEAR(o.CreatedAt) as Year, " +
            "   MONTH(o.CreatedAt) as Month, " +
            "   COALESCE(SUM(CASE WHEN o.PaymentStatus = 'PAID' THEN o.FinalAmount ELSE 0 END), 0) - " +
            "   COALESCE(SUM(CASE WHEN o.Status = 'CANCELLED' AND o.RefundAmount > 0 THEN o.RefundAmount ELSE 0 END), 0) as ActualRevenue " +
            "FROM [Order] o " +
            "GROUP BY YEAR(o.CreatedAt), MONTH(o.CreatedAt) " +
            "ORDER BY Year DESC, Month DESC";

        try {
            return getEntityManager().createNativeQuery(sql).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * ✅ KIỂM TRA USER ĐÃ MUA VÉ SCHEDULE NÀY CHƯA
     */
    @Override
    public boolean hasUserPurchasedSchedule(User user, ShowSchedule schedule) {
        try {
            Long count = em.createQuery(
                "SELECT COUNT(od) FROM OrderDetail od " +
                "WHERE od.orderID.userID = :user " +
                "AND od.scheduleID = :schedule " +
                "AND od.orderID.paymentStatus = 'PAID' " +
                "AND od.orderID.status = 'CONFIRMED'",
                Long.class
            )
            .setParameter("user", user)
            .setParameter("schedule", schedule)
            .getSingleResult();
            
            return count > 0;
        } catch (Exception e) {
            System.err.println("❌ Error in hasUserPurchasedSchedule:");
            e.printStackTrace();
            return false;
        }
    }
}