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
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "ShowSchedule")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ShowSchedule.findAll", query = "SELECT s FROM ShowSchedule s"),
    @NamedQuery(name = "ShowSchedule.findByScheduleID", query = "SELECT s FROM ShowSchedule s WHERE s.scheduleID = :scheduleID"),
    @NamedQuery(name = "ShowSchedule.findByShowTime", query = "SELECT s FROM ShowSchedule s WHERE s.showTime = :showTime"),
    @NamedQuery(name = "ShowSchedule.findByStatus", query = "SELECT s FROM ShowSchedule s WHERE s.status = :status"),
    @NamedQuery(name = "ShowSchedule.findByTotalSeats", query = "SELECT s FROM ShowSchedule s WHERE s.totalSeats = :totalSeats"),
    @NamedQuery(name = "ShowSchedule.findByAvailableSeats", query = "SELECT s FROM ShowSchedule s WHERE s.availableSeats = :availableSeats"),
    @NamedQuery(name = "ShowSchedule.findByCreatedAt", query = "SELECT s FROM ShowSchedule s WHERE s.createdAt = :createdAt")})
public class ShowSchedule implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ScheduleID")
    private Integer scheduleID;
    @Basic(optional = false)
    @NotNull
    @Column(name = "ShowTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date showTime;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "Status")
    private String status;
    @Basic(optional = false)
    @NotNull
    @Column(name = "TotalSeats")
    private int totalSeats;
    @Basic(optional = false)
    @NotNull
    @Column(name = "AvailableSeats")
    private int availableSeats;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CreatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "scheduleID")
    private Collection<Ticket> ticketCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "scheduleID")
    private Collection<Feedback> feedbackCollection;
    @JoinColumn(name = "ShowID", referencedColumnName = "ShowID")
    @ManyToOne(optional = false)
    private Show showID;

    public ShowSchedule() {
    }

    public ShowSchedule(Integer scheduleID) {
        this.scheduleID = scheduleID;
    }

    public ShowSchedule(Integer scheduleID, Date showTime, String status, int totalSeats, int availableSeats, Date createdAt) {
        this.scheduleID = scheduleID;
        this.showTime = showTime;
        this.status = status;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
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

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
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

    @XmlTransient
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
