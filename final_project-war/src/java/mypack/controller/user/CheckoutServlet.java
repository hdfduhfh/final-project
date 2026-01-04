package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import mypack.*;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @EJB
    private TicketFacadeLocal ticketFacade;

    @EJB
    private Order1FacadeLocal orderFacade;

    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;

    @EJB
    private SeatFacadeLocal seatFacade;

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    @EJB
    private PromotionFacadeLocal promotionFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            request.setAttribute("showLoginModal", true);
            request.getRequestDispatcher("/WEB-INF/views/user/cart.jsp").forward(request, response);
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart_user_" + currentUser.getUserID());
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double total = 0;
        for (CartItem item : cart) {
            total += item.getPrice();
        }

        List<Promotion> activePromotions = new ArrayList<>();
        Date now = new Date();
        for (Promotion promo : promotionFacade.findAll()) {
            if ("ACTIVE".equals(promo.getStatus())
                    && now.after(promo.getStartDate())
                    && now.before(promo.getEndDate())) {
                activePromotions.add(promo);
            }
        }

        request.setAttribute("cartItems", cart);
        request.setAttribute("total", total);
        request.setAttribute("user", currentUser);
        request.setAttribute("promotions", activePromotions);

        request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp")
                .forward(request, response);
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("user");

    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart_user_" + currentUser.getUserID());
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    try {
        // ✅ BƯỚC 1: KIỂM TRA AN TOÀN GHẾ
        List<String> errorMessages = new ArrayList<>();

        for (CartItem item : cart) {
            Seat seat = seatFacade.find(item.getSeatID());
            
            // Kiểm tra ghế còn active không
            if (seat == null || !seat.getIsActive()) {
                errorMessages.add("Ghế " + item.getSeatNumber() + 
                    " hiện đang bảo trì hoặc đã bị vô hiệu hóa.");
                continue;
            }
            
            // ✅ KIỂM TRA MỚI: GHẾ ĐÃ BỊ ĐẶT BỞI AI KHÁC CHƯA?
            Set<Integer> bookedSeats = orderDetailFacade
                .findBookedSeatIdsBySchedule(item.getScheduleID());
            
            if (bookedSeats.contains(item.getSeatID())) {
                errorMessages.add("⚠️ Ghế " + item.getSeatNumber() + 
                    " đã có người đặt! Vui lòng quay lại giỏ hàng và chọn ghế khác.");
            }
        }

        // Nếu có lỗi → Dừng lại
        if (!errorMessages.isEmpty()) {
            request.setAttribute("error", String.join("<br>", errorMessages));
            setupCheckoutPageForError(request, cart, currentUser);
            request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp")
                .forward(request, response);
            return;
        }

        // ✅ BƯỚC 2: TÍNH TOÁN TIỀN (GIỮ NGUYÊN CODE CŨ)
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cart) {
            totalAmount = totalAmount.add(BigDecimal.valueOf(item.getPrice()));
        }

        // KHUYẾN MÃI (GIỮ NGUYÊN)
        BigDecimal discountAmount = BigDecimal.ZERO;
        Promotion appliedPromotion = null;
        String promotionIdStr = request.getParameter("promotionId");

        if (promotionIdStr != null && !"0".equals(promotionIdStr)) {
            int promoId = Integer.parseInt(promotionIdStr);
            appliedPromotion = promotionFacade.find(promoId);

            if (appliedPromotion != null) {
                if (promotionFacade.isPromotionValid(appliedPromotion, totalAmount, currentUser)) {

                    String type = appliedPromotion.getDiscountType();
                    BigDecimal value = appliedPromotion.getDiscountValue();
                    BigDecimal maxDiscount = appliedPromotion.getMaxDiscount();

                    if ("FIXED".equals(type)) {
                        discountAmount = value;
                    } else if ("PERCENT".equals(type)) {
                        discountAmount = totalAmount.multiply(value).divide(BigDecimal.valueOf(100));

                        if (maxDiscount != null && maxDiscount.compareTo(BigDecimal.ZERO) > 0) {
                            if (discountAmount.compareTo(maxDiscount) > 0) {
                                discountAmount = maxDiscount;
                            }
                        }
                    }

                } else {
                    request.setAttribute("error", "Mã giảm giá không hợp lệ, đã hết hạn hoặc bạn đã sử dụng hết lượt!");
                    setupCheckoutPageForError(request, cart, currentUser);
                    request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp").forward(request, response);
                    return;
                }
            }
        }

        BigDecimal finalAmount = totalAmount.subtract(discountAmount);
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }

        String paymentMethod = request.getParameter("paymentMethod");

        if (paymentMethod == null || "CASH".equals(paymentMethod)) {
            request.setAttribute("error", "Vui lòng chọn phương thức thanh toán online (VNPay/Momo/Banking)!");
            setupCheckoutPageForError(request, cart, currentUser);
            request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp").forward(request, response);
            return;
        }

        // ✅ BƯỚC 3: TẠO ORDER
        Order1 order = new Order1();
        order.setUserID(currentUser);
        order.setTotalAmount(totalAmount);
        order.setDiscountAmount(discountAmount);
        order.setFinalAmount(finalAmount);
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("UNPAID");
        order.setStatus("PENDING");
        order.setCreatedAt(new Date());

        if (appliedPromotion != null) {
            order.setPromotionCode(appliedPromotion.getCode());
            order.setPromotionID(appliedPromotion);
        }

        orderFacade.create(order);

        // ✅ BƯỚC 4: TẠO ORDER DETAIL + VÉ
        for (CartItem item : cart) {
            Seat seat = seatFacade.find(item.getSeatID());
            ShowSchedule schedule = showScheduleFacade.find(item.getScheduleID());

            if (seat == null || schedule == null) {
                continue;
            }

            OrderDetail detail = new OrderDetail();
            detail.setOrderID(order);
            detail.setSeatID(seat);
            detail.setScheduleID(schedule);
            detail.setPrice(BigDecimal.valueOf(item.getPrice()));
            detail.setQuantity(1);
            detail.setCreatedAt(new Date());

            orderDetailFacade.create(detail);

            Ticket ticket = new Ticket();
            ticket.setOrderDetailID(detail);
            ticket.setStatus("VALID");

            String qrCode = "TICKET-"
                    + order.getOrderID() + "-"
                    + detail.getOrderDetailID() + "-"
                    + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            ticket.setQRCode(qrCode);
            ticket.setIssuedAt(new Date());
            ticket.setCreatedAt(new Date());

            ticketFacade.create(ticket);
            
            // ✅ RELEASE RESERVATION SAU KHI ĐẶT THÀNH CÔNG
            mypack.controller.user.SeatReservationManager.getInstance()
                .releaseReservation(item.getSeatID(), item.getScheduleID());
        }

        session.setAttribute("pending_order_id", order.getOrderID());

        // Đánh dấu đơn đã thanh toán thành công
        order.setPaymentStatus("PAID");
        order.setStatus("CONFIRMED");
        orderFacade.edit(order);

        // ✅ BƯỚC 5: XÓA GIỎ HÀNG
        session.removeAttribute("cart_user_" + currentUser.getUserID());

        // ✅ BƯỚC 6: CHUYỂN SANG XÁC NHẬN
        response.sendRedirect(request.getContextPath() + "/order/confirmation?orderId=" + order.getOrderID());

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Có lỗi xảy ra khi xử lý đơn hàng: " + e.getMessage());
        setupCheckoutPageForError(request, cart, currentUser);
        request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp")
                .forward(request, response);
    }
}

    private void setupCheckoutPageForError(HttpServletRequest request, List<CartItem> cart, User currentUser) {
        request.setAttribute("cartItems", cart);

        double total = 0;
        for (CartItem item : cart) {
            total += item.getPrice();
        }
        request.setAttribute("total", total);
        request.setAttribute("user", currentUser);

        List<Promotion> activePromotions = new ArrayList<>();
        Date now = new Date();
        for (Promotion promo : promotionFacade.findAll()) {
            if ("ACTIVE".equals(promo.getStatus())
                    && now.after(promo.getStartDate())
                    && now.before(promo.getEndDate())) {
                activePromotions.add(promo);
            }
        }
        request.setAttribute("promotions", activePromotions);
    }
}
