/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class TicketFacade extends AbstractFacade<Ticket> implements TicketFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected jakarta.persistence.EntityManager getEntityManager() {
        return em;
    }

    public TicketFacade() {
        super(Ticket.class);
    }

    @Override
    public List<Ticket> findAll() {
        TypedQuery<Ticket> query = em.createQuery("SELECT t FROM Ticket t", Ticket.class);
        return query.getResultList();
    }

    @Override
    public List<Ticket> findRange(int[] range) {
        TypedQuery<Ticket> query = em.createQuery("SELECT t FROM Ticket t", Ticket.class);
        query.setMaxResults(range[1] - range[0] + 1);
        query.setFirstResult(range[0]);
        return query.getResultList();
    }

    @Override
    public int count() {
        Long count = em.createQuery("SELECT COUNT(t) FROM Ticket t", Long.class)
                .getSingleResult();
        return count.intValue();
    }

    @Override
    public List<Ticket> findByOrderDetailId(int orderDetailId) {
        TypedQuery<Ticket> query = em.createQuery(
                "SELECT t FROM Ticket t WHERE t.orderDetailID.orderDetailID = :detailId", Ticket.class);
        query.setParameter("detailId", orderDetailId);
        return query.getResultList();
    }

    @Override
    public List<Ticket> findByOrderId(int orderId) {
        TypedQuery<Ticket> query = em.createQuery(
                "SELECT t FROM Ticket t WHERE t.orderDetailID.orderID.orderID = :orderId", Ticket.class);
        query.setParameter("orderId", orderId);
        return query.getResultList();
    }

    @Override
    public Ticket findByQRCode(String qrCode) {
        try {
            return em.createQuery(
                    "SELECT t FROM Ticket t WHERE t.qRCode = :qr",
                    Ticket.class
            ).setParameter("qr", qrCode)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public String checkInTicket(String qrCode) {
        Ticket t = findByQRCode(qrCode);
        if (t == null) {
            return "NOT_FOUND";
        }

        if (!"VALID".equalsIgnoreCase(t.getStatus())) {
            return "INVALID_STATUS";
        }

        Date showTime = t.getOrderDetailID()
                .getScheduleID()
                .getShowTime();

        long now = System.currentTimeMillis();
        long show = showTime.getTime();

        long before30 = show - 30 * 60 * 1000;
        long after30 = show + 30 * 60 * 1000;

        if (now < before30) {
            return "TOO_EARLY";
        }

        if (now > after30) {
            t.setStatus("EXPIRED");
            t.setUpdatedAt(new Date());
            em.merge(t);
            return "TOO_LATE";
        }

        // hợp lệ
        t.setStatus("USED");
        t.setCheckInAt(new Date());
        t.setUpdatedAt(new Date());
        em.merge(t);

        return "SUCCESS";
    }

}
