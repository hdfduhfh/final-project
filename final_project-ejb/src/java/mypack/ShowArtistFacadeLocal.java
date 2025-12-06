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
public interface ShowArtistFacadeLocal {

    void create(ShowArtist showArtist);

    void edit(ShowArtist showArtist);

    void remove(ShowArtist showArtist);

    ShowArtist find(Object id);

    List<ShowArtist> findAll();

    List<ShowArtist> findRange(int[] range);

    int count();
    
}
