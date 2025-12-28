<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá - ${show.showName} | BookingStage</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --gold-primary: #d4af37;
            --gold-light: #FDB931;
            --dark-bg: #0a0a0a;
            --card-bg: #1a1a1a;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Montserrat', sans-serif;
            background: var(--dark-bg);
            color: #f0f0f0;
            min-height: 100vh;
        }

        /* Header */
        .page-header {
            background: linear-gradient(135deg, rgba(26,26,26,0.95) 0%, rgba(20,20,20,0.9) 100%);
            padding: 25px 0;
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .back-btn {
            color: #ccc;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 25px;
            transition: all 0.3s;
        }

        .back-btn:hover {
            border-color: var(--gold-primary);
            color: var(--gold-primary);
            background: rgba(212, 175, 55, 0.1);
        }

        /* Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Show Info Section */
        .show-info-card {
            background: linear-gradient(135deg, var(--card-bg) 0%, #252525 100%);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.08);
            display: flex;
            gap: 30px;
            align-items: center;
        }

        .show-poster {
            width: 150px;
            height: 200px;
            border-radius: 12px;
            object-fit: cover;
            box-shadow: 0 8px 24px rgba(0,0,0,0.4);
            background: #333;
        }

        .no-image {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 3rem;
        }

        .show-details h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: #fff;
            margin-bottom: 10px;
        }

        .show-meta {
            display: flex;
            gap: 20px;
            color: #888;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }

        .show-meta span {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .schedule-badge {
            display: inline-block;
            background: rgba(212, 175, 55, 0.15);
            border: 1px solid var(--gold-primary);
            color: var(--gold-primary);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-top: 10px;
        }

        /* Rating Summary */
        .rating-summary {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 35px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.08);
        }

        .rating-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .avg-rating {
            font-size: 4rem;
            font-weight: 700;
            color: var(--gold-primary);
            font-family: 'Playfair Display', serif;
            line-height: 1;
            margin-bottom: 10px;
        }

        .max-rating {
            font-size: 1.2rem;
            color: #666;
        }

        .stars-display {
            font-size: 1.8rem;
            color: var(--gold-primary);
            margin: 15px 0;
        }

        .total-reviews {
            color: #888;
            font-size: 0.95rem;
        }

        /* Rating Breakdown */
        .rating-breakdown {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .rating-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .rating-label {
            display: flex;
            align-items: center;
            gap: 5px;
            min-width: 70px;
            color: #ccc;
            font-size: 0.9rem;
        }

        .rating-bar {
            flex: 1;
            height: 8px;
            background: #2a2a2a;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
        }

        .rating-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--gold-primary), var(--gold-light));
            border-radius: 10px;
            transition: width 0.5s ease;
        }

        .rating-count {
            min-width: 50px;
            text-align: right;
            color: #888;
            font-size: 0.9rem;
        }

        /* Feedback List */
        .feedback-section h2 {
            font-family: 'Playfair Display', serif;
            color: #fff;
            margin-bottom: 25px;
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .feedback-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .feedback-card {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid rgba(255,255,255,0.08);
            transition: all 0.3s;
        }

        .feedback-card:hover {
            border-color: rgba(212, 175, 55, 0.3);
            transform: translateX(5px);
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--gold-primary), var(--gold-light));
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.2rem;
            color: #000;
        }

        .user-details .user-name {
            font-weight: 600;
            color: #fff;
            margin-bottom: 3px;
        }

        .user-details .review-date {
            color: #666;
            font-size: 0.85rem;
        }

        .rating-stars {
            display: flex;
            gap: 4px;
            color: var(--gold-primary);
            font-size: 1rem;
        }

        .rating-stars .empty {
            color: #333;
        }

        .feedback-comment {
            color: #ddd;
            line-height: 1.7;
            font-size: 0.95rem;
            padding: 15px;
            background: rgba(0,0,0,0.3);
            border-radius: 8px;
            border-left: 3px solid rgba(212, 175, 55, 0.5);
        }

        .schedule-info {
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid rgba(255,255,255,0.05);
            font-size: 0.85rem;
            color: #888;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #777;
        }

        .empty-state i {
            font-size: 5rem;
            color: var(--gold-primary);
            opacity: 0.2;
            margin-bottom: 25px;
        }

        .empty-state h3 {
            font-family: 'Playfair Display', serif;
            color: #ccc;
            font-size: 1.8rem;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #888;
            font-size: 1rem;
        }

        /* Verified Badge */
        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: rgba(46, 204, 113, 0.15);
            border: 1px solid #2ecc71;
            color: #2ecc71;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .show-info-card {
                flex-direction: column;
                text-align: center;
            }

            .show-poster {
                width: 120px;
                height: 160px;
            }

            .show-details h1 {
                font-size: 1.5rem;
            }

            .show-meta {
                flex-direction: column;
                gap: 10px;
            }

            .avg-rating {
                font-size: 3rem;
            }

            .feedback-header {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="page-header">
        <div class="header-content">
            <a href="${pageContext.request.contextPath}/" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i>
                Trang chủ
            </a>
            <div style="color: var(--gold-primary); font-weight: 600;">
                <i class="fa-solid fa-star"></i>
                Đánh giá từ khán giả
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Show Info -->
        <div class="show-info-card">
            <!-- Show Image -->
            <c:choose>
                <c:when test="${not empty show.showImage}">
                    <img src="${pageContext.request.contextPath}/${show.showImage}" 
                         alt="${show.showName}" 
                         class="show-poster"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <div class="show-poster no-image" style="display: none;">
                        <i class="fa-solid fa-image"></i>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="show-poster no-image">
                        <i class="fa-solid fa-image"></i>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="show-details">
                <h1>${show.showName}</h1>
                
                <c:if test="${not empty show.description}">
                    <p style="color: #888; margin: 10px 0 15px 0; line-height: 1.6;">
                        ${show.description}
                    </p>
                </c:if>
                
                <div class="show-meta">
                    <span>
                        <i class="fa-solid fa-clock"></i>
                        ${show.durationMinutes} phút
                    </span>
                    <span>
                        <i class="fa-solid fa-circle-dot"></i>
                        ${show.status}
                    </span>
                </div>
                
                <c:if test="${schedule != null}">
                    <div class="schedule-badge">
                        <i class="fa-regular fa-calendar"></i>
                        Suất chiếu: <fmt:formatDate value="${schedule.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Rating Summary -->
        <div class="rating-summary">
            <div class="rating-header">
                <div class="avg-rating">
                    <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
                </div>
                <span class="max-rating">/ 5.0</span>
                
                <div class="stars-display">
                    <c:forEach begin="1" end="5" var="i">
                        <i class="fa-solid fa-star ${i <= avgRating ? '' : 'empty'}"></i>
                    </c:forEach>
                </div>
                
                <div class="total-reviews">
                    Dựa trên ${totalFeedback} đánh giá
                </div>
            </div>

            <div class="rating-breakdown">
                <c:set var="total" value="${totalFeedback > 0 ? totalFeedback : 1}"/>
                
                <div class="rating-row">
                    <div class="rating-label">
                        <i class="fa-solid fa-star"></i> 5
                    </div>
                    <div class="rating-bar">
                        <div class="rating-fill" style="width: ${(rating5 / total) * 100}%"></div>
                    </div>
                    <div class="rating-count">${rating5}</div>
                </div>

                <div class="rating-row">
                    <div class="rating-label">
                        <i class="fa-solid fa-star"></i> 4
                    </div>
                    <div class="rating-bar">
                        <div class="rating-fill" style="width: ${(rating4 / total) * 100}%"></div>
                    </div>
                    <div class="rating-count">${rating4}</div>
                </div>

                <div class="rating-row">
                    <div class="rating-label">
                        <i class="fa-solid fa-star"></i> 3
                    </div>
                    <div class="rating-bar">
                        <div class="rating-fill" style="width: ${(rating3 / total) * 100}%"></div>
                    </div>
                    <div class="rating-count">${rating3}</div>
                </div>

                <div class="rating-row">
                    <div class="rating-label">
                        <i class="fa-solid fa-star"></i> 2
                    </div>
                    <div class="rating-bar">
                        <div class="rating-fill" style="width: ${(rating2 / total) * 100}%"></div>
                    </div>
                    <div class="rating-count">${rating2}</div>
                </div>

                <div class="rating-row">
                    <div class="rating-label">
                        <i class="fa-solid fa-star"></i> 1
                    </div>
                    <div class="rating-bar">
                        <div class="rating-fill" style="width: ${(rating1 / total) * 100}%"></div>
                    </div>
                    <div class="rating-count">${rating1}</div>
                </div>
            </div>
        </div>

        <!-- Feedback List -->
        <div class="feedback-section">
            <h2>
                <i class="fa-solid fa-comments"></i>
                Bình luận từ khán giả
            </h2>

            <c:choose>
                <c:when test="${empty feedbacks}">
                    <div class="empty-state">
                        <i class="fa-solid fa-comment-slash"></i>
                        <h3>Chưa có đánh giá nào</h3>
                        <p>Hãy là người đầu tiên đánh giá sau khi xem!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="feedback-list">
                        <c:forEach var="feedback" items="${feedbacks}">
                            <div class="feedback-card">
                                <div class="feedback-header">
                                    <div class="user-info">
                                        <div class="user-avatar">
                                            ${feedback.userID.fullName.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div class="user-details">
                                            <div class="user-name">
                                                ${feedback.userID.fullName}
                                                <span class="verified-badge">
                                                    <i class="fa-solid fa-circle-check"></i>
                                                    Đã xem
                                                </span>
                                            </div>
                                            <div class="review-date">
                                                <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fa-solid fa-star ${i <= feedback.rating ? '' : 'empty'}"></i>
                                        </c:forEach>
                                    </div>
                                </div>

                                <c:if test="${not empty feedback.comment}">
                                    <div class="feedback-comment">
                                        ${feedback.comment}
                                    </div>
                                </c:if>

                                <div class="schedule-info">
                                    <i class="fa-regular fa-calendar"></i>
                                    Suất chiếu: 
                                    <fmt:formatDate value="${feedback.scheduleID.showTime}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Animate rating bars on load
        window.addEventListener('load', function() {
            const bars = document.querySelectorAll('.rating-fill');
            bars.forEach((bar, index) => {
                setTimeout(() => {
                    bar.style.opacity = '1';
                }, index * 100);
            });
        });
    </script>
</body>
</html>