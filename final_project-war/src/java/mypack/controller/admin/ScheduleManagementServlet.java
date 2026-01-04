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
import mypack.OrderDetailFacadeLocal;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.net.URLEncoder;
import java.util.TimeZone;

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

    @EJB
    private OrderDetailFacadeLocal orderDetailFacade;

    private static final SimpleDateFormat DTL = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    private static final ZoneId APP_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    private static final int MIN_BUFFER_BETWEEN_SHOWS_MINUTES = 120;

    private static final SimpleDateFormat VN_DDMMYYYY_HHMM = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    static {
        TimeZone vn = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        VN_DDMMYYYY_HHMM.setTimeZone(vn);
        DTL.setTimeZone(vn);
    }

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {
        }
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    // =========================================================
    // REALTIME STATUS
    // Upcoming: now < start
    // Ongoing : start <= now < end
    // Cancelled: now >= end
    // =========================================================
    private String computeRealtimeStatus(Date start, int durationMinutes) {
        if (start == null) {
            return "Cancelled";
        }

        ZonedDateTime now = ZonedDateTime.now(APP_ZONE);
        ZonedDateTime st = start.toInstant().atZone(APP_ZONE);
        ZonedDateTime en = st.plusMinutes(durationMinutes);

        if (now.isBefore(st)) {
            return "Upcoming";
        }
        if (!now.isBefore(en)) {
            return "Cancelled";
        }
        return "Ongoing";
    }

    private String computeRealtimeStatus(ShowSchedule sc) {
        if (sc == null) {
            return "Cancelled";
        }
        int dur = getShowDurationMinutes(sc.getShowID());
        return computeRealtimeStatus(sc.getShowTime(), dur);
    }

    private boolean isBeforeTodayVN(Date picked) {
        if (picked == null) {
            return true;
        }
        LocalDate today = ZonedDateTime.now(APP_ZONE).toLocalDate();
        LocalDate pickedDate = picked.toInstant().atZone(APP_ZONE).toLocalDate();
        return pickedDate.isBefore(today);
    }

    private Date plusMinutes(Date d, int minutes) {
        return new Date(d.getTime() + minutes * 60_000L);
    }

    private Date minusMinutes(Date d, int minutes) {
        return new Date(d.getTime() - minutes * 60_000L);
    }

    private LocalDate toLocalDateVN(Date d) {
        return d.toInstant().atZone(APP_ZONE).toLocalDate();
    }

    private Date startOfDayVN(LocalDate day) {
        return Date.from(day.atStartOfDay(APP_ZONE).toInstant());
    }

    private Date startOfNextDayVN(LocalDate day) {
        return Date.from(day.plusDays(1).atStartOfDay(APP_ZONE).toInstant());
    }

    private String getSafeShowName(Show s) {
        try {
            if (s != null && s.getShowName() != null && !s.getShowName().trim().isEmpty()) {
                return s.getShowName().trim();
            }
        } catch (Exception ignored) {
        }
        return "(Không rõ tên show)";
    }

    private int getShowDurationMinutes(Show show) {
        if (show == null) {
            return 120;
        }

        try {
            Integer v = null;

            try {
                v = (Integer) show.getClass().getMethod("getDurationMinutes").invoke(show);
            } catch (Exception ignored) {
            }
            if (v == null) {
                try {
                    v = (Integer) show.getClass().getMethod("getDuration").invoke(show);
                } catch (Exception ignored) {
                }
            }
            if (v == null) {
                try {
                    v = (Integer) show.getClass().getMethod("getDurationMin").invoke(show);
                } catch (Exception ignored) {
                }
            }

            if (v != null && v > 0) {
                return v;
            }

        } catch (Exception ignored) {
        }

        return 120;
    }

    private boolean isOverlap(Date startA, Date endA, Date startB, Date endB) {
        return startA.before(endB) && startB.before(endA);
    }

    private String validateMinBufferAnyShow(Show showNew, Date startNew, Integer excludeScheduleId) {
        if (showNew == null) {
            return "Vở diễn chưa được chọn";
        }
        if (startNew == null) {
            return "Giờ chiếu cho buổi diễn chưa hợp lệ";
        }

        LocalDate day = toLocalDateVN(startNew);
        Date dayStart = startOfDayVN(day);
        Date dayEndExclusive = startOfNextDayVN(day);

        List<ShowSchedule> sameDaySchedules = showScheduleFacade.findInRange(dayStart, dayEndExclusive);

        int durNew = getShowDurationMinutes(showNew);
        Date endNew = plusMinutes(startNew, durNew);

        for (ShowSchedule ex : sameDaySchedules) {
            if (ex == null) {
                continue;
            }

            if (excludeScheduleId != null && ex.getScheduleID() != null
                    && ex.getScheduleID().intValue() == excludeScheduleId.intValue()) {
                continue;
            }

            if (ex.getShowTime() == null || ex.getShowID() == null) {
                continue;
            }

            Date startEx = ex.getShowTime();
            Show showEx = ex.getShowID();

            int durEx = getShowDurationMinutes(showEx);
            Date endEx = plusMinutes(startEx, durEx);

            Date startExBuf = minusMinutes(startEx, MIN_BUFFER_BETWEEN_SHOWS_MINUTES);
            Date endExBuf = plusMinutes(endEx, MIN_BUFFER_BETWEEN_SHOWS_MINUTES);

            if (isOverlap(startNew, endNew, startExBuf, endExBuf)) {
                String newStartStr = VN_DDMMYYYY_HHMM.format(startNew);
                String newEndStr = VN_DDMMYYYY_HHMM.format(endNew);

                String exShowName = getSafeShowName(showEx);
                String exStartStr = VN_DDMMYYYY_HHMM.format(startEx);
                String exEndStr = VN_DDMMYYYY_HHMM.format(endEx);

                return "❌ Lịch chiếu phải cách lịch hiện tại ít nhất "
                        + MIN_BUFFER_BETWEEN_SHOWS_MINUTES + " phút. "
                        + "Bạn chọn: [" + newStartStr + " → " + newEndStr + "]. "
                        + "Bị quá gần: \"" + exShowName + "\" "
                        + "suất [" + exStartStr + " → " + exEndStr + "].";
            }
        }
        return null;
    }

    private String validateFormTimesInternal(Show show, List<Date> times) {
        if (times == null || times.size() <= 1) {
            return null;
        }

        int dur = getShowDurationMinutes(show);

        for (int i = 0; i < times.size(); i++) {
            Date si = times.get(i);
            Date ei = plusMinutes(si, dur);

            Date siBuf = minusMinutes(si, MIN_BUFFER_BETWEEN_SHOWS_MINUTES);
            Date eiBuf = plusMinutes(ei, MIN_BUFFER_BETWEEN_SHOWS_MINUTES);

            for (int j = i + 1; j < times.size(); j++) {
                Date sj = times.get(j);
                Date ej = plusMinutes(sj, dur);

                if (isOverlap(sj, ej, siBuf, eiBuf)) {
                    return "❌ Các suất bạn chọn trong form đang quá gần nhau. "
                            + "Mỗi suất phải cách nhau ít nhất " + MIN_BUFFER_BETWEEN_SHOWS_MINUTES + " phút (tính từ thời điểm kết thúc). "
                            + "Vui lòng chọn giờ khác.";
                }
            }
        }
        return null;
    }

    private Date parseDateTimeLocal(String dateTimeStr) throws ParseException {
        if (dateTimeStr == null || dateTimeStr.trim().isEmpty()) {
            throw new ParseException("Giờ chiếu không được để trống.", 0);
        }
        try {
            LocalDateTime ldt = LocalDateTime.parse(dateTimeStr.trim());
            ZonedDateTime zdt = ldt.atZone(APP_ZONE);
            return Date.from(zdt.toInstant());
        } catch (Exception ex) {
            throw new ParseException("Giờ chiếu không hợp lệ.", 0);
        }
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

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // ✅ NEW: sync realtime status cho schedules + show
            try {
                showScheduleFacade.syncRealtimeStatuses();
            } catch (Exception ignored) {
            }

            String keyword = request.getParameter("search");
            String status = request.getParameter("status");

            final int pageSize = 6;
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

            // ✅ BỎ hoàn toàn đoạn computeRealtimeStatus + syncShowByScheduleRealtime
            // vì realtime đã sync trong facade, và sync cũ ép sai tất cả schedules thành Ongoing.
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

            java.util.LinkedHashMap<Integer, java.util.List<ShowSchedule>> groupedAll = new java.util.LinkedHashMap<>();
            for (ShowSchedule sc : schedules) {
                Integer showId = (sc.getShowID() != null) ? sc.getShowID().getShowID() : -1;

                if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status.trim())) {
                    String st = (sc.getStatus() != null) ? sc.getStatus() : "";
                    if (!st.equalsIgnoreCase(status.trim())) {
                        continue;
                    }
                }

                groupedAll.computeIfAbsent(showId, k -> new java.util.ArrayList<>()).add(sc);
            }

            java.util.List<Integer> showIds = new java.util.ArrayList<>(groupedAll.keySet());
            int totalGroups = showIds.size();
            int totalPages = (int) Math.ceil(totalGroups / (double) pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalGroups);

            java.util.LinkedHashMap<Integer, java.util.List<ShowSchedule>> groupedPage = new java.util.LinkedHashMap<>();
            for (int i = start; i < end; i++) {
                Integer showId = showIds.get(i);
                groupedPage.put(showId, groupedAll.get(showId));
            }

            int totalSchedulesAfterFilter = 0;
            for (java.util.List<ShowSchedule> lst : groupedAll.values()) {
                totalSchedulesAfterFilter += lst.size();
            }

            request.setAttribute("groupedSchedules", groupedPage);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("totalSchedules", totalSchedulesAfterFilter);
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

        String[] times = request.getParameterValues("showTime");
        if (times != null && times.length > 0) {
            request.setAttribute("showTimeValue", times[0]);
        }

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
        if (isShowEmpty) {
            forwardAddError(request, response, "Tên vở diễn chưa được chọn");
            return;
        }
        if (isTimesEmpty) {
            forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa được chọn");
            return;
        }

        for (int i = 0; i < showTimeArr.length; i++) {
            String tStr = (showTimeArr[i] != null) ? showTimeArr[i].trim() : "";
            if (tStr.isEmpty()) {
                forwardAddError(request, response, "Giờ chiếu cho buổi diễn chưa được chọn");
                return;
            }
        }

        try {
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

                if (isBeforeTodayVN(t)) {
                    forwardAddError(request, response, "Ngày bạn chọn không được thấp hơn ngày hôm nay");
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

            String formErr = validateFormTimesInternal(show, times);
            if (formErr != null) {
                forwardAddError(request, response, formErr);
                return;
            }

            for (Date t : times) {
                String bufferErr = validateMinBufferAnyShow(show, t, null);
                if (bufferErr != null) {
                    forwardAddError(request, response, bufferErr);
                    return;
                }
            }

            for (Date t : times) {
                ShowSchedule schedule = new ShowSchedule();
                schedule.setShowID(show);
                schedule.setShowTime(t);

                int dur = getShowDurationMinutes(show);
                schedule.setStatus(computeRealtimeStatus(t, dur));
                schedule.setCreatedAt(Date.from(ZonedDateTime.now(APP_ZONE).toInstant()));
                showScheduleFacade.create(schedule);
            }

            // ✅ sync lại sau khi tạo
            try {
                showScheduleFacade.syncRealtimeStatuses();
            } catch (Exception ignored) {
            }

            String msg = URLEncoder.encode("Thêm lịch chiếu thành công!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/schedule?success=" + msg);

        } catch (Exception e) {
            e.printStackTrace();
            forwardAddError(request, response, "Lỗi khi tạo lịch chiếu: " + e.toString());
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=ID không hợp lệ");
            return;
        }

        try {
            Integer id = Integer.valueOf(idStr);
            ShowSchedule schedule = showScheduleFacade.find(id);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=Không tìm thấy lịch chiếu");
                return;
            }

            schedule.setStatus(computeRealtimeStatus(schedule));

            List<Show> shows = showFacade.findAll();
            request.setAttribute("shows", shows);
            request.setAttribute("schedule", schedule);
            request.setAttribute("showTimeLocal", DTL.format(schedule.getShowTime()));

            request.getRequestDispatcher("/WEB-INF/views/admin/schedule/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=ID không hợp lệ");
        }
    }

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
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=Không tìm thấy lịch chiếu");
                return;
            }

            String currentRealtime = computeRealtimeStatus(schedule);
            schedule.setStatus(currentRealtime);

            if ("Ongoing".equalsIgnoreCase(currentRealtime)) {
                forwardEditError(request, response, schedule,
                        "❌ Lịch chiếu đang CHIẾU (Ongoing) nên KHÔNG THỂ cập nhật ngày/giờ.");
                return;
            }

            Integer originalShowId = (schedule.getShowID() != null) ? schedule.getShowID().getShowID() : null;
            Integer postedShowId = null;
            try {
                if (showIdStr != null && !showIdStr.trim().isEmpty()) {
                    postedShowId = Integer.valueOf(showIdStr.trim());
                }
            } catch (Exception ignored) {
            }

            if (originalShowId == null || postedShowId == null || !originalShowId.equals(postedShowId)) {
                forwardEditError(request, response, schedule,
                        "❌ Không được đổi vở diễn khi cập nhật. Nếu muốn đổi show, hãy tạo lịch mới.");
                return;
            }

            Show show = schedule.getShowID();
            if (show == null) {
                forwardEditError(request, response, schedule, "Vở diễn chưa được chọn");
                return;
            }

            if (showTimeStr == null || showTimeStr.trim().isEmpty()) {
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

            if (isBeforeTodayVN(showTime)) {
                forwardEditError(request, response, schedule, "Ngày bạn chọn không được thấp hơn ngày hôm nay");
                return;
            }

            Integer currentId = schedule.getScheduleID();

            String bufferErr = validateMinBufferAnyShow(show, showTime, currentId);
            if (bufferErr != null) {
                forwardEditError(request, response, schedule, bufferErr);
                return;
            }

            schedule.setShowTime(showTime);

            int dur = getShowDurationMinutes(show);
            schedule.setStatus(computeRealtimeStatus(showTime, dur));

            showScheduleFacade.edit(schedule);

            // ✅ sync lại để show/schedules đúng ngay
            try {
                showScheduleFacade.syncRealtimeStatuses();
            } catch (Exception ignored) {
            }

            String msg = URLEncoder.encode("Cập nhật lịch chiếu thành công!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/schedule?success=" + msg);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=Lỗi khi cập nhật: " + e.getMessage());
        }
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=ID không hợp lệ");
            return;
        }

        try {
            Integer id = Integer.valueOf(idStr);
            ShowSchedule schedule = showScheduleFacade.find(id);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=Không tìm thấy lịch chiếu");
                return;
            }

            String realtime = computeRealtimeStatus(schedule);
            schedule.setStatus(realtime);

            if ("Ongoing".equalsIgnoreCase(realtime)) {
                String msg = URLEncoder.encode("❌ Không thể xóa! Lịch chiếu đang ở trạng thái Ongoing.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=" + msg);
                return;
            }

            if (!"Cancelled".equalsIgnoreCase(realtime)) {
                String msg = URLEncoder.encode("❌ Chỉ được xóa khi lịch chiếu đã diễn xong và chuyển sang Cancelled.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=" + msg);
                return;
            }

            if (orderDetailFacade.hasOrdersForSchedule(id)) {
                Long orderCount = orderDetailFacade.countOrdersBySchedule(id);
                String msg = URLEncoder.encode("❌ Không thể xóa! Suất chiếu này đã có " + orderCount + " vé được đặt.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/admin/schedule?error=" + msg);
                return;
            }

            showScheduleFacade.remove(schedule);

            // ✅ sync lại sau xóa
            try {
                showScheduleFacade.syncRealtimeStatuses();
            } catch (Exception ignored) {
            }

            String msg = URLEncoder.encode("Xóa lịch chiếu thành công!", "UTF-8");
            response.sendRedirect(request.getContextPath() + "/admin/schedule?success=" + msg);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/schedule?error=Lỗi khi xóa: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Show Schedule Management Servlet for Admin";
    }
}
