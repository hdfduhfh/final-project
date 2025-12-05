package mypack;

import jakarta.ejb.Local;
import java.util.Date;
import java.util.List;

/**
 * Local interface cho ShowFacade.
 * Cung cấp các CRUD cơ bản + một số hàm tìm kiếm theo nghiệp vụ.
 */
@Local
public interface ShowFacadeLocal {

    // ===== CRUD cơ bản (dùng chung với AbstractFacade) =====

    void create(Show show);

    Show edit(Show show);

    void remove(Show show);

    Show find(Object id);

    List<Show> findAll();

    int count();

    // ===== các hàm nghiệp vụ riêng cho Show =====

    /**
     * Lấy tất cả show đang ACTIVE (status = 'Active'),
     * sắp xếp theo CreatedAt mới nhất.
     */
    List<Show> findActiveShows();

    /**
     * Lấy danh sách show có ít nhất một suất diễn
     * trong khoảng thời gian [from, to].
     */
    List<Show> findShowsByDateRange(Date from, Date to);
}
