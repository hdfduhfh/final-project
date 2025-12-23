/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class OrderDetailFacade extends AbstractFacade<OrderDetail> implements OrderDetailFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected jakarta.persistence.EntityManager getEntityManager() {
        return em;
    }

    public OrderDetailFacade() {
        super(OrderDetail.class);
    }
    // Thêm vào OrderDetailFacade class:

    @Override
    public Set<Integer> findBookedSeatIdsBySchedule(int scheduleId) {
        Set<Integer> bookedSeatIds = new HashSet<>();
        try {
            TypedQuery<Integer> query = em.createQuery(
                    "SELECT od.seatID.seatID FROM OrderDetail od "
                    + "WHERE od.scheduleID.scheduleID = :scheduleId "
                    + "AND od.orderID.status IN ('PENDING', 'CONFIRMED', 'PAID')",
                    Integer.class
            );
            query.setParameter("scheduleId", scheduleId);
            bookedSeatIds.addAll(query.getResultList());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookedSeatIds;
    }

    @Override
    public List<OrderDetail> findByOrderId(Integer orderId) {
        try {
            TypedQuery<OrderDetail> query = em.createQuery(
                "SELECT od FROM OrderDetail od WHERE od.orderID.orderID = :orderId",
                OrderDetail.class
            );
            query.setParameter("orderId", orderId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
}
