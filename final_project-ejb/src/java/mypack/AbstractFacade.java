package mypack;

import jakarta.persistence.EntityManager;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;

/**
 * Lớp generic dùng chung cho tất cả các Facade (ShowFacade, ArtistFacade,
 * ShowScheduleFacade, ShowArtistFacade).
 *
 * Cung cấp sẵn các hàm CRUD cơ bản để tránh lặp lại code.
 *
 * @param <T> kiểu entity (Show, Artist, ShowSchedule, ShowArtist, ...)
 */
public abstract class AbstractFacade<T> {

    private final Class<T> entityClass;

    public AbstractFacade(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    /**
     * Mỗi Facade con phải implement hàm này
     * để trả về EntityManager tương ứng (được inject bằng @PersistenceContext).
     */
    protected abstract EntityManager getEntityManager();

    // ============================================================
    //                      CÁC HÀM CRUD CƠ BẢN
    // ============================================================

    /**
     * Lưu entity mới vào database.
     */
    public void create(T entity) {
        getEntityManager().persist(entity);
    }

    /**
     * Cập nhật entity (merge) và trả về instance đã merge.
     */
    public T edit(T entity) {
        return getEntityManager().merge(entity);
    }

    /**
     * Xoá entity khỏi database.
     */
    public void remove(T entity) {
        getEntityManager().remove(getEntityManager().merge(entity));
    }

    /**
     * Tìm entity theo khoá chính.
     */
    public T find(Object id) {
        return getEntityManager().find(entityClass, id);
    }

    /**
     * Lấy toàn bộ bản ghi của entity.
     */
    public List<T> findAll() {
        EntityManager em = getEntityManager();
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<T> cq = cb.createQuery(entityClass);
        Root<T> root = cq.from(entityClass);
        cq.select(root);
        return em.createQuery(cq).getResultList();
    }

    /**
     * Lấy một dải bản ghi (phân trang), từ index range[0] tới range[1] (inclusive).
     * Ví dụ: range = {0, 9} => lấy 10 bản ghi đầu tiên.
     */
    public List<T> findRange(int[] range) {
        if (range == null || range.length != 2) {
            throw new IllegalArgumentException("range phải có 2 phần tử: {from, to}");
        }

        EntityManager em = getEntityManager();
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<T> cq = cb.createQuery(entityClass);
        Root<T> root = cq.from(entityClass);
        cq.select(root);

        var query = em.createQuery(cq);
        int from = range[0];
        int to = range[1];
        int pageSize = to - from + 1;

        query.setFirstResult(from);
        query.setMaxResults(pageSize);

        return query.getResultList();
    }

    /**
     * Đếm tổng số bản ghi của entity.
     */
    public int count() {
        EntityManager em = getEntityManager();
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Long> cq = cb.createQuery(Long.class);
        Root<T> root = cq.from(entityClass);
        cq.select(cb.count(root));
        Long result = em.createQuery(cq).getSingleResult();
        return (result != null) ? result.intValue() : 0;
    }
}
