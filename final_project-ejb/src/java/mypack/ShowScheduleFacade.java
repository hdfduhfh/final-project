package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.Date;
import java.util.List;

/**
 * Facade cho bảng ShowSchedule (các suất diễn)
 */
@Stateless
public class ShowScheduleFacade extends AbstractFacade<ShowSchedule>
        implements ShowScheduleFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    public ShowScheduleFacade() {
        super(ShowSchedule.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    /**
     * Lấy tất cả lịch diễn của một show,
     * sắp xếp theo thời gian diễn.
     */
    @Override
    public List<ShowSchedule> findByShow(Show show) {
        return em.createQuery(
                "SELECT sch FROM ShowSchedule sch " +
                "WHERE sch.show = :show " +
                "ORDER BY sch.showTime", ShowSchedule.class)
                .setParameter("show", show)
                .getResultList();
    }

    /**
     * Lấy các suất diễn trong khoảng thời gian [from, to].
     */
    @Override
    public List<ShowSchedule> findByDateRange(Date from, Date to) {
        return em.createQuery(
                "SELECT sch FROM ShowSchedule sch " +
                "WHERE sch.showTime BETWEEN :from AND :to " +
                "ORDER BY sch.showTime", ShowSchedule.class)
                .setParameter("from", from)
                .setParameter("to", to)
                .getResultList();
    }
}
