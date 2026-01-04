package mypack;

import jakarta.ejb.Local;
import java.util.List;

@Local
public interface ShowFacadeLocal {

    void create(Show show);

    void edit(Show show);

    void remove(Show show);

    void deleteHard(Integer showId);

    Show find(Object id);

    List<Show> findAll();

    List<Show> findRange(int[] range);

    int count();

    List<Show> searchByName(String keyword);

    // ===== THÊM CÁC METHOD MỚI =====
    List<Show> findByShowName(String showName);

    List<Show> findByStatus(String status);

    List<Show> findActiveShows();

    Long countAllShows();

    Long countByStatus(String status);

    List<Show> findLatestShows(int limit);

    // ✅ THÊM MỚI: Kiểm tra Show có đơn hàng không
    /**
     * Kiểm tra Show có lịch diễn nào đã được đặt vé chưa
     * @param showId ID của Show
     * @return true nếu có đơn hàng, false nếu không
     */
    boolean hasOrdersForShow(Integer showId);

    /**
     * Đếm số lượng đơn hàng của Show
     * @param showId ID của Show
     * @return Số lượng đơn hàng
     */
    Long countOrdersForShow(Integer showId);

    // ✅ NEW: đồng bộ trạng thái Show theo trạng thái các ShowSchedule (realtime)
    // Rule:
    // - Có schedule Ongoing => show Ongoing
    // - Else có schedule Upcoming => show Upcoming
    // - Else: không đụng tới show (giữ logic cũ)
    void syncShowStatusFromSchedules();
}
