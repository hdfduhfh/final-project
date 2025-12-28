package mypack;

import jakarta.ejb.Local;
import java.math.BigDecimal;
import java.util.List;

@Local
public interface Order1FacadeLocal {

    void create(Order1 order1);

    void edit(Order1 order1);

    void remove(Order1 order1);

    Order1 find(Object id);

    List<Order1> findAll();

    List<Order1> findRange(int[] range);

    int count();

    List<Order1> findByUser(User user);

    /**
     * Tính tổng doanh thu THỰC TẾ
     * Tổng tiền đã thu - Tổng tiền đã hoàn lại
     * @return 
     */
    BigDecimal getTotalRevenue();

    /**
     * Tính tổng giảm giá đã áp dụng
     * @return 
     */
    BigDecimal getTotalDiscount();

    /**
     * Tính tổng tiền đã hoàn lại cho khách
     * @return 
     */
    BigDecimal getTotalRefund();
    
    /**
     * THÊM MỚI: Tính tổng phí hủy vé (Doanh thu từ hủy vé)
     * @return 
     */
    BigDecimal getTotalCancellationFee();

    /**
     * Đếm số đơn hàng đã bị hủy
     * @return 
     */
    Long countCancelledOrder();

    /**
     * Lấy danh sách đơn hàng đã thanh toán
     * @return 
     */
    List<Order1> findPaidOrders();

    /**
     * Thống kê doanh thu theo ngày (Đã trừ tiền hoàn)
     * Trả về: [Ngày, Tổng thu, Tổng hoàn, Doanh thu thực]
     * @return 
     */
    List<Object[]> getRevenueByDate();
    
    /**
     * ✅ Thống kê doanh thu theo tháng
     * Trả về: [Năm, Tháng, Doanh thu thực]
     * @return 
     */
    List<Object[]> getRevenueByMonth();

    /**
     * Kiểm tra user đã mua vé schedule này chưa
     * @param user
     * @param schedule
     * @return 
     */
    boolean hasUserPurchasedSchedule(User user, ShowSchedule schedule);
}