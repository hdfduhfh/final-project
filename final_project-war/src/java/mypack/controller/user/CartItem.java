/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack.controller.user;

import java.io.Serializable;

public class CartItem implements Serializable {
    private int seatID;
    private String seatNumber;
    private String seatType;
    private int scheduleID;
    private String showName;
    private double price;

    public CartItem() {
    }

    public CartItem(int seatID, String seatNumber, String seatType, int scheduleID, String showName, double price) {
        this.seatID = seatID;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.scheduleID = scheduleID;
        this.showName = showName;
        this.price = price;
    }

    // Getter & Setter
    public int getSeatID() { return seatID; }
    public void setSeatID(int seatID) { this.seatID = seatID; }

    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }

    public int getScheduleID() { return scheduleID; }
    public void setScheduleID(int scheduleID) { this.scheduleID = scheduleID; }

    public String getShowName() { return showName; }
    public void setShowName(String showName) { this.showName = showName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
