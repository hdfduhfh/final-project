/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "Seat", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Seat.findAll", query = "SELECT s FROM Seat s"),
    @NamedQuery(name = "Seat.findBySeatID", query = "SELECT s FROM Seat s WHERE s.seatID = :seatID"),
    @NamedQuery(name = "Seat.findBySeatNumber", query = "SELECT s FROM Seat s WHERE s.seatNumber = :seatNumber"),
    @NamedQuery(name = "Seat.findBySeatType", query = "SELECT s FROM Seat s WHERE s.seatType = :seatType"),
    @NamedQuery(name = "Seat.findByRowLabel", query = "SELECT s FROM Seat s WHERE s.rowLabel = :rowLabel"),
    @NamedQuery(name = "Seat.findByColumnNumber", query = "SELECT s FROM Seat s WHERE s.columnNumber = :columnNumber"),
    @NamedQuery(name = "Seat.findByIsActive", query = "SELECT s FROM Seat s WHERE s.isActive = :isActive"),
    @NamedQuery(name = "Seat.findByCreatedAt", query = "SELECT s FROM Seat s WHERE s.createdAt = :createdAt")})
public class Seat implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "SeatID", nullable = false)
    private Integer seatID;
    @Basic(optional = false)
    @Column(name = "SeatNumber", nullable = false, length = 10)
    private String seatNumber;
    @Basic(optional = false)
    @Column(name = "SeatType", nullable = false, length = 20)
    private String seatType;
    @Basic(optional = false)
    @Column(name = "RowLabel", nullable = false, length = 5)
    private String rowLabel;
    @Basic(optional = false)
    @Column(name = "ColumnNumber", nullable = false)
    private int columnNumber;
    @Basic(optional = false)
    @Column(name = "IsActive", nullable = false)
    private boolean isActive;
    @Basic(optional = false)
    @Column(name = "Price", nullable = false)
    private double price;
    @Basic(optional = false)
    @Column(name = "CreatedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "seatID")
    private Collection<OrderDetail> orderDetailCollection;

    public Seat() {
    }

    public Seat(Integer seatID) {
        this.seatID = seatID;
    }

    public Seat(Integer seatID, String seatNumber, String seatType, String rowLabel, int columnNumber, boolean isActive, Date createdAt) {
        this.seatID = seatID;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.rowLabel = rowLabel;
        this.columnNumber = columnNumber;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public Integer getSeatID() {
        return seatID;
    }

    public void setSeatID(Integer seatID) {
        this.seatID = seatID;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public String getRowLabel() {
        return rowLabel;
    }

    public void setRowLabel(String rowLabel) {
        this.rowLabel = rowLabel;
    }

    public int getColumnNumber() {
        return columnNumber;
    }

    public void setColumnNumber(int columnNumber) {
        this.columnNumber = columnNumber;
    }

    public boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Collection<OrderDetail> getOrderDetailCollection() {
        return orderDetailCollection;
    }

    public void setOrderDetailCollection(Collection<OrderDetail> orderDetailCollection) {
        this.orderDetailCollection = orderDetailCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (seatID != null ? seatID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Seat)) {
            return false;
        }
        Seat other = (Seat) object;
        if ((this.seatID == null && other.seatID != null) || (this.seatID != null && !this.seatID.equals(other.seatID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Seat[ seatID=" + seatID + " ]";
    }

}
