/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
/* Chat dock toggle */
const chatDock = document.getElementById("chatDock");
const chatIcon = document.getElementById("chatIcon");
const chatClose = document.getElementById("chatClose");

chatIcon.addEventListener("click", () => {
    chatDock.style.display = "flex";
    chatIcon.style.display = "none";
});

chatClose.addEventListener("click", () => {
    chatDock.style.display = "none";
    chatIcon.style.display = "flex";
});
