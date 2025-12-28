package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

@Stateless
public class FeedbackFacade extends AbstractFacade<Feedback> implements FeedbackFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public FeedbackFacade() {
        super(Feedback.class);
    }
    
    /**
     * ✅ Kiểm tra user đã feedback cho schedule này chưa
     */
    @Override
    public boolean hasUserFeedback(User user, ShowSchedule schedule) {
        try {
            Long count = em.createQuery(
                "SELECT COUNT(f) FROM Feedback f " +
                "WHERE f.userID = :user AND f.scheduleID = :schedule",
                Long.class
            )
            .setParameter("user", user)
            .setParameter("schedule", schedule)
            .getSingleResult();
            
            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * ✅ Lấy tất cả feedback (dành cho admin)
     */
    @Override
    public List<Feedback> findAllOrderByNewest() {
        try {
            return em.createQuery(
                "SELECT f FROM Feedback f ORDER BY f.createdAt DESC",
                Feedback.class
            ).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    /**
     * ✅ Lấy feedback theo schedule (hiển thị trên trang chi tiết show)
     */
    @Override
    public List<Feedback> findBySchedule(ShowSchedule schedule) {
        try {
            return em.createQuery(
                "SELECT f FROM Feedback f " +
                "WHERE f.scheduleID = :schedule AND f.status = 'ACTIVE' " +
                "ORDER BY f.createdAt DESC",
                Feedback.class
            )
            .setParameter("schedule", schedule)
            .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    /**
     * ✅ Lấy feedback theo show (tất cả suất chiếu của 1 show)
     */
    @Override
    public List<Feedback> findByShow(Show show) {
        try {
            return em.createQuery(
                "SELECT f FROM Feedback f " +
                "WHERE f.scheduleID.showID = :show AND f.status = 'ACTIVE' " +
                "ORDER BY f.createdAt DESC",
                Feedback.class
            )
            .setParameter("show", show)
            .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    /**
     * ✅ Tính rating trung bình của 1 show
     */
    @Override
    public Double getAverageRatingByShow(Show show) {
        try {
            Double avg = em.createQuery(
                "SELECT AVG(f.rating) FROM Feedback f " +
                "WHERE f.scheduleID.showID = :show AND f.status = 'ACTIVE'",
                Double.class
            )
            .setParameter("show", show)
            .getSingleResult();
            
            return avg != null ? avg : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
    
    /**
     * ✅ Đếm số feedback của 1 show
     */
    @Override
    public Long countFeedbackByShow(Show show) {
        try {
            return em.createQuery(
                "SELECT COUNT(f) FROM Feedback f " +
                "WHERE f.scheduleID.showID = :show AND f.status = 'ACTIVE'",
                Long.class
            )
            .setParameter("show", show)
            .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }
}