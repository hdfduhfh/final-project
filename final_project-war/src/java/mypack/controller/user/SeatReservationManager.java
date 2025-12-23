/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SeatReservationManager {
    private static SeatReservationManager instance;
    
    // Key: "seatId-scheduleId", Value: SeatReservation
    private Map<String, SeatReservation> reservations;
    
    // Scheduled task để tự động xóa ghế hết hạn
    private ScheduledExecutorService scheduler;

    private SeatReservationManager() {
        reservations = new ConcurrentHashMap<>();
        
        // Chạy task tự động xóa ghế hết hạn mỗi 30 giây
        scheduler = Executors.newScheduledThreadPool(1);
        scheduler.scheduleAtFixedRate(() -> {
            cleanupExpiredReservations();
        }, 30, 30, TimeUnit.SECONDS);
    }

    public static synchronized SeatReservationManager getInstance() {
        if (instance == null) {
            instance = new SeatReservationManager();
        }
        return instance;
    }

    // Tạo key duy nhất cho ghế
    private String makeKey(int seatId, int scheduleId) {
        return seatId + "-" + scheduleId;
    }

    // Đặt chỗ ghế (thêm vào reservation)
    public synchronized boolean reserveSeat(int seatId, int scheduleId, String sessionId, Integer userId) {
        String key = makeKey(seatId, scheduleId);
        
        // Kiểm tra ghế đã được đặt chưa
        SeatReservation existing = reservations.get(key);
        if (existing != null) {
            // Nếu hết hạn thì xóa và cho đặt mới
            if (existing.isExpired()) {
                reservations.remove(key);
            } else {
                // Nếu cùng user/session thì cho phép (refresh)
                if (existing.belongsTo(sessionId, userId)) {
                    reservations.put(key, new SeatReservation(seatId, scheduleId, sessionId, userId));
                    return true;
                }
                // Khác user/session và chưa hết hạn → không cho đặt
                return false;
            }
        }
        
        // Tạo reservation mới
        reservations.put(key, new SeatReservation(seatId, scheduleId, sessionId, userId));
        return true;
    }

    // Kiểm tra ghế có bị đặt không
    public synchronized boolean isReserved(int seatId, int scheduleId, String currentSessionId, Integer currentUserId) {
        String key = makeKey(seatId, scheduleId);
        SeatReservation reservation = reservations.get(key);
        
        if (reservation == null) {
            return false;
        }
        
        // Nếu hết hạn thì xóa
        if (reservation.isExpired()) {
            reservations.remove(key);
            return false;
        }
        
        // Nếu cùng user/session thì không coi là reserved (cho phép remove)
        if (reservation.belongsTo(currentSessionId, currentUserId)) {
            return false;
        }
        
        return true;
    }

    // Hủy reservation khi user xóa khỏi giỏ hàng hoặc thanh toán
    public synchronized void releaseReservation(int seatId, int scheduleId) {
        String key = makeKey(seatId, scheduleId);
        reservations.remove(key);
    }

    // Hủy tất cả reservation của một session (khi logout - KHÔNG dùng nữa)
    @Deprecated
    public synchronized void releaseSessionReservations(String sessionId) {
        // Không xóa nữa vì cần giữ reservation cho userId
    }

    // Chuyển reservation từ sessionId sang userId (khi login)
    public synchronized void transferReservationsToUser(String sessionId, Integer userId) {
        for (Map.Entry<String, SeatReservation> entry : reservations.entrySet()) {
            SeatReservation reservation = entry.getValue();
            if (reservation.getSessionId().equals(sessionId) && reservation.getUserId() == null) {
                reservation.setUserId(userId);
            }
        }
    }

    // Lấy tất cả reservation của user (khi login lại)
    public synchronized Map<String, SeatReservation> getUserReservations(Integer userId) {
        Map<String, SeatReservation> userReservations = new ConcurrentHashMap<>();
        for (Map.Entry<String, SeatReservation> entry : reservations.entrySet()) {
            SeatReservation reservation = entry.getValue();
            if (reservation.getUserId() != null && reservation.getUserId().equals(userId)) {
                if (!reservation.isExpired()) {
                    userReservations.put(entry.getKey(), reservation);
                }
            }
        }
        return userReservations;
    }

    // Xóa tất cả reservation hết hạn
    private synchronized void cleanupExpiredReservations() {
        reservations.entrySet().removeIf(entry -> entry.getValue().isExpired());
    }

    // Lấy thông tin reservation (để hiển thị countdown)
    public synchronized SeatReservation getReservation(int seatId, int scheduleId) {
        String key = makeKey(seatId, scheduleId);
        SeatReservation reservation = reservations.get(key);
        
        if (reservation != null && reservation.isExpired()) {
            reservations.remove(key);
            return null;
        }
        
        return reservation;
    }

    // Shutdown scheduler khi server stop
    public void shutdown() {
        if (scheduler != null) {
            scheduler.shutdown();
        }
    }
}