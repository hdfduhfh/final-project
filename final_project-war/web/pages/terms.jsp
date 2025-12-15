<%-- 
    Document   : terms
    Created on : Dec 11, 2025, 2:23:30 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Điều khoản sử dụng - BookingStage</title>
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
        
        .terms-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            animation: fadeInUp 0.8s ease;
        }
        
        .terms-section h2 {
            font-size: 1.8rem;
            color: #1e293b;
            margin: 30px 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 3px solid #667eea;
        }
        
        .terms-section h2:first-child {
            margin-top: 0;
        }
        
        .terms-section h3 {
            font-size: 1.4rem;
            color: #334155;
            margin: 25px 0 15px 0;
        }
        
        .terms-section p {
            font-size: 1.05rem;
            color: #64748b;
            line-height: 1.8;
            margin-bottom: 15px;
        }
        
        .terms-section ul, .terms-section ol {
            margin: 15px 0;
            padding-left: 30px;
        }
        
        .terms-section li {
            font-size: 1.05rem;
            color: #64748b;
            margin-bottom: 10px;
            line-height: 1.7;
        }
        
        .terms-section strong {
            color: #1e293b;
        }
        
        .highlight-box {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border-left: 5px solid #f59e0b;
            padding: 25px;
            border-radius: 15px;
            margin: 25px 0;
        }
        
        .table-of-contents {
            background: #f8fafc;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .table-of-contents h3 {
            color: #1e293b;
            margin-top: 0;
            margin-bottom: 15px;
        }
        
        .table-of-contents ul {
            list-style: none;
            padding: 0;
        }
        
        .table-of-contents li {
            margin-bottom: 10px;
        }
        
        .table-of-contents a {
            color: #667eea;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .table-of-contents a:hover {
            color: #764ba2;
            padding-left: 10px;
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
            
            .terms-section {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>
    
    <div class="container">
        <div class="page-header">
            <h1>📜 Điều Khoản Sử Dụng</h1>
            <p class="update-date">Cập nhật lần cuối: 12/12/2024</p>
        </div>
        
        <div class="terms-section">
            <div class="table-of-contents">
                <h3>📑 Mục Lục</h3>
                <ul>
                    <li><a href="#section1">1. Chấp nhận điều khoản</a></li>
                    <li><a href="#section2">2. Tài khoản người dùng</a></li>
                    <li><a href="#section3">3. Đặt vé và thanh toán</a></li>
                    <li><a href="#section4">4. Quyền và nghĩa vụ</a></li>
                    <li><a href="#section5">5. Bảo mật thông tin</a></li>
                    <li><a href="#section6">6. Sở hữu trí tuệ</a></li>
                    <li><a href="#section7">7. Hành vi bị cấm</a></li>
                    <li><a href="#section8">8. Chấm dứt dịch vụ</a></li>
                    <li><a href="#section9">9. Giới hạn trách nhiệm</a></li>
                    <li><a href="#section10">10. Liên hệ</a></li>
                </ul>
            </div>
            
            <h2 id="section1">1. Chấp Nhận Điều Khoản</h2>
            <p>Chào mừng bạn đến với <strong>BookingStage</strong>. Khi truy cập và sử dụng website của chúng tôi, bạn đồng ý tuân thủ các điều khoản và điều kiện sau đây.</p>
            <p>Nếu bạn không đồng ý với bất kỳ phần nào của điều khoản này, vui lòng không sử dụng dịch vụ của chúng tôi.</p>
            
            <h2 id="section2">2. Tài Khoản Người Dùng</h2>
            <h3>2.1. Đăng ký tài khoản</h3>
            <p>Để sử dụng đầy đủ các tính năng, bạn cần tạo tài khoản bằng cách cung cấp:</p>
            <ul>
                <li>Họ và tên đầy đủ</li>
                <li>Địa chỉ email hợp lệ</li>
                <li>Số điện thoại liên hệ</li>
                <li>Mật khẩu bảo mật</li>
            </ul>
            
            <h3>2.2. Bảo mật tài khoản</h3>
            <p>Bạn có trách nhiệm:</p>
            <ul>
                <li>Giữ bí mật thông tin đăng nhập</li>
                <li>Không chia sẻ tài khoản cho người khác</li>
                <li>Thông báo ngay nếu phát hiện truy cập trái phép</li>
                <li>Cập nhật thông tin chính xác</li>
            </ul>
            
            <h2 id="section3">3. Đặt Vé và Thanh Toán</h2>
            <h3>3.1. Quy trình đặt vé</h3>
            <p>Khi đặt vé, bạn đồng ý:</p>
            <ul>
                <li>Cung cấp thông tin chính xác, đầy đủ</li>
                <li>Thanh toán đúng số tiền hiển thị</li>
                <li>Tuân thủ quy định về số lượng vé/giao dịch</li>
                <li>Không sử dụng vé cho mục đích thương mại</li>
            </ul>
            
            <h3>3.2. Giá vé và phí</h3>
            <p>Giá vé đã bao gồm:</p>
            <ul>
                <li>VAT theo quy định</li>
                <li>Phí dịch vụ (nếu có)</li>
                <li>Chi phí xử lý thanh toán</li>
            </ul>
            <p><strong>Lưu ý:</strong> Giá vé có thể thay đổi tùy theo thời điểm và chương trình khuyến mãi.</p>
            
            <h3>3.3. Xác nhận đặt vé</h3>
            <p>Sau khi thanh toán thành công:</p>
            <ul>
                <li>Vé điện tử sẽ được gửi qua email trong 2-5 phút</li>
                <li>Kiểm tra kỹ thông tin trên vé</li>
                <li>Liên hệ ngay nếu phát hiện sai sót</li>
            </ul>
            
            <h2 id="section4">4. Quyền và Nghĩa Vụ</h2>
            <h3>4.1. Quyền của người dùng</h3>
            <p>Bạn có quyền:</p>
            <ul>
                <li>Truy cập và sử dụng dịch vụ miễn phí</li>
                <li>Nhận thông tin đầy đủ về show và vé</li>
                <li>Được bảo vệ thông tin cá nhân</li>
                <li>Khiếu nại và được giải quyết</li>
                <li>Hủy đặt vé theo chính sách</li>
            </ul>
            
            <h3>4.2. Nghĩa vụ của người dùng</h3>
            <p>Bạn phải:</p>
            <ul>
                <li>Tuân thủ pháp luật Việt Nam</li>
                <li>Cung cấp thông tin chính xác</li>
                <li>Không sử dụng dịch vụ cho mục đích bất hợp pháp</li>
                <li>Tôn trọng quyền lợi của người khác</li>
                <li>Thanh toán đầy đủ, đúng hạn</li>
            </ul>
            
            <h2 id="section5">5. Bảo Mật Thông Tin</h2>
            <p>Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn theo <a href="${pageContext.request.contextPath}/privacy" style="color: #667eea;">Chính sách bảo mật</a>.</p>
            <p>Thông tin được thu thập sẽ chỉ dùng cho:</p>
            <ul>
                <li>Xử lý đơn hàng</li>
                <li>Gửi vé và thông báo</li>
                <li>Hỗ trợ khách hàng</li>
                <li>Cải thiện dịch vụ</li>
            </ul>
            
            <h2 id="section6">6. Sở Hữu Trí Tuệ</h2>
            <p>Tất cả nội dung trên website thuộc quyền sở hữu của BookingStage, bao gồm:</p>
            <ul>
                <li>Logo, thương hiệu, nhãn hiệu</li>
                <li>Thiết kế giao diện, hình ảnh</li>
                <li>Nội dung văn bản, video</li>
                <li>Mã nguồn, phần mềm</li>
            </ul>
            <p><strong>Nghiêm cấm:</strong> Sao chép, sửa đổi, phân phối mà không có sự cho phép.</p>
            
            <h2 id="section7">7. Hành Vi Bị Cấm</h2>
            <div class="highlight-box">
                <p><strong>Người dùng KHÔNG ĐƯỢC:</strong></p>
                <ul>
                    <li>🚫 Sử dụng bot, script để đặt vé tự động</li>
                    <li>🚫 Mua vé để bán lại kiếm lời (scalping)</li>
                    <li>🚫 Hack, phá hoại hệ thống</li>
                    <li>🚫 Spam, gửi tin nhắn quấy rối</li>
                    <li>🚫 Đăng nội dung vi phạm pháp luật</li>
                    <li>🚫 Giả mạo thông tin, lừa đảo</li>
                    <li>🚫 Khai thác lỗ hổng để trục lợi</li>
                </ul>
            </div>
            <p><strong>Vi phạm sẽ bị:</strong> Khóa tài khoản vĩnh viễn và xử lý theo pháp luật.</p>
            
            <h2 id="section8">8. Chấm Dứt Dịch Vụ</h2>
            <h3>8.1. Tạm ngưng/Khóa tài khoản</h3>
            <p>Chúng tôi có quyền tạm ngưng hoặc khóa tài khoản nếu:</p>
            <ul>
                <li>Vi phạm điều khoản sử dụng</li>
                <li>Có hoạt động đáng ngờ</li>
                <li>Theo yêu cầu của cơ quan chức năng</li>
                <li>Không hoạt động trong 24 tháng</li>
            </ul>
            
            <h3>8.2. Hủy đăng ký</h3>
            <p>Bạn có thể hủy tài khoản bất cứ lúc nào. Tuy nhiên:</p>
            <ul>
                <li>Vé đã đặt vẫn có hiệu lực</li>
                <li>Điểm thưởng sẽ bị mất</li>
                <li>Không thể khôi phục sau khi xóa</li>
            </ul>
            
            <h2 id="section9">9. Giới Hạn Trách Nhiệm</h2>
            <p>BookingStage không chịu trách nhiệm về:</p>
            <ul>
                <li>Chất lượng của show (do ban tổ chức quyết định)</li>
                <li>Thay đổi lịch trình, nội dung show</li>
                <li>Thiệt hại do lỗi mạng, điện, thiên tai</li>
                <li>Mất mát, hư hỏng tài sản cá nhân tại sự kiện</li>
                <li>Tranh chấp giữa người dùng với nhau</li>
            </ul>
            
            <p><strong>Trách nhiệm tối đa</strong> của chúng tôi giới hạn ở giá trị vé đã thanh toán.</p>
            
            <h2 id="section10">10. Thay Đổi Điều Khoản</h2>
            <p>Chúng tôi có quyền cập nhật điều khoản này. Thay đổi sẽ có hiệu lực ngay khi đăng tải trên website.</p>
            <p>Việc bạn tiếp tục sử dụng dịch vụ sau khi thay đổi đồng nghĩa với việc chấp nhận điều khoản mới.</p>
            
            <h2>📞 Liên Hệ</h2>
            <p>Nếu có bất kỳ thắc mắc nào về điều khoản sử dụng, vui lòng liên hệ:</p>
            <ul>
                <li><strong>Công ty:</strong> BookingStage.Com</li>
                <li><strong>Địa chỉ:</strong> 123 Đường Văn Hóa, Quận 1, TP.HCM</li>
                <li><strong>Email:</strong> support@bookingstage.vn</li>
                <li><strong>Hotline:</strong> 1900-xxxx</li>
                <li><strong>Giờ làm việc:</strong> 8:00 - 22:00 (T2-CN)</li>
            </ul>
        </div>
    </div>
    
    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
</body>
</html>
