/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
@Stateless
public class RoleFacade extends AbstractFacade<Role> implements RoleFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public RoleFacade() {
        super(Role.class);
    }

    @Override
    public Role findByName(String name) {
        List<Role> list = em.createQuery(
                "SELECT r FROM Role r WHERE r.roleName = :name",
                Role.class
        )
                .setParameter("name", name.trim())
                .getResultList();

        return list.isEmpty() ? null : list.get(0);
    }

}
