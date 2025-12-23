package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import mypack.Order1;
import mypack.Order1FacadeLocal;
import mypack.User;
import mypack.UserFacadeLocal;
import mypack.Seat;
import mypack.SeatFacadeLocal;
import mypack.ShowSchedule;
import mypack.ShowScheduleFacadeLocal;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @EJB
    private Order1FacadeLocal orderFacade; 

    @EJB
    private UserFacadeLocal userFacade;

    @EJB
    private SeatFacadeLocal seatFacade;

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userFacade.login(email, password);

        PrintWriter out = response.getWriter();

        if (user == null) {
            // Sai thông tin
            out.print("{\"success\":false, \"message\":\"Sai thông tin đăng nhập!\"}");
            return;
        }

        // Lưu session
        HttpSession session = request.getSession();
        String sessionId = session.getId();

        session.setAttribute("user", user);
        List<Order1> orders = orderFacade.findByUser(user);
        session.setAttribute("userOrders", orders);
        // ==========================================
        // BƯỚC 1: Chuyển reservation từ sessionId sang userId
        // ==========================================
        SeatReservationManager.getInstance().transferReservationsToUser(sessionId, user.getUserID());

        // ==========================================
        // BƯỚC 2: Merge cart tạm vào cart user TRƯỚC KHI rebuild
        // ==========================================
        List<CartItem> tempCart = (List<CartItem>) session.getAttribute("cart");
        List<CartItem> userCart = (List<CartItem>) session.getAttribute("cart_user_" + user.getUserID());

        if (userCart == null) {
            userCart = new ArrayList<>();
        }

        // Merge cart tạm (từ lúc chưa login)
        if (tempCart != null && !tempCart.isEmpty()) {
            for (CartItem tempItem : tempCart) {
                boolean exists = false;
                for (CartItem userItem : userCart) {
                    if (userItem.getSeatID() == tempItem.getSeatID()
                            && userItem.getScheduleID() == tempItem.getScheduleID()) {
                        exists = true;
                        break;
                    }
                }
                if (!exists) {
                    userCart.add(tempItem);
                }
            }
        }

        // ==========================================
        // BƯỚC 3: Lấy lại reservations cũ của user (từ lần login trước)
        // ==========================================
        Map<String, SeatReservation> userReservations
                = SeatReservationManager.getInstance().getUserReservations(user.getUserID());

        // ==========================================
        // BƯỚC 4: Rebuild cart từ reservations CŨ (không có trong cart hiện tại)
        // ==========================================
        if (!userReservations.isEmpty()) {
            for (Map.Entry<String, SeatReservation> entry : userReservations.entrySet()) {
                SeatReservation reservation = entry.getValue();

                try {
                    // Kiểm tra ghế này đã có trong cart chưa
                    boolean alreadyInCart = false;
                    for (CartItem item : userCart) {
                        if (item.getSeatID() == reservation.getSeatId()
                                && item.getScheduleID() == reservation.getScheduleId()) {
                            alreadyInCart = true;
                            break;
                        }
                    }

                    if (!alreadyInCart) {
                        // Lấy thông tin ghế và suất diễn từ database
                        Seat seat = seatFacade.find(reservation.getSeatId());
                        ShowSchedule schedule = showScheduleFacade.find(reservation.getScheduleId());

                        if (seat != null && schedule != null) {
                            CartItem item = new CartItem(
                                    seat.getSeatID(),
                                    seat.getSeatNumber(),
                                    seat.getSeatType(),
                                    schedule.getScheduleID(),
                                    schedule.getShowID().getShowName(),
                                    seat.getPrice()
                            );
                            userCart.add(item);
                        }
                    }
                } catch (Exception e) {
                    // Skip nếu có lỗi
                    e.printStackTrace();
                }
            }
        }

        // Lưu cart đã merge + rebuild
        if (!userCart.isEmpty()) {
            session.setAttribute("cart_user_" + user.getUserID(), userCart);
        }

        // Xóa cart tạm
        session.removeAttribute("cart");

        // ==========================================
        // Trả về JSON response
        // ==========================================
        String role = user.getRoleID().getRoleName().equalsIgnoreCase("ADMIN") ? "ADMIN" : "USER";

        // Kiểm tra có redirectAfterLogin không
        String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
        if (redirectUrl != null) {
            session.removeAttribute("redirectAfterLogin");
            out.print("{\"success\":true, \"role\":\"" + role + "\", \"redirectUrl\":\"" + redirectUrl + "\"}");
        } else {
            out.print("{\"success\":true, \"role\":\"" + role + "\"}");
        }
    }
}
