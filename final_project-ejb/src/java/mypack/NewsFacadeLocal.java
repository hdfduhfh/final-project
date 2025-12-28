/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package mypack;

import jakarta.ejb.Local;
import java.util.List;


@Local
public interface NewsFacadeLocal {

    void create(News news);
    void edit(News news);
    void remove(News news);
    News find(Object id);

    List<News> findAll();
    List<News> findRange(int[] range);
    int count();

    // New helpers
    List<News> findPublished(int page, int size, String keyword);
    List<News> findAdminList(int page, int size, String status, String keyword, boolean includeDeleted);
    int countAdminList(String status, String keyword, boolean includeDeleted);
    News findBySlug(String slug);
    void softDelete(Integer id);
    
    // cho admin
List<News> findByTitle(String keyword);

// cho public
List<News> findPublishedByTitle(String keyword);

List<News> findPage(int page, int pageSize);
    long countAll();

List<News> findPublishedPage(int page, int pageSize);
long countPublished();
}