package mypack.controller.admin;

///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package mypack.controller.admin;
//
//import jakarta.ejb.EJB;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import mypack.Show;
//import mypack.ShowFacadeLocal;
//import mypack.ShowSchedule;
//import mypack.ShowScheduleFacadeLocal;
//
//import java.io.IOException;
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.List;
//
//@WebServlet(name = "ScheduleManagementServlet", urlPatterns = {
//    "/admin/schedule",
//    "/admin/schedule/add",
//    "/admin/schedule/edit",
//    "/admin/schedule/delete"
//})
//public class ScheduleManagementServlet extends HttpServlet {
//
//    @EJB
//    private ShowScheduleFacadeLocal showScheduleFacade;
//
//    @EJB
//    private ShowFacadeLocal showFacade;
//
//    /* ===================== COMMON UTF-8 ===================== */
//    private void setUtf8(HttpServletRequest request, HttpServletResponse response) {
//        try {
//            request.setCharacterEncoding("UTF-8");
//        } catch (Exception ignored) {
//        }
//        response.setCharacterEncoding("UTF-8");
//        response.setContentType("text/html; charset=UTF-8");
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        setUtf8(request, response);
//
//        String path = request.getServletPath();
//
//        switch (path) {
//            case "/admin/schedule":
//                showList(request, response);
//                break;
//            case "/admin/schedule/add":
//                showAddForm(request, response);
//                break;
//            case "/admin/schedule/edit":
//                showEditForm(request, response);
//                break;
//            case "/admin/schedule/delete":
//                deleteSchedule(request, response);
//                break;
//            default:
//                response.sendError(HttpServletResponse.SC_NOT_FOUND);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        setUtf8(request, response);
//
//        String path = request.getServletPath();
//
//        switch (path) {
//            case "/admin/schedule/add":
//                createSchedule(request, response);
//                break;
//            case "/admin/schedule/edit":
//                updateSchedule(request, response);
//                break;
//            default:
//                response.sendError(HttpServletResponse.SC_NOT_FOUND);
//        }
//    }
//
//    /* ===================== LIST ===================== */
//    private void showList(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        try {
//            String keyword = request.getParameter("search");
//            List<ShowSchedule> schedules;
//
//            if (keyword != null && !keyword.trim().isEmpty()) {
//                // Tìm kiếm theo keyword (thường là tên vở diễn)
//                schedules = showScheduleFacade.searchByKeyword(keyword.trim());
//            } else {
//                schedules = showScheduleFacade.findAll();
//            }
//
//            int totalSchedules = showScheduleFacade.count();
//
//            request.setAttribute("schedules", schedules);
//            request.setAttribute("searchKeyword", keyword);
//            request.setAttribute("totalSchedules", totalSchedules);
//
//            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/list.jsp")
//                    .forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Lỗi khi tải danh sách lịch chiếu: " + e.getMessage());
//            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/list.jsp")
//                    .forward(request, response);
//        }
//    }
//
//    /* ===================== ADD FORM (DROPDOWN VỞ DIỄN) ===================== */
//    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // PHẦN XỬ LÝ DROPDOWN CHỌN VỞ DIỄN
//        List<Show> shows = showFacade.findAll();
//        request.setAttribute("shows", shows);
//
//        request.getRequestDispatcher("/WEB-INF/views/admin/schedule/add.jsp")
//                .forward(request, response);
//    }
//
//    /* ========== HELPER: FORWARD LỖI CHO ADD (CREATE) ========== */
//    private void forwardAddError(HttpServletRequest request,
//            HttpServletResponse response,
//            String errorMessage)
//            throws ServletException, IOException {
//
//        // Thông báo tổng cho trang add.jsp
//        request.setAttribute("globalMessage", "Vui lòng chọn thông tin cho vở diễn");
//
//        // Thông báo lỗi chi tiết
//        request.setAttribute("error", errorMessage);
//
//        // NẠP LẠI DANH SÁCH VỞ DIỄN CHO DROPDOWN
//        List<Show> shows = showFacade.findAll();
//        request.setAttribute("shows", shows);
//
//        request.getRequestDispatcher("/WEB-INF/views/admin/schedule/add.jsp")
//                .forward(request, response);
//    }
//
//    private void forwardEditError(HttpServletRequest request,
//            HttpServletResponse response,
//            ShowSchedule schedule,
//            String errorMessage)
//            throws ServletException, IOException {
//
//        // Thông báo lỗi cho trang edit.jsp
//        request.setAttribute("error", errorMessage);
//
//        // NẠP LẠI DANH SÁCH VỞ DIỄN CHO DROPDOWN
//        List<Show> shows = showFacade.findAll();
//        request.setAttribute("shows", shows);
//
//        // Giữ lại lịch chiếu hiện tại (scheduleID, createdAt, v.v.)
//        request.setAttribute("schedule", schedule);
//
//        // Forward lại về trang sửa
//        request.getRequestDispatcher("/WEB-INF/views/admin/schedule/edit.jsp")
//                .forward(request, response);
//    }
//
//    /* ===================== CREATE (ADD) ===================== */
//    private void createSchedule(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String showIdStr = request.getParameter("showID");
//        String showTimeStr = request.getParameter("showTime");
//        String status = request.getParameter("status");
//        String totalSeatsStr = request.getParameter("totalSeats");
//        String availableSeatsStr = request.getParameter("availableSeats");
//
//        // ===== 0. KIỂM TRA TẤT CẢ ĐỀU BỎ TRỐNG =====
//        boolean isShowEmpty = (showIdStr == null || showIdStr.trim().isEmpty());
//        boolean isTimeEmpty = (showTimeStr == null || showTimeStr.trim().isEmpty());
//        boolean isStatusEmpty = (status == null || status.trim().isEmpty());
//        boolean isTotalEmpty = (totalSeatsStr == null || totalSeatsStr.trim().isEmpty());
//        boolean isAvailableEmpty = (availableSeatsStr == null || availableSeatsStr.trim().isEmpty());
//
//        if (isShowEmpty && isTimeEmpty && isStatusEmpty && isTotalEmpty && isAvailableEmpty) {
//            // Không có thông tin nào được chọn / điền
//            forwardAddError(request, response, "Vui lòng chọn thông tin cho vở diễn");
//            return;
//        }
//
//        try {
//            /* ===== 1. CHỌN VỞ DIỄN ===== */
//            if (isShowEmpty) {
//                forwardAddError(request, response, "Tên vở diễn chưa được chọn");
//                return;
//            }
//
//            Integer showId;
//            Show show;
//            try {
//                showId = Integer.valueOf(showIdStr.trim());
//                show = showFacade.find(showId);
//            } catch (NumberFormatException ex) {
//                forwardAddError(request, response, "Tên vở diễn chưa được chọn");
//                return;
//            }
//            if (show == null) {
//                forwardAddError(request, response, "Tên vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 2. GIỜ CHIẾU ===== */
//            if (isTimeEmpty) {
//                forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa được chọn");
//                return;
//            }
//
//            Date showTime;
//            try {
//                showTime = parseDateTimeLocal(showTimeStr);
//            } catch (ParseException pe) {
//                forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 3. TRẠNG THÁI ===== */
//            String trimmedStatus = (status != null) ? status.trim() : "";
//            if (trimmedStatus.isEmpty()) {
//                forwardAddError(request, response, "Trạng thái của vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 4. TỔNG SỐ GHẾ ===== */
//            if (isTotalEmpty) {
//                forwardAddError(request, response, "Tổng số ghế không được bỏ trống");
//                return;
//            }
//
//            int totalSeats;
//            try {
//                double val = Double.parseDouble(totalSeatsStr.trim());
//
//                if (val == 0) {
//                    forwardAddError(request, response, "Tổng số ghế không được bằng 0");
//                    return;
//                }
//                if (val < 0) {
//                    forwardAddError(request, response, "Tổng số ghế không được không được là số âm");
//                    return;
//                }
//                if (val % 1 != 0) {
//                    forwardAddError(request, response, "Tổng số ghế không được là số thập phân");
//                    return;
//                }
//
//                totalSeats = (int) val;
//
//            } catch (NumberFormatException ex) {
//                // nhập chữ, ký tự lạ, hoặc số dạng không hợp lệ
//                forwardAddError(request, response, "Tổng số ghế không được là số thập phân");
//                return;
//            }
//
//            /* ===== 5. SỐ GHẾ TRỐNG ===== */
//            if (isAvailableEmpty) {
//                forwardAddError(request, response, "Tổng số ghế trống không được bỏ trống");
//                return;
//            }
//
//            int availableSeats;
//            try {
//                double val = Double.parseDouble(availableSeatsStr.trim());
//
//                if (val == 0) {
//                    forwardAddError(request, response, "Tổng số ghế trống không được bằng 0");
//                    return;
//                }
//                if (val < 0) {
//                    forwardAddError(request, response, "Tổng số ghế trống không được không được là số âm");
//                    return;
//                }
//                if (val % 1 != 0) {
//                    forwardAddError(request, response, "Tổng số ghế trống không được là số thập phân");
//                    return;
//                }
//
//                availableSeats = (int) val;
//
//            } catch (NumberFormatException ex) {
//                forwardAddError(request, response, "Tổng số ghế trống không được là số thập phân");
//                return;
//            }
//
//            // Ràng buộc logic: ghế trống không được lớn hơn tổng ghế
//            if (availableSeats > totalSeats) {
//                forwardAddError(request, response, "Tổng số ghế trống không được lớn hơn tổng số ghế");
//                return;
//            }
//
//            /* ===== 6. TẠO LỊCH CHIẾU ===== */
//            ShowSchedule schedule = new ShowSchedule();
//            schedule.setShowID(show);
//            schedule.setShowTime(showTime);
//            schedule.setStatus(trimmedStatus);
//            schedule.setTotalSeats(totalSeats);
//            schedule.setAvailableSeats(availableSeats);
//            schedule.setCreatedAt(new Date());
//
//            showScheduleFacade.create(schedule);
//
//            // Thành công -> redirect, KHÔNG tạo nếu có lỗi ở trên
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?success=Thêm lịch chiếu thành công!");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            // Nếu có lỗi bất ngờ, cũng không tạo lịch chiếu
//            forwardAddError(request, response, "Lỗi khi tạo lịch chiếu: " + e.getMessage());
//        }
//    }
//
//    /* ===================== EDIT FORM (CÓ DROPDOWN VỞ DIỄN) ===================== */
//    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String idStr = request.getParameter("id");
//        if (idStr == null || idStr.trim().isEmpty()) {
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=ID không hợp lệ");
//            return;
//        }
//
//        try {
//            Integer id = Integer.valueOf(idStr);
//            ShowSchedule schedule = showScheduleFacade.find(id);
//            if (schedule == null) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/schedule?error=Không tìm thấy lịch chiếu");
//                return;
//            }
//
//            // PHẦN XỬ LÝ DROPDOWN CHO EDIT: NẠP TẤT CẢ VỞ DIỄN
//            List<Show> shows = showFacade.findAll();
//            request.setAttribute("shows", shows);
//            request.setAttribute("schedule", schedule);
//
//            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/edit.jsp")
//                    .forward(request, response);
//
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=ID không hợp lệ");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=Lỗi khi tải form sửa: " + e.getMessage());
//        }
//    }
//
//    /* ===================== UPDATE ===================== */
//    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        setUtf8(request, response);
//
//        String scheduleIdStr = request.getParameter("scheduleID");
//        String showIdStr = request.getParameter("showID");
//        String showTimeStr = request.getParameter("showTime");
//        String status = request.getParameter("status");
//        String totalSeatsStr = request.getParameter("totalSeats");
//        String availableSeatsStr = request.getParameter("availableSeats");
//
//        ShowSchedule schedule = null;
//
//        try {
//            // ===== 0. LẤY LỊCH CHIẾU TỪ DB THEO scheduleID =====
//            Integer scheduleId = Integer.valueOf(scheduleIdStr);
//            schedule = showScheduleFacade.find(scheduleId);
//            if (schedule == null) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/schedule?error=Không tìm thấy lịch chiếu");
//                return;
//            }
//
//            // ===== 1. KIỂM TRA TẤT CẢ ĐỀU BỎ TRỐNG =====
//            boolean isShowEmpty = (showIdStr == null || showIdStr.trim().isEmpty());
//            boolean isTimeEmpty = (showTimeStr == null || showTimeStr.trim().isEmpty());
//            boolean isStatusEmpty = (status == null || status.trim().isEmpty());
//            boolean isTotalEmpty = (totalSeatsStr == null || totalSeatsStr.trim().isEmpty());
//            boolean isAvailableEmpty = (availableSeatsStr == null || availableSeatsStr.trim().isEmpty());
//
//            if (isShowEmpty && isTimeEmpty && isStatusEmpty && isTotalEmpty && isAvailableEmpty) {
//                // Không có thông tin nào được điền → không cho cập nhật
//                forwardEditError(request, response, schedule,
//                        "Vui lòng điền và chọn thông tin cần cập nhật cho lịch diễn");
//                return;
//            }
//
//            /* ===== 2. VỞ DIỄN (SHOW) ===== */
//            if (isShowEmpty) {
//                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
//                return;
//            }
//
//            Integer showId;
//            Show show;
//            try {
//                showId = Integer.valueOf(showIdStr.trim());
//                show = showFacade.find(showId);
//            } catch (NumberFormatException ex) {
//                // showID không phải số
//                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
//                return;
//            }
//
//            if (show == null) {
//                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 3. GIỜ CHIẾU ===== */
//            if (isTimeEmpty) {
//                forwardEditError(request, response, schedule,
//                        "Giờ và ngày của vờ diễn chưa được chọn");
//                return;
//            }
//
//            Date showTime;
//            try {
//                showTime = parseDateTimeLocal(showTimeStr);
//            } catch (ParseException ex) {
//                // Format sai
//                forwardEditError(request, response, schedule,
//                        "Giờ và ngày của vờ diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 4. TRẠNG THÁI ===== */
//            if (isStatusEmpty) {
//                forwardEditError(request, response, schedule,
//                        "Trạng thái vở diễn chưa được chọn");
//                return;
//            }
//            String trimmedStatus = status.trim();
//
//            /* ===== 5. TỔNG SỐ GHẾ (TOTAL SEATS) ===== */
//            if (isTotalEmpty) {
//                // Có thể dùng message riêng, hoặc dùng chung với case “chưa nhập gì”
//                forwardEditError(request, response, schedule,
//                        "Tổng số ghế không được bỏ trống");
//                return;
//            }
//
//            int totalSeats;
//            try {
//                double val = Double.parseDouble(totalSeatsStr.trim());
//
//                if (val == 0) {
//                    forwardEditError(request, response, schedule,
//                            "Tổng số ghế không được bằng 0");
//                    return;
//                }
//                if (val < 0) {
//                    forwardEditError(request, response, schedule,
//                            "Tổng số ghế không được là số âm");
//                    return;
//                }
//                if (val % 1 != 0) {
//                    forwardEditError(request, response, schedule,
//                            "Tổng số ghế không được là số thập phân");
//                    return;
//                }
//
//                totalSeats = (int) val;
//            } catch (NumberFormatException ex) {
//                forwardEditError(request, response, schedule,
//                        "Tổng số ghế phải là số tự nhiên");
//                return;
//            }
//
//            /* ===== 6. SỐ GHẾ TRỐNG (AVAILABLE SEATS) ===== */
//            if (isAvailableEmpty) {
//                forwardEditError(request, response, schedule,
//                        "Tổng số ghế trống không được bỏ trống");
//                return;
//            }
//
//            int availableSeats;
//            try {
//                double val = Double.parseDouble(availableSeatsStr.trim());
//
//                if (val == 0) {
//                    forwardEditError(request, response, schedule,
//                            "Tổng số ghế trống không được bằng 0");
//                    return;
//                }
//                if (val < 0) {
//                    forwardEditError(request, response, schedule,
//                            "Tổng số ghế trống không được là số âm");
//                    return;
//                }
//                if (val % 1 != 0) {
//                    forwardEditError(request, response, schedule,
//                            "Tổng số ghế trống không được là số thập phân");
//                    return;
//                }
//
//                availableSeats = (int) val;
//            } catch (NumberFormatException ex) {
//                forwardEditError(request, response, schedule,
//                        "Tổng số ghế trống phải là số tự nhiên");
//                return;
//            }
//
//            // (OPTIONAL) Ràng buộc thêm: ghế trống <= tổng ghế
//            if (availableSeats > totalSeats) {
//                forwardEditError(request, response, schedule,
//                        "Tổng số ghế trống không được lớn hơn tổng số ghế");
//                return;
//            }
//
//            /* ===== 7. GÁN GIÁ TRỊ VÀ LƯU DB ===== */
//            schedule.setShowID(show);
//            schedule.setShowTime(showTime);
//            schedule.setStatus(trimmedStatus);
//            schedule.setTotalSeats(totalSeats);
//            schedule.setAvailableSeats(availableSeats);
//
//            showScheduleFacade.edit(schedule);
//
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?success=Cập nhật lịch chiếu thành công!");
//
//        } catch (NumberFormatException e) {
//            // Lỗi parse scheduleID
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=ID không hợp lệ");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=Lỗi khi cập nhật: " + e.getMessage());
//        }
//    }
//
//    /* ===================== DELETE ===================== */
//    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//
//        String idStr = request.getParameter("id");
//        if (idStr == null || idStr.trim().isEmpty()) {
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=ID không hợp lệ");
//            return;
//        }
//
//        try {
//            Integer id = Integer.valueOf(idStr);
//            ShowSchedule schedule = showScheduleFacade.find(id);
//            if (schedule == null) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/schedule?error=Không tìm thấy lịch chiếu");
//                return;
//            }
//
//            showScheduleFacade.remove(schedule);
//
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?success=Xóa lịch chiếu thành công!");
//
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=ID không hợp lệ");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/schedule?error=Lỗi khi xóa: " + e.getMessage());
//        }
//    }
//
//    /* ===================== HELPER: PARSE DATETIME ===================== */
//    /**
//     * Parse từ chuỗi kiểu HTML5 datetime-local (yyyy-MM-dd'T'HH:mm) sang
//     * java.util.Date
//     */
//    private Date parseDateTimeLocal(String dateTimeStr) throws ParseException {
//        if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
//            throw new ParseException("Giờ chiếu không được để trống.", 0);
//        }
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
//        return sdf.parse(dateTimeStr.trim());
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "Show Schedule Management Servlet for Admin";
//    }
//}
