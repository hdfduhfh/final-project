/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import mypack.Artist;
import mypack.ArtistFacadeLocal;

import java.io.IOException;
import java.io.File;
import java.net.URLEncoder;
import java.util.List;
import java.util.ArrayList;
import java.util.regex.Pattern;

@WebServlet(name = "ArtistManagementServlet", urlPatterns = {
    "/admin/artist",
    "/admin/artist/add",
    "/admin/artist/edit",
    "/admin/artist/delete"
})
public class ArtistManagementServlet extends HttpServlet {

    @EJB
    private ArtistFacadeLocal artistFacade;

    // Không cho ký tự đặc biệt: chỉ cho chữ (kể cả tiếng Việt), số và khoảng trắng
    private static final Pattern NO_SPECIAL_PATTERN
            = Pattern.compile("^[\\p{L}\\d\\s]+$");

    // ✅ helper: trim + lowercase an toàn
    private String safeLower(String s) {
        return (s == null) ? "" : s.trim().toLowerCase();
    }

    // ✅ NEW: helper encode UTF-8 cho URL
    private String urlEncodeUtf8(String s) {
        try {
            return URLEncoder.encode(s, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }

    // ✅ helper: check trùng name (không phân biệt hoa/thường) và trùng poster
    // excludeId: dùng cho edit (để không tự trùng chính nó). Khi add thì truyền null.
    private String checkDuplicateArtist(String inputName, String inputImage, Integer excludeId) {
        String nameLower = safeLower(inputName);
        String imgLower = safeLower(inputImage);

        List<Artist> all = (artistFacade != null) ? artistFacade.findAll() : null;
        if (all == null) {
            return null;
        }

        for (Artist a : all) {
            if (a == null) {
                continue;
            }
            if (excludeId != null && a.getArtistID() != null && a.getArtistID().equals(excludeId)) {
                continue; // bỏ qua chính nó khi edit
            }

            // trùng tên (case-insensitive)
            if (!nameLower.isEmpty() && safeLower(a.getName()).equals(nameLower)) {
                return "Tên nghệ sĩ bạn vừa nhập không được trùng với tên nghệ sĩ bạn đã tạo";
            }

            // trùng poster (case-insensitive)
            if (!imgLower.isEmpty() && safeLower(a.getArtistImage()).equals(imgLower)) {
                return "Poster nghệ sĩ bạn chọn không được chọn trùng với poster nghệ sĩ bạn đã tạo";
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ==== UTF-8 cho tất cả các trang GET (list, add, edit) ====
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/admin/artist":
                showList(request, response);
                break;
            case "/admin/artist/add":
                showAddForm(request, response);
                break;
            case "/admin/artist/edit":
                showEditForm(request, response);
                break;
            case "/admin/artist/delete":
                deleteArtist(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ==== UTF-8 cho tất cả request POST (add, edit) ====
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/admin/artist/add":
                createArtist(request, response);
                break;
            case "/admin/artist/edit":
                updateArtist(request, response);
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

            // ========= PAGINATION CONFIG =========
            final int pageSize = 6; // ✅ 6 artists / page
            int page = 1;

            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.trim().isEmpty()) {
                    page = Integer.parseInt(pageStr.trim());
                }
            } catch (Exception ignored) {}

            if (page < 1) page = 1;

            List<Artist> artists;
            int totalArtists = artistFacade.count(); // tổng toàn bộ
            int totalPages = (int) Math.ceil(totalArtists / (double) pageSize);

            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            int start = (page - 1) * pageSize;

            // ========= SEARCH =========
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Nếu đang search -> hiện toàn bộ kết quả search (chưa phân trang)
                artists = artistFacade.searchByKeyword(searchKeyword.trim());

                // Khi search, totalArtists nên là số kết quả search để UI đúng
                totalArtists = (artists != null) ? artists.size() : 0;
                totalPages = 1; // tạm thời 1 trang
                page = 1;

            } else {
                // ✅ Không search -> phân trang DB
                artists = artistFacade.findRange(start, pageSize);
            }

            request.setAttribute("artists", artists);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("totalArtists", totalArtists);

            // ✅ data phân trang
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);

            request.getRequestDispatcher("/WEB-INF/views/admin/artist/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách nghệ sĩ: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/artist/list.jsp")
                    .forward(request, response);
        }
    }

