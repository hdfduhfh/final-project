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
@Table(name = "ShowSchedule", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "ShowSchedule.findAll", query = "SELECT s FROM ShowSchedule s"),
    @NamedQuery(name = "ShowSchedule.findByScheduleID", query = "SELECT s FROM ShowSchedule s WHERE s.scheduleID = :scheduleID"),
    @NamedQuery(name = "ShowSchedule.findByShowTime", query = "SELECT s FROM ShowSchedule s WHERE s.showTime = :showTime"),
    @NamedQuery(name = "ShowSchedule.findByStatus", query = "SELECT s FROM ShowSchedule s WHERE s.status = :status"),
    @NamedQuery(name = "ShowSchedule.findByCreatedAt", query = "SELECT s FROM ShowSchedule s WHERE s.createdAt = :createdAt")})
public class ShowSchedule implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ScheduleID", nullable = false)
    private Integer scheduleID;
    @Basic(optional = false)
    @Column(name = "ShowTime", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date showTime;
    @Basic(optional = false)
    @Column(name = "Status", nullable = false, length = 20)
    private String status;
    @Basic(optional = false)
    @Column(name = "CreatedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "scheduleID")
    private Collection<OrderDetail> orderDetailCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "scheduleID")
    private Collection<Feedback> feedbackCollection;
    @JoinColumn(name = "ShowID", referencedColumnName = "ShowID", nullable = false)
    @ManyToOne(optional = false)
    private Show showID;

    public ShowSchedule() {
    }

    public ShowSchedule(Integer scheduleID) {
        this.scheduleID = scheduleID;
    }

    public ShowSchedule(Integer scheduleID, Date showTime, String status, Date createdAt) {
        this.scheduleID = scheduleID;
        this.showTime = showTime;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Integer getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(Integer scheduleID) {
        this.scheduleID = scheduleID;
    }

    public Date getShowTime() {
        return showTime;
    }

    public void setShowTime(Date showTime) {
        this.showTime = showTime;
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

    public Collection<OrderDetail> getOrderDetailCollection() {
        return orderDetailCollection;
    }

    public void setOrderDetailCollection(Collection<OrderDetail> orderDetailCollection) {
        this.orderDetailCollection = orderDetailCollection;
    }

    public Collection<Feedback> getFeedbackCollection() {
        return feedbackCollection;
    }

    public void setFeedbackCollection(Collection<Feedback> feedbackCollection) {
        this.feedbackCollection = feedbackCollection;
    }

    public Show getShowID() {
        return showID;
    }

    public void setShowID(Show showID) {
        this.showID = showID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (scheduleID != null ? scheduleID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ShowSchedule)) {
            return false;
        }
        ShowSchedule other = (ShowSchedule) object;
        if ((this.scheduleID == null && other.scheduleID != null) || (this.scheduleID != null && !this.scheduleID.equals(other.scheduleID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.ShowSchedule[ scheduleID=" + scheduleID + " ]";
    }
    
}
