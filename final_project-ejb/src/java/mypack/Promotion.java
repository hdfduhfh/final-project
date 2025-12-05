/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.persistence.Basic;
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
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "Promotion")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Promotion.findAll", query = "SELECT p FROM Promotion p"),
    @NamedQuery(name = "Promotion.findByPromotionID", query = "SELECT p FROM Promotion p WHERE p.promotionID = :promotionID"),
    @NamedQuery(name = "Promotion.findByName", query = "SELECT p FROM Promotion p WHERE p.name = :name"),
    @NamedQuery(name = "Promotion.findByCode", query = "SELECT p FROM Promotion p WHERE p.code = :code"),
    @NamedQuery(name = "Promotion.findByDiscountType", query = "SELECT p FROM Promotion p WHERE p.discountType = :discountType"),
    @NamedQuery(name = "Promotion.findByDiscountValue", query = "SELECT p FROM Promotion p WHERE p.discountValue = :discountValue"),
    @NamedQuery(name = "Promotion.findByMinOrderAmount", query = "SELECT p FROM Promotion p WHERE p.minOrderAmount = :minOrderAmount"),
    @NamedQuery(name = "Promotion.findByMaxDiscount", query = "SELECT p FROM Promotion p WHERE p.maxDiscount = :maxDiscount"),
    @NamedQuery(name = "Promotion.findByStartDate", query = "SELECT p FROM Promotion p WHERE p.startDate = :startDate"),
    @NamedQuery(name = "Promotion.findByEndDate", query = "SELECT p FROM Promotion p WHERE p.endDate = :endDate"),
    @NamedQuery(name = "Promotion.findByStatus", query = "SELECT p FROM Promotion p WHERE p.status = :status"),
    @NamedQuery(name = "Promotion.findByMaxUsage", query = "SELECT p FROM Promotion p WHERE p.maxUsage = :maxUsage"),
    @NamedQuery(name = "Promotion.findByMaxUsagePerUser", query = "SELECT p FROM Promotion p WHERE p.maxUsagePerUser = :maxUsagePerUser")})
public class Promotion implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "PromotionID")
    private Integer promotionID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "Name")
    private String name;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "Code")
    private String code;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "DiscountType")
    private String discountType;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "DiscountValue")
    private BigDecimal discountValue;
    @Column(name = "MinOrderAmount")
    private BigDecimal minOrderAmount;
    @Column(name = "MaxDiscount")
    private BigDecimal maxDiscount;
    @Basic(optional = false)
    @NotNull
    @Column(name = "StartDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;
    @Basic(optional = false)
    @NotNull
    @Column(name = "EndDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "Status")
    private String status;
    @Column(name = "MaxUsage")
    private Integer maxUsage;
    @Column(name = "MaxUsagePerUser")
    private Integer maxUsagePerUser;
    @OneToMany(mappedBy = "promotionID")
    private Collection<Order1> order1Collection;

    public Promotion() {
    }

    public Promotion(Integer promotionID) {
        this.promotionID = promotionID;
    }

    public Promotion(Integer promotionID, String name, String code, String discountType, BigDecimal discountValue, Date startDate, Date endDate, String status) {
        this.promotionID = promotionID;
        this.name = name;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    public Integer getPromotionID() {
        return promotionID;
    }

    public void setPromotionID(Integer promotionID) {
        this.promotionID = promotionID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public BigDecimal getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(BigDecimal minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public BigDecimal getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(BigDecimal maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getMaxUsage() {
        return maxUsage;
    }

    public void setMaxUsage(Integer maxUsage) {
        this.maxUsage = maxUsage;
    }

    public Integer getMaxUsagePerUser() {
        return maxUsagePerUser;
    }

    public void setMaxUsagePerUser(Integer maxUsagePerUser) {
        this.maxUsagePerUser = maxUsagePerUser;
    }

    @XmlTransient
    public Collection<Order1> getOrder1Collection() {
        return order1Collection;
    }

    public void setOrder1Collection(Collection<Order1> order1Collection) {
        this.order1Collection = order1Collection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (promotionID != null ? promotionID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Promotion)) {
            return false;
        }
        Promotion other = (Promotion) object;
        if ((this.promotionID == null && other.promotionID != null) || (this.promotionID != null && !this.promotionID.equals(other.promotionID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Promotion[ promotionID=" + promotionID + " ]";
    }
    
}
