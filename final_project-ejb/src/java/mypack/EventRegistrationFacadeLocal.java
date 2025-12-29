package mypack;

import jakarta.ejb.Local;
import java.util.List;

/**
 * Local interface cho EventRegistrationFacade
 * @author DANG KHOA
 */
@Local
public interface EventRegistrationFacadeLocal {

    // ========== CRUD CƠ BẢN ==========
    void create(EventRegistration registration);

    void edit(EventRegistration registration);

    void remove(EventRegistration registration);

    EventRegistration find(Object id);

    List<EventRegistration> findAll();

    List<EventRegistration> findRange(int[] range);

    int count();

    // ========== TÌM KIẾM THEO ĐIỀU KIỆN ==========
    
    /**
     * Kiểm tra user đã đăng ký event chưa
     */
    boolean isUserRegistered(User user, Event event);

    /**
     * Tìm tất cả đăng ký của 1 user
     */
    List<EventRegistration> findByUser(User user);

    /**
     * Tìm tất cả đăng ký của 1 event
     */
    List<EventRegistration> findByEvent(Event event);

    /**
     * Tìm đăng ký cụ thể của user cho event
     */
    EventRegistration findByUserAndEvent(User user, Event event);
    
    /**
     * Đếm số người đã đăng ký event
     */
    Long countByEvent(Event event);
    
    /**
     * Đếm số event user đã đăng ký
     */
    Long countByUser(User user);
}