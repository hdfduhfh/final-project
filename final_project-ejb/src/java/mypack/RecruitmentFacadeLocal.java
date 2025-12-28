package mypack;

import jakarta.ejb.Local;
import java.util.List;

@Local
public interface RecruitmentFacadeLocal {
    void create(Recruitment recruitment);
    void edit(Recruitment recruitment);
    void remove(Recruitment recruitment);
    Recruitment find(Object id);
    List<Recruitment> findAll();
    List<Recruitment> findRange(int[] range);
    int count();

    void softDelete(Integer id);
    List<Recruitment> findByTitle(String keyword);           // cho admin
    List<Recruitment> findPublishedByTitle(String keyword);  // cho public
    
     List<Recruitment> findPage(int page, int pageSize);
    long countAll();

}