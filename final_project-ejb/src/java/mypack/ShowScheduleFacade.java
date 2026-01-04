package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.List;

@Stateless
public class ShowScheduleFacade extends AbstractFacade<ShowSchedule> implements ShowScheduleFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    private static final ZoneId APP_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ShowScheduleFacade() {
        super(ShowSchedule.class);
    }

    @Override
    public List<ShowSchedule> findPublicSchedulesByShow(Integer showId, Date now) {
        if (showId == null) {
            return java.util.Collections.emptyList();
        }
        if (now == null) {
            now = new Date();
        }

        return em.createQuery(
                "SELECT sc FROM ShowSchedule sc "
                + "WHERE sc.showID.showID = :sid "
                + "  AND (sc.status = 'Upcoming' OR sc.status = 'Ongoing') "
                + "  AND sc.showTime >= :now "
                + "ORDER BY sc.showTime ASC",
                ShowSchedule.class
        )
                .setParameter("sid", showId)
                .setParameter("now", now)
                .getResultList();
    }

    @Override
    public List<ShowSchedule> findInRange(Date startInclusive, Date endExclusive) {
        TypedQuery<ShowSchedule> q = em.createQuery(
                "SELECT s FROM ShowSchedule s WHERE s.showTime >= :start AND s.showTime < :end ORDER BY s.showTime ASC",
                ShowSchedule.class
        );
        q.setParameter("start", startInclusive);
        q.setParameter("end", endExclusive);
        return q.getResultList();
    }

    @Override
    public int countByShowIdAndDateExcept(Integer showId, LocalDate day, Integer excludeScheduleId) {
        ZoneId zone = ZoneId.of("Asia/Ho_Chi_Minh");
        Date start = Date.from(day.atStartOfDay(zone).toInstant());
        Date end = Date.from(day.plusDays(1).atStartOfDay(zone).toInstant()); // exclusive

        String jpql
                = "SELECT COUNT(s) FROM ShowSchedule s "
                + "WHERE s.showID.showID = :showId "
                + "AND s.showTime >= :start AND s.showTime < :end "
                + (excludeScheduleId != null ? "AND s.scheduleID <> :exId " : "");

        TypedQuery<Long> q = em.createQuery(jpql, Long.class);
        q.setParameter("showId", showId);
        q.setParameter("start", start);
        q.setParameter("end", end);
        if (excludeScheduleId != null) {
            q.setParameter("exId", excludeScheduleId);
        }

        Long rs = q.getSingleResult();
        return (rs == null) ? 0 : rs.intValue();
    }

    @Override
    public List<ShowSchedule> findByShowId(Integer showId) {
        return em.createQuery(
                "SELECT sc FROM ShowSchedule sc WHERE sc.showID.showID = :sid ORDER BY sc.showTime ASC",
                ShowSchedule.class
        ).setParameter("sid", showId)
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

    @Override
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

    @Override
    public int countUpcoming() {
        Long count = em.createQuery(
                "SELECT COUNT(s) FROM ShowSchedule s "
                + "WHERE s.showTime >= CURRENT_TIMESTAMP "
                + "AND s.status <> 'Cancelled'",
                Long.class)
                .getSingleResult();
        return count.intValue();
    }

    @Override
    public List<ShowSchedule> searchByShowNameKeyword(String keyword) {
        if (keyword == null) {
            keyword = "";
        }

        String k = keyword.trim().replaceAll("\\s+", " ").toLowerCase();
        if (k.isEmpty()) {
            return findAll();
        }

        String kw = "%" + k + "%";

        return em.createQuery(
                "SELECT sc FROM ShowSchedule sc "
                + "WHERE sc.showID IS NOT NULL "
                + "AND LOWER(sc.showID.showName) LIKE :kw",
                ShowSchedule.class
        ).setParameter("kw", kw)
                .getResultList();
    }

    @Override
    public List<ShowSchedule> findActiveSchedules() {
        TypedQuery<ShowSchedule> query = em.createQuery(
                "SELECT s FROM ShowSchedule s WHERE s.showTime >= :now ORDER BY s.showTime ASC",
                ShowSchedule.class
        );
        query.setParameter("now", new Date());
        return query.getResultList();
    }

    // =========================================================
    // ✅ methods phục vụ user page (lọc theo status)
    // =========================================================
    @Override
    public List<ShowSchedule> findByStatusIn(List<String> statuses, int offset, int limit) {
        if (statuses == null || statuses.isEmpty()) {
            return java.util.Collections.emptyList();
        }

        return em.createQuery(
                "SELECT sc FROM ShowSchedule sc "
                + "WHERE sc.status IN :st "
                + "ORDER BY sc.showTime ASC",
                ShowSchedule.class
        ).setParameter("st", statuses)
                .setFirstResult(offset)
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public int countByStatusIn(List<String> statuses) {
        if (statuses == null || statuses.isEmpty()) {
            return 0;
        }

        Long total = em.createQuery(
                "SELECT COUNT(sc) FROM ShowSchedule sc WHERE sc.status IN :st",
                Long.class
        ).setParameter("st", statuses)
                .getSingleResult();

        return (total == null) ? 0 : total.intValue();
    }

    // =========================================================
    // ✅ NEW: realtime compute + sync schedule & show
    // =========================================================
    private int safeDurationMinutes(Show show) {
        try {
            if (show != null && show.getDurationMinutes() > 0) {
                return show.getDurationMinutes();
            }
        } catch (Exception ignored) {
        }
        return 120;
    }

    private String computeRealtimeStatus(Date start, int durationMinutes, Date now) {
        if (start == null) {
            return "Cancelled";
        }
        if (durationMinutes <= 0) {
            durationMinutes = 120;
        }

        ZonedDateTime zNow = now.toInstant().atZone(APP_ZONE);
        ZonedDateTime zStart = start.toInstant().atZone(APP_ZONE);
        ZonedDateTime zEnd = zStart.plusMinutes(durationMinutes);

        if (zNow.isBefore(zStart)) {
            return "Upcoming";
        }
        if (!zNow.isBefore(zEnd)) {
            return "Cancelled";
        }
        return "Ongoing";
    }

    /**
     * Sync realtime: 1) Mỗi schedule tự tính Upcoming/Ongoing/Cancelled theo
     * giờ + duration của Show 2) Show.status tổng hợp từ schedules: - Có
     * Ongoing => Ongoing - else có Upcoming => Upcoming - else (có lịch nhưng
     * tất cả Cancelled) => Cancelled - Nếu show đang Cancelled thì giữ nguyên
     * (không kéo ngược)
     */
    @Override
    public void syncRealtimeStatuses() {
        Date now = new Date();

        // (1) update schedules
        List<ShowSchedule> schedules = em.createQuery(
                "SELECT sc FROM ShowSchedule sc WHERE sc.showID IS NOT NULL",
                ShowSchedule.class
        ).getResultList();

        if (schedules != null) {
            for (ShowSchedule sc : schedules) {
                if (sc == null || sc.getShowTime() == null || sc.getShowID() == null) {
                    continue;
                }

                int dur = safeDurationMinutes(sc.getShowID());
                String rt = computeRealtimeStatus(sc.getShowTime(), dur, now);

                String cur = (sc.getStatus() == null) ? "" : sc.getStatus().trim();
                if (!rt.equalsIgnoreCase(cur)) {
                    sc.setStatus(rt);
                    em.merge(sc);
                }
            }
        }

        // (2) update shows by aggregation
        List<Show> shows = em.createQuery("SELECT s FROM Show s", Show.class).getResultList();
        if (shows != null) {
            for (Show sh : shows) {
                if (sh == null || sh.getShowID() == null) {
                    continue;
                }

                String curShow = (sh.getStatus() == null) ? "" : sh.getStatus().trim();
                if ("Cancelled".equalsIgnoreCase(curShow)) {
                    continue; // không resurrect
                }

                List<ShowSchedule> lst = em.createQuery(
                        "SELECT sc FROM ShowSchedule sc WHERE sc.showID.showID = :sid",
                        ShowSchedule.class
                ).setParameter("sid", sh.getShowID()).getResultList();

                if (lst == null || lst.isEmpty()) {
                    continue; // chưa có lịch => giữ nguyên
                }

                boolean hasOngoing = false;
                boolean hasUpcoming = false;

                for (ShowSchedule sc : lst) {
                    if (sc == null) {
                        continue;
                    }
                    String st = (sc.getStatus() == null) ? "" : sc.getStatus().trim();
                    if ("Ongoing".equalsIgnoreCase(st)) {
                        hasOngoing = true;
                        break;
                    }
                    if ("Upcoming".equalsIgnoreCase(st)) {
                        hasUpcoming = true;
                    }
                }

                String newStatus;
                if (hasOngoing) {
                    newStatus = "Ongoing";
                } else if (hasUpcoming) {
                    newStatus = "Upcoming";
                } else {
                    newStatus = "Cancelled";
                }

                if (!newStatus.equalsIgnoreCase(curShow)) {
                    sh.setStatus(newStatus);
                    em.merge(sh);
                }
            }
        }

        em.flush();
    }
    @Override
public List<ShowSchedule> findUpcomingByShowIds(List<Integer> showIds) {
    if (showIds == null || showIds.isEmpty()) {
        return java.util.Collections.emptyList();
    }

    // Lấy Upcoming/Ongoing cho các show đang xuất hiện trong page
    return em.createQuery(
            "SELECT ss " +
            "FROM ShowSchedule ss " +
            "WHERE ss.showID.showID IN :ids " +
            "AND (ss.status = 'Upcoming' OR ss.status = 'Ongoing') " +
            "ORDER BY ss.showID.showID ASC, ss.showTime ASC",
            ShowSchedule.class
    )
    .setParameter("ids", showIds)
    .getResultList();
}

}
