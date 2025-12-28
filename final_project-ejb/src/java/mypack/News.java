/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.*;

@Entity
@Table(name = "News", catalog = "BookingStageDB", schema = "dbo")
@NamedQueries({
    @NamedQuery(name = "News.findAll", query = "SELECT n FROM News n WHERE n.isDeleted = false ORDER BY n.createdAt DESC"),
    @NamedQuery(name = "News.findBySlug", query = "SELECT n FROM News n WHERE n.slug = :slug AND n.isDeleted = false")
})
public class News implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "NewsID", nullable = false)
    private Integer newsID;

    @Basic(optional = false)
    @Column(name = "Title", nullable = false, length = 200)
    private String title;

    @Basic(optional = false)
    @Column(name = "Content", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Basic(optional = false)
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "CreatedAt", nullable = false)
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "UpdatedAt")
    private Date updatedAt;

      @ManyToOne(optional = false)
    @JoinColumn(name = "UserID", referencedColumnName = "UserID", nullable = false)
    private User userID;

    // New fields
    @Column(name = "ThumbnailUrl", length = 500)
    private String thumbnailUrl;

    @Column(name = "Summary", length = 500)
    private String summary;

    @Column(name = "Status", nullable = false, length = 50)
    private String status = "Draft"; // Default

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "PublishDate")
    private Date publishDate;

    @Column(name = "Slug", length = 200, unique = true)
    private String slug;

    @Column(name = "IsDeleted", nullable = false)
    private boolean isDeleted = false;

    public News() {}

    // getters/setters…

    public Integer getNewsID() { return newsID; }
    public void setNewsID(Integer newsID) { this.newsID = newsID; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public User getUserID() { return userID; }
    public void setUserID(User userID) { this.userID = userID; }

    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public boolean isIsDeleted() { return isDeleted; }
    public void setIsDeleted(boolean isDeleted) { this.isDeleted = isDeleted; }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = new Date();
        applyPublishRules();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Date();
        applyPublishRules();
    }

    private void applyPublishRules() {
        if ("Published".equalsIgnoreCase(status) && publishDate == null) {
            publishDate = new Date();
        }
        if (!"Published".equalsIgnoreCase(status)) {
            // Optional: clear publishDate if unpublish
            // publishDate = null;
        }
    }

    @Override
    public int hashCode() { return newsID != null ? newsID.hashCode() : 0; }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof News)) return false;
        News other = (News) obj;
        return (this.newsID != null && this.newsID.equals(other.newsID));
    }

    @Override
    public String toString() { return "mypack.News[ newsID=" + newsID + " ]"; }
}
