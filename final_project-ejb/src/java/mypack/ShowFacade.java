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

    public List<Show> searchByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }

        String kw = "%" + keyword.trim().toLowerCase() + "%";

        return em.createQuery(
                "SELECT s FROM Show s WHERE LOWER(s.showName) LIKE :kw ORDER BY s.showName",
                Show.class
        ).setParameter("kw", kw)
                .getResultList();
    }

    @Override
    public void deleteHard(Integer showId) {
        if (showId == null) {
            return;
        }

        // 1) XÓA BẢNG CON TRƯỚC (đúng thứ tự FK)
        // Xóa quan hệ show - artist
        em.createQuery("DELETE FROM ShowArtist sa WHERE sa.showID.showID = :id")
                .setParameter("id", showId)
                .executeUpdate();

        // Nếu có ShowSchedule thì xóa
        // (đúng field thường là ss.showID.showID hoặc ss.showID)
        em.createQuery("DELETE FROM ShowSchedule ss WHERE ss.showID.showID = :id")
                .setParameter("id", showId)
                .executeUpdate();

        // TODO: Nếu bạn có Ticket/Booking phụ thuộc ShowSchedule/Show
        // Ví dụ (tùy model):
        // em.createQuery("DELETE FROM Ticket t WHERE t.showScheduleID.showScheduleID IN " +
        //                "(SELECT ss.showScheduleID FROM ShowSchedule ss WHERE ss.showID.showID = :id)")
        //   .setParameter("id", showId)
        //   .executeUpdate();

        // 2) XÓA SHOW CUỐI CÙNG
        em.createQuery("DELETE FROM Show s WHERE s.showID = :id")
                .setParameter("id", showId)
                .executeUpdate();

        // 3) ép flush để DB thực thi ngay trong transaction
        em.flush();
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

    // ✅ THÊM VÀO ShowFacade.java

    /**
     * Kiểm tra Show có lịch diễn nào đã được đặt vé chưa
     * @param showId ID của Show
     * @return true nếu có đơn hàng, false nếu không
     */
    @Override
    public boolean hasOrdersForShow(Integer showId) {
        if (showId == null) {
            return false;
        }

        try {
            // Đếm số lượng OrderDetail liên quan đến ShowSchedule của Show này
            Long count = em.createQuery(
                    "SELECT COUNT(od) " +
                    "FROM OrderDetail od " +
                    "WHERE od.scheduleID.showID.showID = :showId",
                    Long.class
            )
            .setParameter("showId", showId)
            .getSingleResult();

            System.out.println("✅ Show #" + showId + " có " + count + " đơn hàng");
            return count != null && count > 0;

        } catch (Exception e) {
            System.err.println("❌ Lỗi kiểm tra đơn hàng: " + e.getMessage());
            e.printStackTrace();
            return true; // AN TOÀN: Nếu lỗi thì CHẶN XÓA
        }
    }

    /**
     * Đếm số lượng đơn hàng của Show (để hiển thị)
     * @param showId
     * @return
     */
    @Override
    public Long countOrdersForShow(Integer showId) {
        if (showId == null) {
            return 0L;
        }

        try {
            return em.createQuery(
                    "SELECT COUNT(od) " +
                    "FROM OrderDetail od " +
                    "WHERE od.scheduleID.showID.showID = :showId",
                    Long.class
            )
            .setParameter("showId", showId)
            .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }

    // =========================================================
    // ✅ NEW: AUTO SYNC show.status theo schedule.status
    // Rule (đúng yêu cầu):
    //  - Nếu có ít nhất 1 schedule = Ongoing  => show = Ongoing
    //  - Else nếu có ít nhất 1 schedule = Upcoming => show = Upcoming
    //  - Else: KHÔNG cập nhật (giữ logic cũ, tránh phá Cancelled/Inactive/etc)
    //
    // Lưu ý:
    //  - Method này chỉ đồng bộ Show dựa trên status của ShowSchedule.
    //  - Bạn cần gọi nó sau khi schedule đã được sync realtime (Upcoming/Ongoing/Cancelled).
    // =========================================================
    @Override
    public void syncShowStatusFromSchedules() {
        try {
            // 1) Có schedule Ongoing -> show Ongoing
            em.createQuery(
                "UPDATE Show sh " +
                "SET sh.status = 'Ongoing' " +
                "WHERE EXISTS (" +
                "   SELECT 1 FROM ShowSchedule sc " +
                "   WHERE sc.showID = sh AND sc.status = 'Ongoing'" +
                ")"
            ).executeUpdate();

            // 2) Không có Ongoing nhưng có Upcoming -> show Upcoming
            em.createQuery(
                "UPDATE Show sh " +
                "SET sh.status = 'Upcoming' " +
                "WHERE NOT EXISTS (" +
                "   SELECT 1 FROM ShowSchedule sc " +
                "   WHERE sc.showID = sh AND sc.status = 'Ongoing'" +
                ") " +
                "AND EXISTS (" +
                "   SELECT 1 FROM ShowSchedule sc " +
                "   WHERE sc.showID = sh AND sc.status = 'Upcoming'" +
                ")"
            ).executeUpdate();

            em.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
