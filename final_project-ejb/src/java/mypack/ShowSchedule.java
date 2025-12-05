package mypack;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "ShowSchedule")
public class ShowSchedule implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ScheduleID")
    private Integer scheduleID;

    // N lịch diễn - 1 show
    @ManyToOne(optional = false)
    @JoinColumn(name = "ShowID")
    private Show show;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ShowTime", nullable = false)
    private Date showTime;

    @Column(name = "Status", length = 20, nullable = false)
    private String status;

    @Column(name = "TotalSeats", nullable = false)
    private Integer totalSeats;

    @Column(name = "AvailableSeats", nullable = false)
    private Integer availableSeats;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt")
    private Date createdAt;

    public ShowSchedule() {
    }

    // ===== getters & setters =====

    public Integer getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(Integer scheduleID) {
        this.scheduleID = scheduleID;
    }

    public Show getShow() {
        return show;
    }

    public void setShow(Show show) {
        this.show = show;
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

    public Integer getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(Integer totalSeats) {
        this.totalSeats = totalSeats;
    }

    public Integer getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(Integer availableSeats) {
        this.availableSeats = availableSeats;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // ===== equals / hashCode / toString =====

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ShowSchedule)) return false;
        ShowSchedule other = (ShowSchedule) o;
        return scheduleID != null && scheduleID.equals(other.scheduleID);
    }

    @Override
    public int hashCode() {
        return scheduleID != null ? scheduleID.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "ShowSchedule{" +
                "scheduleID=" + scheduleID +
                ", showTime=" + showTime +
                '}';
    }
}
