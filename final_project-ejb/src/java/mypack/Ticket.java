/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "Ticket", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Ticket.findAll", query = "SELECT t FROM Ticket t"),
    @NamedQuery(name = "Ticket.findByTicketID", query = "SELECT t FROM Ticket t WHERE t.ticketID = :ticketID"),
    @NamedQuery(name = "Ticket.findByQRCode", query = "SELECT t FROM Ticket t WHERE t.qRCode = :qRCode"),
    @NamedQuery(name = "Ticket.findByStatus", query = "SELECT t FROM Ticket t WHERE t.status = :status"),
    @NamedQuery(name = "Ticket.findByIssuedAt", query = "SELECT t FROM Ticket t WHERE t.issuedAt = :issuedAt"),
    @NamedQuery(name = "Ticket.findByCheckInAt", query = "SELECT t FROM Ticket t WHERE t.checkInAt = :checkInAt"),
    @NamedQuery(name = "Ticket.findByCreatedAt", query = "SELECT t FROM Ticket t WHERE t.createdAt = :createdAt"),
    @NamedQuery(name = "Ticket.findByUpdatedAt", query = "SELECT t FROM Ticket t WHERE t.updatedAt = :updatedAt")})
public class Ticket implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "TicketID", nullable = false)
    private Integer ticketID;
    @Column(name = "QRCode", length = 100)
    private String qRCode;
    @Basic(optional = false)
    @Column(name = "Status", nullable = false, length = 20)
    private String status;
    @Basic(optional = false)
    @Column(name = "IssuedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date issuedAt;
    @Column(name = "CheckInAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date checkInAt;
    @Basic(optional = false)
    @Column(name = "CreatedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "UpdatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @JoinColumn(name = "OrderDetailID", referencedColumnName = "OrderDetailID", nullable = false)
    @ManyToOne(optional = false)
    private OrderDetail orderDetailID;
    @Column(name = "DeletedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deletedAt;

    @Column(name = "DeletedBy", length = 100)
    private String deletedBy; // Admin nào xóa

    @Column(name = "DeleteReason", length = 500)
    private String deleteReason; // Lý do xóa

// Getters & Setters
    public Date getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Date deletedAt) {
        this.deletedAt = deletedAt;
    }

    public String getDeletedBy() {
        return deletedBy;
    }

    public void setDeletedBy(String deletedBy) {
        this.deletedBy = deletedBy;
    }

    public String getDeleteReason() {
        return deleteReason;
    }

    public void setDeleteReason(String deleteReason) {
        this.deleteReason = deleteReason;
    }

    public Ticket() {
    }

    public Ticket(Integer ticketID) {
        this.ticketID = ticketID;
    }

    public Ticket(Integer ticketID, String status, Date issuedAt, Date createdAt) {
        this.ticketID = ticketID;
        this.status = status;
        this.issuedAt = issuedAt;
        this.createdAt = createdAt;
    }

    public Integer getTicketID() {
        return ticketID;
    }

    public void setTicketID(Integer ticketID) {
        this.ticketID = ticketID;
    }

    public String getQRCode() {
        return qRCode;
    }

    public void setQRCode(String qRCode) {
        this.qRCode = qRCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(Date issuedAt) {
        this.issuedAt = issuedAt;
    }

    public Date getCheckInAt() {
        return checkInAt;
    }

    public void setCheckInAt(Date checkInAt) {
        this.checkInAt = checkInAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public OrderDetail getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(OrderDetail orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (ticketID != null ? ticketID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Ticket)) {
            return false;
        }
        Ticket other = (Ticket) object;
        if ((this.ticketID == null && other.ticketID != null) || (this.ticketID != null && !this.ticketID.equals(other.ticketID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Ticket[ ticketID=" + ticketID + " ]";
    }

}
