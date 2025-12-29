package mypack;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.*;

/**
 * Entity cho Bảng EventRegistration - Quản lý đăng ký sự kiện
 * @author DANG KHOA
 */
@Entity
@Table(name = "EventRegistration", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "EventRegistration.findAll", 
                query = "SELECT e FROM EventRegistration e ORDER BY e.registrationDate DESC"),
    @NamedQuery(name = "EventRegistration.findByUser", 
                query = "SELECT e FROM EventRegistration e WHERE e.userID = :user ORDER BY e.registrationDate DESC"),
    @NamedQuery(name = "EventRegistration.findByEvent", 
                query = "SELECT e FROM EventRegistration e WHERE e.eventID = :event ORDER BY e.registrationDate ASC"),
    @NamedQuery(name = "EventRegistration.findByUserAndEvent", 
                query = "SELECT e FROM EventRegistration e WHERE e.userID = :user AND e.eventID = :event")
})
public class EventRegistration implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "RegistrationID", nullable = false)
    private Integer registrationID;

    @JoinColumn(name = "UserID", referencedColumnName = "UserID", nullable = false)
    @ManyToOne(optional = false)
    private User userID;

    @JoinColumn(name = "EventID", referencedColumnName = "EventID", nullable = false)
    @ManyToOne(optional = false)
    private Event eventID;

    @Basic(optional = false)
    @Column(name = "RegistrationDate", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date registrationDate;

    @Basic(optional = false)
    @Column(name = "Status", nullable = false, length = 20)
    private String status;

    // ========== CONSTRUCTORS ==========
    public EventRegistration() {
    }

    public EventRegistration(Integer registrationID) {
        this.registrationID = registrationID;
    }

    // ========== GETTERS & SETTERS ==========
    public Integer getRegistrationID() {
        return registrationID;
    }

    public void setRegistrationID(Integer registrationID) {
        this.registrationID = registrationID;
    }

    public User getUserID() {
        return userID;
    }

    public void setUserID(User userID) {
        this.userID = userID;
    }

    public Event getEventID() {
        return eventID;
    }

    public void setEventID(Event eventID) {
        this.eventID = eventID;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (registrationID != null ? registrationID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof EventRegistration)) {
            return false;
        }
        EventRegistration other = (EventRegistration) object;
        if ((this.registrationID == null && other.registrationID != null) 
                || (this.registrationID != null && !this.registrationID.equals(other.registrationID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "EventRegistration[ registrationID=" + registrationID + " ]";
    }
}