    /* ===================== ADD FORM ===================== */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nạp danh sách file ảnh cho dropdown hình nghệ sĩ
        List<String> imageFiles = loadImageFiles(request);
        request.setAttribute("imageFiles", imageFiles);

        request.getRequestDispatcher("/WEB-INF/views/admin/artist/add.jsp")
                .forward(request, response);
    }

    /* ========== HELPER: FORWARD LỖI ADD (có globalMessage + dropdown) ========== */
    private void forwardAddError(HttpServletRequest request,
            HttpServletResponse response,
            String errorMessage)
            throws ServletException, IOException {

        request.setAttribute("globalMessage", "Vui lòng điền và chọn các thông tin cho nghệ sĩ");
        request.setAttribute("error", errorMessage);

        // luôn nạp lại danh sách hình cho dropdown
        List<String> imageFiles = loadImageFiles(request);
        request.setAttribute("imageFiles", imageFiles);

        request.getRequestDispatcher("/WEB-INF/views/admin/artist/add.jsp")
                .forward(request, response);
    }

    /* ===================== CREATE (ADD) ===================== */
    private void createArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String role = request.getParameter("role");
        String bio = request.getParameter("bio");
        String artistImage = request.getParameter("artistImage");

        try {
            String trimmedName = (name != null) ? name.trim() : "";
            String trimmedRole = (role != null) ? role.trim() : "";
            String trimmedBio = (bio != null) ? bio.trim() : "";
            String trimmedImage = (artistImage != null) ? artistImage.trim() : "";

            /* ===== 1. TÊN NGHỆ SĨ ===== */
            if (trimmedName.isEmpty()) {
                forwardAddError(request, response, "Tên nghệ sĩ không được để trống");
                return;
            }

            // Ràng buộc kiểu số cho tên nghệ sĩ (chỉ cho phép số nguyên dương nếu toàn số)
            try {
                double numericVal = Double.parseDouble(trimmedName);

                if (numericVal < 0) {
                    forwardAddError(request, response, "Tên nghệ sĩ không được chứa số âm");
                    return;
                }

                if (trimmedName.contains(".") || trimmedName.contains(",")) {
                    forwardAddError(request, response, "Tên nghệ sĩ không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ex) {
                // không phải chuỗi số thuần, bỏ qua ràng buộc số
            }

            // Ràng buộc ký tự đặc biệt cho tên nghệ sĩ
            if (!NO_SPECIAL_PATTERN.matcher(trimmedName).matches()) {
                forwardAddError(request, response, "Tên nghệ sĩ không được chứa kí tự đặc biệt");
                return;
            }

            /* ===== 2. VAI TRÒ NGHỆ SĨ ===== */
            if (trimmedRole.isEmpty()) {
                forwardAddError(request, response, "Vai trò nghệ sĩ không được để trống");
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedRole);

                if (numericVal < 0) {
                    forwardAddError(request, response, "Vai trò của nghệ sĩ không được chứa số âm");
                    return;
                }

                if (trimmedRole.contains(".") || trimmedRole.contains(",")) {
                    forwardAddError(request, response, "Vai trò của nghệ sĩ không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ex) {}

            if (!NO_SPECIAL_PATTERN.matcher(trimmedRole).matches()) {
                forwardAddError(request, response, "Vai trò nghệ sĩ không được chứa kí tự đặc biệt");
                return;
            }

            /* ===== 3. TIỂU SỬ NGHỆ SĨ ===== */
            if (trimmedBio.isEmpty()) {
                forwardAddError(request, response, "Tiểu sử của nghệ sĩ không được để trống");
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedBio);

                if (numericVal < 0) {
                    forwardAddError(request, response, "Tiểu sử của nghệ sĩ không được chứa số âm");
                    return;
                }

                if (trimmedBio.contains(".") || trimmedBio.contains(",")) {
                    forwardAddError(request, response, "Tiểu sử của nghệ sĩ không được chứa số thập phân");
                    return;
                }
            } catch (NumberFormatException ex) {}

            if (!NO_SPECIAL_PATTERN.matcher(trimmedBio).matches()) {
                forwardAddError(request, response, "Tiểu sử của nghệ sĩ không được chứa kí tự đặc biệt");
                return;
            }

            /* ===== 4. HÌNH ẢNH NGHỆ SĨ ===== */
            if (trimmedImage.isEmpty()) {
                forwardAddError(request, response, "Hình ảnh cho nghệ sĩ chưa được chọn");
                return;
            }

            String lowerImg = trimmedImage.toLowerCase();
            if (!(lowerImg.endsWith(".jpg") || lowerImg.endsWith(".png") || lowerImg.endsWith(".jpeg"))) {
                forwardAddError(request, response,
                        "File bạn vừa tải lên không đúng định dạng, vui lòng tải lên lại file có định dạng jpg và png");
                return;
            }

            // ✅ RÀNG BUỘC KHÔNG ĐƯỢC TRÙNG TÊN & POSTER
            String dupErr = checkDuplicateArtist(trimmedName, trimmedImage, null);
            if (dupErr != null) {
                forwardAddError(request, response, dupErr);
                return;
            }

            /* ===== 5. TẠO NGHỆ SĨ ===== */
            Artist artist = new Artist();
            artist.setName(trimmedName);
            artist.setRole(trimmedRole);
            artist.setBio(trimmedBio);
            artist.setArtistImage(trimmedImage);

            artistFacade.create(artist);

            String message = urlEncodeUtf8("Thêm nghệ sĩ thành công!");
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?success=" + message
                    + "&v=" + System.currentTimeMillis());

        } catch (Exception e) {
            e.printStackTrace();
            forwardAddError(request, response, "Lỗi khi tạo nghệ sĩ: " + e.getMessage());
        }
    }

    /* ===================== EDIT FORM ===================== */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("Thiếu ID nghệ sĩ"));
            return;
        }

        try {
            Integer id = Integer.valueOf(idStr);
            Artist artist = artistFacade.find(id);

            if (artist == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/artist?error=" + urlEncodeUtf8("Không tìm thấy nghệ sĩ"));
                return;
            }

            request.setAttribute("artist", artist);

            List<String> imageFiles = loadImageFiles(request);
            request.setAttribute("imageFiles", imageFiles);

            request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("ID không hợp lệ"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("Lỗi khi tải form sửa: " + e.getMessage()));
        }
    }

    /* ===================== UPDATE ===================== */
    private void updateArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("artistID");

        try {
            Integer id = Integer.valueOf(idStr);
            Artist artist = artistFacade.find(id);

            if (artist == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/artist?error=" + urlEncodeUtf8("Không tìm thấy nghệ sĩ"));
                return;
            }

            String name = request.getParameter("name");
            String role = request.getParameter("role");
            String bio = request.getParameter("bio");
            String artistImage = request.getParameter("artistImage");

            String trimmedName = (name != null) ? name.trim() : "";
            String trimmedRole = (role != null) ? role.trim() : "";
            String trimmedBio = (bio != null) ? bio.trim() : "";
            String trimmedImage = (artistImage != null) ? artistImage.trim() : "";

            /* ===== VALIDATION (giữ nguyên logic của bạn) ===== */
            if (trimmedName.isEmpty()) {
                request.setAttribute("error", "Tên nghệ sĩ không được để trống");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedName);

                if (numericVal < 0) {
                    request.setAttribute("error", "Tên nghệ sĩ không được chứa số âm");
                    request.setAttribute("artist", artist);
                    request.setAttribute("imageFiles", loadImageFiles(request));
                    request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                    return;
                }

                if (trimmedName.contains(".") || trimmedName.contains(",")) {
                    request.setAttribute("error", "Tên nghệ sĩ không được chứa số thập phân");
                    request.setAttribute("artist", artist);
                    request.setAttribute("imageFiles", loadImageFiles(request));
                    request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException ex) {}

            if (!NO_SPECIAL_PATTERN.matcher(trimmedName).matches()) {
                request.setAttribute("error", "Tên nghệ sĩ không được chứa kí tự đặc biệt");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            if (trimmedRole.isEmpty()) {
                request.setAttribute("error", "Vai trò nghệ sĩ không được để trống");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedRole);

                if (numericVal < 0) {
                    request.setAttribute("error", "Vai trò của nghệ sĩ không được chứa số âm");
                    request.setAttribute("artist", artist);
                    request.setAttribute("imageFiles", loadImageFiles(request));
                    request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                    return;
                }

                if (trimmedRole.contains(".") || trimmedRole.contains(",")) {
                    request.setAttribute("error", "Vai trò của nghệ sĩ không được chứa số thập phân");
                    request.setAttribute("artist", artist);
                    request.setAttribute("imageFiles", loadImageFiles(request));
                    request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException ex) {}

            if (!NO_SPECIAL_PATTERN.matcher(trimmedRole).matches()) {
                request.setAttribute("error", "Vai trò nghệ sĩ không được chứa kí tự đặc biệt");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            if (trimmedBio.isEmpty()) {
                request.setAttribute("error", "Tiểu sử của nghệ sĩ không được để trống");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            try {
                double numericVal = Double.parseDouble(trimmedBio);

                if (numericVal < 0) {
                    request.setAttribute("error", "Tiểu sử của nghệ sĩ không được chứa số âm");
                    request.setAttribute("artist", artist);
                    request.setAttribute("imageFiles", loadImageFiles(request));
                    request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                    return;
                }

                if (trimmedBio.contains(".") || trimmedBio.contains(",")) {
                    request.setAttribute("error", "Tiểu sử của nghệ sĩ không được chứa số thập phân");
                    request.setAttribute("artist", artist);
                    request.setAttribute("imageFiles", loadImageFiles(request));
                    request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException ex) {}

            if (!NO_SPECIAL_PATTERN.matcher(trimmedBio).matches()) {
                request.setAttribute("error", "Tiểu sử của nghệ sĩ không được chứa kí tự đặc biệt");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            if (trimmedImage.isEmpty()) {
                request.setAttribute("error", "Hình ảnh cho nghệ sĩ chưa được chọn");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            String lowerImg = trimmedImage.toLowerCase();
            if (!(lowerImg.endsWith(".jpg") || lowerImg.endsWith(".png") || lowerImg.endsWith(".jpeg"))) {
                request.setAttribute("error", "File bạn vừa tải lên không đúng định dạng, vui lòng tải lên lại file có định dạng jpg và png");
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            // ✅ RÀNG BUỘC KHÔNG ĐƯỢC TRÙNG TÊN & POSTER (trừ chính nó)
            String dupErr = checkDuplicateArtist(trimmedName, trimmedImage, artist.getArtistID());
            if (dupErr != null) {
                request.setAttribute("error", dupErr);
                request.setAttribute("artist", artist);
                request.setAttribute("imageFiles", loadImageFiles(request));
                request.getRequestDispatcher("/WEB-INF/views/admin/artist/edit.jsp").forward(request, response);
                return;
            }

            /* ===== UPDATE ===== */
            artist.setName(trimmedName);
            artist.setRole(trimmedRole);
            artist.setBio(trimmedBio);
            artist.setArtistImage(trimmedImage);

            artistFacade.edit(artist);

            // ✅ FIX UTF-8 redirect message
            String msg = urlEncodeUtf8("Cập nhật nghệ sĩ thành công!");
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?success=" + msg
                    + "&v=" + System.currentTimeMillis());

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("ID không hợp lệ"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("Lỗi khi cập nhật: " + e.getMessage()));
        }
    }

    /* ===================== DELETE ===================== */
    private void deleteArtist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id");

        if (idStr == null) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("Thiếu ID nghệ sĩ"));
            return;
        }

        try {
            Integer id = Integer.valueOf(idStr);
            Artist artist = artistFacade.find(id);

            if (artist == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/artist?error=" + urlEncodeUtf8("Không tìm thấy nghệ sĩ"));
                return;
            }

            artistFacade.remove(artist);

            // ✅ FIX UTF-8 redirect message
            String msg = urlEncodeUtf8("Xóa nghệ sĩ thành công!");
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?success=" + msg
                    + "&v=" + System.currentTimeMillis());

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("ID không hợp lệ"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/admin/artist?error=" + urlEncodeUtf8("Lỗi khi xóa: " + e.getMessage()));
        }
    }

    /* ===================== HELPER: LOAD IMAGE FILES ===================== */
    private List<String> loadImageFiles(HttpServletRequest request) {
        List<String> imageFiles = new ArrayList<>();

        try {
            String imagesDirPath = request.getServletContext().getRealPath("assets/images/artist");
            if (imagesDirPath == null) {
                return imageFiles;
            }

            File imagesDir = new File(imagesDirPath);

            if (imagesDir.exists() && imagesDir.isDirectory()) {
                File[] files = imagesDir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        String name = f.getName().toLowerCase();
                        if (name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png")) {
                            imageFiles.add("assets/images/artist/" + f.getName());
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return imageFiles;
    }

    @Override
    public String getServletInfo() {
        return "Artist Management Servlet for Admin";
    }
}
