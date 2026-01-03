package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mypack.Show;
import mypack.ShowFacadeLocal;
import mypack.ShowSchedule;
import mypack.ShowScheduleFacadeLocal;
import mypack.OrderDetailFacadeLocal; // ✅ THÊM

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.LocalDate;

import java.net.URLEncoder;

@WebServlet(name = "ScheduleManagementServlet", urlPatterns = {
    "/admin/schedule",
    "/admin/schedule/add",
    "/admin/schedule/edit",
    "/admin/schedule/delete"
})
public class ScheduleManagementServlet extends HttpServlet {

    @EJB
    private ShowScheduleFacadeLocal showScheduleFacade;

    @EJB
    private ShowFacadeLocal showFacade;
    
    // ✅ THÊM EJB MỚI
    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;

    private static final SimpleDateFormat DTL = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    private static final ZoneId APP_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {
        }
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    private String computeAutoStatus(Date showTime) {
        if (showTime == null) {
            return "Cancelled";
        }

        ZonedDateTime now = ZonedDateTime.now(APP_ZONE);
        ZonedDateTime st = showTime.toInstant().atZone(APP_ZONE);

        LocalDate today = now.toLocalDate();
        LocalDate showDate = st.toLocalDate();

        if (showDate.isBefore(today)) {
            return "Cancelled";
        }
        if (showDate.isAfter(today)) {
            return "Upcoming";
        }

        if (st.isBefore(now)) {
            return "Ongoing";
        }
        return "Ongoing";
    }

