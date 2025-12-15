/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
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
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "Recruitment", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Recruitment.findAll", query = "SELECT r FROM Recruitment r"),
    @NamedQuery(name = "Recruitment.findByJobID", query = "SELECT r FROM Recruitment r WHERE r.jobID = :jobID"),
    @NamedQuery(name = "Recruitment.findByDescription", query = "SELECT r FROM Recruitment r WHERE r.description = :description"),
    @NamedQuery(name = "Recruitment.findByPostedAt", query = "SELECT r FROM Recruitment r WHERE r.postedAt = :postedAt")})
public class Recruitment implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "JobID", nullable = false)
    private Integer jobID;
    @Basic(optional = false)
    @Column(name = "Description", nullable = false, length = 2147483647)
    private String description;
    @Basic(optional = false)
    @Column(name = "PostedAt", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date postedAt;
    @JoinColumn(name = "UserID", referencedColumnName = "UserID", nullable = false)
    @ManyToOne(optional = false)
    private User userID;

    public Recruitment() {
    }

    public Recruitment(Integer jobID) {
        this.jobID = jobID;
    }

    public Recruitment(Integer jobID, String description, Date postedAt) {
        this.jobID = jobID;
        this.description = description;
        this.postedAt = postedAt;
    }

    public Integer getJobID() {
        return jobID;
    }

    public void setJobID(Integer jobID) {
        this.jobID = jobID;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getPostedAt() {
        return postedAt;
    }

    public void setPostedAt(Date postedAt) {
        this.postedAt = postedAt;
    }

    public User getUserID() {
        return userID;
    }

    public void setUserID(User userID) {
        this.userID = userID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (jobID != null ? jobID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Recruitment)) {
            return false;
        }
        Recruitment other = (Recruitment) object;
        if ((this.jobID == null && other.jobID != null) || (this.jobID != null && !this.jobID.equals(other.jobID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Recruitment[ jobID=" + jobID + " ]";
    }
    
}
