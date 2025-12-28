package mypack;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;

@Entity
@Table(name = "Recruitment", catalog = "BookingStageDB", schema = "dbo")
public class Recruitment implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "JobID", nullable = false)
    private Integer jobID;

    @ManyToOne(optional = false)
    @JoinColumn(name = "UserID", referencedColumnName = "UserID", nullable = false)
    private User userID;

    @Basic(optional = false)
    @NotNull
    @Column(name = "IsDeleted", nullable = false)
    private boolean isDeleted;

    @Column(name = "Title", length = 200)
    private String title;

    @Column(name = "Description", nullable = false)
    private String description;

    @Column(name = "Requirement")
    private String requirement;

    @Column(name = "Location", length = 200)
    private String location;

    @Column(name = "Salary", length = 100)
    private String salary;

    @Column(name = "Status", length = 50)
    private String status; // Open/Closed

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "PostedAt", nullable = false)
    private Date postedAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "UpdatedAt")
    private Date updatedAt;

    @Temporal(TemporalType.DATE)
    @Column(name = "Deadline")
    private Date deadline;

    @Column(name = "LogoUrl", length = 255)
    private String logoUrl;

    // Constructor
    public Recruitment() {}

    // Getter & Setter
    public Integer getJobID() { return jobID; }
    public void setJobID(Integer jobID) { this.jobID = jobID; }

    public User getUserID() { return userID; }
    public void setUserID(User userID) { this.userID = userID; }

    public boolean getIsDeleted() { return isDeleted; }
    public void setIsDeleted(boolean isDeleted) { this.isDeleted = isDeleted; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRequirement() { return requirement; }
    public void setRequirement(String requirement) { this.requirement = requirement; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getSalary() { return salary; }
    public void setSalary(String salary) { this.salary = salary; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getPostedAt() { return postedAt; }
    public void setPostedAt(Date postedAt) { this.postedAt = postedAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }
}