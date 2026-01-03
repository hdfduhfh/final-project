package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mypack.Show;
import mypack.ShowFacadeLocal;
import mypack.Artist;
import mypack.ArtistFacadeLocal;
import mypack.ShowArtist;
import mypack.ShowArtistFacadeLocal;

import mypack.utils.ShowTrashStore;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.regex.Pattern;

@WebServlet(
        name = "ShowManagementServlet",
        urlPatterns = {
            "/admin/show",
            "/admin/show/add",
            "/admin/show/edit",
            "/admin/show/delete",
            // ✅ NEW: soft delete + trash
            "/admin/show/soft-delete",
            "/admin/show/trash",
            "/admin/show/restore"
        }
)
@MultipartConfig
public class ShowManagementServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

    @EJB
    private ArtistFacadeLocal artistFacade;

    @EJB
    private ShowArtistFacadeLocal showArtistFacade;

    // chỉ cho chữ (kể cả tiếng Việt), số, khoảng trắng
    private static final Pattern NO_SPECIAL_PATTERN
            = Pattern.compile("^[\\p{L}\\d\\s]+$");

    // ✅ NEW: cho mô tả có dấu . , và xuống dòng
    private static final Pattern DESCRIPTION_PATTERN
            = Pattern.compile("^[\\p{L}\\d\\s\\.,\\r\\n]+$");

    /* =====================================================
       UTF-8
    ===================================================== */
    private void setUtf8(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {
        }
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
    }

    /* =====================================================
       ✅ LOAD IMAGES FROM /assets/images/show/
    ===================================================== */
    private List<String> loadShowImageFiles(HttpServletRequest request) {
        List<String> imageFiles = new ArrayList<>();
        try {
            String realPath = request.getServletContext().getRealPath("/assets/images/show");
            if (realPath == null) {
                return imageFiles;
            }

            File folder = new File(realPath);
            if (!folder.exists() || !folder.isDirectory()) {
                return imageFiles;
            }

            File[] files = folder.listFiles();
            if (files == null) {
                return imageFiles;
            }

            for (File f : files) {
                if (!f.isFile()) {
                    continue;
                }

                String name = f.getName().toLowerCase();
                if (name.endsWith(".jpg") || name.endsWith(".jpeg")
                        || name.endsWith(".png") || name.endsWith(".gif")
                        || name.endsWith(".webp")) {
                    imageFiles.add("assets/images/show/" + f.getName());
                }
            }
            Collections.sort(imageFiles);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return imageFiles;
    }

    /* =====================================================
       HELPER: ROLE
    ===================================================== */
    private boolean isDirectorRole(String role) {
        if (role == null) {
            return false;
        }
        String r = role.toLowerCase();
        return r.contains("đạo diễn") || r.contains("director");
    }

    private List<Artist> getDirectors() {
        List<Artist> rs = new ArrayList<>();
        List<Artist> all = (artistFacade != null) ? artistFacade.findAll() : null;
        if (all == null) {
            return rs;
        }

        for (Artist a : all) {
            if (a != null && isDirectorRole(a.getRole())) {
                rs.add(a);
            }
        }
        return rs;
    }

    private List<Artist> getActorsOnly() {
        List<Artist> rs = new ArrayList<>();
        List<Artist> all = (artistFacade != null) ? artistFacade.findAll() : null;
        if (all == null) {
            return rs;
        }

        for (Artist a : all) {
            if (a != null && !isDirectorRole(a.getRole())) {
                rs.add(a);
            }
        }
        return rs;
    }

    private void prepareAddFormData(HttpServletRequest req) {
        List<Artist> actors = getActorsOnly();
        List<Artist> directors = getDirectors();
        List<String> imageFiles = loadShowImageFiles(req);

        req.setAttribute("artists", actors);
        req.setAttribute("directors", directors);
        req.setAttribute("imageFiles", imageFiles);

        // alias phòng JSP dùng tên khác
        req.setAttribute("actorList", actors);
        req.setAttribute("artistList", actors);
        req.setAttribute("directorList", directors);

        System.out.println("[ShowAdd] actors=" + actors.size() + ", directors=" + directors.size());
    }

    /* =====================================================
       VALIDATION HELPERS
    ===================================================== */
    private boolean allBlank(String... vals) {
        if (vals == null) {
            return true;
        }
        for (String v : vals) {
            if (v != null && !v.trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }

    private boolean hasNegative(String s) {
        return s != null && s.contains("-");
    }

    private boolean hasDecimal(String s) {
        return s != null && (s.contains(".") || s.contains(","));
    }

    private String validateText(String val, String emptyMsg, String negativeMsg, String decimalMsg, String specialMsg) {
        String t = val == null ? "" : val.trim();
        if (t.isEmpty()) {
            return emptyMsg;
        }
        if (hasNegative(t)) {
            return negativeMsg;
        }
        if (hasDecimal(t)) {
            return decimalMsg;
        }
        if (!NO_SPECIAL_PATTERN.matcher(t).matches()) {
            return specialMsg;
        }
        return null;
    }

    // ✅ validate mô tả KHÔNG check thập phân nữa
    private String validateDescription(String val, String emptyMsg, String negativeMsg, String specialMsg) {
        String t = val == null ? "" : val.trim();
        if (t.isEmpty()) {
            return emptyMsg;
        }
        if (hasNegative(t)) {
            return negativeMsg;
        }
        if (!DESCRIPTION_PATTERN.matcher(t).matches()) {
            return specialMsg;
        }
        return null;
    }

    // ✅ 60 <= x <= 180
    private String validateDuration(String s) {
        String t = s == null ? "" : s.trim();

        if (t.isEmpty()) {
            return "Thời lượng diễn không được bỏ trống";
        }
        if (hasDecimal(t)) {
            return "Thời lượng diễn không được là số thập phân";
        }
        if (hasNegative(t)) {
            return "Thời lượng diễn không được là số âm";
        }

        int v;
        try {
            v = Integer.parseInt(t);
        } catch (NumberFormatException e) {
            return "Thời lượng diễn không được là số thập phân";
        }

        if (v <= 0) {
            return "Thời lượng diễn không được bằng 0";
        }

        if (v < 60) {
            return "Thời lượng diễn không được thấp hơn 60 phút";
        }
        if (v > 180) {
            return "Thời lượng diễn không được lớn hơn 180 phút";
        }

        return null;
    }

    /* =====================================================
       ✅ CHECK DUPLICATE NAME / POSTER
    ===================================================== */
    private String normalizeName(String s) {
        if (s == null) {
            return "";
        }
        return s.trim().replaceAll("\\s+", " ").toLowerCase();
    }

    private String normalizePoster(String s) {
        if (s == null) {
            return "";
        }
        return s.trim();
    }

    private boolean isDuplicateShowName(Integer excludeShowId, String inputName) {
        String target = normalizeName(inputName);
        if (target.isEmpty()) {
            return false;
        }

        List<Show> all = showFacade.findAll();
        if (all == null) {
            return false;
        }

        for (Show sh : all) {
            if (sh == null) {
                continue;
            }
            Integer id = sh.getShowID();
            if (excludeShowId != null && excludeShowId.equals(id)) {
                continue;
            }

            String existed = normalizeName(sh.getShowName());
            if (!existed.isEmpty() && existed.equals(target)) {
                return true;
            }
        }
        return false;
    }

    private boolean isDuplicatePoster(Integer excludeShowId, String poster) {
        String target = normalizePoster(poster);
        if (target.isEmpty()) {
            return false;
        }

        List<Show> all = showFacade.findAll();
        if (all == null) {
            return false;
        }

        for (Show sh : all) {
            if (sh == null) {
                continue;
            }
            Integer id = sh.getShowID();
            if (excludeShowId != null && excludeShowId.equals(id)) {
                continue;
            }

            String existed = normalizePoster(sh.getShowImage());
            if (!existed.isEmpty() && existed.equals(target)) {
                return true;
            }
        }
        return false;
    }

    /* =====================================================
       DO GET / POST
    ===================================================== */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);

        switch (req.getServletPath()) {
            case "/admin/show":
                showList(req, resp);
                break;
            case "/admin/show/add":
                showAddForm(req, resp);
                break;
            case "/admin/show/edit":
                showEditForm(req, resp);
                break;
            case "/admin/show/delete":
                deleteShow(req, resp); // hard delete
                break;

            // ✅ NEW
            case "/admin/show/soft-delete":
                softDeleteShow(req, resp);
                break;
            case "/admin/show/restore":
                restoreShow(req, resp);
                break;
            case "/admin/show/trash":
                showTrash(req, resp);
                break;

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private String urlEncodeUtf8(String s) {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);

        switch (req.getServletPath()) {
            case "/admin/show/add":
                createShow(req, resp);
                break;
            case "/admin/show/edit":
                updateShow(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /* =====================================================
       ✅ AUTO CLEAN EXPIRED (quá 30 ngày => hard delete)
       - Không DB, không timer: tự dọn khi admin mở list/trash
    ===================================================== */
    private void cleanupExpiredTrashQuietly() {
        try {
            List<Integer> expired = ShowTrashStore.expiredTrashIds();
            if (expired == null || expired.isEmpty()) {
                return;
            }

            for (Integer id : expired) {
                try {
                    // xóa vĩnh viễn trong DB bằng method cũ
                    showFacade.deleteHard(id);
                } catch (Exception ignored) {
                }
                try {
                    // remove khỏi trash file
                    ShowTrashStore.restore(id);
                } catch (Exception ignored) {
                }
            }
        } catch (Exception ignored) {
        }
    }

    /* =====================================================
       ✅ LIST: SEARCH + DATE + STATUS (lọc trước khi phân trang)
       + ✅ loại bỏ show đang trong thùng rác (soft delete)
    ===================================================== */
    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ✅ chống cache
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        // ✅ auto clean expired
        cleanupExpiredTrashQuietly();

        // ✅ SEARCH
        String keyword = req.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            keyword = req.getParameter("search");
        }
        keyword = (keyword == null) ? "" : keyword.trim();

        // ✅ STATUS (ALL / Ongoing / Upcoming / Cancelled)
        String statusParam = req.getParameter("status");
        statusParam = (statusParam == null) ? "ALL" : statusParam.trim();
        if (statusParam.isEmpty()) {
            statusParam = "ALL";
        }
        req.setAttribute("status", statusParam);

        // ✅ DATE RANGE (yyyy-MM-dd)
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");
        fromDateStr = (fromDateStr == null) ? "" : fromDateStr.trim();
        toDateStr = (toDateStr == null) ? "" : toDateStr.trim();

        req.setAttribute("fromDate", fromDateStr);
        req.setAttribute("toDate", toDateStr);

        System.out.println("[ShowList] keyword=" + keyword
                + " status=" + statusParam
                + " fromDate=" + fromDateStr + " toDate=" + toDateStr);

        // ✅ lấy list theo keyword trước
        List<Show> allShows;
        if (!keyword.isEmpty()) {
            allShows = showFacade.searchByName(keyword);
        } else {
            allShows = showFacade.findAll();
        }
        if (allShows == null) {
            allShows = new ArrayList<>();
        }

        // ✅ FILTER SOFT DELETE (loại show đang ở thùng rác)
        try {
            Set<Integer> trashed = ShowTrashStore.activeTrashIds();
            if (trashed != null && !trashed.isEmpty()) {
                allShows.removeIf(s -> s != null && s.getShowID() != null && trashed.contains(s.getShowID()));
            }
        } catch (Exception ignored) {
        }

        // ✅ PARSE DATE RANGE (lọc trước khi phân trang)
        Date fromDate = null;     // inclusive
        Date toDateExcl = null;   // exclusive (to + 1 day 00:00)

        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);

            if (!fromDateStr.isEmpty()) {
                fromDate = sdf.parse(fromDateStr);
            }
            if (!toDateStr.isEmpty()) {
                Date to = sdf.parse(toDateStr);
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(to);
                cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
                toDateExcl = cal.getTime();
            }
        } catch (Exception e) {
            fromDate = null;
            toDateExcl = null;
        }

        // ✅ LỌC STATUS + DATE TRÊN TOÀN BỘ allShows (trước pagination)
        if (!allShows.isEmpty()) {
            List<Show> filtered = new ArrayList<>();

            boolean filterStatus = (statusParam != null
                    && !statusParam.equalsIgnoreCase("ALL"));

            for (Show s : allShows) {
                if (s == null) {
                    continue;
                }

                // ---- filter STATUS
                if (filterStatus) {
                    String st = (s.getStatus() == null) ? "" : s.getStatus().trim();
                    if (!st.equalsIgnoreCase(statusParam)) {
                        continue;
                    }
                }

                // ---- filter DATE
                if (fromDate != null || toDateExcl != null) {
                    Date created = s.getCreatedAt();
                    if (created == null) {
                        continue;
                    }

                    if (fromDate != null && created.before(fromDate)) {
                        continue;
                    }
                    if (toDateExcl != null && !created.before(toDateExcl)) {
                        continue;
                    }
                }

                filtered.add(s);
            }

            allShows = filtered;
        }

        // ✅ PAGINATION (4 show / 1 page)
        final int pageSize = 4;

        int page = 1;
        try {
            String pageStr = req.getParameter("page");
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (Exception ignored) {
        }
        if (page < 1) {
            page = 1;
        }

        int totalItems = allShows.size();
        int totalPages = (int) Math.ceil(totalItems * 1.0 / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);

        List<Show> pageShows = new ArrayList<>();
        if (totalItems > 0 && fromIndex < totalItems) {
            pageShows = allShows.subList(fromIndex, toIndex);
        }

        req.setAttribute("shows", pageShows);
        req.setAttribute("searchKeyword", keyword);

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalItems", totalItems);

        // ✅ build popup detail data từ ShowArtist
        Map<Integer, String> directorMap = new HashMap<>();
        Map<Integer, String> actorMap = new HashMap<>();

        try {
            List<ShowArtist> allSA = showArtistFacade.findAll();
            if (allSA != null) {
                for (ShowArtist sa : allSA) {
                    if (sa == null || sa.getShowID() == null || sa.getArtistID() == null) {
                        continue;
                    }

                    Integer showId = sa.getShowID().getShowID();
                    Artist artist = sa.getArtistID();
                    if (showId == null || artist == null) {
                        continue;
                    }

                    String name = artist.getName();
                    String role = artist.getRole() != null ? artist.getRole().toLowerCase() : "";
                    if (name == null || name.trim().isEmpty()) {
                        continue;
                    }

                    if (role.contains("đạo diễn") || role.contains("director")) {
                        directorMap.put(showId, name);
                    } else {
                        String current = actorMap.get(showId);
                        if (current == null || current.isEmpty()) {
                            actorMap.put(showId, name);
                        } else if (!current.contains(name)) {
                            actorMap.put(showId, current + ", " + name);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("directorMap", directorMap);
        req.setAttribute("actorMap", actorMap);

        // ✅ THỐNG KÊ THEO STATUS
        long statTotal = showFacade.count();
        long statOngoing = showFacade.countByStatus("Ongoing");
        long statUpcoming = showFacade.countByStatus("Upcoming");
        long statCancelled = showFacade.countByStatus("Cancelled");

        req.setAttribute("statTotal", statTotal);
        req.setAttribute("statOngoing", statOngoing);
        req.setAttribute("statUpcoming", statUpcoming);
        req.setAttribute("statCancelled", statCancelled);

        req.getRequestDispatcher("/WEB-INF/views/admin/show/list.jsp").forward(req, resp);
    }

    /* =====================================================
       ADD FORM
    ===================================================== */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareAddFormData(request);
        request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp").forward(request, response);
    }

    /* =====================================================
       EDIT FORM
    ===================================================== */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer id = Integer.parseInt(req.getParameter("id"));
        Show show = showFacade.find(id);
        if (show == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/show?error=Không tìm thấy show");
            return;
        }

        req.setAttribute("show", show);

        // ✅ NEW: để edit.jsp selected sẵn status
        req.setAttribute("statusValue", show.getStatus());

        req.setAttribute("artists", getActorsOnly());
        req.setAttribute("directors", getDirectors());
        req.setAttribute("imageFiles", loadShowImageFiles(req));

        Integer selectedDirectorId = null;
        List<Integer> selectedArtistIds = new ArrayList<>();

        try {
            List<ShowArtist> allSA = showArtistFacade.findAll();
            if (allSA != null) {
                for (ShowArtist sa : allSA) {
                    if (sa == null || sa.getShowID() == null || sa.getArtistID() == null) {
                        continue;
                    }
                    if (sa.getShowID().getShowID() == null) {
                        continue;
                    }
                    if (!sa.getShowID().getShowID().equals(id)) {
                        continue;
                    }

                    Artist a = sa.getArtistID();
                    if (a == null || a.getArtistID() == null) {
                        continue;
                    }

                    if (isDirectorRole(a.getRole())) {
                        selectedDirectorId = a.getArtistID();
                    } else if (!selectedArtistIds.contains(a.getArtistID())) {
                        selectedArtistIds.add(a.getArtistID());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("selectedDirectorId", selectedDirectorId);
        req.setAttribute("selectedArtistIds", selectedArtistIds);

        req.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp").forward(req, resp);
    }


    /* =====================================================
       CREATE
    ===================================================== */
    private void createShow(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String showName = req.getParameter("showName");
        String description = req.getParameter("description");
        String durationStr = req.getParameter("durationMinutes");
        String status = req.getParameter("status");
        String directorIdStr = req.getParameter("directorId");
        String[] artistIds = req.getParameterValues("artistIds");
        String showImage = req.getParameter("showImageDropdown");

        if (allBlank(showName, description, durationStr, status, directorIdStr, showImage)
                && (artistIds == null || artistIds.length == 0)) {
            forwardAddError(req, resp, "Thông tin cho vở diễn không được để trống");
            return;
        }

        String err = validateText(
                showName,
                "Tên vở diễn không được để trống",
                "Tên vở diễn không được chứa số âm",
                "Tên vở diễn không được chứa số thập phân",
                "Tên vở diễn không được chứa kí tự đặc biệt"
        );
        if (err != null) {
            forwardAddError(req, resp, err);
            return;
        }

        if (isDuplicateShowName(null, showName)) {
            forwardAddError(req, resp, "Tên của show bạn vừa nhập không được trùng với show bạn đã tạo");
            return;
        }

        err = validateDescription(
                description,
                "Mô tả vở diễn không được để trống",
                "Mô tả vở diễn không được chứa số âm",
                "Mô tả vở diễn không được chứa kí tự đặc biệt"
        );
        if (err != null) {
            forwardAddError(req, resp, err);
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            forwardAddError(req, resp, "Trạng thái cho vở diễn không được bỏ trống");
            return;
        }

        err = validateDuration(durationStr);
        if (err != null) {
            forwardAddError(req, resp, err);
            return;
        }
        int duration = Integer.parseInt(durationStr.trim());

        if (directorIdStr == null || directorIdStr.trim().isEmpty()) {
            forwardAddError(req, resp, "Đạo diễn cho vở diễn chưa được chọn");
            return;
        }
        Artist director = artistFacade.find(Integer.parseInt(directorIdStr));
        if (director == null || !isDirectorRole(director.getRole())) {
            forwardAddError(req, resp, "Đạo diễn cho vở diễn chưa được chọn");
            return;
        }

        if (artistIds == null || artistIds.length == 0) {
            forwardAddError(req, resp, "Diễn viên cho vở diễn chưa được chọn");
            return;
        }
        if (artistIds.length < 4) {
            forwardAddError(req, resp, "Diễn viên cho vở diễn không được dưới 4 người");
            return;
        }

        if (showImage == null || showImage.trim().isEmpty()) {
            forwardAddError(req, resp, "Hình ảnh cho vở diễn không được chọn");
            return;
        }

        if (isDuplicatePoster(null, showImage)) {
            forwardAddError(req, resp, "Poster phim bạn chọn không được trùng với poster phim đã tạo");
            return;
        }

        Show s = new Show();
        s.setShowName(showName.trim());
        s.setDescription(description.trim());
        s.setDurationMinutes(duration);
        s.setStatus(status);
        s.setShowImage(showImage.trim());
        s.setCreatedAt(new Date());

        showFacade.create(s);

        Set<Integer> used = new HashSet<>();
        ShowArtist saD = new ShowArtist();
        saD.setShowID(s);
        saD.setArtistID(director);
        showArtistFacade.create(saD);
        if (director.getArtistID() != null) {
            used.add(director.getArtistID());
        }

        for (String aid : artistIds) {
            Artist a = artistFacade.find(Integer.parseInt(aid));
            if (a != null && a.getArtistID() != null && !used.contains(a.getArtistID())) {
                ShowArtist sa = new ShowArtist();
                sa.setShowID(s);
                sa.setArtistID(a);
                showArtistFacade.create(sa);
                used.add(a.getArtistID());
            }
        }

        String msg = java.net.URLEncoder.encode("Đã tạo show thành công", "UTF-8");
        resp.sendRedirect(req.getContextPath() + "/admin/show?success=" + msg + "&v=" + System.currentTimeMillis());
    }

    /* =====================================================
       UPDATE
    ===================================================== */
    private void updateShow(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String showIdStr = req.getParameter("showID");
        Show show = showFacade.find(Integer.parseInt(showIdStr));

        String showName = req.getParameter("showName");
        String description = req.getParameter("description");
        String durationStr = req.getParameter("durationMinutes");
        String status = req.getParameter("status");
        String directorIdStr = req.getParameter("directorId");
        String[] artistIds = req.getParameterValues("artistIds");
        String showImage = req.getParameter("showImageDropdown");

        if (show == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/show?error=Không tìm thấy show");
            return;
        }

        String err = validateText(
                showName,
                "Tên vở diễn không được để trống",
                "Tên vở diễn không được chứa số âm",
                "Tên vở diễn không được chứa số thập phân",
                "Tên vở diễn không được chứa kí tự đặc biệt"
        );
        if (err != null) {
            forwardEditError(req, resp, show, err);
            return;
        }

        if (isDuplicateShowName(show.getShowID(), showName)) {
            forwardEditError(req, resp, show, "Tên của show bạn vừa nhập không được trùng với show bạn đã tạo");
            return;
        }

        err = validateDescription(
                description,
                "Mô tả vở diễn không được để trống",
                "Mô tả vở diễn không được chứa số âm",
                "Mô tả vở diễn không được chứa kí tự đặc biệt"
        );
        if (err != null) {
            forwardEditError(req, resp, show, err);
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            forwardEditError(req, resp, show, "Trạng thái cho vở diễn không được bỏ trống");
            return;
        }

        err = validateDuration(durationStr);
        if (err != null) {
            forwardEditError(req, resp, show, err);
            return;
        }
        int duration = Integer.parseInt(durationStr.trim());

        if (directorIdStr == null || directorIdStr.trim().isEmpty()) {
            forwardEditError(req, resp, show, "Đạo diễn cho vở diễn chưa được chọn");
            return;
        }

        if (artistIds == null || artistIds.length == 0) {
            forwardEditError(req, resp, show, "Diễn viên cho vở diễn chưa được chọn");
            return;
        }
        if (artistIds.length < 4) {
            forwardAddError(req, resp, "Diễn viên cho vở diễn không được dưới 4 người");
            return;
        }

        if (showImage == null || showImage.trim().isEmpty()) {
            forwardEditError(req, resp, show, "Hình ảnh cho vở diễn không được chọn");
            return;
        }

        if (isDuplicatePoster(show.getShowID(), showImage)) {
            forwardEditError(req, resp, show, "Poster phim bạn chọn không được trùng với poster phim đã tạo");
            return;
        }

        show.setShowName(showName.trim());
        show.setDescription(description.trim());
        show.setDurationMinutes(duration);
        show.setStatus(status);
        show.setShowImage(showImage.trim());

        showFacade.edit(show);

        showArtistFacade.removeByShow(show);

        Set<Integer> used = new HashSet<>();
        Artist director = artistFacade.find(Integer.parseInt(directorIdStr));
        ShowArtist saD = new ShowArtist();
        saD.setShowID(show);
        saD.setArtistID(director);
        showArtistFacade.create(saD);
        if (director != null && director.getArtistID() != null) {
            used.add(director.getArtistID());
        }

        for (String aid : artistIds) {
            Artist a = artistFacade.find(Integer.parseInt(aid));
            if (a != null && a.getArtistID() != null && !used.contains(a.getArtistID())) {
                ShowArtist sa = new ShowArtist();
                sa.setShowID(show);
                sa.setArtistID(a);
                showArtistFacade.create(sa);
                used.add(a.getArtistID());
            }
        }

        resp.sendRedirect(req.getContextPath()
                + "/admin/show?success=" + urlEncodeUtf8("Cập nhật show thành công!")
                + "&v=" + System.currentTimeMillis());
    }

    /* =====================================================
       ERROR HELPERS
    ===================================================== */
    private void forwardAddError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);

        String status = req.getParameter("status");
        if (status != null && !status.trim().isEmpty()) {
            req.setAttribute("statusValue", status.trim());
        }

        prepareAddFormData(req);
        req.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp").forward(req, resp);
    }

    private void forwardEditError(HttpServletRequest req, HttpServletResponse resp, Show show, String msg)
            throws ServletException, IOException {

        req.setAttribute("show", show);
        req.setAttribute("error", msg);

        req.setAttribute("imageFiles", loadShowImageFiles(req));
        req.setAttribute("artists", getActorsOnly());
        req.setAttribute("directors", getDirectors());

        try {
            Integer id = show != null ? show.getShowID() : null;
            if (id != null) {
                Integer selectedDirectorId = null;
                List<Integer> selectedArtistIds = new ArrayList<>();
                List<ShowArtist> allSA = showArtistFacade.findAll();
                if (allSA != null) {
                    for (ShowArtist sa : allSA) {
                        if (sa == null || sa.getShowID() == null || sa.getArtistID() == null) {
                            continue;
                        }
                        if (sa.getShowID().getShowID() == null) {
                            continue;
                        }
                        if (!sa.getShowID().getShowID().equals(id)) {
                            continue;
                        }

                        Artist a = sa.getArtistID();
                        if (a == null || a.getArtistID() == null) {
                            continue;
                        }

                        if (isDirectorRole(a.getRole())) {
                            selectedDirectorId = a.getArtistID();
                        } else if (!selectedArtistIds.contains(a.getArtistID())) {
                            selectedArtistIds.add(a.getArtistID());
                        }
                    }
                }
                req.setAttribute("selectedDirectorId", selectedDirectorId);
                req.setAttribute("selectedArtistIds", selectedArtistIds);
            }
        } catch (Exception ignored) {
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp").forward(req, resp);
    }

    /* =====================================================
       ✅ SOFT DELETE: chuyển vào thùng rác (KHÔNG DB)
    ===================================================== */
    private void softDeleteShow(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        Integer id = Integer.parseInt(req.getParameter("id"));
        try {
            ShowTrashStore.softDelete(id);
        } catch (Exception ignored) {
        }

        resp.sendRedirect(req.getContextPath()
                + "/admin/show?success=" + urlEncodeUtf8("Đã chuyển show vào thùng rác")
                + "&v=" + System.currentTimeMillis());
    }

    /* =====================================================
       ✅ RESTORE: khôi phục từ thùng rác
    ===================================================== */
    private void restoreShow(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        Integer id = Integer.parseInt(req.getParameter("id"));
        try {
            ShowTrashStore.restore(id);
        } catch (Exception ignored) {
        }

        resp.sendRedirect(req.getContextPath()
                + "/admin/show/trash?success=" + urlEncodeUtf8("Đã khôi phục show")
                + "&v=" + System.currentTimeMillis());
    }

    /* =====================================================
       ✅ TRASH PAGE
    ===================================================== */
    private void showTrash(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // auto clean expired
        cleanupExpiredTrashQuietly();

        Map<Integer, Long> trashMap;
        try {
            trashMap = ShowTrashStore.readTrash();
        } catch (Exception e) {
            trashMap = new HashMap<>();
        }

        long now = System.currentTimeMillis();
        long retention = ShowTrashStore.getRetentionMs();

        // chỉ lấy show còn hạn
        List<Show> trashShows = new ArrayList<>();

// ✅ FIX: dùng Date để fmt:formatDate chạy được
        Map<Integer, Date> deletedAtMap = new HashMap<>();

        Map<Integer, Integer> remainDaysMap = new HashMap<>();

        for (Map.Entry<Integer, Long> e : trashMap.entrySet()) {
            Integer id = e.getKey();
            Long deletedAt = e.getValue();
            if (id == null || deletedAt == null) {
                continue;
            }

            long age = now - deletedAt;
            if (age > retention) {
                continue;
            }

            Show s = null;
            try {
                s = showFacade.find(id);
            } catch (Exception ignored) {
            }
            if (s == null) {
                continue;
            }

            trashShows.add(s);

            // ✅ FIX: Long millis -> Date
            deletedAtMap.put(id, new Date(deletedAt));

            long remainMs = Math.max(0, retention - age);
            int remainDays = (int) Math.ceil(remainMs / (24.0 * 60 * 60 * 1000));
            remainDaysMap.put(id, remainDays);
        }

// sort theo deletedAt mới nhất lên trước
        trashShows.sort((a, b) -> {
            Date da = deletedAtMap.get(a.getShowID());
            Date db = deletedAtMap.get(b.getShowID());
            if (da == null) {
                da = new Date(0);
            }
            if (db == null) {
                db = new Date(0);
            }
            return db.compareTo(da); // mới nhất trước
        });

        req.setAttribute("trashShows", trashShows);
        req.setAttribute("trashDeletedAtMap", deletedAtMap);
        req.setAttribute("trashRemainDaysMap", remainDaysMap);

        req.getRequestDispatcher("/WEB-INF/views/admin/show/trash.jsp").forward(req, resp);

    }

    /* =====================================================
       ✅ HARD DELETE (giữ nguyên)
       - Nếu xóa từ thùng rác => cũng remove khỏi trash file cho sạch
    ===================================================== */
    // ✅ FIX METHOD deleteShow() - CHẶN XÓA NẾU CÓ ĐƠN HÀNG

private void deleteShow(HttpServletRequest req, HttpServletResponse resp)
        throws IOException {

    Integer id = Integer.parseInt(req.getParameter("id"));
    
    // ✅ BƯỚC 1: KIỂM TRA SHOW CÓ LỊCH DIỄN NÀO ĐÃ CÓ ĐƠN HÀNG CHƯA
    boolean hasOrders = showFacade.hasOrdersForShow(id);
    
    if (hasOrders) {
        // ❌ CHẶN XÓA - KHÔNG CHO XÓA KỂ CẢ SAU 30 NGÀY
        String back = req.getParameter("back");
        String msg = urlEncodeUtf8(
            "⚠️ KHÔNG THỂ XÓA! Show này có " + 
            showFacade.countOrdersForShow(id) + 
            " đơn hàng đã được đặt vé. " +
            "Dữ liệu này được bảo vệ vĩnh viễn để đảm bảo tính toàn vẹn của hệ thống."
        );
        
        if ("trash".equalsIgnoreCase(back)) {
            resp.sendRedirect(req.getContextPath() + 
                "/admin/show/trash?error=" + msg);
        } else {
            resp.sendRedirect(req.getContextPath() + 
                "/admin/show?error=" + msg);
        }
        return;
    }
    
    // ✅ BƯỚC 2: NẾU KHÔNG CÓ ĐƠN HÀNG → CHO PHÉP XÓA
    showFacade.deleteHard(id);

    // Remove from trash file
    try {
        ShowTrashStore.restore(id);
    } catch (Exception ignored) {
    }

    String back = req.getParameter("back");
    String msg = urlEncodeUtf8("✅ Xóa show vĩnh viễn thành công");

    if ("trash".equalsIgnoreCase(back)) {
        resp.sendRedirect(req.getContextPath()
                + "/admin/show/trash?success=" + msg
                + "&v=" + System.currentTimeMillis());
    } else {
        resp.sendRedirect(req.getContextPath()
                + "/admin/show?success=" + msg
                + "&v=" + System.currentTimeMillis());
    }
}
}
