package mypack;

import java.io.Serializable;
import java.math.BigDecimal;
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
 * Entity cho Bảng Event - Quản lý sự kiện giao lưu nghệ sĩ
 * CHỈ 1 BẢNG DUY NHẤT
 * @author DANG KHOA
 */
@Entity
@Table(name = "Event", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Event.findAll", query = "SELECT e FROM Event e ORDER BY e.eventDate DESC"),
    @NamedQuery(name = "Event.findByEventID", query = "SELECT e FROM Event e WHERE e.eventID = :eventID"),
    @NamedQuery(name = "Event.findByStatus", query = "SELECT e FROM Event e WHERE e.status = :status ORDER BY e.eventDate ASC"),
    @NamedQuery(name = "Event.findUpcoming", query = "SELECT e FROM Event e WHERE e.status = 'Upcoming' AND e.isPublished = true ORDER BY e.eventDate ASC"),
    @NamedQuery(name = "Event.findByEventType", query = "SELECT e FROM Event e WHERE e.eventType = :eventType ORDER BY e.eventDate DESC"),
    @NamedQuery(name = "Event.findPublished", query = "SELECT e FROM Event e WHERE e.isPublished = true ORDER BY e.eventDate DESC")
})
public class Event implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "EventID", nullable = false)
    private Integer eventID;

    @Basic(optional = false)
    @Column(name = "EventName", nullable = false, length = 200)
    private String eventName;

    @Column(name = "Description", columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Basic(optional = false)
    @Column(name = "EventType", nullable = false, length = 50)
    private String eventType; // 'MeetAndGreet', 'Workshop', 'FanMeeting', 'TalkShow'

    @Basic(optional = false)
    @Column(name = "EventDate", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date eventDate;

    @Column(name = "EndDate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;

    @Column(name = "Venue", length = 200)
    private String venue;

    @Column(name = "Address", length = 300)
    private String address;

    @Basic(optional = false)
    @Column(name = "MaxAttendees", nullable = false)
    private int maxAttendees;

    @Basic(optional = false)
    @Column(name = "CurrentAttendees", nullable = false)
    private int currentAttendees;

    @Basic(optional = false)
    @Column(name = "Price", nullable = false, precision = 12, scale = 2)
    private BigDecimal price;

    @Basic(optional = false)
    @Column(name = "Status", nullable = false, length = 20)
    private String status; // 'Upcoming', 'Ongoing', 'Completed', 'Cancelled'

    @Column(name = "ThumbnailUrl", length = 500)
    private String thumbnailUrl;

    @Column(name = "BannerUrl", length = 500)
    private String bannerUrl;

    @Column(name = "ArtistIDs", length = 200)
    private String artistIDs; // Danh sách ID nghệ sĩ phân cách bằng dấu phẩy "1,3,5"

    @Column(name = "ArtistNames", length = 500)
    private String artistNames; // Tên nghệ sĩ để hiển thị nhanh

    @Column(name = "HostedBy", length = 100)
    private String hostedBy;

    @Column(name = "ContactInfo", length = 200)
    private String contactInfo;

    @Basic(optional = false)
    @Column(name = "IsPublished", nullable = false)
    private boolean isPublished;

    @Basic(optional = false)
    @Column(name = "AllowRegistration", nullable = false)
    private boolean allowRegistration;

    @Column(name = "RegistrationDeadline")
    @Temporal(TemporalType.TIMESTAMP)
    private Date registrationDeadline;

    @Column(name = "Requirements", length = 500)
    private String requirements;

    @Basic(optional = false)
    @Column(name = "CreatedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "UpdatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    @JoinColumn(name = "CreatedBy", referencedColumnName = "UserID")
    @ManyToOne
    private User createdBy;

    // ========== CONSTRUCTORS ==========
    public Event() {
    }

    public Event(Integer eventID) {
        this.eventID = eventID;
    }

    public Event(Integer eventID, String eventName, String eventType, Date eventDate, 
                 int maxAttendees, BigDecimal price, String status, Date createdAt) {
        this.eventID = eventID;
        this.eventName = eventName;
        this.eventType = eventType;
        this.eventDate = eventDate;
        this.maxAttendees = maxAttendees;
        this.price = price;
        this.status = status;
        this.createdAt = createdAt;
    }

    // ========== GETTERS & SETTERS ==========
    public Integer getEventID() {
        return eventID;
    }

    public void setEventID(Integer eventID) {
        this.eventID = eventID;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getVenue() {
        return venue;
    }

    public void setVenue(String venue) {
        this.venue = venue;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getMaxAttendees() {
        return maxAttendees;
    }

    public void setMaxAttendees(int maxAttendees) {
        this.maxAttendees = maxAttendees;
    }

    public int getCurrentAttendees() {
        return currentAttendees;
    }

    public void setCurrentAttendees(int currentAttendees) {
        this.currentAttendees = currentAttendees;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getBannerUrl() {
        return bannerUrl;
    }

    public void setBannerUrl(String bannerUrl) {
        this.bannerUrl = bannerUrl;
    }

    public String getArtistIDs() {
        return artistIDs;
    }

    public void setArtistIDs(String artistIDs) {
        this.artistIDs = artistIDs;
    }

    public String getArtistNames() {
        return artistNames;
    }

    public void setArtistNames(String artistNames) {
        this.artistNames = artistNames;
    }

    public String getHostedBy() {
        return hostedBy;
    }

    public void setHostedBy(String hostedBy) {
        this.hostedBy = hostedBy;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public boolean isIsPublished() {
        return isPublished;
    }

    public void setIsPublished(boolean isPublished) {
        this.isPublished = isPublished;
    }

    public boolean isAllowRegistration() {
        return allowRegistration;
    }

    public void setAllowRegistration(boolean allowRegistration) {
        this.allowRegistration = allowRegistration;
    }

    public Date getRegistrationDeadline() {
        return registrationDeadline;
    }

    public void setRegistrationDeadline(Date registrationDeadline) {
        this.registrationDeadline = registrationDeadline;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
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

    public User getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

    // ========== HELPER METHODS ==========
    
    /**
     * Kiểm tra event đã đầy chỗ chưa
     */
    public boolean isFull() {
        return currentAttendees >= maxAttendees;
    }

    /**
     * Lấy số chỗ còn trống
     */
    public int getAvailableSlots() {
        return maxAttendees - currentAttendees;
    }

    /**
     * Kiểm tra event miễn phí
     */
    public boolean isFree() {
        return price.compareTo(BigDecimal.ZERO) == 0;
    }

    /**
     * Kiểm tra đã quá hạn đăng ký
     */
    public boolean isRegistrationClosed() {
        if (registrationDeadline == null) {
            return false;
        }
        return new Date().after(registrationDeadline);
    }

    /**
     * Kiểm tra có thể đăng ký không
     */
    public boolean canRegister() {
        return allowRegistration 
                && !isFull() 
                && !isRegistrationClosed() 
                && "Upcoming".equals(status);
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (eventID != null ? eventID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Event)) {
            return false;
        }
        Event other = (Event) object;
        if ((this.eventID == null && other.eventID != null) 
                || (this.eventID != null && !this.eventID.equals(other.eventID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Event[ eventID=" + eventID + ", eventName=" + eventName + " ]";
    }
}