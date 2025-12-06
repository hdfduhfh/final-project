package mypack;

import jakarta.ejb.Local;
import java.util.List;

@Local
public interface ShowFacadeLocal {

    void create(Show show);

    void edit(Show show);

    void remove(Show show);

    Show find(Object id);

    List<Show> findAll();

    List<Show> findRange(int[] range);

    int count();

    // ===== THÊM CÁC METHOD MỚI =====
    List<Show> findByShowName(String showName);

    List<Show> findByStatus(String status);

    List<Show> findActiveShows();

    Long countAllShows();

    Long countByStatus(String status);

    List<Show> findLatestShows(int limit);
}
