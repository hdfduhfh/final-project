package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class ApplicationFacade implements ApplicationFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    public void create(Application app) {
        em.persist(app);
    }

    @Override
    public void edit(Application app) {
        em.merge(app);
    }

    @Override
    public void remove(Application app) {
        em.remove(em.merge(app));
    }

    @Override
    public Application find(Object id) {
        return em.find(Application.class, id);
    }

    @Override
    public List<Application> findAll() {
        return em.createQuery("SELECT a FROM Application a", Application.class).getResultList();
    }

    @Override
    public List<Application> findByJobId(int jobId) {
        return em.createQuery("SELECT a FROM Application a WHERE a.job.jobID = :jobId", Application.class)
                 .setParameter("jobId", jobId)
                 .getResultList();
    }

    @Override
public List<Application> searchByNameOrPhone(String keyword) {
    return em.createQuery("SELECT a FROM Application a WHERE a.fullName LIKE :kw OR a.phone LIKE :kw", Application.class)
             .setParameter("kw", "%" + keyword + "%")
             .getResultList();
}
    @Override
    public List<Application> findByStatus(String status) {
        return em.createQuery("SELECT a FROM Application a WHERE a.status = :status", Application.class)
                 .setParameter("status", status)
                 .getResultList();
    }
}