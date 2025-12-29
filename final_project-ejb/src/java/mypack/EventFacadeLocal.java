package mypack;

import jakarta.ejb.Local;
import java.util.Date;
import java.util.List;

/**
 * Local interface cho EventFacade
 * @author DANG KHOA
 */
@Local
public interface EventFacadeLocal {

    // ========== CRUD CƠ BẢN ==========
    void create(Event event);

    void edit(Event event);

    void remove(Event event);

    Event find(Object id);

    List<Event> findAll();

    List<Event> findRange(int[] range);

    int count();

    // ========== TÌM KIẾM THEO ĐIỀU KIỆN ==========
    
    /**
     * Tìm event theo trạng thái
     */
    List<Event> findByStatus(String status);

    /**
     * Tìm event theo loại
     */
    List<Event> findByEventType(String eventType);

    /**
     * Tìm event đã publish
     */
    List<Event> findPublished();

    /**
     * Tìm event sắp diễn ra (Upcoming + Published)
     */
    List<Event> findUpcoming();

    /**
     * Tìm event theo khoảng thời gian
     */
    List<Event> findByDateRange(Date fromDate, Date toDate);

    /**
     * Tìm kiếm event theo tên
     */
    List<Event> searchByName(String keyword);

    /**
     * Tìm event của một user tạo ra
     */
    List<Event> findByCreator(User user);

    // ========== KIỂM TRA VÀ VALIDATION ==========
    
    /**
     * Kiểm tra event có tồn tại không
     */
    boolean existsByEventID(Integer eventID);

    /**
     * Kiểm tra event đã đầy chưa
     */
    boolean isEventFull(Integer eventID);

    /**
     * Kiểm tra có thể đăng ký event không
     */
    boolean canRegisterEvent(Integer eventID);

    // ========== CẬP NHẬT SỐ LƯỢNG ==========
    
    /**
     * Tăng số người tham gia
     */
    boolean incrementAttendees(Integer eventID);

    /**
     * Giảm số người tham gia
     */
    boolean decrementAttendees(Integer eventID);

    // ========== THỐNG KÊ ==========
    
    /**
     * Đếm số event theo trạng thái
     */
    Long countByStatus(String status);

    /**
     * Đếm số event theo loại
     */
    Long countByEventType(String eventType);

    /**
     * Lấy danh sách event phổ biến (nhiều người đăng ký nhất)
     */
    List<Event> findPopularEvents(int limit);

    /**
     * Lấy danh sách event mới nhất
     */
    List<Event> findLatestEvents(int limit);

    // ========== CẬP NHẬT TRẠNG THÁI ==========
    
    /**
     * Tự động cập nhật trạng thái event
     */
    void updateEventStatus();
}