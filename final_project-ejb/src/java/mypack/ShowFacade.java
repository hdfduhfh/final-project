package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.Date;
import java.util.List;

/**
 * Facade cho bảng Show
 */
@Stateless
public class ShowFacade extends AbstractFacade<Show> implements ShowFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    public ShowFacade() {
        super(Show.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    /**
     * Lấy tất cả show đang ACTIVE (status = 'Active'),
     * sắp xếp theo CreatedAt mới nhất.
     */
    @Override
    public List<Show> findActiveShows() {
        return em.createQuery(
                "SELECT s FROM Show s " +
                "WHERE s.status = :status " +
                "ORDER BY s.createdAt DESC", Show.class)
                .setParameter("status", "Active")
                .getResultList();
    }

    /**
     * Lấy danh sách show có ít nhất một suất diễn trong khoảng thời gian [from, to].
     */
    @Override
    public List<Show> findShowsByDateRange(Date from, Date to) {
        return em.createQuery(
                "SELECT DISTINCT s FROM Show s " +
                "JOIN s.schedules sch " +
                "WHERE sch.showTime BETWEEN :from AND :to " +
                "ORDER BY sch.showTime", Show.class)
                .setParameter("from", from)
                .setParameter("to", to)
                .getResultList();
    }
}
