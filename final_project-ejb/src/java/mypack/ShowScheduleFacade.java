/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class ShowScheduleFacade extends AbstractFacade<ShowSchedule> implements ShowScheduleFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ShowScheduleFacade() {
        super(ShowSchedule.class);
    }

    @Override
    public List<ShowSchedule> findByShowId(Integer showId) {
        return em.createQuery(
                "SELECT s FROM ShowSchedule s WHERE s.show.showID = :showId",
                ShowSchedule.class)
                .setParameter("showId", showId)
                .getResultList();
    }

    @Override
    public List<ShowSchedule> findByShowTimeRange(Date from, Date to) {
        return em.createQuery(
                "SELECT s FROM ShowSchedule s "
                + "WHERE s.showTime BETWEEN :from AND :to "
                + "ORDER BY s.showTime ASC",
                ShowSchedule.class)
                .setParameter("from", from)
                .setParameter("to", to)
                .getResultList();
    }

    @Override
    public List<ShowSchedule> searchByKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        String kw = "%" + keyword.trim().toLowerCase() + "%";

        return em.createQuery(
                "SELECT s FROM ShowSchedule s "
                + "JOIN s.show sh "
                + "WHERE LOWER(sh.showName) LIKE :kw "
                + // tìm theo tên show
                "   OR LOWER(s.status) LIKE :kw", // hoặc status
                ShowSchedule.class)
                .setParameter("kw", kw)
                .getResultList();
    }
}
