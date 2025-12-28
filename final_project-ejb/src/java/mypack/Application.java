package mypack;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "Application", catalog = "BookingStageDB", schema = "dbo")
public class Application implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id", nullable = false)
    private Integer id;

    @Column(name = "FullName", nullable = false, length = 200)
    private String fullName;

    @Column(name = "Email", nullable = false, length = 200)
    private String email;

    @Column(name = "Phone", length = 40)
    private String phone;

    @Column(name = "CvUrl", length = 510)
    private String cvUrl;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "AppliedAt")
    private Date appliedAt;

    @ManyToOne(optional = false)
    @JoinColumn(name = "JobID", referencedColumnName = "JobID", nullable = false)
    private Recruitment job;

    @Column(name = "Status", length = 20)
    private String status; // Pending, Accepted, Rejected

    // Constructors
    public Application() {}

    public Application(Integer id) {
        this.id = id;
    }

    // Getters & Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getCvUrl() { return cvUrl; }
    public void setCvUrl(String cvUrl) { this.cvUrl = cvUrl; }

    public Date getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Date appliedAt) { this.appliedAt = appliedAt; }

    public Recruitment getJob() { return job; }
    public void setJob(Recruitment job) { this.job = job; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // hashCode, equals, toString
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Application)) {
            return false;
        }
        Application other = (Application) object;
        return !((this.id == null && other.id != null) ||
                 (this.id != null && !this.id.equals(other.id)));
    }

    @Override
    public String toString() {
        return "mypack.Application[ id=" + id + " ]";
    }
}