package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mypack.Event;
import mypack.EventFacadeLocal;
import mypack.EventRegistration;
import mypack.EventRegistrationFacadeLocal;
import mypack.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.List;

/**
 * Servlet quản lý Event cho User
 * @author DANG KHOA
 */
@WebServlet(name = "EventServlet", urlPatterns = {"/events", "/event-detail", "/event-register"})
public class EventServlet extends HttpServlet {

    @EJB
    private EventFacadeLocal eventFacade;
    
    @EJB
    private EventRegistrationFacadeLocal registrationFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        try {
            switch (path) {
                case "/events":
                    showEventList(request, response);
                    break;
                case "/event-detail":
                    showEventDetail(request, response);
                    break;
                default:
                    showEventList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/user/event/events.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        if ("/event-register".equals(path)) {
            registerEvent(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ========== SHOW EVENT LIST ==========
    private void showEventList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        String typeFilter = request.getParameter("type");

        List<Event> events;
        List<Event> upcomingEvents;
        List<Event> popularEvents;

        if (keyword != null && !keyword.trim().isEmpty()) {
            events = eventFacade.searchByName(keyword);
            events.removeIf(e -> !e.isIsPublished());
        } else if (typeFilter != null && !typeFilter.isEmpty()) {
            events = eventFacade.findByEventType(typeFilter);
            events.removeIf(e -> !e.isIsPublished());
        } else {
            events = eventFacade.findPublished();
        }

        upcomingEvents = eventFacade.findUpcoming();
        if (upcomingEvents.size() > 6) {
            upcomingEvents = upcomingEvents.subList(0, 6);
        }

        popularEvents = eventFacade.findPopularEvents(4);

        request.setAttribute("events", events);
        request.setAttribute("upcomingEvents", upcomingEvents);
        request.setAttribute("popularEvents", popularEvents);
        request.setAttribute("keyword", keyword);
        request.setAttribute("typeFilter", typeFilter);

        request.getRequestDispatcher("/WEB-INF/views/user/event/events.jsp").forward(request, response);
    }

    // ========== SHOW EVENT DETAIL ==========
    private void showEventDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String eventIdStr = request.getParameter("id");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/events");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventFacade.find(eventId);

            if (event == null || !event.isIsPublished()) {
                request.setAttribute("error", "Sự kiện không tồn tại hoặc chưa được công khai!");
                showEventList(request, response);
                return;
            }

            List<Event> relatedEvents = eventFacade.findByEventType(event.getEventType());
            relatedEvents.removeIf(e -> e.getEventID().equals(eventId) || !e.isIsPublished());
            if (relatedEvents.size() > 3) {
                relatedEvents = relatedEvents.subList(0, 3);
            }

            request.setAttribute("event", event);
            request.setAttribute("relatedEvents", relatedEvents);
            request.getRequestDispatcher("/WEB-INF/views/user/event/event-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }

    // ========== REGISTER EVENT ==========
    private void registerEvent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập để đăng ký sự kiện\"}");
            out.flush();
            return;
        }
        
        try {
            String eventIdStr = request.getParameter("eventId");
            if (eventIdStr == null || eventIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"message\":\"Thiếu thông tin sự kiện\"}");
                out.flush();
                return;
            }
            
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventFacade.find(eventId);
            
            if (event == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false,\"message\":\"Không tìm thấy sự kiện\"}");
                out.flush();
                return;
            }
            
            // ⭐ KIỂM TRA ĐÃ ĐĂNG KÝ CHƯA
            if (registrationFacade.isUserRegistered(currentUser, event)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                out.print("{\"success\":false,\"message\":\"Bạn đã đăng ký sự kiện này rồi\"}");
                out.flush();
                return;
            }
            
            // Kiểm tra event có thể đăng ký không
            if (!event.canRegister()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                String errorMsg;
                if (event.isFull()) {
                    errorMsg = "Sự kiện đã hết chỗ";
                } else if (event.isRegistrationClosed()) {
                    errorMsg = "Đã hết hạn đăng ký";
                } else {
                    errorMsg = "Sự kiện không thể đăng ký";
                }
                out.print("{\"success\":false,\"message\":\"" + errorMsg + "\"}");
                out.flush();
                return;
            }
            
            // ⭐ TẠO ĐĂNG KÝ MỚI
            EventRegistration registration = new EventRegistration();
            registration.setUserID(currentUser);
            registration.setEventID(event);
            registration.setRegistrationDate(new Date());
            registration.setStatus("Confirmed");
            
            registrationFacade.create(registration);
            
            // ⭐ TĂNG SỐ NGƯỜI THAM GIA
            boolean success = eventFacade.incrementAttendees(eventId);
            
            if (success) {
                // Lấy lại event để có số liệu mới nhất
                event = eventFacade.find(eventId);
                
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"success\":true,\"message\":\"Đăng ký thành công! Chúng tôi sẽ gửi thông tin chi tiết qua email của bạn.\",\"currentAttendees\":" + event.getCurrentAttendees() + ",\"availableSlots\":" + event.getAvailableSlots() + "}");
            } else {
                // Rollback registration nếu không tăng được attendees
                registrationFacade.remove(registration);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"success\":false,\"message\":\"Không thể đăng ký, vui lòng thử lại\"}");
            }
            
            out.flush();
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"message\":\"ID sự kiện không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra, vui lòng thử lại sau\"}");
            out.flush();
        }
    }
}