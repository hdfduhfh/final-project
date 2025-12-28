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
public interface TicketFacadeLocal {

    void create(Ticket ticket);

    void edit(Ticket ticket);

    void remove(Ticket ticket);

    Ticket find(Object id);

    List<Ticket> findAll();

    List<Ticket> findRange(int[] range);

    int count();

    List<Ticket> findByOrderDetailId(int orderDetailId);

    List<Ticket> findByOrderId(int orderId);

    Ticket findByQRCode(String qrCode);

    String checkInTicket(String qrCode);

    List<Ticket> findWithPaging(int offset, int limit);

    int countAll();
}
