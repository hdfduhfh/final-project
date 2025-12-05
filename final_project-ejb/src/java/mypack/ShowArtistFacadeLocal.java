package mypack;

import jakarta.ejb.Local;
import java.util.List;

/**
 * Local interface cho ShowArtistFacade (bảng nối N-N Show <-> Artist).
 */
@Local
public interface ShowArtistFacadeLocal {

    // ===== CRUD cơ bản =====

    void create(ShowArtist showArtist);

    ShowArtist edit(ShowArtist showArtist);

    void remove(ShowArtist showArtist);

    ShowArtist find(Object id);

    List<ShowArtist> findAll();

    int count();

    // ===== nghiệp vụ riêng cho quan hệ Show - Artist =====

    /**
     * Lấy danh sách nghệ sĩ tham gia một show.
     */
    List<Artist> findArtistsByShow(Show show);

    /**
     * Lấy danh sách show mà một nghệ sĩ tham gia.
     */
    List<Show> findShowsByArtist(Artist artist);
}
