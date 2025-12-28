/* * checkout.js - Luxury Theater Payment Logic (Updated UI)
 */

const originalTotal = parseFloat(document.getElementById('finalTotal').textContent.replace(/[^\d]/g, ''));
let currentDiscount = 0;
let selectedBank = null;

// Cấu hình chung cho SweetAlert để đồng bộ giao diện Luxury
const swalLuxuryConfig = {
    background: '#1a1a1a',
    color: '#fff',
    backdrop: `rgba(0,0,0,0.8) left top no-repeat`, // Làm tối nền web khi popup hiện
    customClass: {
        popup: 'luxury-popup'
    }
};

// ==================== PAYMENT METHOD SWITCHING ====================
document.querySelectorAll('.payment-option').forEach(option => {
    option.addEventListener('click', function () {
        document.querySelectorAll('.payment-option').forEach(opt => {
            opt.classList.remove('selected');
        });
        document.querySelectorAll('.payment-details').forEach(detail => {
            detail.classList.remove('active');
        });

        this.classList.add('selected');
        this.querySelector('input[type="radio"]').checked = true;

        const method = this.getAttribute('data-method');
        const detailsDiv = document.getElementById(method + '-details');
        if (detailsDiv) {
            detailsDiv.classList.add('active');
        }
    });
});

// ==================== BANK SELECTION (VNPAY) ====================
document.querySelectorAll('.bank-item').forEach(bank => {
    bank.addEventListener('click', function () {
        document.querySelectorAll('.bank-item').forEach(b => {
            b.classList.remove('selected');
        });
        this.classList.add('selected');
        selectedBank = this.getAttribute('data-bank');
        console.log('✅ Đã chọn ngân hàng:', selectedBank);
    });
});

// ==================== QR CODE CLICK (MOMO & BANKING) ====================
document.querySelectorAll('.qr-wrapper').forEach(qr => {
    qr.addEventListener('click', function () {
        const method = this.closest('.payment-details').id.replace('-details', '').toUpperCase();

        Swal.fire({
            ...swalLuxuryConfig,
            title: `Quét mã ${method}`,
            text: 'GIẢ LẬP QUÉT MÃ THÀNH CÔNG!',
            icon: 'success',
            showCancelButton: true,
            confirmButtonText: 'TIẾP TỤC THANH TOÁN',
            cancelButtonText: 'HUỶ BỎ'
        }).then((result) => {
            if (result.isConfirmed) {
                const radio = document.querySelector(`input[value="${method}"]`);
                if (radio) radio.checked = true;
                document.getElementById('checkoutForm').submit();
            }
        });
    });
});

// ==================== DISCOUNT CALCULATION ====================
function calculateDiscount() {
    const select = document.getElementById('promotionSelect');
    const selectedOption = select.options[select.selectedIndex];
    const messageDiv = document.getElementById('promotionMessage');

    if (select.value === '0') {
        currentDiscount = 0;
        updateTotalDisplay(0);
        messageDiv.innerHTML = '';
        return;
    }

    const type = selectedOption.getAttribute('data-type');
    const value = parseFloat(selectedOption.getAttribute('data-value'));
    const minOrder = parseFloat(selectedOption.getAttribute('data-min'));
    const maxDiscount = parseFloat(selectedOption.getAttribute('data-max'));

    if (minOrder > 0 && originalTotal < minOrder) {
        messageDiv.innerHTML = '<div class="promotion-error">Yêu cầu đơn hàng tối thiểu ' + formatNumber(minOrder) + ' ₫</div>';
        select.value = '0';
        updateTotalDisplay(0);
        return;
    }

    if (type === 'PERCENT') {
        currentDiscount = originalTotal * (value / 100);
        if (maxDiscount > 0 && currentDiscount > maxDiscount) currentDiscount = maxDiscount;
    } else {
        currentDiscount = value;
        if (currentDiscount > originalTotal) currentDiscount = originalTotal;
    }

    updateTotalDisplay(currentDiscount);
    messageDiv.innerHTML = '<div class="promotion-success">✓ Đã áp dụng mã giảm giá! Tiết kiệm ' + formatNumber(currentDiscount) + ' ₫</div>';
}

function updateTotalDisplay(discount) {
    currentDiscount = discount;
    const finalAmount = originalTotal - currentDiscount;
    const discountRow = document.getElementById('discountRow');
    
    if (discountRow) {
        if (discount > 0) {
            discountRow.style.display = 'flex';
            document.getElementById('discountValue').innerHTML = '- ' + formatNumber(discount) + ' <small>₫</small>';
        } else {
            discountRow.style.display = 'none';
        }
    }
    document.getElementById('finalTotal').innerHTML = formatNumber(finalAmount) + ' <small>₫</small>';
}

