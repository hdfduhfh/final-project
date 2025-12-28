package mypack;

import jakarta.ejb.Local;
import java.util.List;

/**
 * Interface cho FeedbackFacade
 * @author DANG KHOA
 */
@Local
public interface FeedbackFacadeLocal {

    void create(Feedback feedback);

    void edit(Feedback feedback);

    void remove(Feedback feedback);

    Feedback find(Object id);

    List<Feedback> findAll();

    List<Feedback> findRange(int[] range);

    int count();
    
    // ✅ CUSTOM METHODS CHO FEEDBACK SYSTEM
    
    /**
     * Kiểm tra user đã feedback cho schedule này chưa
     * @param user User cần check
     * @param schedule ShowSchedule cần check
     * @return true nếu đã feedback, false nếu chưa
     */
    boolean hasUserFeedback(User user, ShowSchedule schedule);
    
    /**
     * Lấy tất cả feedback, mới nhất lên đầu (cho admin)
     * @return List feedback
     */
    List<Feedback> findAllOrderByNewest();
    
    /**
     * Lấy feedback theo schedule (hiển thị trên trang chi tiết show)
     * @param schedule ShowSchedule
     * @return List feedback của schedule đó
     */
    List<Feedback> findBySchedule(ShowSchedule schedule);
    
    /**
     * Lấy feedback theo show (tất cả suất chiếu của 1 show)
     * @param show Show
     * @return List feedback của show đó
     */
    List<Feedback> findByShow(Show show);
    
    /**
     * Tính rating trung bình của 1 show
     * @param show Show
     * @return Điểm trung bình (0.0 - 5.0)
     */
    Double getAverageRatingByShow(Show show);
    
    /**
     * Đếm số feedback của 1 show
     * @param show Show
     * @return Số lượng feedback
     */
    Long countFeedbackByShow(Show show);
}