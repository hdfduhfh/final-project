package mypack;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "ShowArtist")
public class ShowArtist implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ShowArtistID")
    private Integer showArtistID;

    // N bản ghi nối - 1 Artist
    @ManyToOne(optional = false)
    @JoinColumn(name = "ArtistID")
    private Artist artist;

    // N bản ghi nối - 1 Show
    @ManyToOne(optional = false)
    @JoinColumn(name = "ShowID")
    private Show show;

    public ShowArtist() {
    }

    // ===== getters & setters =====

    public Integer getShowArtistID() {
        return showArtistID;
    }

    public void setShowArtistID(Integer showArtistID) {
        this.showArtistID = showArtistID;
    }

    public Artist getArtist() {
        return artist;
    }

    public void setArtist(Artist artist) {
        this.artist = artist;
    }

    public Show getShow() {
        return show;
    }

    public void setShow(Show show) {
        this.show = show;
    }

    // ===== equals / hashCode / toString =====

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ShowArtist)) return false;
        ShowArtist other = (ShowArtist) o;
        return showArtistID != null && showArtistID.equals(other.showArtistID);
    }

    @Override
    public int hashCode() {
        return showArtistID != null ? showArtistID.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "ShowArtist{" +
                "showArtistID=" + showArtistID +
                '}';
    }
}
