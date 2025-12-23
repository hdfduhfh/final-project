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
@Table(name = "[Order]", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Order1.findAll", query = "SELECT o FROM Order1 o"),
    @NamedQuery(name = "Order1.findByOrderID", query = "SELECT o FROM Order1 o WHERE o.orderID = :orderID"),
    @NamedQuery(name = "Order1.findByTotalAmount", query = "SELECT o FROM Order1 o WHERE o.totalAmount = :totalAmount"),
    @NamedQuery(name = "Order1.findByDiscountAmount", query = "SELECT o FROM Order1 o WHERE o.discountAmount = :discountAmount"),
    @NamedQuery(name = "Order1.findByFinalAmount", query = "SELECT o FROM Order1 o WHERE o.finalAmount = :finalAmount"),
    @NamedQuery(name = "Order1.findByPromotionCode", query = "SELECT o FROM Order1 o WHERE o.promotionCode = :promotionCode"),
    @NamedQuery(name = "Order1.findByPaymentMethod", query = "SELECT o FROM Order1 o WHERE o.paymentMethod = :paymentMethod"),
    @NamedQuery(name = "Order1.findByPaymentStatus", query = "SELECT o FROM Order1 o WHERE o.paymentStatus = :paymentStatus"),
    @NamedQuery(name = "Order1.findByTransactionCode", query = "SELECT o FROM Order1 o WHERE o.transactionCode = :transactionCode"),
    @NamedQuery(name = "Order1.findByPaidAt", query = "SELECT o FROM Order1 o WHERE o.paidAt = :paidAt"),
    @NamedQuery(name = "Order1.findByStatus", query = "SELECT o FROM Order1 o WHERE o.status = :status"),
    @NamedQuery(name = "Order1.findByCreatedAt", query = "SELECT o FROM Order1 o WHERE o.createdAt = :createdAt"),
    @NamedQuery(name = "Order1.findByUpdatedAt", query = "SELECT o FROM Order1 o WHERE o.updatedAt = :updatedAt")})
public class Order1 implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "OrderID", nullable = false)
    private Integer orderID;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @Column(name = "TotalAmount", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalAmount;
    @Basic(optional = false)
    @Column(name = "DiscountAmount", nullable = false, precision = 12, scale = 2)
    private BigDecimal discountAmount;
    @Basic(optional = false)
    @Column(name = "FinalAmount", nullable = false, precision = 12, scale = 2)
    private BigDecimal finalAmount;
    @Column(name = "PromotionCode", length = 50)
    private String promotionCode;
    @Column(name = "PaymentMethod", length = 30)
    private String paymentMethod;
    @Basic(optional = false)
    @Column(name = "PaymentStatus", nullable = false, length = 20)
    private String paymentStatus;
    @Column(name = "TransactionCode", length = 100)
    private String transactionCode;
    @Column(name = "PaidAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date paidAt;
    @Basic(optional = false)
    @Column(name = "Status", nullable = false, length = 20)
    private String status;
    @Basic(optional = false)
    @Column(name = "CreatedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "UpdatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    @JoinColumn(name = "PromotionID", referencedColumnName = "PromotionID")
    @ManyToOne
    private Promotion promotionID;
    @JoinColumn(name = "UserID", referencedColumnName = "UserID", nullable = false)
    @ManyToOne(optional = false)
    private User userID;
    @Column(name = "CancellationRequested")
    private Boolean cancellationRequested = false; // Mặc định là false (chưa yêu cầu)

    @Column(name = "CancellationReason", length = 500)
    private String cancellationReason; // Lưu lý do khách viết
    @Column(name = "RefundAmount", precision = 12, scale = 2)
    private BigDecimal refundAmount = BigDecimal.ZERO;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "orderID")
    private Collection<OrderDetail> orderDetailCollection;

    public Order1() {
    }

    public Order1(Integer orderID) {
        this.orderID = orderID;
    }

    public Order1(Integer orderID, BigDecimal totalAmount, BigDecimal discountAmount, BigDecimal finalAmount, String paymentStatus, String status, Date createdAt) {
        this.orderID = orderID;
        this.totalAmount = totalAmount;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.paymentStatus = paymentStatus;
        this.status = status;
        this.createdAt = createdAt;
    }

    public BigDecimal getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(BigDecimal refundAmount) {
        this.refundAmount = refundAmount;
    }

    public Boolean getCancellationRequested() {
        return cancellationRequested;
    }

    public void setCancellationRequested(Boolean cancellationRequested) {
        this.cancellationRequested = cancellationRequested;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getPromotionCode() {
        return promotionCode;
    }

    public void setPromotionCode(String promotionCode) {
        this.promotionCode = promotionCode;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getTransactionCode() {
        return transactionCode;
    }

    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }

    public Date getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Date paidAt) {
        this.paidAt = paidAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public Promotion getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(Promotion promotionID) {
        this.promotionID = promotionID;
    }

    public User getUserID() {
        return userID;
    }

    public void setUserID(User userID) {
        this.userID = userID;
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
        hash += (orderID != null ? orderID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Order1)) {
            return false;
        }
        Order1 other = (Order1) object;
        if ((this.orderID == null && other.orderID != null) || (this.orderID != null && !this.orderID.equals(other.orderID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Order1[ orderID=" + orderID + " ]";
    }

}
