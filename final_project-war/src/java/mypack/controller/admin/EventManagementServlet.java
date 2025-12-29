package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import mypack.Event;
import mypack.EventFacadeLocal;
import mypack.User;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import mypack.EventRegistration;
import mypack.EventRegistrationFacadeLocal;

/**
 * Servlet quản lý Event cho Admin
 *
 * @author DANG KHOA
 */
@WebServlet(name = "EventManagementServlet", urlPatterns = {"/admin/events"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EventManagementServlet extends HttpServlet {

    @EJB
    private EventRegistrationFacadeLocal registrationFacade;
    @EJB
    private EventFacadeLocal eventFacade;

    private static final String UPLOAD_DIR = "assets/images/events";
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập và quyền admin
        if (currentUser == null || !"ADMIN".equals(currentUser.getRoleID().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showEventList(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteEvent(request, response);
                    break;
                case "view":
                    viewEventDetail(request, response);
                    break;
                case "registrations":  // ⭐ THÊM CÁI NÀY
                    viewEventRegistrations(request, response);
                    break;
                default:
                    showEventList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/event/list.jsp").forward(request, response);
        }
    }

// ========== VIEW REGISTRATIONS ==========
    private void viewEventRegistrations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventFacade.find(eventId);

        if (event == null) {
            request.setAttribute("error", "Không tìm thấy sự kiện!");
            showEventList(request, response);
            return;
        }

        // Lấy danh sách người đăng ký
        List<EventRegistration> registrations = registrationFacade.findByEvent(event);

        request.setAttribute("event", event);
        request.setAttribute("registrations", registrations);
        request.getRequestDispatcher("/WEB-INF/views/admin/event/registrations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"ADMIN".equals(currentUser.getRoleID().getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createEvent(request, response, currentUser);
                    break;
                case "update":
                    updateEvent(request, response, currentUser);
                    break;
                case "updateStatus":
                    updateEventStatus(request, response);
                    break;
                default:
                    showEventList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showEventList(request, response);
        }
    }

    // ========== LIST ==========
    private void showEventList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String statusFilter = request.getParameter("status");
        String typeFilter = request.getParameter("type");

        List<Event> events;

        if (keyword != null && !keyword.trim().isEmpty()) {
            events = eventFacade.searchByName(keyword);
        } else if (statusFilter != null && !statusFilter.isEmpty()) {
            events = eventFacade.findByStatus(statusFilter);
        } else if (typeFilter != null && !typeFilter.isEmpty()) {
            events = eventFacade.findByEventType(typeFilter);
        } else {
            events = eventFacade.findAll();
        }

        // Thống kê
        long upcomingCount = eventFacade.countByStatus("Upcoming");
        long ongoingCount = eventFacade.countByStatus("Ongoing");
        long completedCount = eventFacade.countByStatus("Completed");
        long cancelledCount = eventFacade.countByStatus("Cancelled");

        request.setAttribute("events", events);
        request.setAttribute("keyword", keyword);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("upcomingCount", upcomingCount);
        request.setAttribute("ongoingCount", ongoingCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("cancelledCount", cancelledCount);

        request.getRequestDispatcher("/WEB-INF/views/admin/event/list.jsp").forward(request, response);
    }

    // ========== ADD FORM ==========
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        File imgDir = new File(getServletContext().getRealPath("/assets/images/events"));

        String[] imageList = imgDir.list((dir, name)
                -> name.toLowerCase().endsWith(".jpg")
                || name.toLowerCase().endsWith(".png")
                || name.toLowerCase().endsWith(".jpeg")
        );

        request.setAttribute("imageList", imageList);

        request.getRequestDispatcher("/WEB-INF/views/admin/event/form.jsp").forward(request, response);
    }

    // ========== EDIT FORM ==========
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        File imgDir = new File(getServletContext().getRealPath("/assets/images/events"));

        String[] imageList = imgDir.list((dir, name)
                -> name.toLowerCase().endsWith(".jpg")
                || name.toLowerCase().endsWith(".png")
                || name.toLowerCase().endsWith(".jpeg")
        );

        request.setAttribute("imageList", imageList);

        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventFacade.find(eventId);

        if (event == null) {
            request.setAttribute("error", "Không tìm thấy sự kiện!");
            showEventList(request, response);
            return;
        }

        request.setAttribute("event", event);
        request.getRequestDispatcher("/WEB-INF/views/admin/event/form.jsp").forward(request, response);
    }

    // ========== CREATE ==========
    private void createEvent(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        Event event = new Event();
        populateEventFromRequest(event, request, currentUser);
        event.setCreatedAt(new Date());
        event.setCreatedBy(currentUser);
        event.setCurrentAttendees(0);

        eventFacade.create(event);

        response.sendRedirect(request.getContextPath() + "/admin/events?success=create");
    }

    // ========== UPDATE ==========
    private void updateEvent(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        Event event = eventFacade.find(eventId);

        if (event == null) {
            request.setAttribute("error", "Không tìm thấy sự kiện!");
            showEventList(request, response);
            return;
        }

        populateEventFromRequest(event, request, currentUser);
        event.setUpdatedAt(new Date());

        eventFacade.edit(event);

        response.sendRedirect(request.getContextPath() + "/admin/events?success=update");
    }

    // ========== DELETE ==========
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventFacade.find(eventId);

        if (event != null) {
            eventFacade.remove(event);
            response.sendRedirect(request.getContextPath() + "/admin/events?success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/events?error=notfound");
        }
    }

    // ========== UPDATE STATUS ==========
    private void updateEventStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String newStatus = request.getParameter("status");

        Event event = eventFacade.find(eventId);
        if (event != null) {
            event.setStatus(newStatus);
            event.setUpdatedAt(new Date());
            eventFacade.edit(event);
            response.sendRedirect(request.getContextPath() + "/admin/events?success=statusUpdate");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/events?error=notfound");
        }
    }

    // ========== VIEW DETAIL ==========
    private void viewEventDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(request.getParameter("id"));
        Event event = eventFacade.find(eventId);

        if (event == null) {
            request.setAttribute("error", "Không tìm thấy sự kiện!");
            showEventList(request, response);
            return;
        }

        request.setAttribute("event", event);
        request.getRequestDispatcher("/WEB-INF/views/admin/event/view.jsp").forward(request, response);
    }

    // ========== HELPER METHOD ==========
    private void populateEventFromRequest(Event event, HttpServletRequest request, User currentUser)
            throws Exception {

        event.setEventName(request.getParameter("eventName"));
        event.setDescription(request.getParameter("description"));
        event.setEventType(request.getParameter("eventType"));
        event.setVenue(request.getParameter("venue"));
        event.setAddress(request.getParameter("address"));
        event.setHostedBy(request.getParameter("hostedBy"));
        event.setContactInfo(request.getParameter("contactInfo"));
        event.setArtistNames(request.getParameter("artistNames"));
        event.setRequirements(request.getParameter("requirements"));

        event.setStatus(request.getParameter("status"));
        event.setIsPublished("on".equals(request.getParameter("isPublished")));
        event.setAllowRegistration("on".equals(request.getParameter("allowRegistration")));

        // Số lượng
        String maxAttendeesStr = request.getParameter("maxAttendees");
        if (maxAttendeesStr != null && !maxAttendeesStr.isEmpty()) {
            event.setMaxAttendees(Integer.parseInt(maxAttendeesStr));
        }

        String priceStr = request.getParameter("price");
        if (priceStr != null && !priceStr.isEmpty()) {
            event.setPrice(new BigDecimal(priceStr));
        }

        // Ngày tháng
        if (request.getParameter("eventDate") != null && !request.getParameter("eventDate").isEmpty()) {
            event.setEventDate(DATE_FORMAT.parse(request.getParameter("eventDate")));
        }

        if (request.getParameter("endDate") != null && !request.getParameter("endDate").isEmpty()) {
            event.setEndDate(DATE_FORMAT.parse(request.getParameter("endDate")));
        }

        if (request.getParameter("registrationDeadline") != null && !request.getParameter("registrationDeadline").isEmpty()) {
            event.setRegistrationDeadline(DATE_FORMAT.parse(request.getParameter("registrationDeadline")));
        }

        // ⭐ CHỌN ẢNH TỪ DROPDOWN (KHÔNG UPLOAD)
        String selectedThumbnail = request.getParameter("thumbnailSelect");
        String selectedBanner = request.getParameter("bannerSelect");

        if (selectedThumbnail != null && !selectedThumbnail.isEmpty()) {
            event.setThumbnailUrl("assets/images/events/" + selectedThumbnail);
        }

        if (selectedBanner != null && !selectedBanner.isEmpty()) {
            event.setBannerUrl("assets/images/events/" + selectedBanner);
        }
    }

    private String uploadFile(Part filePart, HttpServletRequest request) throws IOException {

        // Tên file gốc
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String newFileName = System.currentTimeMillis() + "_" + fileName;

        // ĐƯỜNG DẪN THẬT TỚI THƯ MỤC webapp/assets/images/events
        String uploadPath = request.getServletContext()
                .getRealPath("/assets/images/events");

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        File savedFile = new File(uploadDir, newFileName);
        filePart.write(savedFile.getAbsolutePath());

        // Trả về đường dẫn dùng cho <img src="">
        return "assets/images/events/" + newFileName;
    }

}
