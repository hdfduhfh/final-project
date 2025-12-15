package mypack.controller.admin;

///*
// * ShowManagementServlet.java
// */
//package mypack.controller.admin;
//
//import jakarta.ejb.EJB;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.Part;
//
//import mypack.Show;
//import mypack.ShowFacadeLocal;
//import mypack.Artist;
//import mypack.ArtistFacadeLocal;
//import mypack.ShowArtist;
//import mypack.ShowArtistFacadeLocal;
//
//import java.io.File;
//import java.io.IOException;
//import java.nio.file.Paths;
//import java.util.Date;
//import java.util.List;
//import java.util.ArrayList;
//import java.util.regex.Pattern;
//
//@WebServlet(
//        name = "ShowManagementServlet",
//        urlPatterns = {
//            "/admin/show",
//            "/admin/show/add",
//            "/admin/show/edit",
//            "/admin/show/delete"
//        }
//)
//@MultipartConfig
//public class ShowManagementServlet extends HttpServlet {
//
//    @EJB
//    private ShowFacadeLocal showFacade;
//
//    @EJB
//    private ArtistFacadeLocal artistFacade;
//
//    @EJB
//    private ShowArtistFacadeLocal showArtistFacade;
//
//    // Không cho ký tự đặc biệt: chỉ cho chữ (kể cả tiếng Việt), số, khoảng trắng
//    private static final Pattern NO_SPECIAL_PATTERN
//            = Pattern.compile("^[\\p{L}\\d\\s]+$");
//
//    // ===================== COMMON UTF-8 =====================
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
//        switch (path) {
//            case "/admin/show":
//                showList(request, response);
//                break;
//            case "/admin/show/add":
//                showAddForm(request, response);
//                break;
//            case "/admin/show/edit":
//                showEditForm(request, response);
//                break;
//            case "/admin/show/delete":
//                deleteShow(request, response);
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
//        switch (path) {
//            case "/admin/show/add":
//                createShow(request, response);
//                break;
//            case "/admin/show/edit":
//                updateShow(request, response);
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
//        // 1. Lấy keyword người dùng gõ từ ô search (list.jsp: <input name="search" ...>)
//        String keyword = request.getParameter("keyword");
//        List<Show> shows;
//
//        if (keyword != null && !keyword.trim().isEmpty()) {
//            // Chuẩn hóa chuỗi tìm kiếm (cắt khoảng trắng 2 đầu)
//            String trimmedKeyword = keyword.trim();
//
//            // 2. Gọi hàm searchByName trong ShowFacade
//            //    Hàm này nên dùng LOWER(showName) LIKE LOWER('%keyword%')
//            //    để không phân biệt chữ hoa/thường và tìm theo kiểu "chứa"
//            shows = showFacade.searchByName(trimmedKeyword);
//
//        } else {
//            // 3. Không nhập gì -> trả về toàn bộ show
//            shows = showFacade.findAll();
//        }
//
//        // 4. Đẩy lại keyword xuống JSP để hiển thị lại trong ô input (giữ giá trị đã gõ)
//        request.setAttribute("searchKeyword", keyword);
//
//        // 5. Nếu có error ở query string (vd: /admin/show?error=...),
//        //    chuyển thành attribute để JSP hiển thị bằng ${error}
//        String errorMsg = request.getParameter("error");
//        if (errorMsg != null && !errorMsg.trim().isEmpty()) {
//            request.setAttribute("error", errorMsg.trim());
//        }
//
//        // (success bạn đang dùng ${param.success} trong JSP, nên không cần setAttribute)
//        // 6. Đưa danh sách show xuống JSP
//        request.setAttribute("shows", shows);
//
//        // 7. Forward tới trang list.jsp
//        request.getRequestDispatcher("/WEB-INF/views/admin/show/list.jsp")
//                .forward(request, response);
//    }
//
//    /* ===================== ADD FORM ===================== */
//    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Load danh sách nghệ sĩ
//        List<Artist> artists = artistFacade.findAll();
//        request.setAttribute("artists", artists);
//
//        // Load danh sách file ảnh từ thư mục assets/images/show
//        List<String> imageFiles = loadImageFiles(request);
//        request.setAttribute("imageFiles", imageFiles);
//
//        request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
//                .forward(request, response);
//    }
//
//    /* ===================== EDIT FORM ===================== */
//    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        try {
//            String idParam = request.getParameter("id");
//            if (idParam == null || idParam.trim().isEmpty()) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/show?error=ID không hợp lệ");
//                return;
//            }
//
//            Integer showId = Integer.parseInt(idParam);
//            Show show = showFacade.find(showId);
//            if (show == null) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/show?error=Không tìm thấy show");
//                return;
//            }
//
//            // danh sách nghệ sĩ để dropdown/multi-select
//            List<Artist> artists = artistFacade.findAll();
//            request.setAttribute("artists", artists);
//
//            // Nếu anh muốn tick sẵn multi-select, có thể lấy từ show.getShowArtistCollection()
//            // (phần này tùy anh triển khai trong edit.jsp bằng selectedArtistIds)
//            // danh sách file ảnh
//            List<String> imageFiles = loadImageFiles(request);
//            request.setAttribute("imageFiles", imageFiles);
//
//            // gửi show hiện tại xuống JSP
//            request.setAttribute("show", show);
//
//            request.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp")
//                    .forward(request, response);
//
//        } catch (NumberFormatException e) {
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/show?error=ID không hợp lệ");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/show?error=Lỗi: " + e.getMessage());
//        }
//    }
//
//    /* ===================== CREATE (ADD) ===================== */
//    private void createShow(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        try {
//            List<Artist> selectedArtists = new ArrayList<>();
//
//            // Lấy dữ liệu từ form
//            String showName = request.getParameter("showName");
//            String description = request.getParameter("description");
//            String durationStr = request.getParameter("durationMinutes");
//            String status = request.getParameter("status");
//            String showImageParam = request.getParameter("showImage");
//            String showImageDropdown = request.getParameter("showImageDropdown");
//            String artistIdStr = request.getParameter("artistID"); // tên cũ (single)
//            // tên mới (multi-select): artistIds
//            String[] artistIds = request.getParameterValues("artistIds");
//
//            /* ===== 1. TÊN VỞ DIỄN ===== */
//            String trimmedShowName = (showName != null) ? showName.trim() : "";
//            if (trimmedShowName.isEmpty()) {
//                loadArtistsAndForwardError(request, response,
//                        "Tên vở diễn không được để trống");
//                return;
//            }
//
//            // Không cho ký tự đặc biệt
//            if (!NO_SPECIAL_PATTERN.matcher(trimmedShowName).matches()) {
//                loadArtistsAndForwardError(request, response,
//                        "Tên vở diễn không được chứa ký tự đặc biệt");
//                return;
//            }
//
//            /* ===== 2. MÔ TẢ VỞ DIỄN ===== */
//            String trimmedDescription = (description != null) ? description.trim() : "";
//            if (trimmedDescription.isEmpty()) {
//                loadArtistsAndForwardError(request, response,
//                        "Mô tả không được để trống");
//                return;
//            }
//
//            /* ===== 3. THỜI LƯỢNG DIỄN ===== */
//            if (durationStr == null || durationStr.trim().isEmpty()) {
//                loadArtistsAndForwardError(request, response,
//                        "Thời lượng diễn không được để trống");
//                return;
//            }
//
//            int duration;
//            try {
//                duration = Integer.parseInt(durationStr.trim());
//            } catch (NumberFormatException e) {
//                loadArtistsAndForwardError(request, response,
//                        "Thời lượng diễn phải là số nguyên");
//                return;
//            }
//
//            if (duration <= 60) {
//                loadArtistsAndForwardError(request, response,
//                        "Thời lượng diễn phải trên 60 phút");
//                return;
//            }
//
//            /* ===== 4. TRẠNG THÁI ===== */
//            if (status == null || status.trim().isEmpty()) {
//                loadArtistsAndForwardError(request, response,
//                        "Trạng thái vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 5. NGHỆ SĨ (NHIỀU NGHỆ SĨ) ===== */
//            // Hỗ trợ cả tên tham số cũ (artistID) và mới (artistIds - multi-select)
//            if ((artistIds == null || artistIds.length == 0)
//                    && artistIdStr != null && !artistIdStr.trim().isEmpty()) {
//                artistIds = new String[]{artistIdStr.trim()};
//            }
//
//            if (artistIds == null || artistIds.length == 0) {
//                loadArtistsAndForwardError(request, response,
//                        "Nghệ sĩ cho vở diễn chưa được chọn");
//                return;
//            }
//
//            for (String idStr : artistIds) {
//                if (idStr == null || idStr.trim().isEmpty()) {
//                    continue;
//                }
//                try {
//                    Integer artistId = Integer.parseInt(idStr.trim());
//                    Artist artist = artistFacade.find(artistId);
//                    if (artist == null) {
//                        loadArtistsAndForwardError(request, response,
//                                "Nghệ sĩ cho vở diễn chưa được chọn");
//                        return;
//                    }
//                    selectedArtists.add(artist);
//                } catch (NumberFormatException ex) {
//                    loadArtistsAndForwardError(request, response,
//                            "Nghệ sĩ cho vở diễn chưa được chọn");
//                    return;
//                }
//            }
//
//            if (selectedArtists.isEmpty()) {
//                loadArtistsAndForwardError(request, response,
//                        "Nghệ sĩ cho vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 6. HÌNH ẢNH VỞ DIỄN ===== */
//            String finalImagePath = null; // KHÔNG lấy sẵn hình cũ nữa
//
//            Part imagePart = null;
//            try {
//                imagePart = request.getPart("imageFile");
//            } catch (IllegalStateException ex) {
//                // không phải multipart hoặc lỗi kích thước, bỏ qua
//            }
//
//            // 6.1. Nếu upload file mới
//            if (imagePart != null && imagePart.getSize() > 0) {
//                String submittedFileName = imagePart.getSubmittedFileName();
//                if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
//                    String fileName = Paths.get(submittedFileName).getFileName().toString();
//                    String lower = fileName.toLowerCase();
//
//                    if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg")
//                            || lower.endsWith(".png") || lower.endsWith(".gif"))) {
//                        loadArtistsAndForwardError(request, response,
//                                "Chỉ cho phép upload file ảnh (JPG, PNG, GIF)");
//                        return;
//                    }
//
//                    String uploadDirPath = request.getServletContext()
//                            .getRealPath("/assets/images/show");
//                    File uploadDir = new File(uploadDirPath);
//                    if (!uploadDir.exists()) {
//                        uploadDir.mkdirs();
//                    }
//
//                    File savedFile = new File(uploadDir, fileName);
//                    imagePart.write(savedFile.getAbsolutePath());
//
//                    finalImagePath = "assets/images/show/" + fileName;
//                }
//            }
//
//            // 6.2. Nếu không upload file mới thì dùng dropdown hoặc text
//            if (finalImagePath == null) {
//                if (showImageDropdown != null && !showImageDropdown.trim().isEmpty()) {
//                    finalImagePath = showImageDropdown.trim();
//                } else if (showImageParam != null && !showImageParam.trim().isEmpty()) {
//                    finalImagePath = showImageParam.trim();
//                }
//            }
//
//            /* ===== 7. TẠO SHOW ===== */
//            Show newShow = new Show();
//            newShow.setShowName(trimmedShowName);
//            newShow.setDescription(trimmedDescription);
//            newShow.setDurationMinutes(duration);
//            newShow.setStatus(status.trim());
//            newShow.setShowImage(finalImagePath);
//            newShow.setCreatedAt(new Date());
//
//            showFacade.create(newShow);
//
//            // Tạo các bản ghi ShowArtist cho từng nghệ sĩ đã chọn
//            if (showArtistFacade != null) {
//                for (Artist artist : selectedArtists) {
//                    ShowArtist sa = new ShowArtist();
//                    sa.setShowID(newShow);
//                    sa.setArtistID(artist);
//                    showArtistFacade.create(sa);
//                }
//            }
//
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/show?success=Thêm show thành công!");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            loadArtistsAndForwardError(request, response,
//                    "Lỗi khi thêm vở diễn: " + e.getMessage());
//        }
//    }
//
//    /* ===================== UPDATE (EDIT) ===================== */
//    private void updateShow(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        Show show = null;
//
//        try {
//            List<Artist> selectedArtists = new ArrayList<>();
//
//            // 1. Lấy dữ liệu từ form
//            String showIdStr = request.getParameter("showID");
//            String showName = request.getParameter("showName");
//            String description = request.getParameter("description");
//            String durationStr = request.getParameter("durationMinutes");
//            String status = request.getParameter("status");
//            String showImageParam = request.getParameter("showImage");
//            String showImageDropdown = request.getParameter("showImageDropdown");
//            String artistIdStr = request.getParameter("artistID"); // tên cũ (single)
//            String[] artistIds = request.getParameterValues("artistIds"); // tên mới multi
//
//            if (showIdStr == null || showIdStr.trim().isEmpty()) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/show?error=ID vở diễn không hợp lệ");
//                return;
//            }
//
//            Integer showId = Integer.parseInt(showIdStr);
//            show = showFacade.find(showId);
//            if (show == null) {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/show?error=Không tìm thấy vở diễn");
//                return;
//            }
//
//            /* ===== 2. TÊN VỞ DIỄN ===== */
//            String trimmedShowName = (showName != null) ? showName.trim() : "";
//            if (trimmedShowName.isEmpty()) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Tên vở diễn không được để trống");
//                return;
//            }
//
//            if (!NO_SPECIAL_PATTERN.matcher(trimmedShowName).matches()) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Tên vở diễn không được chứa ký tự đặc biệt");
//                return;
//            }
//
//            /* ===== 3. MÔ TẢ ===== */
//            String trimmedDescription = (description != null) ? description.trim() : "";
//            if (trimmedDescription.isEmpty()) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Mô tả không được để trống");
//                return;
//            }
//
//            /* ===== 4. THỜI LƯỢNG ===== */
//            if (durationStr == null || durationStr.trim().isEmpty()) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Thời lượng diễn không được để trống");
//                return;
//            }
//
//            int duration;
//            try {
//                duration = Integer.parseInt(durationStr.trim());
//            } catch (NumberFormatException e) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Thời lượng diễn phải là số nguyên");
//                return;
//            }
//
//            if (duration <= 60) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Thời lượng diễn phải trên 60 phút");
//                return;
//            }
//
//            /* ===== 5. TRẠNG THÁI ===== */
//            if (status == null || status.trim().isEmpty()) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Trạng thái vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 6. NGHỆ SĨ (MULTI) ===== */
//            if ((artistIds == null || artistIds.length == 0)
//                    && artistIdStr != null && !artistIdStr.trim().isEmpty()) {
//                artistIds = new String[]{artistIdStr.trim()};
//            }
//
//            if (artistIds == null || artistIds.length == 0) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Nghệ sĩ cho vở diễn chưa được chọn");
//                return;
//            }
//
//            for (String idStr : artistIds) {
//                if (idStr == null || idStr.trim().isEmpty()) {
//                    continue;
//                }
//                try {
//                    Integer artistId = Integer.parseInt(idStr.trim());
//                    Artist artist = artistFacade.find(artistId);
//                    if (artist == null) {
//                        loadArtistsAndForwardErrorEdit(request, response, show,
//                                "Nghệ sĩ cho vở diễn chưa được chọn");
//                        return;
//                    }
//                    selectedArtists.add(artist);
//                } catch (NumberFormatException ex) {
//                    loadArtistsAndForwardErrorEdit(request, response, show,
//                            "Nghệ sĩ cho vở diễn chưa được chọn");
//                    return;
//                }
//            }
//
//            if (selectedArtists.isEmpty()) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Nghệ sĩ cho vở diễn chưa được chọn");
//                return;
//            }
//
//            /* ===== 7. HÌNH ẢNH ===== */
//            String finalImagePath = show.getShowImage(); // mặc định lấy ảnh hiện tại
//
//            Part imagePart = null;
//            try {
//                imagePart = request.getPart("imageFile");
//            } catch (IllegalStateException ex) {
//                // không phải multipart hoặc lỗi kích thước
//            }
//
//            // 7.1. Upload file mới
//            if (imagePart != null && imagePart.getSize() > 0) {
//                String submittedFileName = imagePart.getSubmittedFileName();
//                if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
//                    String fileName = Paths.get(submittedFileName).getFileName().toString();
//                    String lower = fileName.toLowerCase();
//
//                    if (!(lower.endsWith(".jpg") || lower.endsWith(".jpeg")
//                            || lower.endsWith(".png") || lower.endsWith(".gif"))) {
//                        loadArtistsAndForwardErrorEdit(request, response, show,
//                                "Chỉ cho phép upload file ảnh (JPG, PNG, GIF)");
//                        return;
//                    }
//
//                    String uploadDirPath = request.getServletContext()
//                            .getRealPath("/assets/images/show");
//                    File uploadDir = new File(uploadDirPath);
//                    if (!uploadDir.exists()) {
//                        uploadDir.mkdirs();
//                    }
//
//                    File savedFile = new File(uploadDir, fileName);
//                    imagePart.write(savedFile.getAbsolutePath());
//
//                    finalImagePath = "assets/images/show/" + fileName;
//                }
//            } else {
//                // 7.2. Nếu không upload mới thì dùng dropdown hoặc text
//                if (showImageDropdown != null && !showImageDropdown.trim().isEmpty()) {
//                    finalImagePath = showImageDropdown.trim();
//                } else if (showImageParam != null && !showImageParam.trim().isEmpty()) {
//                    finalImagePath = showImageParam.trim();
//                }
//            }
//
//            /* ===== 8. CẬP NHẬT SHOW ===== */
//            show.setShowName(trimmedShowName);
//            show.setDescription(trimmedDescription);
//            show.setDurationMinutes(duration);
//            show.setStatus(status.trim());
//            show.setShowImage(finalImagePath);
//
//            showFacade.edit(show);
//
//            // Cập nhật lại các bản ghi ShowArtist cho show này
//            if (showArtistFacade != null) {
//                // Xóa quan hệ cũ
//                showArtistFacade.removeByShow(show);
//                // Thêm quan hệ mới theo danh sách nghệ sĩ đã chọn
//                for (Artist artist : selectedArtists) {
//                    ShowArtist sa = new ShowArtist();
//                    sa.setShowID(show);
//                    sa.setArtistID(artist);
//                    showArtistFacade.create(sa);
//                }
//            }
//
//            response.sendRedirect(request.getContextPath()
//                    + "/admin/show?success=Cập nhật show thành công!");
//
//        } catch (NumberFormatException e) {
//            if (show != null) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Dữ liệu không hợp lệ");
//            } else {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/show?error=Dữ liệu không hợp lệ");
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            if (show != null) {
//                loadArtistsAndForwardErrorEdit(request, response, show,
//                        "Lỗi khi cập nhật vở diễn: " + e.getMessage());
//            } else {
//                response.sendRedirect(request.getContextPath()
//                        + "/admin/show?error=Lỗi: " + e.getMessage());
//            }
//        }
//    }
//
//    /* ===================== DELETE ===================== */
//    private void deleteShow(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//
//        String ctx = request.getContextPath();
//        String idParam = request.getParameter("id");
//
//        if (idParam == null || idParam.trim().isEmpty()) {
//            response.sendRedirect(ctx + "/admin/show?error=ID show không hợp lệ");
//            return;
//        }
//
//        try {
//            Integer showId = Integer.parseInt(idParam.trim());
//
//            if (showFacade == null) {
//                response.sendRedirect(ctx + "/admin/show?error=Lỗi hệ thống: showFacade == null");
//                return;
//            }
//
//            // ✅ XÓA CỨNG: xóa hết dữ liệu liên quan rồi mới xóa Show
//            showFacade.deleteHard(showId);
//
//            response.sendRedirect(ctx + "/admin/show?success=Xóa show thành công!");
//        } catch (NumberFormatException ex) {
//            response.sendRedirect(ctx + "/admin/show?error=ID show không hợp lệ");
//        } catch (Exception ex) {
//            ex.printStackTrace();
//            response.sendRedirect(ctx + "/admin/show?error=Không thể xóa show. Vui lòng kiểm tra ràng buộc dữ liệu liên quan.");
//        }
//    }
//
//    /* ===================== LOAD IMAGE FILES ===================== */
//    private List<String> loadImageFiles(HttpServletRequest request) {
//        List<String> imageFiles = new ArrayList<>();
//        try {
//            String realPath
//                    = request.getServletContext().getRealPath("/assets/images/show");
//            if (realPath == null) {
//                return imageFiles;
//            }
//
//            File folder = new File(realPath);
//            if (!folder.exists() || !folder.isDirectory()) {
//                return imageFiles;
//            }
//
//            File[] files = folder.listFiles();
//            if (files == null) {
//                return imageFiles;
//            }
//
//            for (File f : files) {
//                if (f.isFile()) {
//                    imageFiles.add("assets/images/show/" + f.getName());
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return imageFiles;
//    }
//
//    /* ===================== ERROR HELPERS ===================== */
//    private void loadArtistsAndForwardError(HttpServletRequest request,
//            HttpServletResponse response,
//            String errorMessage)
//            throws ServletException, IOException {
//
//        // Load lại danh sách nghệ sĩ
//        List<Artist> artists = artistFacade.findAll();
//        request.setAttribute("artists", artists);
//
//        // Load lại danh sách file ảnh
//        List<String> imageFiles = loadImageFiles(request);
//        request.setAttribute("imageFiles", imageFiles);
//
//        // Thông báo tổng cho trang add.jsp
//        request.setAttribute("globalMessage",
//                "Vui lòng điền đầy đủ các thông tin cho vở diễn");
//
//        // Thông báo lỗi cụ thể
//        request.setAttribute("error", errorMessage);
//
//        // Quay lại trang add.jsp
//        request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
//                .forward(request, response);
//    }
//
//    private void loadArtistsAndForwardErrorEdit(HttpServletRequest request,
//            HttpServletResponse response,
//            Show show,
//            String errorMessage)
//            throws ServletException, IOException {
//
//        // Load lại danh sách nghệ sĩ
//        List<Artist> artists = artistFacade.findAll();
//        request.setAttribute("artists", artists);
//
//        // Load lại danh sách file ảnh
//        List<String> imageFiles = loadImageFiles(request);
//        request.setAttribute("imageFiles", imageFiles);
//
//        // Gửi lại show hiện tại (đã lấy từ DB)
//        request.setAttribute("show", show);
//
//        // Thông báo tổng cho trang edit.jsp
//        request.setAttribute("globalMessage",
//                "Vui lòng chỉnh sửa và kiểm tra lại các thông tin cho vở diễn");
//
//        // Thông báo lỗi cụ thể
//        request.setAttribute("error", errorMessage);
//
//        // Quay lại trang edit.jsp
//        request.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp")
//                .forward(request, response);
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "Show Management Servlet for Admin";
//    }
//}
