/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import java.util.List;
import mypack.utils.HashUtils;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class UserFacade extends AbstractFacade<User> implements UserFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UserFacade() {
        super(User.class);
    }

    // File này thêm vào nếu null sẽ ko tìm thấy user
    public User login(String email, String password) {
        try {
            String passwordHash = HashUtils.hashPassword(password);

            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email AND u.passwordHash = :passwordHash",
                    User.class
            );
            query.setParameter("email", email);
            query.setParameter("passwordHash", passwordHash);

            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ===== Triển khai existsByEmail =====
    @Override
    public boolean existsByEmail(String email) {
        Long count = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.email = :email", Long.class)
                .setParameter("email", email)
                .getSingleResult();
        return count > 0;
    }

    @Override
    public User findByEmail(String email) {
        try {
            Query q = em.createNamedQuery("User.findByEmail", User.class); // Hoặc câu lệnh SQL của ní
            q.setParameter("email", email);

            List<User> results = q.getResultList();

            if (!results.isEmpty()) {
                // Nếu có nhiều người trùng email, lấy người đầu tiên tìm thấy
                return results.get(0);
            }
            return null; // Không tìm thấy ai
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public Long countOrdersByUser(Integer userID) {
        return em.createQuery(
                "SELECT COUNT(o) FROM Order1 o WHERE o.userID.userID = :uid", Long.class)
                .setParameter("uid", userID)
                .getSingleResult();
    }

}
