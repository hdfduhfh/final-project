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
public interface ShowScheduleFacadeLocal {

    void create(ShowSchedule showSchedule);

    void edit(ShowSchedule showSchedule);

    void remove(ShowSchedule showSchedule);

    ShowSchedule find(Object id);

    List<ShowSchedule> findAll();

    List<ShowSchedule> findRange(int[] range);

    int count();
    
}
