/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

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
            return em.createQuery(
                    "SELECT u FROM User u WHERE u.email = :email AND u.passwordHash = :pass", User.class)
                    .setParameter("email", email)
                    .setParameter("pass", password)
                    .getSingleResult();
        } catch (Exception e) {
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
}
