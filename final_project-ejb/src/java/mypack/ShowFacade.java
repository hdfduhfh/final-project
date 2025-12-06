/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.util.List;

@Stateless
public class ShowFacade extends AbstractFacade<Show> implements ShowFacadeLocal {
    
    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ShowFacade() {
        super(Show.class);
    }
    
    // ===== THÊM CÁC METHOD MỚI =====
    
    @Override
    public List<Show> findByShowName(String showName) {
        Query query = em.createQuery(
            "SELECT s FROM Show s WHERE LOWER(s.showName) LIKE LOWER(:showName) ORDER BY s.createdAt DESC"
        );
        query.setParameter("showName", "%" + showName + "%");
        return query.getResultList();
    }
    
    @Override
    public List<Show> findByStatus(String status) {
        Query query = em.createQuery(
            "SELECT s FROM Show s WHERE s.status = :status ORDER BY s.createdAt DESC"
        );
        query.setParameter("status", status);
        return query.getResultList();
    }
    
    @Override
    public List<Show> findActiveShows() {
        return findByStatus("Active");
    }
    
    @Override
    public Long countAllShows() {
        Query query = em.createQuery("SELECT COUNT(s) FROM Show s");
        return (Long) query.getSingleResult();
    }
    
    @Override
    public Long countByStatus(String status) {
        Query query = em.createQuery(
            "SELECT COUNT(s) FROM Show s WHERE s.status = :status"
        );
        query.setParameter("status", status);
        return (Long) query.getSingleResult();
    }
    
    @Override
    public List<Show> findLatestShows(int limit) {
        Query query = em.createQuery(
            "SELECT s FROM Show s ORDER BY s.createdAt DESC"
        );
        query.setMaxResults(limit);
        return query.getResultList();
    }
}
