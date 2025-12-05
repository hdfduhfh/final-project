package mypack;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Artist")
public class Artist implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ArtistID")
    private Integer artistID;

    @Column(name = "Name", length = 100, nullable = false)
    private String name;

    @Column(name = "Role", length = 50)
    private String role;

    @Column(name = "Bio", length = 255)
    private String bio;

    @Column(name = "ArtistImage", length = 500)
    private String artistImage;

    // 1 Artist - N ShowArtist (N-N với Show)
    @OneToMany(mappedBy = "artist", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ShowArtist> showArtists = new ArrayList<>();

    public Artist() {
    }

    // ===== getters & setters =====

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

    public List<ShowArtist> getShowArtists() {
        return showArtists;
    }

    public void setShowArtists(List<ShowArtist> showArtists) {
        this.showArtists = showArtists;
    }

    // ===== helper =====

    /** Gắn artist này vào một show (tạo ShowArtist). */
    public void addShow(Show show) {
        ShowArtist link = new ShowArtist();
        link.setArtist(this);
        link.setShow(show);
        showArtists.add(link);
        show.getShowArtists().add(link);
    }

    /** Gỡ artist khỏi một show. */
    public void removeShow(Show show) {
        showArtists.removeIf(link -> {
            if (link.getShow() != null && link.getShow().equals(show)) {
                show.getShowArtists().remove(link);
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
        if (!(o instanceof Artist)) return false;
        Artist other = (Artist) o;
        return artistID != null && artistID.equals(other.artistID);
    }

    @Override
    public int hashCode() {
        return artistID != null ? artistID.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "Artist{" +
                "artistID=" + artistID +
                ", name='" + name + '\'' +
                '}';
    }
}
