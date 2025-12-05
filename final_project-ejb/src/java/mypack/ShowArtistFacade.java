package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

/**
 * Facade cho bảng nối ShowArtist
 */
@Stateless
public class ShowArtistFacade extends AbstractFacade<ShowArtist>
        implements ShowArtistFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    public ShowArtistFacade() {
        super(ShowArtist.class);
    }

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    /**
     * Lấy danh sách nghệ sĩ tham gia một show.
     */
    @Override
    public List<Artist> findArtistsByShow(Show show) {
        return em.createQuery(
                "SELECT sa.artist FROM ShowArtist sa " +
                "WHERE sa.show = :show", Artist.class)
                .setParameter("show", show)
                .getResultList();
    }

    /**
     * Lấy danh sách show mà một nghệ sĩ tham gia.
     */
    @Override
    public List<Show> findShowsByArtist(Artist artist) {
        return em.createQuery(
                "SELECT sa.show FROM ShowArtist sa " +
                "WHERE sa.artist = :artist", Show.class)
                .setParameter("artist", artist)
                .getResultList();
    }
}
