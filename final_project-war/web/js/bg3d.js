/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


/* Background 3D với Three.js */

/* Background 3D với Three.js - Phiên bản "Golden Stardust" */

(function () {
    const container = document.getElementById('bg3d');
    if (!container) return;

    // 1. Khởi tạo Scene
    const scene = new THREE.Scene();
    
    // Thêm sương mù (Fog) để tạo chiều sâu, làm các hạt ở xa mờ dần vào bóng tối
    scene.fog = new THREE.FogExp2(0x000000, 0.002);

    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 1000);
    camera.position.z = 100; // Đưa camera ra xa hơn một chút

    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(window.devicePixelRatio); // Để nét trên màn hình Retina
    container.appendChild(renderer.domElement);

    // 2. Tạo Texture phát sáng (Glow) bằng Code (không cần file ảnh)
    // Giúp hạt trông như đốm sáng thay vì hình vuông hay hình tròn cứng
    function createGlowTexture() {
        const canvas = document.createElement('canvas');
        canvas.width = 32;
        canvas.height = 32;
        const context = canvas.getContext('2d');
        const gradient = context.createRadialGradient(16, 16, 0, 16, 16, 16);
        gradient.addColorStop(0, 'rgba(255, 255, 255, 1)'); // Tâm trắng
        gradient.addColorStop(0.2, 'rgba(255, 215, 0, 1)'); // Viền vàng (Gold)
        gradient.addColorStop(0.5, 'rgba(255, 215, 0, 0.2)'); // Lan tỏa mờ
        gradient.addColorStop(1, 'rgba(0, 0, 0, 0)'); // Trong suốt ngoài cùng
        context.fillStyle = gradient;
        context.fillRect(0, 0, 32, 32);
        const texture = new THREE.Texture(canvas);
        texture.needsUpdate = true;
        return texture;
    }

    // 3. Tạo hệ thống hạt (Particles System)
    const particleCount = 1000; // Tăng số lượng lên 1000 hạt
    const geometry = new THREE.BufferGeometry();
    const positions = [];
    const colors = [];
    const sizes = [];

    const color = new THREE.Color();

    for (let i = 0; i < particleCount; i++) {
        // Vị trí ngẫu nhiên rộng hơn
        const x = (Math.random() * 2 - 1) * 200;
        const y = (Math.random() * 2 - 1) * 200;
        const z = (Math.random() * 2 - 1) * 200;
        positions.push(x, y, z);

        // Màu sắc: Random giữa Vàng Gold và Trắng để lấp lánh
        // Gold: 1.0, 0.84, 0
        const mix = Math.random();
        color.setHSL(0.12, 1.0, 0.5 + mix * 0.5); // Tông vàng sáng
        colors.push(color.r, color.g, color.b);

        // Kích thước ngẫu nhiên
        sizes.push(Math.random() * 2);
    }

    geometry.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
    geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
    geometry.setAttribute('size', new THREE.Float32BufferAttribute(sizes, 1).setUsage(THREE.DynamicDrawUsage));

    // Material xịn hơn
    const material = new THREE.PointsMaterial({
        size: 1.5,
        map: createGlowTexture(), // Dùng texture tự tạo
        transparent: true,
        opacity: 0.8,
        vertexColors: true, // Cho phép mỗi hạt một màu
        blending: THREE.AdditiveBlending, // Quan trọng: Cộng hưởng ánh sáng (làm sáng rực chỗ hạt chồng lên nhau)
        depthWrite: false // Giúp các hạt không che khuất nhau kiểu khối đặc
    });

    const particles = new THREE.Points(geometry, material);
    scene.add(particles);

    // 4. Xử lý tương tác chuột (Mouse Interaction) - Tạo hiệu ứng 3D Parallax
    let mouseX = 0;
    let mouseY = 0;
    let targetX = 0;
    let targetY = 0;

    const windowHalfX = window.innerWidth / 2;
    const windowHalfY = window.innerHeight / 2;

    document.addEventListener('mousemove', (event) => {
        mouseX = (event.clientX - windowHalfX) * 0.1;
        mouseY = (event.clientY - windowHalfY) * 0.1;
    });

    // 5. Animation Loop
    const clock = new THREE.Clock();

    function animate() {
        requestAnimationFrame(animate);

        const elapsedTime = clock.getElapsedTime();

        // Xoay toàn bộ hệ thống hạt nhẹ nhàng
        particles.rotation.y += 0.0005;
        particles.rotation.x += 0.0002;

        // Hiệu ứng "Thở" (Pulse): Làm các hạt phập phồng nhẹ
        const sizes = geometry.attributes.size.array;
        for (let i = 0; i < particleCount; i++) {
             // Thay đổi kích thước theo sóng sin để tạo cảm giác lấp lánh
             sizes[i] = (Math.sin(elapsedTime * 2 + i) * 0.5 + 1) * 2; 
        }
        geometry.attributes.size.needsUpdate = true;

        // Camera di chuyển mượt theo chuột (Parallax)
        targetX = mouseX * 0.5;
        targetY = mouseY * 0.5;
        camera.position.x += (targetX - camera.position.x) * 0.05;
        camera.position.y += (-targetY - camera.position.y) * 0.05;
        camera.lookAt(scene.position);

        renderer.render(scene, camera);
    }

    animate();

    // Resize handler
    window.addEventListener('resize', () => {
        const width = window.innerWidth;
        const height = window.innerHeight;
        renderer.setSize(width, height);
        camera.aspect = width / height;
        camera.updateProjectionMatrix();
    });
})();
