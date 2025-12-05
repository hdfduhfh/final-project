package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

/**
 * Facade cho bảng Artist
 */
@Stateless
public class ArtistFacade extends AbstractFacade<Artist> implements ArtistFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    public ArtistFacade() {
        super(Artist.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    /**
     * Tìm nghệ sĩ theo tên (LIKE, không phân biệt hoa thường).
     */
    @Override
    public List<Artist> searchByName(String keyword) {
        if (keyword == null) {
            keyword = "";
        }
        String pattern = "%" + keyword.toLowerCase() + "%";

        return em.createQuery(
                "SELECT a FROM Artist a " +
                "WHERE LOWER(a.name) LIKE :kw " +
                "ORDER BY a.name", Artist.class)
                .setParameter("kw", pattern)
                .getResultList();
    }
}
