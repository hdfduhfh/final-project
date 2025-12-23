/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package mypack;

import jakarta.ejb.Local;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
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

    // Tìm theo ShowID
    List<ShowSchedule> findByShowId(Integer showId);

    // Tìm theo khoảng ngày giờ
    List<ShowSchedule> findByShowTimeRange(Date from, Date to);

    // Tìm theo keyword (tên show hoặc status)
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
}
