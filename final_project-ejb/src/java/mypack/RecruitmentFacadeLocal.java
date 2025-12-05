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
public interface RecruitmentFacadeLocal {

    void create(Recruitment recruitment);

    void edit(Recruitment recruitment);

    void remove(Recruitment recruitment);

    Recruitment find(Object id);

    List<Recruitment> findAll();

    List<Recruitment> findRange(int[] range);

    int count();
    
}
