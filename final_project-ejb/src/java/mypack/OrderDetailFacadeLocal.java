/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package mypack;

import jakarta.ejb.Local;
import java.util.List;
import java.util.Set;

/**
 *
 * @author DANG KHOA
 */
@Local
public interface OrderDetailFacadeLocal {

    void create(OrderDetail orderDetail);

    void edit(OrderDetail orderDetail);

    void remove(OrderDetail orderDetail);

    OrderDetail find(Object id);

    List<OrderDetail> findAll();

    List<OrderDetail> findRange(int[] range);

    int count();

    Set<Integer> findBookedSeatIdsBySchedule(int scheduleId);

    List<OrderDetail> findByOrderId(Integer oderId);
    // ✅ THÊM METHOD MỚI: Kiểm tra xem suất chiếu có đơn hàng nào chưa

    boolean hasOrdersForSchedule(Integer scheduleId);

    // ✅ Đếm số lượng đơn hàng của suất chiếu
    Long countOrdersBySchedule(Integer scheduleId);
}
