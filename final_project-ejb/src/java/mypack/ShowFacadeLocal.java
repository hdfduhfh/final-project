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
public interface ShowFacadeLocal {

    void create(Show show);

    void edit(Show show);

    void remove(Show show);

    Show find(Object id);

    List<Show> findAll();

    List<Show> findRange(int[] range);

    int count();
    
}
