<%-- 
    Document   : privacy
    Created on : Dec 11, 2025, 2:23:44 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chính sách bảo mật - BookingStage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding-top: 80px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 50px;
            animation: fadeInDown 0.8s ease;
        }
        
        .page-header h1 {
            font-size: 3rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
        }
        
        .page-header .update-date {
            color: #64748b;
            font-size: 1rem;
        }
        
        .privacy-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            animation: fadeInUp 0.8s ease;
        }
        
        .privacy-section h2 {
            font-size: 1.8rem;
            color: #1e293b;
            margin: 30px 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
        }
        
        .privacy-section h2:first-child {
            margin-top: 0;
        }
        
        .privacy-section h3 {
            font-size: 1.4rem;
            color: #334155;
            margin: 25px 0 15px 0;
        }
        
        .privacy-section p {
            font-size: 1.05rem;
            color: #64748b;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        
        .privacy-section ul, .privacy-section ol {
            margin: 15px 0;
            padding-left: 30px;
        }
        
        .privacy-section li {
            font-size: 1.05rem;
            color: #64748b;
            margin-bottom: 10px;
            line-height: 1.7;
        }
        
        .privacy-section strong {
            color: #1e293b;
        }
        
        .info-box {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            border-left: 5px solid #3b82f6;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
        }
        
        .info-box h4 {
            color: #1e40af;
            font-size: 1.3rem;
            margin-top: 0;
            margin-bottom: 15px;
        }
        
        .security-box {
            background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
            border-left: 5px solid #10b981;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
        }
        
        .security-box h4 {
            color: #065f46;
            font-size: 1.3rem;
            margin-top: 0;
            margin-bottom: 15px;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin: 25px 0;
            background: #f8fafc;
            border-radius: 15px;
            overflow: hidden;
        }
        
        .data-table th, .data-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .data-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: bold;
        }
        
        .data-table tr:last-child td {
            border-bottom: none;
        }
        
        .contact-section {
            text-align: center;
            margin-top: 40px;
            padding: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            color: white;
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 2rem;
            }
            
            .privacy-section {
                padding: 25px;
            }
            
            .data-table {
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="container">
        <div class="page-header">
            <h1>🔒 Chính Sách Bảo Mật</h1>
            <p class="update-date">Cập nhật lần cuối: 12/12/2024</p>
        </div>
        
        <div class="privacy-section">
            <div class="info-box">
                <h4>🛡️ Cam Kết Của Chúng Tôi</h4>
                <p>BookingStage cam kết bảo vệ quyền riêng tư và bảo mật thông tin cá nhân của bạn. 
                Chính sách này giải thích cách chúng tôi thu thập, sử dụng, lưu trữ và bảo vệ dữ liệu của bạn.</p>
            </div>
            
            <h2>1. Thông Tin Chúng Tôi Thu Thập</h2>
            
            <h3>1.1. Thông tin cá nhân</h3>
            <p>Khi bạn đăng ký tài khoản hoặc đặt vé, chúng tôi thu thập:</p>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Loại thông tin</th>
                        <th>Mục đích sử dụng</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Họ và tên</strong></td>
                        <td><strong>Xác định danh tính, in trên vé</strong></td>
                    </tr>
                    <tr>
                        <td><strong>Email</strong></td>
                        <td><strong>Gửi vé, xác nhận đơn hàng, thông báo</strong></td>
                    </tr>
                    <tr>
                        <td><strong>Số điện thoại</strong></td>
                        <td><strong>Liên hệ khẩn cấp, xác thực OTP</strong></td>
                    </tr>
                    <tr>
                        <td><strong>Địa chỉ</strong></td>
                        <td><strong>Xuất hóa đơn VAT (nếu yêu cầu)</strong></td>
                    </tr>
                </tbody>
            </table>
            
            <h3>1.2. Thông tin thanh toán</h3>
            <ul>
                <li><strong>Thông tin thẻ:</strong> Được xử lý qua cổng thanh toán bên thứ ba bảo mật (không lưu trên hệ thống)</li>
                <li><strong>Lịch sử giao dịch:</strong> Mã đơn hàng, số tiền, thời gian, phương thức</li>
                <li><strong>Hóa đơn:</strong> Thông tin công ty (nếu xuất hóa đơn)</li>
            </ul>
            
            <h3>1.3. Thông tin tự động thu thập</h3>
            <ul>
                <li><strong>Cookies:</strong> Để cải thiện trải nghiệm người dùng</li>
                <li><strong>IP Address:</strong> Phát hiện gian lận, bảo mật</li>
                <li><strong>Device Info:</strong> Loại thiết bị, trình duyệt, hệ điều hành</li>
                <li><strong>Log Files:</strong> Thời gian truy cập, trang đã xem, hành vi</li>
            </ul>
            
            <h2>2. Mục Đích Sử Dụng Thông Tin</h2>
            <p>Chúng tôi sử dụng thông tin của bạn để:</p>
            
            <h3>2.1. Cung cấp dịch vụ</h3>
            <ul>
                <li>Xử lý đơn hàng và gửi vé điện tử</li>
                <li>Xác nhận và quản lý đặt chỗ</li>
                <li>Hỗ trợ khách hàng</li>
                <li>Xử lý hoàn tiền, đổi vé</li>
            </ul>
            
            <h3>2.2. Cải thiện trải nghiệm</h3>
            <ul>
                <li>Cá nhân hóa nội dung và gợi ý show</li>
                <li>Phân tích hành vi để cải thiện website</li>
                <li>Nghiên cứu thị trường</li>
                <li>Tối ưu hiệu suất hệ thống</li>
            </ul>
            
            <h3>2.3. Marketing và truyền thông</h3>
            <ul>
                <li>Gửi email về show mới, khuyến mãi</li>
                <li>SMS thông báo quan trọng</li>
                <li>Newsletter hàng tuần/tháng</li>
                <li>Chương trình khách hàng thân thiết</li>
            </ul>
            <p><strong>Lưu ý:</strong> Bạn có thể hủy đăng ký nhận email marketing bất cứ lúc nào.</p>
            
            <h3>2.4. Bảo mật và tuân thủ pháp luật</h3>
            <ul>
                <li>Phát hiện và ngăn chặn gian lận</li>
                <li>Xác minh danh tính</li>
                <li>Tuân thủ yêu cầu pháp lý</li>
                <li>Giải quyết tranh chấp</li>
            </ul>
            
            <h2>3. Chia Sẻ Thông Tin</h2>
            <p>Chúng tôi <strong>KHÔNG BÁN</strong> thông tin cá nhân của bạn. Tuy nhiên, có thể chia sẻ với:</p>
            
            <h3>3.1. Đối tác tin cậy</h3>
            <ul>
                <li><strong>Ban tổ chức show:</strong> Tên, email, số lượng vé (để check-in)</li>
                <li><strong>Cổng thanh toán:</strong> Thông tin cần thiết để xử lý giao dịch</li>
                <li><strong>Dịch vụ email:</strong> Gửi vé và thông báo</li>
                <li><strong>Phân tích dữ liệu:</strong> Google Analytics (dữ liệu ẩn danh)</li>
            </ul>
            
            <h3>3.2. Yêu cầu pháp lý</h3>
            <p>Chúng tôi có thể tiết lộ thông tin khi:</p>
            <ul>
                <li>Theo yêu cầu của tòa án, cơ quan chức năng</li>
                <li>Bảo vệ quyền lợi hợp pháp của công ty</li>
                <li>Ngăn chặn hành vi vi phạm pháp luật</li>
            </ul>
            
            <h2>4. Bảo Mật Thông Tin</h2>
            
            <div class="security-box">
                <h4>🔐 Biện Pháp Bảo Mật</h4>
                <p>Chúng tôi áp dụng các tiêu chuẩn bảo mật cao nhất:</p>
                <ul>
                    <li><strong>Mã hóa SSL/TLS 256-bit:</strong> Bảo vệ dữ liệu truyền tải</li>
                    <li><strong>Firewall:</strong> Ngăn chặn truy cập trái phép</li>
                    <li><strong>Mã hóa database:</strong> Dữ liệu nhạy cảm được mã hóa</li>
                    <li><strong>2FA (Two-Factor Auth):</strong> Xác thực hai lớp cho admin</li>
                    <li><strong>Regular Security Audit:</strong> Kiểm tra bảo mật định kỳ</li>
                    <li><strong>PCI DSS Compliant:</strong> Tuân thủ chuẩn bảo mật thanh toán</li>
                </ul>
            </div>
            
            <h3>4.1. Trách nhiệm của bạn</h3>
            <p>Để bảo vệ tài khoản, bạn nên:</p>
            <ul>
                <li>Sử dụng mật khẩu mạnh, không chia sẻ</li>
                <li>Đăng xuất sau khi sử dụng thiết bị chung</li>
                <li>Không truy cập từ mạng WiFi công cộng không an toàn</li>
                <li>Cập nhật trình duyệt, phần mềm bảo mật</li>
                <li>Thông báo ngay nếu phát hiện bất thường</li>
            </ul>
            
            <h2>5. Quyền Của Bạn</h2>
            <p>Bạn có quyền:</p>
            
            <h3>5.1. Truy cập và chỉnh sửa</h3>
            <ul>
                <li>Xem thông tin cá nhân đã cung cấp</li>
                <li>Cập nhật, sửa đổi thông tin</li>
                <li>Tải xuống dữ liệu của bạn</li>
            </ul>
            
            <h3>5.2. Xóa dữ liệu</h3>
            <ul>
                <li>Yêu cầu xóa tài khoản và dữ liệu cá nhân</li>
                <li>Hủy đăng ký email marketing</li>
            </ul>
            <p><strong>Lưu ý:</strong> Một số dữ liệu cần giữ lại theo quy định pháp luật (hóa đơn, giao dịch).</p>
            
            <h3>5.3. Phản đối và khiếu nại</h3>
            <ul>
                <li>Phản đối việc xử lý dữ liệu cá nhân</li>
                <li>Khiếu nại vi phạm quyền riêng tư</li>
            </ul>
            
            <h2>6. Cookies và Công Nghệ Theo Dõi</h2>
            <p>Chúng tôi sử dụng cookies để:</p>
            <ul>
                <li><strong>Essential Cookies:</strong> Đăng nhập, giỏ hàng (bắt buộc)</li>
                <li><strong>Analytics Cookies:</strong> Google Analytics (có thể từ chối)</li>
                <li><strong>Marketing Cookies:</strong> Quảng cáo, retargeting (có thể từ chối)</li>
            </ul>
            <p>Bạn có thể quản lý cookies trong cài đặt trình duyệt.</p>
            
            <h2>7. Lưu Trữ Dữ Liệu</h2>
            <p>Thông tin của bạn được lưu trữ:</p>
            <ul>
                <li><strong>Thời gian:</strong> Trong thời gian cần thiết hoặc theo quy định pháp luật</li>
                <li><strong>Vị trí:</strong> Server tại Việt Nam và AWS Singapore</li>
                <li><strong>Backup:</strong> Sao lưu định kỳ, mã hóa</li>
            </ul>
            
            <h2>8. Quyền Riêng Tư Trẻ Em</h2>
            <p>Dịch vụ của chúng tôi dành cho người từ <strong>16 tuổi trở lên</strong>.</p>
            <p>Nếu phát hiện thu thập thông tin từ trẻ em dưới 16 tuổi, chúng tôi sẽ xóa ngay lập tức.</p>
            
            <h2>9. Cập Nhật Chính Sách</h2>
            <p>Chúng tôi có thể cập nhật chính sách này. Thay đổi quan trọng sẽ được thông báo qua:</p>
            <ul>
                <li>Email đăng ký</li>
                <li>Thông báo trên website</li>
                <li>Banner khi đăng nhập</li>
            </ul>
            
            <h2>10. Liên Hệ</h2>
            <p>Nếu có thắc mắc về chính sách bảo mật hoặc muốn thực hiện quyền của mình:</p>
            <ul>
                <li><strong>Email:</strong> support@bookingstage.vn</li>
                <li><strong>Hotline:</strong> 1900-xxxx</li>
                <li><strong>Địa chỉ:</strong> 123 Đường Văn Hóa, Q.1, TP.HCM</li>
            </ul>
        </div>
        
        <div class="contact-section">
            <h3>🤝 Chúng Tôi Tôn Trọng Quyền Riêng Tư Của Bạn</h3>
            <p style="margin-bottom: 30px; opacity: 0.9;">
                Nếu có bất kỳ thắc mắc nào về cách chúng tôi xử lý dữ liệu cá nhân,<br>
                đừng ngần ngại liên hệ với chúng tôi!
            </p>
            <div style="display: flex; justify-content: center; gap: 30px; flex-wrap: wrap;">
                <div>✉️ <strong>support@bookingstage.vn</strong></div>
                <div>📞 <strong>1900-xxxx</strong></div>
            </div>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>
