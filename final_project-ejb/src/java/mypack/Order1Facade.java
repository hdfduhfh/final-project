/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.math.BigDecimal;
import java.util.ArrayList;

/**
 *
 * @author DANG KHOA
 */
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

    @Override
    public BigDecimal getTotalRevenue() {
        return em.createQuery(
                "SELECT COALESCE(SUM(o.finalAmount), 0) "
                + "FROM Order1 o WHERE o.paymentStatus = 'PAID'",
                BigDecimal.class
        ).getSingleResult();
    }

    @Override
    public BigDecimal getTotalDiscount() {
        return em.createQuery(
                "SELECT COALESCE(SUM(o.discountAmount), 0) "
                + "FROM Order1 o WHERE o.paymentStatus = 'PAID'",
                BigDecimal.class
        ).getSingleResult();
    }

    @Override
    public BigDecimal getTotalRefund() {
        return em.createQuery(
                "SELECT COALESCE(SUM(o.refundAmount), 0) "
                + "FROM Order1 o WHERE o.refundAmount > 0",
                BigDecimal.class
        ).getSingleResult();
    }

    @Override
    public Long countCancelledOrder() {
        return em.createQuery(
                "SELECT COUNT(o) FROM Order1 o WHERE o.status = 'CANCELLED'",
                Long.class
        ).getSingleResult();
    }

    @Override
    public List<Order1> findPaidOrders() {
        return em.createQuery(
                "SELECT o FROM Order1 o WHERE o.paymentStatus = 'PAID' ORDER BY o.paidAt",
                Order1.class
        ).getResultList();
    }

    @Override
    public List<Object[]> getRevenueByDate() {
        System.out.println("--- BẮT ĐẦU LẤY DỮ LIỆU THỐNG KÊ ---");

        // SQL chuẩn theo script BookingStageDB bạn gửi
        String sql = "SELECT TOP 7 "
                + "   CAST(CreatedAt AS DATE) as ReportDate, "
                + // Sửa order_date -> CreatedAt
                "   SUM(FinalAmount) as Total "
                + // Sửa total_price -> FinalAmount (Lấy tiền thực trả)
                "FROM [Order] "
                + // Sửa Order1 -> [Order] (Quan trọng dấu ngoặc vuông)
                "WHERE Status = ?1 "
                + "GROUP BY CAST(CreatedAt AS DATE) "
                + "ORDER BY ReportDate DESC";

        try {
            // Status trong DB của bạn là 'Confirmed' (theo comment trong script SQL)
            List<Object[]> result = getEntityManager().createNativeQuery(sql)
                    .setParameter(1, "Confirmed")
                    .getResultList();

            if (result.isEmpty()) {
                System.out.println("SQL chạy thành công nhưng KHÔNG CÓ đơn hàng nào Status='Confirmed'");
            } else {
                System.out.println("Đã tìm thấy " + result.size() + " ngày có doanh thu.");
            }

            return result;
        } catch (Exception e) {
            System.out.println("LỖI SQL KHI THỐNG KÊ:");
            e.printStackTrace();
            return new java.util.ArrayList<>(); // Trả về list rỗng để không crash web
        }
    }
}
