// Toggle password (PHẢI Ở GLOBAL)
function togglePassword(inputId, icon) {
    var input = document.getElementById(inputId);
    if (!input) return;

    if (input.type === "password") {
        input.type = "text";
        icon.style.opacity = "0.5";
    } else {
        input.type = "password";
        icon.style.opacity = "1";
    }
}

// Mobile menu
document.addEventListener("DOMContentLoaded", function () {
    const hamburger = document.getElementById('hamburger');
    const nav = document.querySelector('.nav');

    if (hamburger && nav) {
        hamburger.addEventListener('click', () => {
            const isOpen = nav.style.display === 'block';
            nav.style.display = isOpen ? 'none' : 'block';
        });
    }
});
