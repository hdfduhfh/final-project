<%-- 
    Document   : index
    Created on : Dec 5, 2025, 2:27:16 PM
    Author     : DANG KHOA
--%>

<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>BookingStage — Rạp hát nghệ thuật sang trọng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="https://unpkg.com/three@0.160.0/build/three.min.js"></script>
        <style>
            body {
                margin:0;
                font-family:'Playfair Display',serif;
                background:radial-gradient(circle at center,#111 0%,#000 100%);
                color:#fff;
            }
            #bg3d {
                position:fixed;
                inset:0;
                z-index:0;
                pointer-events:none;
            }

            .hero {
                min-height:70vh;
                display:flex;
                align-items:center;
                justify-content:center;
                padding:120px 20px;
            }
            .hero-inner {
                text-align:center;
                max-width:900px;
            }
            .hero-title {
                font-size:48px;
                color:#ffd700;
                margin-bottom:20px;
            }
            .hero-desc {
                font-size:18px;
                color:#ddd;
                margin-bottom:30px;
            }
            .btn-gold {
                background:linear-gradient(135deg,#ffd700,#ffae00);
                color:#000;
                padding:14px 22px;
                border-radius:10px;
                font-weight:bold;
                box-shadow:0 0 12px rgba(255,215,0,.6);
                transition:transform .2s ease;
            }
            .btn-gold:hover {
                transform:scale(1.05);
            }
            .btn-outline {
                background:transparent;
                border:1px solid #ffd700;
                color:#ffd700;
                padding:14px 22px;
                border-radius:10px;
                font-weight:bold;
                margin-left:10px;
            }

            .section {
                max-width:1100px;
                margin:40px auto;
            }
            .section-header {
                text-align:center;
                margin-bottom:20px;
            }
            .grid {
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
                gap:20px;
            }
            .card {
                border-radius:18px;
                overflow:hidden;
                background:rgba(255,255,255,0.08);
                backdrop-filter:blur(12px);
                border:1px solid rgba(255,255,255,0.25);
                transition:transform .3s ease, box-shadow .3s ease;
            }
            .card:hover {
                transform:translateY(-6px);
                box-shadow:0 12px 24px rgba(255,215,0,.3);
            }
            .card img {
                width:100%;
                height:220px;
                object-fit:cover;
            }
            .card .content {
                padding:14px;
            }
            .tag {
                font-weight:bold;
                color:#ffd700;
            }
            .price {
                font-weight:bold;
                color:#ffae00;
            }

            .stats {
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(200px,1fr));
                gap:20px;
                margin-top:30px;
            }
            .stat {
                text-align:center;
                padding:20px;
                border-radius:16px;
                background:rgba(255,255,255,0.08);
                border:1px solid rgba(255,255,255,0.25);
            }
            .stat h3 {
                margin:0;
                font-size:28px;
                color:#ffd700;
            }

            .chat-icon {
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 60px;
                height: 60px;
                background: #eab308; /* vàng gold */
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 28px;
                cursor: pointer;
                box-shadow: 0 4px 12px rgba(0,0,0,0.25);
                z-index: 999;
                transition: transform 0.25s ease;
            }

            .chat-icon:hover {
                transform: scale(1.1);
            }

            /* CHAT DOCK */
            .chat-dock {
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 320px;
                height: 420px;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                display: none; /* mặc định ẩn */
                flex-direction: column;
                overflow: hidden;
                z-index: 1000;
                animation: fadeInUp 0.3s ease;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* CHAT HEADER */
            .chat-header {
                background: #1e1e2e;
                color: white;
                padding: 12px;
                font-weight: bold;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .chat-close {
                cursor: pointer;
                font-size: 20px;
            }

            /* CHAT BODY */
            .chat-body {
                flex: 1;
                padding: 10px;
                overflow-y: auto;
            }

            /* CHAT INPUT */
            .chat-input {
                padding: 10px;
                display: flex;
                gap: 8px;
                background: #f5f5f5;
            }

            .chat-input input {
                flex: 1;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 6px;
            }

            .send-btn {
                padding: 8px 12px;
                background: #eab308;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }
            .msg {
                padding:8px 10px;
                border-radius:12px;
                margin:6px 0;
                max-width:85%;
            }
            .msg.user {
                background:rgba(255,215,0,.2);
                margin-left:auto;
            }
            .msg.ai {
                background:rgba(255,255,255,.1);
            }
            .typing {
                font-style:italic;
                color:#ffd700;
            }

            .footer {
                text-align:center;
                margin:40px auto;
                color:#aaa;
            }
        </style>
    </head>
    <body>
        <%@ include file="/WEB-INF/views/layout/header.jsp" %>
        <!-- 3D Background -->
        <div id="bg3d"></div>


        <!-- Hero -->
        <section class="hero">
            <div class="hero-inner">
                <h1 class="hero-title">✨ Nghệ thuật đỉnh cao ✨</h1>
                <p class="hero-desc">Rạp hát sang trọng, đẳng cấp, với AI đồng hành hỗ trợ bạn mọi lúc.</p>
                <div>
                    <a class="btn-gold" href="${pageContext.request.contextPath}/shows">Đặt vé ngay</a>
                    <a class="btn-outline" href="${pageContext.request.contextPath}/schedule">Xem lịch diễn</a>
                </div>
            </div>
        </section>

        <!-- Featured Shows -->
        <section class="section">
            <div class="section-header"><h2>🌟 Chương trình nổi bật</h2></div>
            <div class="grid">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/assets/images/show/bong-dan-ong10113.jpeg" alt="Show 1">
                    <div class="content">
                        <div class="tag">🎭 Kịch</div>
                        <h4>Dạ Cổ Hoài Lang</h4>
                        <div>📅 25/12/2024 • 🕐 19:30</div>
                        <div class="price">300.000đ - 800.000đ</div>
                    </div>
                </div>
                <div class="card">
                    <img src="${pageContext.request.contextPath}/assets/images/show/chuyen-cu-minh-bo-qua10111.jpg" alt="Show 2">
                    <div class="content">
                        <div class="tag">🎵 Hòa nhạc</div>
                        <h4>Giao Hưởng Việt Nam</h4>
                        <div>📅 30/12/2024 • 🕐 20:00</div>
                        <div class="price">500.000đ - 1.500.000đ</div>
                    </div>
                </div>
                <div class="card">
                    <img src="${pageContext.request.contextPath}/assets/images/show/anh-trai-say-ai32102.jpg" alt="Show 3">
                    <div class="content">
                        <div class="tag">💃 Múa</div
                        <h4>Văn Hóa Dân Tộc</h4>
                        <div>📅 05/01/2025 • 🕐 19:00</div>
                        <div class="price">200.000đ - 600.000đ</div>
                    </div>
                </div>
            </div>

            <!-- Stats Section -->
            <div class="stats">
                <div class="stat">
                    <h3>500+</h3>
                    <p>Chương trình mỗi năm</p>
                </div>
                <div class="stat">
                    <h3>50K+</h3>
                    <p>Khách hàng hài lòng</p>
                </div>
                <div class="stat">
                    <h3>100+</h3>
                    <p>Nghệ sĩ nổi tiếng</p>
                </div>
                <div class="stat">
                    <h3>10+</h3>
                    <p>Năm kinh nghiệm</p>
                </div>
            </div>
        </section>

        <!-- Chat icon -->
        <div id="chatIcon" class="chat-icon">💬</div>

        <!-- Chat dock -->
        <div class="chat-dock" id="chatDock">
            <div class="chat-header">
                AI Assistant 🤖
                <span id="chatClose" class="chat-close">×</span>
            </div>

            <div class="chat-body" id="chatBody"></div>

            <div class="chat-input">
                <input id="chatInput" placeholder="Hỏi AI về show, giá vé, lịch diễn..."/>
                <button class="send-btn" id="sendBtn">Gửi</button>
            </div>
        </div>


        <!-- Footer -->
        <%@ include file="/WEB-INF/views/layout/footer.jsp" %>
        <script>
            // AI Chatbot logic
            const chatBody = document.getElementById('chatBody');
            const chatInput = document.getElementById('chatInput');
            const sendBtn = document.getElementById('sendBtn');

            function addMsg(text, who = 'ai') {
                const div = document.createElement('div');
                div.className = 'msg ' + (who === 'user' ? 'user' : 'ai');
                div.textContent = text;
                chatBody.appendChild(div);
                chatBody.scrollTop = chatBody.scrollHeight;
            }

            function showTyping() {
                const typing = document.createElement('div');
                typing.className = 'typing';
                typing.textContent = 'AI đang gõ...';
                chatBody.appendChild(typing);
                chatBody.scrollTop = chatBody.scrollHeight;
                setTimeout(() => typing.remove(), 2000);
            }

            async function askAI(message) {
                showTyping();
                // Giả lập trả lời AI (bạn sẽ thay bằng API thật)
                setTimeout(() => {
                    addMsg("Giá vé dao động từ 200.000đ đến 1.500.000đ tuỳ show.", 'ai');
                }, 2000);
            }

            sendBtn.addEventListener('click', () => {
                const msg = chatInput.value.trim();
                if (!msg)
                    return;
                addMsg(msg, 'user');
                chatInput.value = '';
                askAI(msg);
            });

            chatInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    sendBtn.click();
                }
            });

            // Background 3D với Three.js
            (function () {
                const container = document.getElementById('bg3d');
                const scene = new THREE.Scene();
                const camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 0.1, 1000);
                camera.position.z = 40;
                const renderer = new THREE.WebGLRenderer({alpha: true, antialias: true});
                renderer.setSize(window.innerWidth, window.innerHeight);
                container.appendChild(renderer.domElement);

                const points = [];
                const group = new THREE.Group();
                scene.add(group);

                const geom = new THREE.SphereGeometry(0.3, 16, 16);
                const mat = new THREE.MeshBasicMaterial({color: 0xffd700});
                for (let i = 0; i < 60; i++) {
                    const m = new THREE.Mesh(geom, mat);
                    m.position.set((Math.random() - 0.5) * 30, (Math.random() - 0.5) * 20, (Math.random() - 0.5) * 20);
                    m.userData.vel = new THREE.Vector3((Math.random() - 0.5) * 0.05, (Math.random() - 0.5) * 0.05, (Math.random() - 0.5) * 0.05);
                    points.push(m);
                    group.add(m);
                }

                function animate() {
                    requestAnimationFrame(animate);
                    points.forEach(p => {
                        p.position.add(p.userData.vel);
                    });
                    group.rotation.y += 0.001;
                    renderer.render(scene, camera);
                }
                animate();

                window.addEventListener('resize', () => {
                    camera.aspect = window.innerWidth / window.innerHeight;
                    camera.updateProjectionMatrix();
                    renderer.setSize(window.innerWidth, window.innerHeight);
                });
            })();
        </script>
        <script>
            const chatDock = document.getElementById("chatDock");
            const chatIcon = document.getElementById("chatIcon");
            const chatClose = document.getElementById("chatClose");

// Mở chat
            chatIcon.addEventListener("click", () => {
                chatDock.style.display = "flex";
                chatIcon.style.display = "none";
            });

// Thu nhỏ chat
            chatClose.addEventListener("click", () => {
                chatDock.style.display = "none";
                chatIcon.style.display = "flex";
            });
        </script>
