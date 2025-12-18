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
import jakarta.persistence.TypedQuery;

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
                "SELECT s FROM ShowSchedule s WHERE s.showID.showID = :showId",
                ShowSchedule.class
        )
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

        try {
            return em.createQuery(
                    "SELECT sc "
                    + "FROM ShowSchedule sc "
                    + "WHERE LOWER(sc.showID.showName) LIKE :kw "
                    + "   OR LOWER(sc.status) LIKE :kw",
                    ShowSchedule.class
            ).setParameter("kw", kw)
                    .getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
    }

    @Override
    public boolean existsByShowId(Integer showId) {
        if (showId == null) {
            return false;
        }

        Long c = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc WHERE sc.showID.showID = :showId",
                Long.class
        ).setParameter("showId", showId)
                .getSingleResult();

        return c != null && c > 0;
    }

    @Override
    public boolean existsByShowTime(Date showTime) {
        if (showTime == null) {
            return false;
        }

        Long c = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc WHERE sc.showTime = :showTime",
                Long.class
        ).setParameter("showTime", showTime)
                .getSingleResult();

        return c != null && c > 0;
    }

    @Override
    public boolean existsByShowIdExcept(Integer showId, Integer excludeScheduleId) {
        if (showId == null) {
            return false;
        }

        Long c = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc "
                + "WHERE sc.showID.showID = :showId AND sc.scheduleID <> :exId",
                Long.class
        ).setParameter("showId", showId)
                .setParameter("exId", excludeScheduleId)
                .getSingleResult();

        return c != null && c > 0;
    }

    @Override
    public boolean existsByShowTimeExcept(Date showTime, Integer excludeScheduleId) {
        if (showTime == null) {
            return false;
        }

        Long c = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc "
                + "WHERE sc.showTime = :showTime AND sc.scheduleID <> :exId",
                Long.class
        ).setParameter("showTime", showTime)
                .setParameter("exId", excludeScheduleId)
                .getSingleResult();

        return c != null && c > 0;
    }

    @Override
    public int countByShowId(Integer showId) {
        if (showId == null) {
            return 0;
        }
        Long c = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc WHERE sc.showID.showID = :showId",
                Long.class
        ).setParameter("showId", showId)
                .getSingleResult();
        return (c == null) ? 0 : c.intValue();
    }

    @Override
    public int countByShowIdExcept(Integer showId, Integer excludeScheduleId) {
        if (showId == null) {
            return 0;
        }
        Long c = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc "
                + "WHERE sc.showID.showID = :showId AND sc.scheduleID <> :exId",
                Long.class
        ).setParameter("showId", showId)
                .setParameter("exId", excludeScheduleId)
                .getSingleResult();
        return (c == null) ? 0 : c.intValue();
    }

    public List<ShowSchedule> findUpcoming(int offset, int limit) {
        return em.createQuery(
                "SELECT s FROM ShowSchedule s "
                + "WHERE s.showTime >= CURRENT_TIMESTAMP "
                + "AND s.status <> 'Cancelled' "
                + "ORDER BY s.showTime ASC",
                ShowSchedule.class)
                .setFirstResult(offset)
                .setMaxResults(limit)
                .getResultList();
    }

    public int countUpcoming() {
        Long count = em.createQuery(
                "SELECT COUNT(s) FROM ShowSchedule s "
                + "WHERE s.showTime >= CURRENT_TIMESTAMP "
                + "AND s.status <> 'Cancelled'",
                Long.class)
                .getSingleResult();
        return count.intValue();
    }

}
