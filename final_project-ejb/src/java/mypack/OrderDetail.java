/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;
import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "OrderDetail", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "OrderDetail.findAll", query = "SELECT o FROM OrderDetail o"),
    @NamedQuery(name = "OrderDetail.findByOrderDetailID", query = "SELECT o FROM OrderDetail o WHERE o.orderDetailID = :orderDetailID"),
    @NamedQuery(name = "OrderDetail.findByPrice", query = "SELECT o FROM OrderDetail o WHERE o.price = :price"),
    @NamedQuery(name = "OrderDetail.findByQuantity", query = "SELECT o FROM OrderDetail o WHERE o.quantity = :quantity"),
    @NamedQuery(name = "OrderDetail.findByCreatedAt", query = "SELECT o FROM OrderDetail o WHERE o.createdAt = :createdAt")})
public class OrderDetail implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "OrderDetailID", nullable = false)
    private Integer orderDetailID;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @Column(name = "Price", nullable = false, precision = 12, scale = 2)
    private BigDecimal price;
    @Basic(optional = false)
    @Column(name = "Quantity", nullable = false)
    private int quantity;
    @Basic(optional = false)
    @Column(name = "CreatedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "orderDetailID")
    private Collection<Ticket> ticketCollection;
    @JoinColumn(name = "OrderID", referencedColumnName = "OrderID", nullable = false)
    @ManyToOne(optional = false)
    private Order1 orderID;
    @JoinColumn(name = "SeatID", referencedColumnName = "SeatID", nullable = false)
    @ManyToOne(optional = false)
    private Seat seatID;
    @JoinColumn(name = "ScheduleID", referencedColumnName = "ScheduleID", nullable = false)
    @ManyToOne(optional = false)
    private ShowSchedule scheduleID;

    public OrderDetail() {
    }

    public OrderDetail(Integer orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public OrderDetail(Integer orderDetailID, BigDecimal price, int quantity, Date createdAt) {
        this.orderDetailID = orderDetailID;
        this.price = price;
        this.quantity = quantity;
        this.createdAt = createdAt;
    }

    public Integer getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(Integer orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Collection<Ticket> getTicketCollection() {
        return ticketCollection;
    }

    public void setTicketCollection(Collection<Ticket> ticketCollection) {
        this.ticketCollection = ticketCollection;
    }

    public Order1 getOrderID() {
        return orderID;
    }

    public void setOrderID(Order1 orderID) {
        this.orderID = orderID;
    }

    public Seat getSeatID() {
        return seatID;
    }

    public void setSeatID(Seat seatID) {
        this.seatID = seatID;
    }

    public ShowSchedule getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(ShowSchedule scheduleID) {
        this.scheduleID = scheduleID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (orderDetailID != null ? orderDetailID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof OrderDetail)) {
            return false;
        }
        OrderDetail other = (OrderDetail) object;
        if ((this.orderDetailID == null && other.orderDetailID != null) || (this.orderDetailID != null && !this.orderDetailID.equals(other.orderDetailID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.OrderDetail[ orderDetailID=" + orderDetailID + " ]";
    }
    
}
