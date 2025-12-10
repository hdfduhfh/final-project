/*
 * ShowManagementServlet.java
 */
package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import mypack.Show;
import mypack.ShowFacadeLocal;
import mypack.Artist;
import mypack.ArtistFacadeLocal;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.regex.Pattern;

/**
 * Servlet quản lý Show: - Danh sách, tìm kiếm - Thêm, sửa, xóa - Upload / chọn
 * hình ảnh từ thư mục assets/images/show
 */
@WebServlet(name = "ShowManagementServlet", urlPatterns = {
    "/admin/show",
    "/admin/show/add",
    "/admin/show/edit",
    "/admin/show/delete"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024, // 5 MB
        maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class ShowManagementServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

    @EJB
    private ArtistFacadeLocal artistFacade;

    // Không cho ký tự đặc biệt: chỉ cho chữ (kể cả tiếng Việt), số, khoảng trắng
    private static final Pattern NO_SPECIAL_PATTERN
            = Pattern.compile("^[\\p{L}\\d\\s]+$");

    // ===================== COMMON UTF-8 =====================
    private void setUtf8(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {
        }
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập UTF-8 cho tất cả các trang GET: list, add, edit
        setUtf8(request, response);

        String path = request.getServletPath();

        switch (path) {
            case "/admin/show":
                showList(request, response);
                break;
            case "/admin/show/add":
                showAddForm(request, response);
                break;
            case "/admin/show/edit":
                showEditForm(request, response);
                break;
            case "/admin/show/delete":
                deleteShow(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập UTF-8 cho tất cả các form POST: add, edit
        setUtf8(request, response);

        String path = request.getServletPath();

        switch (path) {
            case "/admin/show/add":
                createShow(request, response);
                break;
            case "/admin/show/edit":
                updateShow(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /* ===================== LIST ===================== */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String searchKeyword = request.getParameter("search");
            List<Show> shows;

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Hàm custom trong ShowFacadeLocal: tìm theo tên (LIKE %từ khóa%)
                shows = showFacade.findByShowName(searchKeyword.trim());
            } else {
                shows = showFacade.findAll();
            }

            long totalShows = shows.size();
            long activeShows = shows.stream()
                    .filter(s -> "Active".equalsIgnoreCase(s.getStatus()))
                    .count();
            long inactiveShows = totalShows - activeShows;

            request.setAttribute("shows", shows);
            request.setAttribute("totalShows", totalShows);
            request.setAttribute("activeShows", activeShows);
            request.setAttribute("inactiveShows", inactiveShows);
            request.setAttribute("searchKeyword", searchKeyword);

            request.getRequestDispatcher("/WEB-INF/views/admin/show/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách show: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/show/list.jsp")
                    .forward(request, response);
        }
    }

    /* ===================== ADD FORM ===================== */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // danh sách nghệ sĩ để dropdown chọn nghệ sĩ cho vở diễn
        List<Artist> artists = artistFacade.findAll();
        request.setAttribute("artists", artists);

        // danh sách hình ảnh show để dropdown
        List<String> imageFiles = loadImageFiles(request);
        request.setAttribute("imageFiles", imageFiles);

        request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
                .forward(request, response);
    }

    /* ===================== EDIT FORM ===================== */
    /**
     * Khi bấm nút "Sửa" ở list.jsp: - Lấy show theo ID - Gửi lại toàn bộ thông
     * tin show sang edit.jsp - Gửi luôn danh sách hình trong thư mục
     * assets/images/show để dropdown hình ảnh hiển thị đúng.
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/show?error=ID không hợp lệ");
                return;
            }

            Integer showId = Integer.parseInt(idParam);
            Show show = showFacade.find(showId);
            if (show == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/show?error=Không tìm thấy show");
                return;
            }

            // danh sách nghệ sĩ để dropdown (nếu có)
            List<Artist> artists = artistFacade.findAll();
            request.setAttribute("artists", artists);

            // danh sách hình ảnh trong thư mục assets/images/show
            List<String> imageFiles = loadImageFiles(request);
            request.setAttribute("imageFiles", imageFiles);

            // gửi show hiện tại để edit.jsp hiển thị lại toàn bộ thông tin
            request.setAttribute("show", show);

            request.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/show?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/show?error=Lỗi: " + e.getMessage());
        }
    }

    /* ===================== CREATE (ADD) ===================== */
    private void createShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy dữ liệu từ form
            String showName = request.getParameter("showName");
            String description = request.getParameter("description");
            String durationStr = request.getParameter("durationMinutes");
            String status = request.getParameter("status");
            String showImageParam = request.getParameter("showImage");
            String showImageDropdown = request.getParameter("showImageDropdown");
            String artistIdStr = request.getParameter("artistID");

            /* ===== 1. TÊN VỞ DIỄN ===== */
            String trimmedShowName = (showName != null) ? showName.trim() : "";
            if (trimmedShowName.isEmpty()) {
                loadArtistsAndForwardError(request, response,
                        "Tên vở diễn không được để trống");
                return;
            }

            // RÀNG BUỘC SỐ CHO TÊN (chỉ cho N hoặc N*)
            try {
                double numericVal = Double.parseDouble(trimmedShowName);

                if (numericVal < 0) {
                    loadArtistsAndForwardError(request, response,
                            "Tên vở diễn không được chứa số âm");
                    return;
                }

                if (trimmedShowName.contains(".") || trimmedShowName.contains(",")) {
                    loadArtistsAndForwardError(request, response,
                            "Tên vở diễn không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ignore) {
                // không phải chuỗi số thuần -> bỏ qua ràng buộc số
            }

            if (!NO_SPECIAL_PATTERN.matcher(trimmedShowName).matches()) {
                loadArtistsAndForwardError(request, response,
                        "Tên vở diễn không được chứa ký tự đặc biệt");
                return;
            }

            /* ===== 2. MÔ TẢ VỞ DIỄN ===== */
            String trimmedDescription = (description != null) ? description.trim() : "";
            if (trimmedDescription.isEmpty()) {
                loadArtistsAndForwardError(request, response,
                        "Mô tả không được để trống");
                return;
            }

            // RÀNG BUỘC SỐ CHO MÔ TẢ (chỉ cho N hoặc N*)
            try {
                double numericVal = Double.parseDouble(trimmedDescription);

                if (numericVal < 0) {
                    loadArtistsAndForwardError(request, response,
                            "Mô tả vở diễn không được chứa số âm");
                    return;
                }

                if (trimmedDescription.contains(".") || trimmedDescription.contains(",")) {
                    loadArtistsAndForwardError(request, response,
                            "Mô tả vở diễn không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ignore) {
                // không phải chuỗi số thuần
            }

            if (!NO_SPECIAL_PATTERN.matcher(trimmedDescription).matches()) {
                loadArtistsAndForwardError(request, response,
                        "Mô tả không được chứa ký tự đặc biệt");
                return;
            }

            /* ===== 3. THỜI LƯỢNG ===== */
            if (durationStr == null || durationStr.trim().isEmpty()) {
                loadArtistsAndForwardError(request, response,
                        "Thời lượng diễn phải được nhập");
                return;
            }

            int duration;
            try {
                duration = Integer.parseInt(durationStr.trim());
            } catch (NumberFormatException e) {
                loadArtistsAndForwardError(request, response,
                        "Thời lượng diễn phải là số nguyên");
                return;
            }

            if (duration <= 60) {
                loadArtistsAndForwardError(request, response,
                        "Thời lượng diễn phải trên 60 phút");
                return;
            }

            /* ===== 4. TRẠNG THÁI ===== */
            if (status == null || status.trim().isEmpty()) {
                loadArtistsAndForwardError(request, response,
                        "Trạng thái vở diễn chưa được chọn");
                return;
            }

            /* ===== 5. NGHỆ SĨ ===== */
            if (artistIdStr == null || artistIdStr.trim().isEmpty()) {
                loadArtistsAndForwardError(request, response,
                        "Nghệ sĩ cho vở diễn chưa được chọn");
                return;
            }
            try {
                Integer artistId = Integer.parseInt(artistIdStr.trim());
                Artist artist = artistFacade.find(artistId);
                if (artist == null) {
                    loadArtistsAndForwardError(request, response,
                            "Nghệ sĩ cho vở diễn chưa được chọn");
                    return;
                }
                // Nếu sau này có quan hệ Show - Artist trực tiếp, có thể set vào entity ở đây.
            } catch (NumberFormatException ex) {
                loadArtistsAndForwardError(request, response,
                        "Nghệ sĩ cho vở diễn chưa được chọn");
                return;
            }

            /* ===== 6. HÌNH ẢNH VỞ DIỄN ===== */
            String finalImagePath = null;

            // Ưu tiên file upload
            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (IllegalStateException ex) {
                // không phải multipart hoặc lỗi kích thước
            }

            if (imagePart != null && imagePart.getSize() > 0) {
                String submittedFileName = imagePart.getSubmittedFileName();
                String fileName = Paths.get(submittedFileName).getFileName().toString();
                String lowerName = fileName.toLowerCase();

                if (!(lowerName.endsWith(".jpg")
                        || lowerName.endsWith(".jpeg")
                        || lowerName.endsWith(".png"))) {

                    loadArtistsAndForwardError(request, response,
                            "File bạn vừa thêm vào không đúng định dạng, hãy thêm lại file cho đúng định dạng như jpg hoặc png");
                    return;
                }

                // Lưu file vào thư mục assets/images/show
                String uploadDirPath = request.getServletContext()
                        .getRealPath("/assets/images/show");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File destFile = new File(uploadDir, fileName);
                imagePart.write(destFile.getAbsolutePath());

                finalImagePath = "assets/images/show/" + fileName;

            } else if (showImageDropdown != null && !showImageDropdown.trim().isEmpty()) {
                // nếu chọn từ dropdown
                finalImagePath = showImageDropdown.trim();
            } else if (showImageParam != null && !showImageParam.trim().isEmpty()) {
                // fallback: đường dẫn text
                finalImagePath = showImageParam.trim();
            }

            if (finalImagePath == null || finalImagePath.trim().isEmpty()) {
                loadArtistsAndForwardError(request, response,
                        "Hình ảnh cho vở diễn chưa được chọn");
                return;
            }

            /* ===== 7. TẠO SHOW ===== */
            Show newShow = new Show();
            newShow.setShowName(trimmedShowName);
            newShow.setDescription(trimmedDescription);
            newShow.setDurationMinutes(duration);
            newShow.setStatus(status.trim());
            newShow.setShowImage(finalImagePath);
            newShow.setCreatedAt(new Date());

            showFacade.create(newShow);

            response.sendRedirect(request.getContextPath()
                    + "/admin/show?success=Thêm show thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            loadArtistsAndForwardError(request, response,
                    "Lỗi khi thêm show: " + e.getMessage());
        }
    }

    /* ===================== UPDATE ===================== */
    /**
     * Cập nhật show. Nếu bất kỳ thông tin bắt buộc nào ở trang edit.jsp bị bỏ
     * trống hoặc không hợp lệ thì: - Không gọi showFacade.edit(show) - Quay lại
     * trang edit.jsp, hiển thị thông báo lỗi.
     */
    private void updateShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Show show = null;

        try {

            // 1. Lấy dữ liệu từ form
            String showName = request.getParameter("showName");
            String description = request.getParameter("description");
            String durationStr = request.getParameter("durationMinutes");
            String status = request.getParameter("status");
            String showImageParam = request.getParameter("showImage");
            String showImageDropdown = request.getParameter("showImageDropdown");
            String artistIdStr = request.getParameter("artistID");

            /* ===== 1. TÊN VỞ DIỄN ===== */
            String trimmedShowName = (showName != null) ? showName.trim() : "";
            if (trimmedShowName.isEmpty()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Tên vở diễn không được để trống");
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedShowName);

                if (numericVal < 0) {
                    loadArtistsAndForwardErrorEdit(request, response, show,
                            "Tên vở diễn không được chứa số âm");
                    return;
                }

                if (trimmedShowName.contains(".") || trimmedShowName.contains(",")) {
                    loadArtistsAndForwardErrorEdit(request, response, show,
                            "Tên vở diễn không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ignore) {
                // không phải chuỗi số thuần
            }

            if (!NO_SPECIAL_PATTERN.matcher(trimmedShowName).matches()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Tên vở diễn không được chứa ký tự đặc biệt");
                return;
            }

            /* ===== 2. MÔ TẢ VỞ DIỄN ===== */
            String trimmedDescription = (description != null) ? description.trim() : "";
            if (trimmedDescription.isEmpty()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Mô tả không được để trống");
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedDescription);

                if (numericVal < 0) {
                    loadArtistsAndForwardErrorEdit(request, response, show,
                            "Mô tả vở diễn không được chứa số âm");
                    return;
                }

                if (trimmedDescription.contains(".") || trimmedDescription.contains(",")) {
                    loadArtistsAndForwardErrorEdit(request, response, show,
                            "Mô tả vở diễn không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ignore) {
                // không phải chuỗi số thuần
            }

            if (!NO_SPECIAL_PATTERN.matcher(trimmedDescription).matches()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Mô tả không được chứa ký tự đặc biệt");
                return;
            }

            /* ===== 3. THỜI LƯỢNG ===== */
            if (durationStr == null || durationStr.trim().isEmpty()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Thời lượng diễn chưa được nhập");
                return;
            }

            int duration;
            try {
                duration = Integer.parseInt(durationStr.trim());
            } catch (NumberFormatException e) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Thời lượng diễn phải là số nguyên");
                return;
            }

            if (duration <= 60) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Thời lượng diễn phải trên 60 phút");
                return;
            }

            /* ===== 4. TRẠNG THÁI ===== */
            if (status == null || status.trim().isEmpty()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Trạng thái vở diễn chưa được chọn");
                return;
            }

            /* ===== 5. NGHỆ SĨ ===== */
            if (artistIdStr == null || artistIdStr.trim().isEmpty()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Nghệ sĩ cho vở diễn chưa được chọn");
                return;
            }
            try {
                Integer artistId = Integer.parseInt(artistIdStr.trim());
                Artist artist = artistFacade.find(artistId);
                if (artist == null) {
                    loadArtistsAndForwardErrorEdit(request, response, show,
                            "Nghệ sĩ cho vở diễn chưa được chọn");
                    return;
                }
                // nếu có quan hệ Show-Artist thì set ở đây
                // show.setArtist(artist);
            } catch (NumberFormatException ex) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Nghệ sĩ cho vở diễn chưa được chọn");
                return;
            }

            /* ===== 6. HÌNH ẢNH VỞ DIỄN ===== */
            String finalImagePath = null; // KHÔNG lấy sẵn hình cũ nữa

            Part imagePart = null;
            try {
                imagePart = request.getPart("imageFile");
            } catch (IllegalStateException ex) {
                // không phải multipart hoặc lỗi kích thước, bỏ qua
            }

            // 6.1. Nếu upload file mới
            if (imagePart != null && imagePart.getSize() > 0) {
                String submittedFileName = imagePart.getSubmittedFileName();
                String fileName = Paths.get(submittedFileName).getFileName().toString();
                String lowerName = fileName.toLowerCase();

                if (!(lowerName.endsWith(".jpg")
                        || lowerName.endsWith(".jpeg")
                        || lowerName.endsWith(".png"))) {

                    loadArtistsAndForwardErrorEdit(request, response, show,
                            "File bạn vừa thêm vào không đúng định dạng, hãy thêm lại file cho đúng định dạng như jpg hoặc png");
                    return;
                }

                String uploadDirPath = request.getServletContext()
                        .getRealPath("/assets/images/show");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                File destFile = new File(uploadDir, fileName);
                imagePart.write(destFile.getAbsolutePath());

                finalImagePath = "assets/images/show/" + fileName;

                // 6.2. Nếu chọn từ dropdown thư mục
            } else if (showImageDropdown != null && !showImageDropdown.trim().isEmpty()) {
                finalImagePath = showImageDropdown.trim();

                // 6.3. Nếu có input ẩn/hidden giữ đường dẫn
            } else if (showImageParam != null && !showImageParam.trim().isEmpty()) {
                finalImagePath = showImageParam.trim();
            }

            // 6.4. Bắt buộc phải chọn/nhập hình
            if (finalImagePath == null || finalImagePath.trim().isEmpty()) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "Hình ảnh cho vở diễn chưa được chọn");
                return; // KHÔNG cập nhật show
            }

            /* ===== 7. CẬP NHẬT SHOW ===== */
            show.setShowName(trimmedShowName);
            show.setDescription(trimmedDescription);
            show.setDurationMinutes(duration);
            show.setStatus(status.trim());
            show.setShowImage(finalImagePath);

            showFacade.edit(show);

            response.sendRedirect(request.getContextPath()
                    + "/admin/show?success=Cập nhật show thành công!");

        } catch (NumberFormatException e) {
            if (show != null) {
                loadArtistsAndForwardErrorEdit(request, response, show,
                        "ID hoặc thời lượng không hợp lệ.");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/show?error=Dữ liệu không hợp lệ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/show?error=Lỗi: " + e.getMessage());
        }
    }

    /* ===================== DELETE ===================== */
    private void deleteShow(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/show?error=ID không hợp lệ");
            return;
        }

        try {
            Integer showId = Integer.parseInt(idParam);
            Show show = showFacade.find(showId);
            if (show == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/show?error=Không tìm thấy show");
                return;
            }

            showFacade.remove(show);

            response.sendRedirect(request.getContextPath()
                    + "/admin/show?success=Xóa show thành công!");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/show?error=ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/show?error=Lỗi: " + e.getMessage());
        }
    }

    /* ===================== HELPER: LOAD IMAGE FILES ===================== */
    /**
     * Đọc tất cả file .jpg/.jpeg/.png trong thư mục assets/images/show và trả
     * về đường dẫn tương đối "assets/images/show/ten_file".
     */
    private List<String> loadImageFiles(HttpServletRequest request) {
        List<String> imageFiles = new ArrayList<>();

        try {
            String imagesDirPath = request.getServletContext()
                    .getRealPath("/assets/images/show");
            if (imagesDirPath == null) {
                return imageFiles;
            }

            File imagesDir = new File(imagesDirPath);
            if (imagesDir.exists() && imagesDir.isDirectory()) {
                File[] files = imagesDir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        String name = f.getName().toLowerCase();
                        if (name.endsWith(".jpg") || name.endsWith(".jpeg")  || name.endsWith(".png")) {

                            imageFiles.add("assets/images/show/" + f.getName());
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return imageFiles;
    }

    /* ===================== HELPER: FORWARD LỖI ADD/EDIT ===================== */
    private void loadArtistsAndForwardError(HttpServletRequest request,
            HttpServletResponse response,
            String errorMessage)
            throws ServletException, IOException {

        // Load lại danh sách nghệ sĩ
        List<Artist> artists = artistFacade.findAll();
        request.setAttribute("artists", artists);

        // Load lại danh sách file ảnh
        List<String> imageFiles = loadImageFiles(request);
        request.setAttribute("imageFiles", imageFiles);

        // Thông báo tổng cho trang add.jsp
        request.setAttribute("globalMessage",
                "Vui lòng điền và chọn các thông tin cho vở diễn");

        // Thông báo lỗi cụ thể
        request.setAttribute("error", errorMessage);

        // Quay lại trang thêm show
        request.getRequestDispatcher("/WEB-INF/views/admin/show/add.jsp")
                .forward(request, response);
    }

    private void loadArtistsAndForwardErrorEdit(HttpServletRequest request,
            HttpServletResponse response,
            Show show,
            String errorMessage)
            throws ServletException, IOException {

        // Load lại danh sách nghệ sĩ
        List<Artist> artists = artistFacade.findAll();
        request.setAttribute("artists", artists);

        // Load lại danh sách file ảnh
        List<String> imageFiles = loadImageFiles(request);
        request.setAttribute("imageFiles", imageFiles);

        // Gửi lại show hiện tại (đã lấy từ DB)
        request.setAttribute("show", show);

        // Thông báo tổng cho trang edit.jsp
        request.setAttribute("globalMessage",
                "Vui lòng chỉnh sửa và kiểm tra lại các thông tin cho vở diễn");

        // Thông báo lỗi cụ thể
        request.setAttribute("error", errorMessage);

        // Quay lại trang edit.jsp
        request.getRequestDispatcher("/WEB-INF/views/admin/show/edit.jsp")
                .forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Show Management Servlet for Admin";
    }
}
