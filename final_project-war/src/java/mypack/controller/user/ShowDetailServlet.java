/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mypack.Show;
import mypack.ShowFacadeLocal;

import java.io.IOException;

@WebServlet(name = "ShowDetailServlet", urlPatterns = {"/shows/detail/*"})
public class ShowDetailServlet extends HttpServlet {

    @EJB
    private ShowFacadeLocal showFacade;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy showID từ URL: /shows/detail/1
        String pathInfo = req.getPathInfo(); // /1
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/shows");
            return;
        }

        try {
            int showID = Integer.parseInt(pathInfo.substring(1));
            Show show = showFacade.find(showID);

            if (show == null) {
                resp.sendRedirect(req.getContextPath() + "/shows");
                return;
            }

            req.setAttribute("show", show);
            req.getRequestDispatcher("/WEB-INF/views/user/showDetail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/shows");
        }
    }
}
