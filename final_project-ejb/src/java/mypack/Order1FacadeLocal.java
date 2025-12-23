/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package mypack;

import jakarta.ejb.Local;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
@Local
public interface Order1FacadeLocal {

    void create(Order1 order1);

    void edit(Order1 order1);

    void remove(Order1 order1);

    Order1 find(Object id);

    List<Order1> findAll();

    List<Order1> findRange(int[] range);

    int count();
    
    List<Order1> findByUser(User user);

    
}