function formatNumber(num) {
    return Math.round(num).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
}

// ==================== FORM SUBMISSION ====================
document.getElementById('checkoutForm').addEventListener('submit', function (e) {
    e.preventDefault();
    const form = this;
    const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');

    if (!paymentMethod) {
        Swal.fire({
            ...swalLuxuryConfig,
            icon: 'warning',
            title: 'THÔNG BÁO',
            text: 'Vui lòng chọn phương thức thanh toán!',
            confirmButtonText: 'ĐÃ HIỂU'
        });
        return;
    }

    const finalAmount = originalTotal - currentDiscount;
    const formattedAmount = formatNumber(finalAmount);
    const method = paymentMethod.value;

    // ✅ XỬ LÝ VNPAY
    if (method === 'VNPAY') {
        if (!selectedBank) {
            Swal.fire({
                ...swalLuxuryConfig,
                icon: 'warning',
                title: 'THIẾU THÔNG TIN',
                text: 'Vui lòng chọn ngân hàng để tiếp tục!',
                confirmButtonText: 'OK'
            });
            return;
        }

        const cardNumber = document.querySelector('.demo-input[placeholder*="Số thẻ"]').value.trim();
        const cardName = document.querySelector('.demo-input[placeholder*="Tên chủ thẻ"]').value.trim();
        const otp = document.querySelector('.demo-input[placeholder*="OTP"]').value.trim();

        if (!cardNumber || !cardName || !otp) {
            Swal.fire({
                ...swalLuxuryConfig,
                icon: 'error',
                title: 'THIẾU THÔNG TIN',
                text: 'Vui lòng nhập đầy đủ thông tin thẻ (Demo)!',
                confirmButtonText: 'QUAY LẠI'
            });
            return;
        }

        // Processing Effect
        const btn = document.querySelector('.btn-primary');
        const originalText = btn.textContent;
        btn.textContent = '⏳ ĐANG XỬ LÝ...';
        btn.disabled = true;

        setTimeout(() => {
            Swal.fire({
                ...swalLuxuryConfig,
                title: 'XÁC NHẬN THANH TOÁN',
                html: `
                    <div style="text-align: left; font-size: 14px; line-height: 1.8; color: #ddd; padding: 10px; background: rgba(255,255,255,0.05); border-radius: 8px;">
                        <p style="margin: 5px 0;">🏦 <b>Ngân hàng:</b> <span style="color: #DFBD69">${selectedBank}</span></p>
                        <p style="margin: 5px 0;">💳 <b>Số thẻ:</b> ${cardNumber}</p>
                        <p style="margin: 5px 0;">💰 <b>Tổng tiền:</b> <span style="color: #4cd137; font-weight: bold; font-size: 18px;">${formattedAmount} ₫</span></p>
                        <hr style="border-color: rgba(255,255,255,0.1); margin: 10px 0;">
                        <p style="color: #fca5a5; font-style: italic; font-size: 13px; text-align: center;">
                            ⚠️ Đây là môi trường Demo (Sandbox)
                        </p>
                    </div>
                `,
                icon: 'info',
                showCancelButton: true,
                confirmButtonText: 'XÁC NHẬN TRỪ TIỀN',
                cancelButtonText: 'QUAY LẠI'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                } else {
                    btn.textContent = originalText;
                    btn.disabled = false;
                }
            });
        }, 1500);
        return;
    }

    // ✅ XỬ LÝ MOMO & BANKING
    Swal.fire({
        ...swalLuxuryConfig,
        title: 'XÁC NHẬN DEMO',
        html: `
            <div style="font-size: 15px; color: #ddd;">
                <p>Số tiền: <b style="color: #DFBD69; font-size: 20px;">${formattedAmount} ₫</b></p>
                <p>Phương thức: <b>${method}</b></p>
                <br>
                <p style="color: #fca5a5; font-size: 13px;">⚠️ Không trừ tiền thật</p>
            </div>
        `,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'HOÀN TẤT',
        cancelButtonText: 'HUỶ'
    }).then((result) => {
        if (result.isConfirmed) {
            form.submit();
        }
    });
});

// ==================== DEMO INPUT AUTO-FILL ====================
document.querySelectorAll('.demo-input').forEach(input => {
    input.addEventListener('focus', function () {
        if (!this.value || this.value === this.placeholder) {
            if (this.placeholder.includes('Số thẻ')) {
                this.value = '9704 1234 5678 9012';
            } else if (this.placeholder.includes('Tên chủ thẻ')) {
                this.value = 'NGUYEN VAN A';
            } else if (this.placeholder.includes('OTP')) {
                this.value = '123456';
            }
        }
    });
});

console.log('✅ Checkout JS Loaded with Luxury Theme');