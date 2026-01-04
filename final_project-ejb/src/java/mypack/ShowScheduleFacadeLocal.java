package mypack;

import jakarta.ejb.Local;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Local
public interface ShowScheduleFacadeLocal {

    void create(ShowSchedule showSchedule);

    void edit(ShowSchedule showSchedule);

    void remove(ShowSchedule showSchedule);

    ShowSchedule find(Object id);

    List<ShowSchedule> findAll();

    List<ShowSchedule> findRange(int[] range);

    int count();

    List<ShowSchedule> searchByShowNameKeyword(String keyword);

    List<ShowSchedule> findByShowId(Integer showId);

    List<ShowSchedule> findByShowTimeRange(Date from, Date to);

    List<ShowSchedule> searchByKeyword(String keyword);

    boolean existsByShowId(Integer showId);

    boolean existsByShowTime(Date showTime);

    boolean existsByShowIdExcept(Integer showId, Integer excludeScheduleId);

    boolean existsByShowTimeExcept(Date showTime, Integer excludeScheduleId);

    int countByShowId(Integer showId);

    int countByShowIdExcept(Integer showId, Integer excludeScheduleId);

    List<ShowSchedule> findUpcoming(int offset, int limit);

    int countUpcoming();

    List<ShowSchedule> findActiveSchedules();

    List<ShowSchedule> findInRange(Date startInclusive, Date endExclusive);

    int countByShowIdAndDateExcept(Integer showId, LocalDate day, Integer excludeScheduleId);

    // ✅ dùng cho trang user theo logic status (Ongoing/Upcoming)
    List<ShowSchedule> findByStatusIn(List<String> statuses, int offset, int limit);

    int countByStatusIn(List<String> statuses);

    // ✅ NEW: Sync realtime statuses cho Schedule + Show
    void syncRealtimeStatuses();

    List<ShowSchedule> findPublicSchedulesByShow(Integer showId, Date now);

    List<ShowSchedule> findUpcomingByShowIds(List<Integer> showIds);

}
