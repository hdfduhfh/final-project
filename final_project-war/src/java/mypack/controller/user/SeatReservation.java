/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import java.io.Serializable;
import java.util.Date;

public class SeatReservation implements Serializable {
    private int seatId;
    private int scheduleId;
    private String sessionId;
    private Integer userId;  // NULL nếu chưa login
    private Date reservedAt;
    private static final long RESERVATION_TIMEOUT = 10 * 60 * 1000; // 10 phút

    public SeatReservation() {
    }

    // Constructor với sessionId (cho user chưa login)
    public SeatReservation(int seatId, int scheduleId, String sessionId) {
        this.seatId = seatId;
        this.scheduleId = scheduleId;
        this.sessionId = sessionId;
        this.userId = null;
        this.reservedAt = new Date();
    }

    // Constructor với userId (cho user đã login)
    public SeatReservation(int seatId, int scheduleId, String sessionId, Integer userId) {
        this.seatId = seatId;
        this.scheduleId = scheduleId;
        this.sessionId = sessionId;
        this.userId = userId;
        this.reservedAt = new Date();
    }

    // Kiểm tra xem ghế còn bị khóa không
    public boolean isExpired() {
        long now = System.currentTimeMillis();
        long reserved = reservedAt.getTime();
        return (now - reserved) > RESERVATION_TIMEOUT;
    }

    // Lấy thời gian còn lại (milliseconds)
    public long getTimeRemaining() {
        long now = System.currentTimeMillis();
        long reserved = reservedAt.getTime();
        long elapsed = now - reserved;
        return Math.max(0, RESERVATION_TIMEOUT - elapsed);
    }

    // Kiểm tra xem reservation có thuộc về user/session này không
    public boolean belongsTo(String sessionId, Integer userId) {
        // Nếu có userId, ưu tiên check userId
        if (this.userId != null && userId != null) {
            return this.userId.equals(userId);
        }
        // Nếu không có userId, check sessionId
        return this.sessionId.equals(sessionId);
    }

    // Getters & Setters
    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getReservedAt() {
        return reservedAt;
    }

    public void setReservedAt(Date reservedAt) {
        this.reservedAt = reservedAt;
    }
}