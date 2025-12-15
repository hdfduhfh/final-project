/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/* AI Chatbot Script - FIXED VERSION */
console.log('🤖 AI Chatbot initializing...');

const chatBody = document.getElementById('chatBody');
const chatInput = document.getElementById('chatInput');
const sendBtn = document.getElementById('sendBtn');

// Kiểm tra elements
if (!chatBody || !chatInput || !sendBtn) {
    console.error('❌ Chat elements not found!');
} else {
    console.log('✅ Chat elements loaded');
}

function addMsg(text, who = 'ai') {
    const wrapper = document.createElement('div');
    wrapper.style.clear = 'both';
    wrapper.style.overflow = 'auto';

    const div = document.createElement('div');
    div.className = 'msg ' + (who === 'user' ? 'user' : 'ai');
    div.innerHTML = text;

    wrapper.appendChild(div);
    chatBody.appendChild(wrapper);
    chatBody.scrollTop = chatBody.scrollHeight;

    console.log('💬 Message added:', who, text.substring(0, 50));
}

function showTyping() {
    const wrapper = document.createElement('div');
    wrapper.style.clear = 'both';
    wrapper.style.overflow = 'auto';
    wrapper.id = 'typingWrapper';

    const typing = document.createElement('div');
    typing.className = 'typing';
    typing.innerHTML = 'AI đang suy nghĩ<span class="dots">...</span>';

    wrapper.appendChild(typing);
    chatBody.appendChild(wrapper);
    chatBody.scrollTop = chatBody.scrollHeight;

    console.log('⏳ Typing indicator shown');
}

function removeTyping() {
    const wrapper = document.getElementById('typingWrapper');
    if (wrapper) {
        wrapper.remove();
        console.log('✅ Typing indicator removed');
    }
}

async function askAI(message) {
    console.log('🚀 Asking AI:', message);
    showTyping();

    try {
        console.log('📡 Calling Claude API...');
        const response = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'anthropic-version': '2023-06-01'
            },
            body: JSON.stringify({
                model: 'claude-sonnet-4-20250514',
                max_tokens: 1000,
                system: 'Bạn là trợ lý AI của BookingStage. THÔNG TIN SHOW: 1) Dạ Cổ Hoài Lang (25/12, 19:30, 300k-800k), 2) Giao Hưởng VN (30/12, 20:00, 500k-1.5tr), 3) Văn Hóa Dân Tộc (05/01, 19:00, 200k-600k). Trả lời ngắn gọn, thân thiện, dùng emoji, tiếng Việt.',
                messages: [{role: 'user', content: message}]
            })
        });

        console.log('📥 API Response status:', response.status);

        if (!response.ok) {
            throw new Error('API error: ' + response.status);
        }

        const data = await response.json();
        console.log('✅ API Data received:', data);

        removeTyping();

        if (data.content && data.content[0] && data.content[0].text) {
            addMsg(data.content[0].text, 'ai');
        } else {
            throw new Error('Invalid response format');
        }
    } catch (error) {
        console.error('❌ AI Error:', error);
        removeTyping();

        // Fallback response
        const fallback = getFallbackResponse(message);
        addMsg(fallback, 'ai');
    }
}

function getFallbackResponse(message) {
    console.log('🔄 Using fallback response');
    const lower = message.toLowerCase();

    if (lower.includes('giá') || lower.includes('bao nhiêu')) {
        return '💰 <strong>Giá vé các show:</strong><br><br>' +
                '🎭 Dạ Cổ Hoài Lang: 300.000đ - 800.000đ<br>' +
                '🎵 Giao Hưởng VN: 500.000đ - 1.500.000đ<br>' +
                '💃 Văn Hóa Dân Tộc: 200.000đ - 600.000đ<br><br>' +
                'Bạn muốn đặt show nào? 😊';
    }

    if (lower.includes('lịch') || lower.includes('ngày')) {
        return '📅 <strong>Lịch diễn tháng này:</strong><br><br>' +
                '• 25/12/2024 - Dạ Cổ Hoài Lang (19:30)<br>' +
                '• 30/12/2024 - Giao Hưởng VN (20:00)<br>' +
                '• 05/01/2025 - Văn Hóa Dân Tộc (19:00)<br><br>' +
                'Show nào bạn quan tâm nhất? 🎭';
    }

    if (lower.includes('đặt') || lower.includes('mua')) {
        return '🎟️ <strong>Cách đặt vé:</strong><br><br>' +
                '1️⃣ Chọn show bạn thích<br>' +
                '2️⃣ Chọn ghế và số lượng<br>' +
                '3️⃣ Thanh toán online an toàn<br><br>' +
                'Rất đơn giản! Bạn muốn đặt show nào? 😊';
    }

    if (lower.includes('gợi ý') || lower.includes('nên xem')) {
        return '✨ <strong>Để gợi ý phù hợp:</strong><br><br>' +
                '🎭 Kịch truyền thống cảm động?<br>' +
                '🎵 Nhạc giao hưởng sang trọng?<br>' +
                '💃 Múa dân gian sôi động?<br><br>' +
                'Bạn thích thể loại nào? 😄';
    }

    if (lower.includes('hello') || lower.includes('hi') || lower.includes('chào')) {
        return '👋 <strong>Chào bạn!</strong><br><br>' +
                'Tôi là AI Assistant của BookingStage. Tôi có thể giúp bạn:<br><br>' +
                '🎭 Tìm show phù hợp<br>' +
                '💰 Xem giá vé<br>' +
                '📅 Kiểm tra lịch diễn<br>' +
                '🎟️ Hướng dẫn đặt vé<br><br>' +
                'Bạn cần hỗ trợ gì? 😊';
    }

    return '🤖 <strong>Tôi có thể giúp bạn:</strong><br><br>' +
            '• Thông tin show & giá vé 💰<br>' +
            '• Lịch diễn & đặt vé 📅<br>' +
            '• Gợi ý show phù hợp ✨<br>' +
            '• Chỗ ngồi & thanh toán 🎟️<br><br>' +
            'Hoặc gọi: <strong>1900-xxxx</strong> 📞';
}

// Send message function
function sendMessage() {
    const msg = chatInput.value.trim();
    console.log('📤 Send button clicked. Message:', msg);

    if (!msg) {
        console.log('⚠️ Empty message, ignoring');
        return;
    }

    addMsg(msg, 'user');
    chatInput.value = '';
    askAI(msg);
}

// Event listeners
sendBtn.addEventListener('click', sendMessage);
console.log('✅ Click listener added');

chatInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        console.log('⌨️ Enter key pressed');
        sendMessage();
    }
});
console.log('✅ Keypress listener added');

// Welcome message
setTimeout(() => {
    console.log('👋 Showing welcome message');
    addMsg('👋 <strong>Xin chào!</strong> Tôi là AI Assistant của BookingStage.<br><br>' +
            'Tôi có thể giúp bạn:<br>' +
            '🎭 Tìm show phù hợp<br>' +
            '🎟️ Đặt vé nhanh chóng<br>' +
            '💬 Giải đáp thắc mắc<br><br>' +
            'Hãy hỏi tôi bất cứ điều gì! 😊', 'ai');
}, 500);

console.log('✅ AI Chatbot initialized successfully!');
