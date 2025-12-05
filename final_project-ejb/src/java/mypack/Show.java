package mypack;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "Show")
public class Show implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ShowID")
    private Integer showID;

    @Column(name = "ShowName", length = 150, nullable = false)
    private String showName;

    @Column(name = "Description", length = 255)
    private String description;

    @Column(name = "DurationMinutes", nullable = false)
    private Integer durationMinutes;

    @Column(name = "Status", length = 20, nullable = false)
    private String status;

    @Column(name = "ShowImage", length = 500)
    private String showImage;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt")
    private Date createdAt;

    // 1 Show - N lịch diễn
    @OneToMany(mappedBy = "show", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ShowSchedule> schedules = new ArrayList<>();

    // 1 Show - N bản ghi ShowArtist (N-N với Artist)
    @OneToMany(mappedBy = "show", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ShowArtist> showArtists = new ArrayList<>();

    public Show() {
    }

    // ===== getters & setters cơ bản =====

    public Integer getShowID() {
        return showID;
    }

    public void setShowID(Integer showID) {
        this.showID = showID;
    }

    public String getShowName() {
        return showName;
    }

    public void setShowName(String showName) {
        this.showName = showName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(Integer durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShowImage() {
        return showImage;
    }

    public void setShowImage(String showImage) {
        this.showImage = showImage;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<ShowSchedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<ShowSchedule> schedules) {
        this.schedules = schedules;
    }

    public List<ShowArtist> getShowArtists() {
        return showArtists;
    }

    public void setShowArtists(List<ShowArtist> showArtists) {
        this.showArtists = showArtists;
    }

    // ===== helper cho module Quản lý chương trình biểu diễn =====

    /** Thêm một suất diễn vào show này và set quan hệ 2 chiều. */
    public void addSchedule(ShowSchedule schedule) {
        schedules.add(schedule);
        schedule.setShow(this);
    }

    /** Xoá một suất diễn khỏi show này và clear quan hệ 2 chiều. */
    public void removeSchedule(ShowSchedule schedule) {
        schedules.remove(schedule);
        schedule.setShow(null);
    }

    /** Thêm một nghệ sĩ vào show (tạo bản ghi ShowArtist). */
    public void addArtist(Artist artist) {
        ShowArtist link = new ShowArtist();
        link.setShow(this);
        link.setArtist(artist);
        showArtists.add(link);
        artist.getShowArtists().add(link);
    }

    /** Gỡ nghệ sĩ khỏi show (xoá bản ghi ShowArtist tương ứng). */
    public void removeArtist(Artist artist) {
        showArtists.removeIf(link -> {
            if (link.getArtist() != null && link.getArtist().equals(artist)) {
                artist.getShowArtists().remove(link);
                link.setArtist(null);
                link.setShow(null);
                return true;
            }
            return false;
        });
    }

    // ===== equals / hashCode / toString =====

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Show)) return false;
        Show other = (Show) o;
        return showID != null && showID.equals(other.showID);
    }

    @Override
    public int hashCode() {
        return showID != null ? showID.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "Show{" +
                "showID=" + showID +
                ", showName='" + showName + '\'' +
                '}';
    }
}
