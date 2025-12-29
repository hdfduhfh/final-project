package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.NoResultException;
import java.util.List;

/**
 * Facade cho EventRegistration Entity
 * @author DANG KHOA
 */
@Stateless
public class EventRegistrationFacade extends AbstractFacade<EventRegistration> 
        implements EventRegistrationFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public EventRegistrationFacade() {
        super(EventRegistration.class);
    }

    // ========== TÌM KIẾM THEO ĐIỀU KIỆN ==========
    
    @Override
    public boolean isUserRegistered(User user, Event event) {
        try {
            Long count = em.createQuery(
                "SELECT COUNT(r) FROM EventRegistration r " +
                "WHERE r.userID = :user AND r.eventID = :event " +
                "AND r.status = 'Confirmed'",
                Long.class
            )
            .setParameter("user", user)
            .setParameter("event", event)
            .getSingleResult();
            
            return count != null && count > 0;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public List<EventRegistration> findByUser(User user) {
        return em.createNamedQuery("EventRegistration.findByUser", EventRegistration.class)
                .setParameter("user", user)
                .getResultList();
    }

    @Override
    public List<EventRegistration> findByEvent(Event event) {
        return em.createNamedQuery("EventRegistration.findByEvent", EventRegistration.class)
                .setParameter("event", event)
                .getResultList();
    }

    @Override
    public EventRegistration findByUserAndEvent(User user, Event event) {
        try {
            return em.createNamedQuery("EventRegistration.findByUserAndEvent", EventRegistration.class)
                    .setParameter("user", user)
                    .setParameter("event", event)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public Long countByEvent(Event event) {
        return em.createQuery(
            "SELECT COUNT(r) FROM EventRegistration r " +
            "WHERE r.eventID = :event AND r.status = 'Confirmed'",
            Long.class
        )
        .setParameter("event", event)
        .getSingleResult();
    }

    @Override
    public Long countByUser(User user) {
        return em.createQuery(
            "SELECT COUNT(r) FROM EventRegistration r " +
            "WHERE r.userID = :user AND r.status = 'Confirmed'",
            Long.class
        )
        .setParameter("user", user)
        .getSingleResult();
    }
}