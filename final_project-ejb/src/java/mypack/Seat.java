/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "Seat")
@XmlRootElement
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
    @Column(name = "SeatID")
    private Integer seatID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "SeatNumber")
    private String seatNumber;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "SeatType")
    private String seatType;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 5)
    @Column(name = "RowLabel")
    private String rowLabel;
    @Basic(optional = false)
    @NotNull
    @Column(name = "ColumnNumber")
    private int columnNumber;
    @Basic(optional = false)
    @NotNull
    @Column(name = "IsActive")
    private boolean isActive;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CreatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "seatID")
    private Collection<Ticket> ticketCollection;

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

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @XmlTransient
    public Collection<Ticket> getTicketCollection() {
        return ticketCollection;
    }

    public void setTicketCollection(Collection<Ticket> ticketCollection) {
        this.ticketCollection = ticketCollection;
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
