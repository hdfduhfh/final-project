package mypack;

import jakarta.ejb.Local;
import java.util.List;

/**
 * Local interface cho ArtistFacade.
 */
@Local
public interface ArtistFacadeLocal {

    // ===== CRUD cơ bản =====

    void create(Artist artist);

    Artist edit(Artist artist);

    void remove(Artist artist);

    Artist find(Object id);

    List<Artist> findAll();

    int count();

    // ===== nghiệp vụ riêng cho Artist =====

    /**
     * Tìm nghệ sĩ theo tên (LIKE, không phân biệt hoa thường).
     */
    List<Artist> searchByName(String keyword);
}
