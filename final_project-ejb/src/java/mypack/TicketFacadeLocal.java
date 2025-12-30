package mypack;

import jakarta.ejb.Local;
import java.util.Date;
import java.util.List;

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
    
    // NEW: Advanced search methods
    List<Ticket> searchTickets(String qrCode, String status, String customerName, 
                               Date fromDate, Date toDate, int offset, int limit);
    int countSearchResults(String qrCode, String status, String customerName, 
                          Date fromDate, Date toDate);
}