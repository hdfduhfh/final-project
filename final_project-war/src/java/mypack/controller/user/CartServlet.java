package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import mypack.Seat;
import mypack.SeatFacadeLocal;
import mypack.ShowSchedule;
import mypack.ShowScheduleFacadeLocal;
import mypack.User;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @EJB
    private SeatFacadeLocal seatFacade;

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        Integer userId = currentUser != null ? currentUser.getUserID() : null;
        String sessionId = session.getId();

        // Xử lý xóa item
        if ("remove".equals(action)) {
            String indexStr = request.getParameter("index");
            if (indexStr != null) {
                int index = Integer.parseInt(indexStr);
                List<CartItem> cart = getCartFromSession(session, userId);

                if (cart != null && index >= 0 && index < cart.size()) {
                    CartItem removedItem = cart.get(index);

                    // Release reservation
                    SeatReservationManager.getInstance().releaseReservation(
                            removedItem.getSeatID(),
                            removedItem.getScheduleID()
                    );

                    cart.remove(index);
                    saveCartToSession(session, cart, userId);
                }
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Xử lý clear cart
        if ("clear".equals(action)) {
            List<CartItem> cart = getCartFromSession(session, userId);

            // Release tất cả reservations
            if (cart != null) {
                for (CartItem item : cart) {
                    SeatReservationManager.getInstance().releaseReservation(
                            item.getSeatID(),
                            item.getScheduleID()
                    );
                }
            }

            clearCart(session, userId);
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Hiển thị giỏ hàng
        List<CartItem> cart = getCartFromSession(session, userId);

        // Kiểm tra và xóa các item đã hết hạn reservation
        if (cart != null) {
            Iterator<CartItem> iterator = cart.iterator();
            while (iterator.hasNext()) {
                CartItem item = iterator.next();
                SeatReservation reservation = SeatReservationManager.getInstance()
                        .getReservation(item.getSeatID(), item.getScheduleID());

                // Nếu không còn reservation hoặc reservation không thuộc user này
                if (reservation == null || !reservation.belongsTo(sessionId, userId)) {
                    iterator.remove();
                }
            }
            saveCartToSession(session, cart, userId);
        }

        // Tính tổng tiền
        double total = 0;
        if (cart != null) {
            for (CartItem item : cart) {
                total += item.getPrice();
            }
        }

        request.setAttribute("cartItems", cart != null ? cart : new ArrayList<>());
        request.setAttribute("total", total);
        request.getRequestDispatcher("/WEB-INF/views/user/cart.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            Integer userId = currentUser != null ? currentUser.getUserID() : null;
            String sessionId = session.getId();

            List<CartItem> cart = getCartFromSession(session, userId);

            try {
                int seatId = Integer.parseInt(request.getParameter("seatId"));
                int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

                // Kiểm tra xem ghế có bị user khác đặt không
                if (SeatReservationManager.getInstance().isReserved(seatId, scheduleId, sessionId, userId)) {
                    response.setContentType("text/html; charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('❌ Ghế đã được người khác chọn!');");
                    out.println("window.location.href='" + request.getContextPath() + "/seats/layout?scheduleId=" + scheduleId + "';");
                    out.println("</script>");
                    return;
                }

                // Lấy Seat từ DB
                Seat seat = seatFacade.find(seatId);
                if (seat == null) {
                    response.sendRedirect(request.getContextPath() + "/seats/layout?scheduleId=" + scheduleId);
                    return;
                }

                String seatNumber = seat.getSeatNumber();
                String seatType = seat.getSeatType();
                double price = seat.getPrice();

                // Lấy ShowSchedule từ DB
                ShowSchedule schedule = showScheduleFacade.find(scheduleId);
                if (schedule == null || schedule.getShowID() == null) {
                    response.sendRedirect(request.getContextPath() + "/seats/layout?scheduleId=" + scheduleId);
                    return;
                }

                String showName = schedule.getShowID().getShowName();

                // Kiểm tra ghế đã có trong giỏ chưa
                boolean exists = false;
                for (CartItem item : cart) {
                    if (item.getSeatID() == seatId && item.getScheduleID() == scheduleId) {
                        exists = true;
                        break;
                    }
                }

                if (!exists) {
                    // Đặt chỗ ghế (reserve)
                    boolean reserved = SeatReservationManager.getInstance()
                            .reserveSeat(seatId, scheduleId, sessionId, userId);

                    if (reserved) {
                        CartItem newItem = new CartItem(seatId, seatNumber, seatType,
                                scheduleId, showName, price);
                        cart.add(newItem);
                        saveCartToSession(session, cart, userId);
                    } else {
                        response.setContentType("text/html; charset=UTF-8");
                        PrintWriter out = response.getWriter();
                        out.println("<script>");
                        out.println("alert('❌ Ghế đã được người khác chọn!');");
                        out.println("window.location.href='" + request.getContextPath() + "/seats/layout?scheduleId=" + scheduleId + "';");
                        out.println("</script>");
                        return;
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            // Quay lại trang chọn ghế với scheduleId
            String scheduleIdParam = request.getParameter("scheduleId");
            response.sendRedirect(request.getContextPath()
                    + "/seats/layout?scheduleId=" + scheduleIdParam);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    // Helper methods để quản lý cart theo userId
    private List<CartItem> getCartFromSession(HttpSession session, Integer userId) {
        String cartKey = userId != null ? "cart_user_" + userId : "cart";
        List<CartItem> cart = (List<CartItem>) session.getAttribute(cartKey);
        if (cart == null) {
            cart = new ArrayList<>();
        }
        return cart;
    }

    private void saveCartToSession(HttpSession session, List<CartItem> cart, Integer userId) {
        String cartKey = userId != null ? "cart_user_" + userId : "cart";
        session.setAttribute(cartKey, cart);
    }

    private void clearCart(HttpSession session, Integer userId) {
        String cartKey = userId != null ? "cart_user_" + userId : "cart";
        session.removeAttribute(cartKey);
    }
}