    private boolean isBeforeNowVN(Date showTime) {
        if (showTime == null) return true;

        ZonedDateTime now = ZonedDateTime.now(APP_ZONE);
        ZonedDateTime picked = showTime.toInstant().atZone(APP_ZONE);

        return picked.isBefore(now);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setUtf8(request, response);

        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/schedule")) {
            showList(request, response);
        } else if (uri.endsWith("/admin/schedule/add")) {
            showAddForm(request, response);
        } else if (uri.endsWith("/admin/schedule/edit")) {
            showEditForm(request, response);
        } else if (uri.endsWith("/admin/schedule/delete")) {
            deleteSchedule(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        setUtf8(request, response);

        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/schedule/add")) {
            createSchedule(request, response);
        } else if (uri.endsWith("/admin/schedule/edit")) {
            updateSchedule(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /* ===================== LIST ===================== */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String keyword = request.getParameter("search");

            final int pageSize = 9;
            int page = 1;

            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Integer.parseInt(pageStr.trim());
                }
            } catch (Exception ignored) {
            }
            if (page < 1) {
                page = 1;
            }

            List<ShowSchedule> schedules;

            if (keyword != null && !keyword.trim().isEmpty()) {
                schedules = showScheduleFacade.searchByShowNameKeyword(keyword);
                if (schedules == null) {
                    schedules = java.util.Collections.emptyList();
                }
            } else {
                schedules = showScheduleFacade.findAll();
                if (schedules == null) {
                    schedules = java.util.Collections.emptyList();
                }
            }

            schedules.sort((a, b) -> {
                Integer sa = (a.getShowID() != null) ? a.getShowID().getShowID() : -1;
                Integer sb = (b.getShowID() != null) ? b.getShowID().getShowID() : -1;

                int cmp = sa.compareTo(sb);
                if (cmp != 0) {
                    return cmp;
                }

                if (a.getShowTime() == null && b.getShowTime() == null) {
                    return 0;
                }
                if (a.getShowTime() == null) {
                    return 1;
                }
                if (b.getShowTime() == null) {
                    return -1;
                }
                return a.getShowTime().compareTo(b.getShowTime());
            });

            int totalSchedules = schedules.size();
            int totalPages = (int) Math.ceil(totalSchedules / (double) pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalSchedules);

            List<ShowSchedule> pageSchedules = schedules.subList(start, end);

            java.util.LinkedHashMap<Integer, java.util.List<ShowSchedule>> grouped = new java.util.LinkedHashMap<>();
            for (ShowSchedule sc : pageSchedules) {
                Integer showId = (sc.getShowID() != null) ? sc.getShowID().getShowID() : -1;
                grouped.computeIfAbsent(showId, k -> new java.util.ArrayList<>()).add(sc);
            }

            request.setAttribute("groupedSchedules", grouped);
            request.setAttribute("schedules", pageSchedules);
            request.setAttribute("searchKeyword", keyword);

            request.setAttribute("totalSchedules", totalSchedules);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);

            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách lịch chiếu: " + e.toString());
            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/list.jsp")
                    .forward(request, response);
        }
    }

    /* ===================== ADD FORM ===================== */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Show> shows = showFacade.findAll();
        request.setAttribute("shows", shows);

        request.getRequestDispatcher("/WEB-INF/views/admin/schedule/add.jsp")
                .forward(request, response);
    }

    private void forwardAddError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {

        String global = "Vui lòng chọn thông tin cho vở diễn";
        request.setAttribute("globalMessage", global);

        if (errorMessage != null && !errorMessage.trim().isEmpty()
                && !errorMessage.trim().equalsIgnoreCase(global)) {
            request.setAttribute("error", errorMessage);
        } else {
            request.removeAttribute("error");
        }

        request.setAttribute("showIDValue", request.getParameter("showID"));
        request.setAttribute("showTimeValue", request.getParameter("showTime"));

        List<Show> shows = showFacade.findAll();
        request.setAttribute("shows", shows);

        request.getRequestDispatcher("/WEB-INF/views/admin/schedule/add.jsp")
                .forward(request, response);
    }

    private void forwardEditError(HttpServletRequest request, HttpServletResponse response,
            ShowSchedule schedule, String errorMessage)
            throws ServletException, IOException {

        request.setAttribute("globalMessage", "Vui lòng kiểm tra lại thông tin lịch diễn");
        request.setAttribute("error", errorMessage);

        List<Show> shows = showFacade.findAll();
        request.setAttribute("shows", shows);

        request.setAttribute("schedule", schedule);
        request.setAttribute("showTimeLocal", DTL.format(schedule.getShowTime()));

        request.getRequestDispatcher("/WEB-INF/views/admin/schedule/edit.jsp")
                .forward(request, response);
    }

    /* ===================== CREATE ===================== */
    private void createSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String showIdStr = request.getParameter("showID");
        String[] showTimeArr = request.getParameterValues("showTime");

        boolean isShowEmpty = (showIdStr == null || showIdStr.trim().isEmpty());
        boolean isTimesEmpty = (showTimeArr == null || showTimeArr.length == 0);

        if (isShowEmpty && isTimesEmpty) {
            forwardAddError(request, response, "Bạn chưa chọn vở diễn và giờ chiếu.");
            return;
        }

        try {
            if (isShowEmpty) {
                forwardAddError(request, response, "Tên vở diễn chưa được chọn");
                return;
            }

            Integer showId;
            Show show;
            try {
                showId = Integer.valueOf(showIdStr.trim());
                show = showFacade.find(showId);
            } catch (NumberFormatException ex) {
                forwardAddError(request, response, "Tên vở diễn chưa được chọn");
                return;
            }
            if (show == null) {
                forwardAddError(request, response, "Tên vở diễn chưa được chọn");
                return;
            }

            if (isTimesEmpty) {
                forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa được chọn");
                return;
            }

            java.util.ArrayList<Date> times = new java.util.ArrayList<>();
            java.util.HashSet<Long> timeKeySet = new java.util.HashSet<>();

            for (String tStr : showTimeArr) {
                if (tStr == null || tStr.trim().isEmpty()) {
                    forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa được chọn");
                    return;
                }

                Date t;
                try {
                    t = parseDateTimeLocal(tStr.trim());
                } catch (ParseException pe) {
                    forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa hợp lệ");
                    return;
                }

                if (isBeforeNowVN(t)) {
                    forwardAddError(request, response, "Ngày và giờ bạn chọn không được thấp hơn thời điểm hiện tại");
                    return;
                }

                long key = t.getTime();
                if (timeKeySet.contains(key)) {
                    forwardAddError(request, response, "Ngày và giờ bạn chọn không được trùng nhau trong form");
                    return;
                }
                timeKeySet.add(key);
                times.add(t);
            }

            int existingCount = showScheduleFacade.countByShowId(show.getShowID());
            if (existingCount + times.size() > 3) {
                forwardAddError(request, response,
                        "Show bạn chọn chỉ được tối đa 3 lịch diễn. Hiện đã có " + existingCount + " lịch.");
                return;
            }

            for (Date t : times) {
                ShowSchedule schedule = new ShowSchedule();
                schedule.setShowID(show);
                schedule.setShowTime(t);
                schedule.setStatus(computeAutoStatus(t));
                schedule.setCreatedAt(new Date());
                showScheduleFacade.create(schedule);
            }

            String msg = URLEncoder.encode("Thêm lịch chiếu thành công!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/schedule?success=" + msg);

        } catch (Exception e) {
            e.printStackTrace();
            forwardAddError(request, response, "Lỗi khi tạo lịch chiếu: " + e.toString());
        }
    }

    /* ===================== EDIT FORM ===================== */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=ID không hợp lệ");
            return;
        }

        try {
            Integer id = Integer.valueOf(idStr);
            ShowSchedule schedule = showScheduleFacade.find(id);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedule?error=Không tìm thấy lịch chiếu");
                return;
            }

            List<Show> shows = showFacade.findAll();
            request.setAttribute("shows", shows);
            request.setAttribute("schedule", schedule);

            request.setAttribute("showTimeLocal", DTL.format(schedule.getShowTime()));

            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=ID không hợp lệ");
        }
    }

    /* ===================== UPDATE ===================== */
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String scheduleIdStr = request.getParameter("scheduleID");
        String showIdStr = request.getParameter("showID");
        String showTimeStr = request.getParameter("showTime");

        ShowSchedule schedule;

        try {
            Integer scheduleID = Integer.valueOf(scheduleIdStr);
            schedule = showScheduleFacade.find(scheduleID);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedule?error=Không tìm thấy lịch chiếu");
                return;
            }

            boolean isShowEmpty = (showIdStr == null || showIdStr.trim().isEmpty());
            boolean isTimeEmpty = (showTimeStr == null || showTimeStr.trim().isEmpty());

            if (isShowEmpty && isTimeEmpty) {
                forwardEditError(request, response, schedule,
                        "Vui lòng điền và chọn thông tin cần cập nhật cho lịch diễn");
                return;
            }

            if (isShowEmpty) {
                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
                return;
            }

            Integer showId;
            Show show;
            try {
                showId = Integer.valueOf(showIdStr.trim());
                show = showFacade.find(showId);
            } catch (NumberFormatException ex) {
                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
                return;
            }
            if (show == null) {
                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
                return;
            }

            if (isTimeEmpty) {
                forwardEditError(request, response, schedule, "Giờ và ngày của vở diễn chưa được chọn");
                return;
            }

            Date showTime;
            try {
                showTime = parseDateTimeLocal(showTimeStr);
            } catch (ParseException ex) {
                forwardEditError(request, response, schedule, "Giờ và ngày của vở diễn chưa được chọn");
                return;
            }

            if (isBeforeNowVN(showTime)) {
                forwardEditError(request, response, schedule, "Ngày và giờ bạn chọn không được thấp hơn thời điểm hiện tại");
                return;
            }

            Integer currentId = schedule.getScheduleID();

            int count = showScheduleFacade.countByShowIdExcept(show.getShowID(), currentId);
            if (count >= 3) {
                forwardEditError(request, response, schedule,
                        "Show bạn chọn đã có tối đa 3 lịch diễn, không thể cập nhật sang show này");
                return;
            }

            schedule.setShowID(show);
            schedule.setShowTime(showTime);
            schedule.setStatus(computeAutoStatus(showTime));

            showScheduleFacade.edit(schedule);

            String msg = URLEncoder.encode("Cập nhật lịch chiếu thành công!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/schedule?success=" + msg);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=Lỗi khi cập nhật: " + e.getMessage());
        }
    }

    /* ===================== DELETE ===================== */
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=ID không hợp lệ");
            return;
        }

        try {
            Integer id = Integer.valueOf(idStr);
            ShowSchedule schedule = showScheduleFacade.find(id);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/schedule?error=Không tìm thấy lịch chiếu");
                return;
            }

            // ✅ KIỂM TRA TRƯỚC KHI XÓA
            if (orderDetailFacade.hasOrdersForSchedule(id)) {
                Long orderCount = orderDetailFacade.countOrdersBySchedule(id);
                String msg = URLEncoder.encode(
                    "❌ Không thể xóa! Suất chiếu này đã có " + orderCount + " vé được đặt.", 
                    "UTF-8"
                );
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=" + msg);
                return;
            }

            showScheduleFacade.remove(schedule);

            String msg = URLEncoder.encode("Xóa lịch chiếu thành công!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/schedule?success=" + msg);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/schedule?error=Lỗi khi xóa: " + e.getMessage());
        }
    }

    private Date parseDateTimeLocal(String dateTimeStr) throws ParseException {
        if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
            throw new ParseException("Giờ chiếu không được để trống.", 0);
        }
        return DTL.parse(dateTimeStr.trim());
    }

    @Override
    public String getServletInfo() {
        return "Show Schedule Management Servlet for Admin";
    }
}