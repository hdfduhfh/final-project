package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.Date;
import java.util.List;

/**
 * Facade cho Event Entity
 * @author DANG KHOA
 */
@Stateless
public class EventFacade extends AbstractFacade<Event> implements EventFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public EventFacade() {
        super(Event.class);
    }

    // ========== TÌM KIẾM THEO ĐIỀU KIỆN ==========
    
    @Override
    public List<Event> findByStatus(String status) {
        return em.createNamedQuery("Event.findByStatus", Event.class)
                .setParameter("status", status)
                .getResultList();
    }

    @Override
    public List<Event> findByEventType(String eventType) {
        return em.createNamedQuery("Event.findByEventType", Event.class)
                .setParameter("eventType", eventType)
                .getResultList();
    }

    @Override
    public List<Event> findPublished() {
        return em.createNamedQuery("Event.findPublished", Event.class)
                .getResultList();
    }

    @Override
    public List<Event> findUpcoming() {
        return em.createNamedQuery("Event.findUpcoming", Event.class)
                .getResultList();
    }

    @Override
    public List<Event> findByDateRange(Date fromDate, Date toDate) {
        return em.createQuery(
                "SELECT e FROM Event e WHERE e.eventDate BETWEEN :from AND :to ORDER BY e.eventDate ASC",
                Event.class)
                .setParameter("from", fromDate)
                .setParameter("to", toDate)
                .getResultList();
    }

    @Override
    public List<Event> searchByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }

        String kw = "%" + keyword.trim().toLowerCase() + "%";

        return em.createQuery(
                "SELECT e FROM Event e WHERE LOWER(e.eventName) LIKE :kw ORDER BY e.eventDate DESC",
                Event.class
        ).setParameter("kw", kw)
                .getResultList();
    }

    @Override
    public List<Event> findByCreator(User user) {
        return em.createQuery(
                "SELECT e FROM Event e WHERE e.createdBy = :user ORDER BY e.createdAt DESC",
                Event.class
        ).setParameter("user", user)
                .getResultList();
    }

    // ========== KIỂM TRA VÀ VALIDATION ==========
    
    @Override
    public boolean existsByEventID(Integer eventID) {
        if (eventID == null) {
            return false;
        }

        Long count = em.createQuery(
                "SELECT COUNT(e) FROM Event e WHERE e.eventID = :id",
                Long.class
        ).setParameter("id", eventID)
                .getSingleResult();

        return count != null && count > 0;
    }

    @Override
    public boolean isEventFull(Integer eventID) {
        try {
            Event event = find(eventID);
            return event != null && event.isFull();
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public boolean canRegisterEvent(Integer eventID) {
        try {
            Event event = find(eventID);
            return event != null && event.canRegister();
        } catch (Exception e) {
            return false;
        }
    }

    // ========== CẬP NHẬT SỐ LƯỢNG ==========
    
    @Override
    public boolean incrementAttendees(Integer eventID) {
        try {
            int updated = em.createQuery(
                    "UPDATE Event e SET e.currentAttendees = e.currentAttendees + 1, " +
                    "e.updatedAt = :now " +
                    "WHERE e.eventID = :id " +
                    "AND e.currentAttendees < e.maxAttendees"
            )
            .setParameter("id", eventID)
            .setParameter("now", new Date())
            .executeUpdate();

            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean decrementAttendees(Integer eventID) {
        try {
            int updated = em.createQuery(
                    "UPDATE Event e SET e.currentAttendees = e.currentAttendees - 1, " +
                    "e.updatedAt = :now " +
                    "WHERE e.eventID = :id " +
                    "AND e.currentAttendees > 0"
            )
            .setParameter("id", eventID)
            .setParameter("now", new Date())
            .executeUpdate();

            return updated > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== THỐNG KÊ ==========
    
    @Override
    public Long countByStatus(String status) {
        return em.createQuery(
                "SELECT COUNT(e) FROM Event e WHERE e.status = :status",
                Long.class
        ).setParameter("status", status)
                .getSingleResult();
    }

    @Override
    public Long countByEventType(String eventType) {
        return em.createQuery(
                "SELECT COUNT(e) FROM Event e WHERE e.eventType = :type",
                Long.class
        ).setParameter("type", eventType)
                .getSingleResult();
    }

    @Override
    public List<Event> findPopularEvents(int limit) {
        return em.createQuery(
                "SELECT e FROM Event e " +
                "WHERE e.isPublished = true " +
                "AND e.status = 'Upcoming' " +
                "ORDER BY e.currentAttendees DESC, e.eventDate ASC",
                Event.class
        ).setMaxResults(limit)
                .getResultList();
    }

    @Override
    public List<Event> findLatestEvents(int limit) {
        return em.createQuery(
                "SELECT e FROM Event e " +
                "WHERE e.isPublished = true " +
                "ORDER BY e.createdAt DESC",
                Event.class
        ).setMaxResults(limit)
                .getResultList();
    }

    // ========== CẬP NHẬT TRẠNG THÁI ==========
    
    @Override
    public void updateEventStatus() {
        Date now = new Date();

        // Chuyển sang Ongoing nếu đến giờ diễn ra
        em.createQuery(
                "UPDATE Event e SET e.status = 'Ongoing', e.updatedAt = :now " +
                "WHERE e.status = 'Upcoming' " +
                "AND e.eventDate <= :now " +
                "AND (e.endDate IS NULL OR e.endDate > :now)"
        ).setParameter("now", now)
                .executeUpdate();

        // Chuyển sang Completed nếu đã kết thúc
        em.createQuery(
                "UPDATE Event e SET e.status = 'Completed', e.updatedAt = :now " +
                "WHERE e.status IN ('Upcoming', 'Ongoing') " +
                "AND e.endDate IS NOT NULL " +
                "AND e.endDate < :now"
        ).setParameter("now", now)
                .executeUpdate();
    }
}