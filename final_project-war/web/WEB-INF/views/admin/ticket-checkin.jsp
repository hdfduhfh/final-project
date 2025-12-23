<%-- 
    Document   : ticket-checkin
    Created on : Dec 21, 2025, 4:31:14 PM
    Author     : DANG KHOA
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Check-in vé</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome 6 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            :root{
                --bg:#0b1220;
                --panel:#0f1b33;
                --muted:#8ea0c4;
                --line:rgba(255,255,255,.08);
            }

            body{
                background:
                    radial-gradient(1200px 700px at 20% -10%, rgba(79,70,229,.28), transparent 55%),
                    radial-gradient(900px 500px at 80% 0%, rgba(6,182,212,.22), transparent 60%),
                    linear-gradient(180deg, var(--bg), #070b14);
                min-height:100vh;
                color:#e6ecff;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, "Noto Sans", "Helvetica Neue", sans-serif;
            }

            .wrap{
                max-width: 860px;
                margin: 0 auto;
                padding: 22px 18px 28px;
            }

            .topbar{
                display:flex;
                gap:12px;
                align-items:center;
                justify-content:space-between;
                padding: 14px 16px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.35);
            }
            .page-h{
                display:flex;
                gap:12px;
                align-items:center;
            }
            .page-h h1{
                font-size: 18px;
                margin:0;
                font-weight: 900;
                letter-spacing:.2px;
            }
            .page-h .crumb{
                color: var(--muted);
                font-weight: 600;
                font-size: 12px;
            }

            .panel{
                margin-top: 14px;
                padding: 16px;
                border-radius: 18px;
                background: rgba(255,255,255,.06);
                border: 1px solid var(--line);
                backdrop-filter: blur(10px);
                box-shadow: 0 18px 55px rgba(0,0,0,.20);
            }

            .hint{
                color: var(--muted);
                font-weight: 650;
                font-size: 13px;
                margin-bottom: 10px;
            }

            .qr-input{
                height: 48px;
                font-weight: 750;
                letter-spacing: .3px;
            }

            .btn-checkin{
                height: 48px;
                font-weight: 900;
                border-radius: 14px;
            }

            .kbd{
                padding: 2px 8px;
                border-radius: 999px;
                background: rgba(255,255,255,.10);
                border: 1px solid var(--line);
                color:#e6ecff;
                font-weight: 800;
                font-size: 12px;
            }
        </style>
    </head>

    <body>
        <div class="wrap">

            <!-- TOPBAR -->
            <div class="topbar">
                <div class="page-h">
                    <div class="d-none d-md-grid" style="place-items:center; width:44px; height:44px; border-radius:16px; background:rgba(255,255,255,.08); border:1px solid var(--line);">
                        <i class="fa-solid fa-qrcode"></i>
                    </div>
                    <div>
                        <h1>🎟 Check-in vé</h1>
                        <div class="crumb">Admin / Ticket / Check-in</div>
                    </div>
                </div>

                <a class="btn btn-outline-light fw-bold" style="border-radius:14px;"
                   href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="fa-solid fa-arrow-left"></i> Về Dashboard
                </a>
            </div>

            <!-- ALERTS -->
            <c:if test="${not empty message}">
                <div class="alert alert-success mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-circle-check"></i>
                    <div>${message}</div>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3 mb-0 d-flex align-items-center gap-2">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <!-- PANEL -->
            <div class="panel">
                <div class="hint">
                    Nhập hoặc quét QR để check-in. Sau khi quét xong thường sẽ tự “Enter”.
                    <span class="ms-2 kbd">Enter</span>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/ticket-checkin">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-9">
                            <div class="input-group">
                                <span class="input-group-text bg-white">
                                    <i class="fa-solid fa-qrcode"></i>
                                </span>
                                <input type="text"
                                       name="qrCode"
                                       id="qrCodeInput"
                                       class="form-control qr-input"
                                       placeholder="Nhập hoặc quét QR..."
                                       autofocus
                                       required>
                            </div>
                        </div>

                        <div class="col-md-3 d-grid">
                            <button type="submit" class="btn btn-warning btn-checkin">
                                <i class="fa-solid fa-circle-check"></i> Check-in
                            </button>
                        </div>
                    </div>

                    <div class="mt-3 d-flex flex-wrap gap-2">
                        <button type="button" class="btn btn-outline-light fw-bold" style="border-radius:14px;"
                                onclick="clearQr()">
                            <i class="fa-solid fa-xmark"></i> Xóa
                        </button>

                        <button type="button" class="btn btn-outline-light fw-bold" style="border-radius:14px;"
                                onclick="focusQr()">
                            <i class="fa-solid fa-crosshairs"></i> Focus QR
                        </button>
                    </div>
                </form>
            </div>

        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function focusQr() {
                const el = document.getElementById('qrCodeInput');
                if (el) el.focus();
            }
            function clearQr() {
                const el = document.getElementById('qrCodeInput');
                if (!el) return;
                el.value = '';
                el.focus();
            }

            // Optional: Enter sẽ submit bình thường, scanner thường tự Enter
            window.addEventListener('load', focusQr);
        </script>
    </body>
</html>
