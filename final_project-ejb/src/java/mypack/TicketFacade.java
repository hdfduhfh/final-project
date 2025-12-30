package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;

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

        t.setStatus("USED");
        t.setCheckInAt(new Date());
        t.setUpdatedAt(new Date());
        em.merge(t);

        return "SUCCESS";
    }

    @Override
    public List<Ticket> findWithPaging(int offset, int limit) {
        return em.createQuery("SELECT t FROM Ticket t ORDER BY t.ticketID DESC", Ticket.class)
                .setFirstResult(offset)
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public int countAll() {
        return ((Long) em.createQuery("SELECT COUNT(t) FROM Ticket t").getSingleResult()).intValue();
    }

    // NEW: Advanced search implementation
    @Override
    public List<Ticket> searchTickets(String qrCode, String status, String customerName, 
                                     Date fromDate, Date toDate, int offset, int limit) {
        StringBuilder jpql = new StringBuilder("SELECT t FROM Ticket t WHERE 1=1");
        
        if (qrCode != null && !qrCode.trim().isEmpty()) {
            jpql.append(" AND LOWER(t.qRCode) LIKE LOWER(:qrCode)");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("ALL")) {
            jpql.append(" AND UPPER(t.status) = UPPER(:status)");
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            jpql.append(" AND LOWER(t.orderDetailID.orderID.userID.fullName) LIKE LOWER(:customerName)");
        }
        if (fromDate != null) {
            jpql.append(" AND t.issuedAt >= :fromDate");
        }
        if (toDate != null) {
            jpql.append(" AND t.issuedAt <= :toDate");
        }
        
        jpql.append(" ORDER BY t.ticketID DESC");
        
        TypedQuery<Ticket> query = em.createQuery(jpql.toString(), Ticket.class);
        
        if (qrCode != null && !qrCode.trim().isEmpty()) {
            query.setParameter("qrCode", "%" + qrCode + "%");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("ALL")) {
            query.setParameter("status", status);
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            query.setParameter("customerName", "%" + customerName + "%");
        }
        if (fromDate != null) {
            query.setParameter("fromDate", fromDate);
        }
        if (toDate != null) {
            query.setParameter("toDate", toDate);
        }
        
        query.setFirstResult(offset);
        query.setMaxResults(limit);
        
        return query.getResultList();
    }

    @Override
    public int countSearchResults(String qrCode, String status, String customerName, 
                                 Date fromDate, Date toDate) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(t) FROM Ticket t WHERE 1=1");
        
        if (qrCode != null && !qrCode.trim().isEmpty()) {
            jpql.append(" AND LOWER(t.qRCode) LIKE LOWER(:qrCode)");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("ALL")) {
            jpql.append(" AND UPPER(t.status) = UPPER(:status)");
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            jpql.append(" AND LOWER(t.orderDetailID.orderID.userID.fullName) LIKE LOWER(:customerName)");
        }
        if (fromDate != null) {
            jpql.append(" AND t.issuedAt >= :fromDate");
        }
        if (toDate != null) {
            jpql.append(" AND t.issuedAt <= :toDate");
        }
        
        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        
        if (qrCode != null && !qrCode.trim().isEmpty()) {
            query.setParameter("qrCode", "%" + qrCode + "%");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("ALL")) {
            query.setParameter("status", status);
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            query.setParameter("customerName", "%" + customerName + "%");
        }
        if (fromDate != null) {
            query.setParameter("fromDate", fromDate);
        }
        if (toDate != null) {
            query.setParameter("toDate", toDate);
        }
        
        return query.getSingleResult().intValue();
    }
}