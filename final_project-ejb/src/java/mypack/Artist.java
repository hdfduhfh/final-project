/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
import java.util.Collection;
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

/**
 *
 * @author DANG KHOA
 */
@Entity
@Table(name = "Artist", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "Artist.findAll", query = "SELECT a FROM Artist a"),
    @NamedQuery(name = "Artist.findByArtistID", query = "SELECT a FROM Artist a WHERE a.artistID = :artistID"),
    @NamedQuery(name = "Artist.findByName", query = "SELECT a FROM Artist a WHERE a.name = :name"),
    @NamedQuery(name = "Artist.findByRole", query = "SELECT a FROM Artist a WHERE a.role = :role"),
    @NamedQuery(name = "Artist.findByBio", query = "SELECT a FROM Artist a WHERE a.bio = :bio"),
    @NamedQuery(name = "Artist.findByArtistImage", query = "SELECT a FROM Artist a WHERE a.artistImage = :artistImage")})
public class Artist implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "ArtistID", nullable = false)
    private Integer artistID;
    @Basic(optional = false)
    @Column(name = "Name", nullable = false, length = 100)
    private String name;
    @Column(name = "Role", length = 50)
    private String role;
    @Column(name = "Bio", length = 255)
    private String bio;
    @Column(name = "ArtistImage", length = 500)
    private String artistImage;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "artistID")
    private Collection<ShowArtist> showArtistCollection;

    public Artist() {
    }

    public Artist(Integer artistID) {
        this.artistID = artistID;
    }

    public Artist(Integer artistID, String name) {
        this.artistID = artistID;
        this.name = name;
    }

    public Integer getArtistID() {
        return artistID;
    }

    public void setArtistID(Integer artistID) {
        this.artistID = artistID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getArtistImage() {
        return artistImage;
    }

    public void setArtistImage(String artistImage) {
        this.artistImage = artistImage;
    }

    public Collection<ShowArtist> getShowArtistCollection() {
        return showArtistCollection;
    }

    public void setShowArtistCollection(Collection<ShowArtist> showArtistCollection) {
        this.showArtistCollection = showArtistCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (artistID != null ? artistID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Artist)) {
            return false;
        }
        Artist other = (Artist) object;
        if ((this.artistID == null && other.artistID != null) || (this.artistID != null && !this.artistID.equals(other.artistID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "mypack.Artist[ artistID=" + artistID + " ]";
    }
    
}
