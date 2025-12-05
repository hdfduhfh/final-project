package mypack;

import jakarta.ejb.Local;
import java.util.Date;
import java.util.List;

/**
 * Local interface cho ShowScheduleFacade (quản lý suất diễn).
 */
@Local
public interface ShowScheduleFacadeLocal {

    // ===== CRUD cơ bản =====

    void create(ShowSchedule schedule);

    ShowSchedule edit(ShowSchedule schedule);

    void remove(ShowSchedule schedule);

    ShowSchedule find(Object id);

    List<ShowSchedule> findAll();

    int count();

    // ===== nghiệp vụ riêng cho lịch diễn =====

    /**
     * Lấy tất cả lịch diễn của một show.
     */
    List<ShowSchedule> findByShow(Show show);

    /**
     * Lấy các suất diễn trong khoảng thời gian [from, to].
     */
    List<ShowSchedule> findByDateRange(Date from, Date to);
}
