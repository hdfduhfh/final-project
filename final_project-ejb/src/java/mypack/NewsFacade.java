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

@Stateless
public class NewsFacade extends AbstractFacade<News> implements NewsFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public NewsFacade() {
        super(News.class);
    }

    @Override
    public void create(News news) {
        // generate slug nếu trống
        if (news.getSlug() == null || news.getSlug().isEmpty()) {
            news.setSlug(generateSlug(news.getTitle()));
        }
        // check slug unique
        if (findBySlug(news.getSlug()) != null) {
            throw new IllegalArgumentException("Slug đã tồn tại");
        }
        super.create(news);
    }

    @Override
    public void edit(News news) {
        // check slug unique khi edit
        News existed = findBySlug(news.getSlug());
        if (existed != null && !existed.getNewsID().equals(news.getNewsID())) {
            throw new IllegalArgumentException("Slug đã tồn tại");
        }
        super.edit(news);
    }

    @Override
    public void remove(News news) {
        // khuyến nghị dùng softDelete thay vì remove
        super.remove(news);
    }

    @Override
    public News findBySlug(String slug) {
        try {
            TypedQuery<News> q = em.createQuery(
                    "SELECT n FROM News n WHERE n.slug = :slug", News.class);
            q.setParameter("slug", slug);
            List<News> results = q.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void softDelete(Integer id) {
        News n = find(id);
        if (n != null) {
            n.setIsDeleted(true);
            edit(n);
        }
    }

    @Override
    public List<News> findPublished(int page, int size, String keyword) {
        String jpql = "SELECT n FROM News n WHERE n.isDeleted=false AND LOWER(n.status)='published' "
                + "AND (:kw IS NULL OR LOWER(n.title) LIKE :kw OR LOWER(n.summary) LIKE :kw) "
                + "ORDER BY n.createdAt DESC";
        return em.createQuery(jpql, News.class)
                .setParameter("kw", keyword == null ? null : "%" + keyword.toLowerCase() + "%")
                .setFirstResult(page * size)
                .setMaxResults(size)
                .getResultList();
    }

    @Override
    public List<News> findAdminList(int page, int size, String status, String keyword, boolean includeDeleted) {
        String jpql = "SELECT n FROM News n WHERE (:includeDeleted=true OR n.isDeleted=false) "
                + "AND (:status IS NULL OR LOWER(n.status)=LOWER(:status)) "
                + "AND (:kw IS NULL OR LOWER(n.title) LIKE :kw OR LOWER(n.summary) LIKE :kw) "
                + "ORDER BY n.createdAt DESC";
        return em.createQuery(jpql, News.class)
                .setParameter("includeDeleted", includeDeleted)
                .setParameter("status", status)
                .setParameter("kw", keyword == null ? null : "%" + keyword.toLowerCase() + "%")
                .setFirstResult(page * size)
                .setMaxResults(size)
                .getResultList();
    }

    public int countAdminList(String status, String keyword, boolean includeDeleted) {
        String jpql = "SELECT COUNT(n) FROM News n WHERE (:includeDeleted=true OR n.isDeleted=false) "
                + "AND (:status IS NULL OR LOWER(n.status)=LOWER(:status)) "
                + "AND (:kw IS NULL OR LOWER(n.title) LIKE :kw OR LOWER(n.summary) LIKE :kw)";
        Long count = em.createQuery(jpql, Long.class)
                .setParameter("includeDeleted", includeDeleted)
                .setParameter("status", status)
                .setParameter("kw", keyword == null ? null : "%" + keyword.toLowerCase() + "%")
                .getSingleResult();
        return count.intValue();
    }

    @Override
    public List<News> findByTitle(String keyword) {
        // admin: tìm tất cả (trừ deleted)
        return em.createQuery("SELECT n FROM News n WHERE n.isDeleted=false AND LOWER(n.title) LIKE :kw", News.class)
                .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                .getResultList();
    }

    @Override
    public List<News> findPage(int page, int pageSize) {
        return em.createQuery("SELECT n FROM News n WHERE n.isDeleted=false ORDER BY n.createdAt DESC", News.class)
                .setFirstResult((page - 1) * pageSize)
                .setMaxResults(pageSize)
                .getResultList();
    }

    @Override
    public long countAll() {
        return em.createQuery("SELECT COUNT(n) FROM News n WHERE n.isDeleted=false", Long.class)
                .getSingleResult();
    }

    @Override
    public List<News> findPublishedPage(int page, int pageSize) {
        return em.createQuery("SELECT n FROM News n WHERE n.isDeleted=false AND n.status='Published' ORDER BY n.createdAt DESC", News.class)
                .setFirstResult((page - 1) * pageSize)
                .setMaxResults(pageSize)
                .getResultList();
    }

    @Override
    public long countPublished() {
        return em.createQuery("SELECT COUNT(n) FROM News n WHERE n.isDeleted=false AND n.status='Published'", Long.class)
                .getSingleResult();
    }

    @Override
    public List<News> findPublishedByTitle(String keyword) {
        // public: chỉ lấy Published
        return em.createQuery("SELECT n FROM News n WHERE n.isDeleted=false AND LOWER(n.status)='published' AND LOWER(n.title) LIKE :kw", News.class)
                .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                .getResultList();
    }

    private String generateSlug(String title) {
        String s = title.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .trim()
                .replaceAll("\\s+", "-");
        return s.length() > 200 ? s.substring(0, 200) : s;
    }

}

