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
public interface SeatFacadeLocal {

    void create(Seat seat);

    void edit(Seat seat);

    void remove(Seat seat);

    Seat find(Object id);

    List<Seat> findAll();

    List<Seat> findRange(int[] range);

    int count();
    
}
