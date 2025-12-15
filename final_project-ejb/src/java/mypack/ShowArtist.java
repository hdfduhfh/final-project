/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
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

/**
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "ShowArtist", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "ShowArtist.findAll", query = "SELECT s FROM ShowArtist s"),
    @NamedQuery(name = "ShowArtist.findByShowArtistID", query = "SELECT s FROM ShowArtist s WHERE s.showArtistID = :showArtistID")})
public class ShowArtist implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ShowArtistID", nullable = false)
    private Integer showArtistID;
    @JoinColumn(name = "ArtistID", referencedColumnName = "ArtistID", nullable = false)
    @ManyToOne(optional = false)
    private Artist artistID;
    @JoinColumn(name = "ShowID", referencedColumnName = "ShowID", nullable = false)
    @ManyToOne(optional = false)
    private Show showID;

    public ShowArtist() {
    }

    public ShowArtist(Integer showArtistID) {
        this.showArtistID = showArtistID;
    }

    public Integer getShowArtistID() {
        return showArtistID;
    }

    public void setShowArtistID(Integer showArtistID) {
        this.showArtistID = showArtistID;
    }

    public Artist getArtistID() {
        return artistID;
    }

    public void setArtistID(Artist artistID) {
        this.artistID = artistID;
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
        hash += (showArtistID != null ? showArtistID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ShowArtist)) {
            return false;
        }
        ShowArtist other = (ShowArtist) object;
        if ((this.showArtistID == null && other.showArtistID != null) || (this.showArtistID != null && !this.showArtistID.equals(other.showArtistID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.ShowArtist[ showArtistID=" + showArtistID + " ]";
    }
    
}
