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
@Table(name = "Show")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Show.findAll", query = "SELECT s FROM Show s"),
    @NamedQuery(name = "Show.findByShowID", query = "SELECT s FROM Show s WHERE s.showID = :showID"),
    @NamedQuery(name = "Show.findByShowName", query = "SELECT s FROM Show s WHERE s.showName = :showName"),
    @NamedQuery(name = "Show.findByDescription", query = "SELECT s FROM Show s WHERE s.description = :description"),
    @NamedQuery(name = "Show.findByDurationMinutes", query = "SELECT s FROM Show s WHERE s.durationMinutes = :durationMinutes"),
    @NamedQuery(name = "Show.findByStatus", query = "SELECT s FROM Show s WHERE s.status = :status"),
    @NamedQuery(name = "Show.findByShowImage", query = "SELECT s FROM Show s WHERE s.showImage = :showImage"),
    @NamedQuery(name = "Show.findByCreatedAt", query = "SELECT s FROM Show s WHERE s.createdAt = :createdAt")})
public class Show implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ShowID")
    private Integer showID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "ShowName")
    private String showName;
    @Size(max = 255)
    @Column(name = "Description")
    private String description;
    @Basic(optional = false)
    @NotNull
    @Column(name = "DurationMinutes")
    private int durationMinutes;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "Status")
    private String status;
    @Size(max = 500)
    @Column(name = "ShowImage")
    private String showImage;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CreatedAt")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "showID")
    private Collection<ShowArtist> showArtistCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "showID")
    private Collection<ShowSchedule> showScheduleCollection;

    public Show() {
    }

    public Show(Integer showID) {
        this.showID = showID;
    }

    public Show(Integer showID, String showName, int durationMinutes, String status, Date createdAt) {
        this.showID = showID;
        this.showName = showName;
        this.durationMinutes = durationMinutes;
        this.status = status;
        this.createdAt = createdAt;
    }

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

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
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

    @XmlTransient
    public Collection<ShowArtist> getShowArtistCollection() {
        return showArtistCollection;
    }

    public void setShowArtistCollection(Collection<ShowArtist> showArtistCollection) {
        this.showArtistCollection = showArtistCollection;
    }

    @XmlTransient
    public Collection<ShowSchedule> getShowScheduleCollection() {
        return showScheduleCollection;
    }

    public void setShowScheduleCollection(Collection<ShowSchedule> showScheduleCollection) {
        this.showScheduleCollection = showScheduleCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (showID != null ? showID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Show)) {
            return false;
        }
        Show other = (Show) object;
        if ((this.showID == null && other.showID != null) || (this.showID != null && !this.showID.equals(other.showID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Show[ showID=" + showID + " ]";
    }
    
}
