package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class RecruitmentFacade extends AbstractFacade<Recruitment> implements RecruitmentFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() { return em; }

    public RecruitmentFacade() { super(Recruitment.class); }

    @Override
    public void softDelete(Integer id) {
        Recruitment job = find(id);
        if (job != null) {
            job.setIsDeleted(true);
            edit(job);
        }
    }

    @Override
    public List<Recruitment> findByTitle(String keyword) {
        return em.createQuery("SELECT r FROM Recruitment r WHERE r.isDeleted=false AND LOWER(r.title) LIKE :kw", Recruitment.class)
                 .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                 .getResultList();
    }

    @Override
    public List<Recruitment> findPublishedByTitle(String keyword) {
        return em.createQuery("SELECT r FROM Recruitment r WHERE r.isDeleted=false AND r.status='Open' AND LOWER(r.title) LIKE :kw", Recruitment.class)
                 .setParameter("kw", "%" + keyword.toLowerCase() + "%")
                 .getResultList();
    }

    @Override
    public List<Recruitment> findPage(int page, int pageSize) {
        return em.createQuery("SELECT r FROM Recruitment r WHERE r.isDeleted=false ORDER BY r.postedAt DESC", Recruitment.class)
                 .setFirstResult((page - 1) * pageSize)
                 .setMaxResults(pageSize)
                 .getResultList();
    }

    @Override
    public long countAll() {
        return em.createQuery("SELECT COUNT(r) FROM Recruitment r WHERE r.isDeleted=false", Long.class)
                 .getSingleResult();
    }
}