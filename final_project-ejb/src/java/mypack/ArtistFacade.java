/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class ArtistFacade extends AbstractFacade<Artist> implements ArtistFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ArtistFacade() {
        super(Artist.class);
    }

        @Override
    public List<Artist> searchByKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }

        String kw = "%" + keyword.trim().toLowerCase() + "%";

        return em.createQuery(
                "SELECT a FROM Artist a " +
                "WHERE LOWER(a.name) LIKE :kw " +
                "   OR LOWER(a.role) LIKE :kw " +
                "   OR LOWER(a.bio)  LIKE :kw " +
                "ORDER BY a.name ASC",
                Artist.class)
                .setParameter("kw", kw)
                .getResultList();
    }
    
        @Override
    public List<Artist> findRange(int start, int size) {
        TypedQuery<Artist> q = em.createQuery(
            "SELECT a FROM Artist a ORDER BY a.artistID DESC", Artist.class
        );
        q.setFirstResult(start);
        q.setMaxResults(size);
        return q.getResultList();
    }
}
