package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import mypack.Seat;
import mypack.SeatFacadeLocal;
import mypack.ShowSchedule;
import mypack.ShowScheduleFacadeLocal;
import mypack.OrderDetailFacadeLocal;
import mypack.User;

@WebServlet(name = "SeatLayoutServlet", urlPatterns = {"/seats/layout"})
public class SeatLayoutServlet extends HttpServlet {
    
    @EJB
    private SeatFacadeLocal seatFacade;
    
    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;
    
    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String currentSessionId = session.getId();
        
        // Lấy user từ session
        User currentUser = (User) session.getAttribute("user");
        Integer userId = null;
        if (currentUser != null) {
            userId = currentUser.getUserID();
        }
        
        // Lấy tất cả ghế active
        List<Seat> seats = seatFacade.findAll();
        List<Seat> activeSeats = new ArrayList<>();
        for (Seat s : seats) {
            if (s.getIsActive()) {
                activeSeats.add(s);
            }
        }
        
        // Map ghế theo khu vực: TOP, LEFT, RIGHT, BOTTOM
        Map<String, List<Seat>> seatMap = new HashMap<>();
        seatMap.put("TOP", new ArrayList<>());
        seatMap.put("LEFT", new ArrayList<>());
        seatMap.put("RIGHT", new ArrayList<>());
        seatMap.put("BOTTOM", new ArrayList<>());
        
        for (Seat s : activeSeats) {
            char row = s.getRowLabel().charAt(0);
            if (row >= 'A' && row <= 'E') {
                seatMap.get("TOP").add(s);
            } else if (row >= 'F' && row <= 'J') {
                seatMap.get("LEFT").add(s);
            } else if (row >= 'K' && row <= 'O') {
                seatMap.get("RIGHT").add(s);
            } else if (row >= 'P' && row <= 'T') {
                seatMap.get("BOTTOM").add(s);
            }
        }
        
        // Sắp xếp từng khu vực: theo hàng rồi đến cột
        Comparator<Seat> comparator = Comparator
                .comparing((Seat s) -> s.getRowLabel())
                .thenComparingInt(Seat::getColumnNumber);
        
        seatMap.values().forEach(list -> list.sort(comparator));
        
        // Lấy danh sách tất cả suất diễn chưa hết hạn (chỉ lấy suất từ hiện tại trở đi)
        List<ShowSchedule> allSchedules = showScheduleFacade.findAll();
        List<ShowSchedule> schedules = new ArrayList<>();
        Date now = new Date();
        
        for (ShowSchedule schedule : allSchedules) {
            if (schedule.getShowTime().after(now)) {
                schedules.add(schedule);
            }
        }
        
        request.setAttribute("schedules", schedules);
        
        // Nhận scheduleId nếu người dùng đã chọn
        String scheduleIdRaw = request.getParameter("scheduleId");
        Set<Integer> bookedSeatIds = new HashSet<>();
        Set<Integer> reservedSeatIds = new HashSet<>();
        
        if (scheduleIdRaw != null && !scheduleIdRaw.isEmpty()) {
            int scheduleId = Integer.parseInt(scheduleIdRaw);
            request.setAttribute("selectedScheduleId", scheduleId);
            
            // Lấy danh sách ghế đã đặt (đã thanh toán)
            bookedSeatIds = orderDetailFacade.findBookedSeatIdsBySchedule(scheduleId);
            
            // Lấy danh sách ghế đang được reserve bởi user khác
            for (Seat seat : activeSeats) {
                boolean isReserved = SeatReservationManager.getInstance()
                    .isReserved(seat.getSeatID(), scheduleId, currentSessionId, userId);
                
                if (isReserved) {
                    reservedSeatIds.add(seat.getSeatID());
                }
            }
        }
        
        // Lấy cart từ session (theo userId nếu đã login)
        String cartKey = (userId != null) ? "cart_user_" + userId : "cart";
        List<CartItem> cart = (List<CartItem>) session.getAttribute(cartKey);
        Set<Integer> cartSeatIds = new HashSet<>();
        
        if (cart != null) {
            for (CartItem item : cart) {
                cartSeatIds.add(item.getSeatID());
            }
        }
        
        // Gửi dữ liệu sang JSP
        request.setAttribute("seatMap", seatMap);
        request.setAttribute("bookedSeatIds", bookedSeatIds);
        request.setAttribute("reservedSeatIds", reservedSeatIds);
        request.setAttribute("cartSeatIds", cartSeatIds);
        request.setAttribute("cartSize", cart != null ? cart.size() : 0);
        
        request.getRequestDispatcher("/WEB-INF/views/user/seats/layout.jsp")
                .forward(request, response);
    }
}