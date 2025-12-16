/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import jakarta.persistence.TypedQuery;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class ShowArtistFacade extends AbstractFacade<ShowArtist> implements ShowArtistFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ShowArtistFacade() {
        super(ShowArtist.class);
    }

    public long countActorsByShow(Integer showId) {
        if (showId == null) {
            return 0;
        }

        // ✅ Đếm những artist thuộc show này và KHÔNG phải đạo diễn
        // Role có thể là "Đạo diễn" / "Director" hoặc có chứa chữ đó.
        TypedQuery<Long> q = em.createQuery(
                "SELECT COUNT(sa) "
                + "FROM ShowArtist sa "
                + "WHERE sa.showID.showID = :sid "
                + "AND (LOWER(sa.artistID.role) NOT LIKE '%đạo diễn%') "
                + "AND (LOWER(sa.artistID.role) NOT LIKE '%director%')",
                Long.class
        );
        q.setParameter("sid", showId);
        Long rs = q.getSingleResult();
        return rs == null ? 0 : rs;
    }

    @Override
    public void create(ShowArtist showArtist) {
        super.create(showArtist);
    }

    @Override
    public void removeByShow(Show show) {
        em.createQuery("DELETE FROM ShowArtist sa WHERE sa.showID = :show")
                .setParameter("show", show)
                .executeUpdate();
    }

    public List<ShowArtist> findByShowId(Integer showId) {
        return em.createQuery(
                "SELECT sa FROM ShowArtist sa "
                + "JOIN FETCH sa.artistID a "
                + "WHERE sa.showID.showID = :id", ShowArtist.class)
                .setParameter("id", showId)
                .getResultList();
    }

    @Override
    public void removeByArtist(Artist artist) {
        if (artist == null || artist.getArtistID() == null) {
            return;
        }

        em.createQuery("DELETE FROM ShowArtist sa WHERE sa.artistID = :artist")
                .setParameter("artist", artist)
                .executeUpdate();
    }

    @Override
    public void removeByShowAndArtist(Integer showId, Integer artistId) {
        if (showId == null || artistId == null) {
            return;
        }

        em.createQuery("DELETE FROM ShowArtist sa WHERE sa.showID.showID = :sid AND sa.artistID.artistID = :aid")
                .setParameter("sid", showId)
                .setParameter("aid", artistId)
                .executeUpdate();
    }
}
