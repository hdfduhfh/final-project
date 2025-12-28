package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import mypack.Order1;
import mypack.Promotion;
import mypack.PromotionFacadeLocal;

@WebServlet(name = "PromotionManagementServlet", urlPatterns = {"/admin/promotions"})
public class PromotionManagementServlet extends HttpServlet {

    @EJB
    private PromotionFacadeLocal promotionFacade;

    private static final String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deletePromotion(request, response);
                break;
            case "usage":
                // ✅ THÊM ACTION MỚI - Trả về JSON
                getUsageData(request, response);
                break;
            default:
                listPromotions(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            insertPromotion(request, response);
        } else if ("update".equals(action)) {
            updatePromotion(request, response);
        } else {
            listPromotions(request, response);
        }
    }

    // ===================== LIST =====================
    private void listPromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Promotion> promotions = promotionFacade.findAll();
        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("/WEB-INF/views/admin/promotions/list.jsp").forward(request, response);
    }

    // ===================== SHOW FORMS =====================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/promotions/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Promotion existingPromo = promotionFacade.find(id);

            if (existingPromo == null) {
                response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=notfound");
                return;
            }

            request.setAttribute("promotion", existingPromo);

            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
            if (existingPromo.getStartDate() != null) {
                request.setAttribute("formattedStartDate", sdf.format(existingPromo.getStartDate()));
            }
            if (existingPromo.getEndDate() != null) {
                request.setAttribute("formattedEndDate", sdf.format(existingPromo.getEndDate()));
            }

            request.getRequestDispatcher("/WEB-INF/views/admin/promotions/edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        }
    }

    // ===================== DELETE =====================
    private void deletePromotion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Promotion p = promotionFacade.find(id);
            if (p != null) {
                promotionFacade.remove(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=deleted");
    }

    // ===================== ✅ API: GET USAGE DATA (KHÔNG DÙNG GSON) =====================
    private void getUsageData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String promotionIdStr = request.getParameter("id");
        
        if (promotionIdStr == null || promotionIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing promotion ID\"}");
            return;
        }
        
        try {
            int promotionId = Integer.parseInt(promotionIdStr);
            Promotion promotion = promotionFacade.find(promotionId);
            
            if (promotion == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Promotion not found\"}");
                return;
            }
            
            // ===== TẠO JSON BẰTAY BẰNG StringBuilder =====
            StringBuilder json = new StringBuilder();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            json.append("{");
            json.append("\"success\": true,");
            
            // Đếm số lượng
            int count = (promotion.getOrder1Collection() != null) 
                ? promotion.getOrder1Collection().size() 
                : 0;
            json.append("\"total\": ").append(count).append(",");
            
            // Mảng usages
            json.append("\"usages\": [");
            
            if (promotion.getOrder1Collection() != null && !promotion.getOrder1Collection().isEmpty()) {
                int index = 0;
                for (Order1 order : promotion.getOrder1Collection()) {
                    if (index > 0) {
                        json.append(",");
                    }
                    
                    json.append("{");
                    
                    // Thông tin khách hàng
                    json.append("\"userName\": \"")
                        .append(escapeJson(order.getUserID().getFullName()))
                        .append("\",");
                    json.append("\"userEmail\": \"")
                        .append(escapeJson(order.getUserID().getEmail()))
                        .append("\",");
                    
                    // Thông tin đơn hàng
                    json.append("\"orderId\": ")
                        .append(order.getOrderID())
                        .append(",");
                    json.append("\"createdAt\": \"")
                        .append(escapeJson(sdf.format(order.getCreatedAt())))
                        .append("\",");
                    json.append("\"status\": \"")
                        .append(escapeJson(order.getStatus()))
                        .append("\",");
                    
                    // Thông tin giảm giá
                    String discountAmount = (order.getDiscountAmount() != null) 
                        ? order.getDiscountAmount().toString() 
                        : "0";
                    String finalAmount = (order.getFinalAmount() != null) 
                        ? order.getFinalAmount().toString() 
                        : "0";
                    
                    json.append("\"discountAmount\": \"")
                        .append(escapeJson(discountAmount))
                        .append("\",");
                    json.append("\"finalAmount\": \"")
                        .append(escapeJson(finalAmount))
                        .append("\"");
                    
                    json.append("}");
                    index++;
                }
            }
            
            json.append("]");
            json.append("}");
            
            // Trả về JSON
            response.getWriter().write(json.toString());
            
            System.out.println("✅ API Usage called for Promotion #" + promotionId);
            System.out.println("   Total usages: " + count);
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid promotion ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
    
    /**
     * ✅ HELPER: Escape ký tự đặc biệt trong JSON
     */
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")   // Backslash
                  .replace("\"", "\\\"")   // Double quote
                  .replace("\n", "\\n")    // Newline
                  .replace("\r", "\\r")    // Carriage return
                  .replace("\t", "\\t");   // Tab
    }

    // ===================== INSERT & UPDATE LOGIC =====================
    private void insertPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = validateInput(request);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            keepOldInputData(request);
            request.getRequestDispatcher("/WEB-INF/views/admin/promotions/add.jsp").forward(request, response);
            return;
        }

        try {
            Promotion p = new Promotion();
            populatePromotionFromRequest(p, request);
            promotionFacade.create(p);
            response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=created");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    private void updatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = validateInput(request);
        String idStr = request.getParameter("id");

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            keepOldInputData(request);

            if (idStr != null) {
                Promotion p = promotionFacade.find(Integer.parseInt(idStr));
                request.setAttribute("promotion", p);
            }

            request.getRequestDispatcher("/WEB-INF/views/admin/promotions/edit.jsp").forward(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Promotion p = promotionFacade.find(id);
            if (p != null) {
                populatePromotionFromRequest(p, request);
                promotionFacade.edit(p);
            }
            response.sendRedirect(request.getContextPath() + "/admin/promotions?msg=updated");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cập nhật: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
        }
    }

    // ===================== VALIDATION =====================
    private List<String> validateInput(HttpServletRequest request) {
        List<String> errors = new ArrayList<>();

        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String type = request.getParameter("discountType");
        String valStr = request.getParameter("discountValue");
        String startStr = request.getParameter("startDate");
        String endStr = request.getParameter("endDate");

        if (name == null || name.trim().isEmpty()) {
            errors.add("Tên khuyến mãi không được để trống.");
        }
        if (code == null || code.trim().isEmpty()) {
            errors.add("Mã code không được để trống.");
        }

        try {
            BigDecimal val = new BigDecimal(valStr);
            if (val.compareTo(BigDecimal.ZERO) < 0) {
                errors.add("Giá trị giảm không được là số âm.");
            }
            if ("PERCENT".equals(type) && val.compareTo(new BigDecimal("100")) > 0) {
                errors.add("Giảm giá theo phần trăm (%) không được vượt quá 100.");
            }
        } catch (Exception e) {
            errors.add("Giá trị giảm phải là số hợp lệ.");
        }

        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        try {
            Date start = sdf.parse(startStr);
            Date end = sdf.parse(endStr);
            if (end.before(start)) {
                errors.add("Ngày kết thúc không được diễn ra trước ngày bắt đầu.");
            }
        } catch (ParseException e) {
            errors.add("Định dạng ngày tháng không hợp lệ.");
        }

        checkPositiveNumber(request.getParameter("minOrderAmount"), "Đơn hàng tối thiểu", errors);
        checkPositiveNumber(request.getParameter("maxDiscount"), "Giảm tối đa", errors);
        checkPositiveInteger(request.getParameter("maxUsage"), "Số lượt dùng tối đa", errors);

        return errors;
    }

    private void checkPositiveNumber(String numStr, String fieldName, List<String> errors) {
        if (numStr != null && !numStr.isEmpty()) {
            try {
                BigDecimal val = new BigDecimal(numStr);
                if (val.compareTo(BigDecimal.ZERO) < 0) {
                    errors.add(fieldName + " không được âm.");
                }
            } catch (Exception e) {
                errors.add(fieldName + " phải là số.");
            }
        }
    }

    private void checkPositiveInteger(String numStr, String fieldName, List<String> errors) {
        if (numStr != null && !numStr.isEmpty()) {
            try {
                int val = Integer.parseInt(numStr);
                if (val < 0) {
                    errors.add(fieldName + " không được âm.");
                }
            } catch (Exception e) {
                errors.add(fieldName + " phải là số nguyên.");
            }
        }
    }

    // ===================== HELPERS =====================
    private void populatePromotionFromRequest(Promotion p, HttpServletRequest request) throws ParseException {
        p.setName(request.getParameter("name"));
        p.setCode(request.getParameter("code").toUpperCase());
        p.setDiscountType(request.getParameter("discountType"));
        p.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));

        String minOrder = request.getParameter("minOrderAmount");
        if (minOrder != null && !minOrder.isEmpty()) {
            p.setMinOrderAmount(new BigDecimal(minOrder));
        } else {
            p.setMinOrderAmount(null);
        }

        String maxDisc = request.getParameter("maxDiscount");
        if (maxDisc != null && !maxDisc.isEmpty()) {
            p.setMaxDiscount(new BigDecimal(maxDisc));
        } else {
            p.setMaxDiscount(null);
        }

        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        p.setStartDate(sdf.parse(request.getParameter("startDate")));
        p.setEndDate(sdf.parse(request.getParameter("endDate")));
        p.setStatus(request.getParameter("status"));

        String maxUsage = request.getParameter("maxUsage");
        if (maxUsage != null && !maxUsage.isEmpty()) {
            p.setMaxUsage(Integer.parseInt(maxUsage));
        }

        String maxPerUser = request.getParameter("maxUsagePerUser");
        if (maxPerUser != null && !maxPerUser.isEmpty()) {
            p.setMaxUsagePerUser(Integer.parseInt(maxPerUser));
        }
    }

    private void keepOldInputData(HttpServletRequest request) {
        request.setAttribute("oldName", request.getParameter("name"));
        request.setAttribute("oldCode", request.getParameter("code"));
        request.setAttribute("oldType", request.getParameter("discountType"));
        request.setAttribute("oldValue", request.getParameter("discountValue"));
        request.setAttribute("oldMinOrder", request.getParameter("minOrderAmount"));
        request.setAttribute("oldMaxDiscount", request.getParameter("maxDiscount"));
        request.setAttribute("oldStartDate", request.getParameter("startDate"));
        request.setAttribute("oldEndDate", request.getParameter("endDate"));
        request.setAttribute("oldStatus", request.getParameter("status"));
        request.setAttribute("oldMaxUsage", request.getParameter("maxUsage"));
        request.setAttribute("oldMaxPerUser", request.getParameter("maxUsagePerUser"));
    }
}