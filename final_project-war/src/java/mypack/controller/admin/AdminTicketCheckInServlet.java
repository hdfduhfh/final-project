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
import java.io.IOException;
import java.util.Date;
import mypack.Ticket;
import mypack.TicketFacadeLocal;

/**
 *
 * @author DANG KHOA
 */
@WebServlet(name = "AdminTicketCheckinServlet", urlPatterns = {"/admin/ticket-checkin"})
public class AdminTicketCheckInServlet extends HttpServlet {

    @EJB
    private TicketFacadeLocal ticketFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/admin/ticket-checkin.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String qrCode = request.getParameter("qrCode");

        Ticket t = ticketFacade.findByQRCode(qrCode);
        if (t == null) {
            request.setAttribute("error", "❌ Không tìm thấy vé");
            forward(request, response);
            return;
        }

        Date showTime = t.getOrderDetailID()
                .getScheduleID()
                .getShowTime();

        long now = System.currentTimeMillis();
        long show = showTime.getTime();
        long diff = show - now; // ms

        String result = ticketFacade.checkInTicket(qrCode);

        switch (result) {
            case "SUCCESS":
                request.setAttribute("message", "✅ Check-in thành công");
                break;

            case "TOO_EARLY":
                long totalSeconds = diff / 1000;
                long seconds = totalSeconds % 60;
                long totalMinutes = totalSeconds / 60;
                long minutes = totalMinutes % 60;
                long totalHours = totalMinutes / 60;
                long hours = totalHours % 24;
                long days = totalHours / 24;

                request.setAttribute(
                        "error",
                        String.format(
                                "⏳ Chưa tới giờ check-in. Còn %d ngày %d giờ %d phút %d giây",
                                days, hours, minutes, seconds
                        )
                );
                break;

            case "TOO_LATE":
                request.setAttribute(
                        "error",
                        "❌ Đã quá giờ check-in (quá 30 phút sau suất diễn)"
                );
                break;

            case "INVALID_STATUS":
                request.setAttribute(
                        "error",
                        "❌ Vé đã được check-in hoặc không hợp lệ"
                );
                break;

            default:
                request.setAttribute("error", "❌ Check-in thất bại");
        }

        forward(request, response);
    }

    private void forward(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(
                "/WEB-INF/views/admin/ticket-checkin.jsp"
        ).forward(request, response);
    }

}
