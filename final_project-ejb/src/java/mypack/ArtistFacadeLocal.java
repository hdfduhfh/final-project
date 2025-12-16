/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */

package mypack;

import jakarta.ejb.Local;
import java.util.List;

/**
 *
 * @author DANG KHOA
 */
@Local
public interface ArtistFacadeLocal {

    void create(Artist artist);

    void edit(Artist artist);

    void remove(Artist artist);

    Artist find(Object id);

    List<Artist> findAll();

    List<Artist> findRange(int[] range);

    int count();

     List<Artist> searchByKeyword(String keyword);
}

