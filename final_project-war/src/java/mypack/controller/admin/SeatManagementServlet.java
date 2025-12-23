package mypack.controller.admin;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import mypack.Seat;
import mypack.SeatFacadeLocal;

@WebServlet(name = "SeatManagementServlet", urlPatterns = {"/admin/seats"})
public class SeatManagementServlet extends HttpServlet {

    @EJB
    private SeatFacadeLocal seatFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/seats/add.jsp")
                    .forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("seat", seatFacade.find(id));
            request.getRequestDispatcher("/WEB-INF/views/admin/seats/edit.jsp")
                    .forward(request, response);
            return;
        }

        // -------------------------------------------------------------
        // 🔴 UPDATE PHẦN DELETE: KIỂM TRA TRƯỚC KHI XÓA
        // -------------------------------------------------------------
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Seat seat = seatFacade.find(id);
                
                if (seat != null) {
                    // Kiểm tra xem ghế này đã có trong đơn hàng nào chưa
                    // (Sử dụng Collection OrderDetail có sẵn trong Entity Seat)
                    boolean hasOrders = seat.getOrderDetailCollection() != null && !seat.getOrderDetailCollection().isEmpty();
                    
                    if (hasOrders) {
                        // Nếu đã có đơn hàng -> Không cho xóa -> Báo lỗi
                        response.sendRedirect(request.getContextPath() + "/admin/seats?error=CannotDeleteBookedSeat");
                        return;
                    } else {
                        // Nếu chưa có đơn hàng -> Xóa thoải mái
                        seatFacade.remove(seat);
                        response.sendRedirect(request.getContextPath() + "/admin/seats?success=deleted");
                        return;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace(); // Log lỗi server để debug
                response.sendRedirect(request.getContextPath() + "/admin/seats?error=SystemError");
                return;
            }
        }
        // -------------------------------------------------------------

        // DEFAULT: LIST
        List<Seat> allSeats = seatFacade.findAll();
        request.setAttribute("seats", allSeats);

        // Đếm số ghế VIP và NORMAL
        long vipCount = allSeats.stream().filter(s -> "VIP".equals(s.getSeatType())).count();
        long normalCount = allSeats.stream().filter(s -> "NORMAL".equals(s.getSeatType())).count();

        request.setAttribute("vipCount", vipCount);
        request.setAttribute("normalCount", normalCount);
        
        // Nhận thông báo lỗi từ URL (nếu có)
        String error = request.getParameter("error");
        if ("CannotDeleteBookedSeat".equals(error)) {
            request.setAttribute("error", "Không thể xóa ghế này vì đã có lịch sử đặt vé! Bạn chỉ có thể Vô hiệu hóa nó.");
        } else if ("CannotDisableBookedSeat".equals(error)) {
            request.setAttribute("error", "Không thể vô hiệu hóa ghế này vì đang có vé đặt cho suất chiếu tương lai!");
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/seats/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Code Bulk Update Price (GIỮ NGUYÊN NHƯ CŨ CỦA BẠN)
        if ("bulkUpdatePrice".equals(action)) {
            // ... (Giữ nguyên phần code bulkUpdatePrice của bạn ở đây) ...
             String updateVip = request.getParameter("updateVip");
            String updateNormal = request.getParameter("updateNormal");
            String vipPriceParam = request.getParameter("vipPrice");
            String normalPriceParam = request.getParameter("normalPrice");

            boolean shouldUpdateVip = "true".equals(updateVip) && vipPriceParam != null && !vipPriceParam.trim().isEmpty();
            boolean shouldUpdateNormal = "true".equals(updateNormal) && normalPriceParam != null && !normalPriceParam.trim().isEmpty();

            if (!shouldUpdateVip && !shouldUpdateNormal) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Vui lòng chọn ít nhất 1 loại ghế để cập nhật");
                return;
            }

            try {
                // Cập nhật VIP
                if (shouldUpdateVip) {
                    double vipPrice = Double.parseDouble(vipPriceParam);
                    if (vipPrice < 0) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giá VIP không hợp lệ");
                        return;
                    }

                    List<Seat> vipSeats = seatFacade.findBySeatType("VIP");
                    for (Seat seat : vipSeats) {
                        seat.setPrice(vipPrice);
                        seatFacade.edit(seat);
                    }
                }

                // Cập nhật NORMAL
                if (shouldUpdateNormal) {
                    double normalPrice = Double.parseDouble(normalPriceParam);
                    if (normalPrice < 0) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giá NORMAL không hợp lệ");
                        return;
                    }

                    List<Seat> normalSeats = seatFacade.findBySeatType("NORMAL");
                    for (Seat seat : normalSeats) {
                        seat.setPrice(normalPrice);
                        seatFacade.edit(seat);
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/seats?success=bulkPriceUpdated");
                return;
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Định dạng giá không hợp lệ");
                return;
            }
        }

        // -------------------------------------------------------------
        // 🔴 UPDATE PHẦN EDIT: CHECK KHI VÔ HIỆU HÓA (DISABLE)
        // -------------------------------------------------------------
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String seatType = request.getParameter("seatType");
            String priceParam = request.getParameter("price");
            String isActiveParam = request.getParameter("isActive");

            if (seatType == null || priceParam == null || isActiveParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu dữ liệu");
                return;
            }

            double price = Double.parseDouble(priceParam);
            boolean newIsActive = Boolean.parseBoolean(isActiveParam); // Trạng thái Admin muốn set

            Seat seat = seatFacade.find(id);
            if (seat == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy ghế");
                return;
            }
            
            // LOGIC KIỂM TRA: Nếu đang bật mà muốn tắt (newIsActive == false)
            if (seat.getIsActive() && !newIsActive) {
                // Kiểm tra xem ghế có dính dáng đến đơn hàng nào không?
                // Ở mức độ cơ bản, nếu có bất kỳ đơn hàng nào thì cảnh báo (hoặc chặn)
                // Để chuẩn xác nhất thì phải check ngày giờ chiếu > hiện tại (như tôi phân tích trước đó)
                // Nhưng ở đây dùng tạm check collection cho an toàn
                boolean hasOrders = seat.getOrderDetailCollection() != null && !seat.getOrderDetailCollection().isEmpty();
                
                if (hasOrders) {
                    // Tùy chọn: Chặn luôn không cho tắt
                    // response.sendRedirect(request.getContextPath() + "/admin/seats?error=CannotDisableBookedSeat");
                    // return;
                    
                    // HOẶC: Vẫn cho tắt (như phân tích trước) nhưng phải đảm bảo Code Checkout đã handle
                    // Ở đây tôi vẫn cho tắt theo đúng yêu cầu "Admin có quyền vô hiệu hóa"
                }
            }

            seat.setSeatType(seatType);
            seat.setPrice(price);
            seat.setIsActive(newIsActive); // Cập nhật trạng thái

            seatFacade.edit(seat);

            response.sendRedirect(request.getContextPath() + "/admin/seats");
            return;
        }
        
        // Code Bulk Create (Giữ nguyên)
        if ("bulkCreate".equals(action)) {
             // ... (Giữ nguyên phần code bulkCreate của bạn) ...
             String rowStartParam = request.getParameter("rowStart");
            String rowEndParam = request.getParameter("rowEnd");
            String seatPerRowParam = request.getParameter("seatPerRow");
            String vipPriceParam = request.getParameter("vipPrice");
            String normalPriceParam = request.getParameter("normalPrice");

            // Validate null
            if (rowStartParam == null || rowEndParam == null || seatPerRowParam == null
                    || vipPriceParam == null || normalPriceParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu dữ liệu nhập");
                return;
            }

            char rowStart = rowStartParam.charAt(0);
            char rowEnd = rowEndParam.charAt(0);

            if (rowStart > rowEnd) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hàng bắt đầu phải trước hàng kết thúc");
                return;
            }

            int seatPerRow = Integer.parseInt(seatPerRowParam);
            double vipPrice = Double.parseDouble(vipPriceParam);
            double normalPrice = Double.parseDouble(normalPriceParam);

            if (seatPerRow <= 0 || vipPrice < 0 || normalPrice < 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số ghế và giá phải ≥ 0");
                return;
            }

            for (char row = rowStart; row <= rowEnd; row++) {
                for (int col = 1; col <= seatPerRow; col++) {
                    String seatNumber = row + String.valueOf(col);

                    // Check ghế trùng
                    Seat existingSeat = seatFacade.findBySeatNumber(seatNumber);
                    if (existingSeat != null) {
                        continue; // bỏ qua ghế đã tồn tại
                    }

                    Seat newSeat = new Seat();
                    newSeat.setRowLabel(String.valueOf(row));
                    newSeat.setColumnNumber(col);
                    newSeat.setSeatNumber(seatNumber);
                    newSeat.setIsActive(true);
                    newSeat.setCreatedAt(new Date());

                    // Tính khu vực
                    String area;
                    if (row >= 'A' && row <= 'E') {
                        area = "TOP";
                    } else if (row >= 'F' && row <= 'J') {
                        area = "LEFT";
                    } else if (row >= 'K' && row <= 'O') {
                        area = "RIGHT";
                    } else if (row >= 'P' && row <= 'T') {
                        area = "BOTTOM";
                    } else {
                        area = "UNKNOWN";
                    }

                    // Gán VIP/NORMAL
                    String seatTypeForNew;
                    switch (area) {
                        case "TOP":
                            seatTypeForNew = (row <= 'B') ? "VIP" : "NORMAL";
                            break;
                        case "LEFT":
                            seatTypeForNew = (row <= 'G') ? "VIP" : "NORMAL";
                            break;
                        case "RIGHT":
                            seatTypeForNew = (row <= 'L') ? "VIP" : "NORMAL";
                            break;
                        case "BOTTOM":
                            seatTypeForNew = (row <= 'Q') ? "VIP" : "NORMAL";
                            break;
                        default:
                            seatTypeForNew = "NORMAL";
                    }
                    newSeat.setSeatType(seatTypeForNew);

                    // Gán giá
                    newSeat.setPrice(seatTypeForNew.equals("VIP") ? vipPrice : normalPrice);

                    seatFacade.create(newSeat);
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/seats");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/seats");
    }
}