package mypack;

import jakarta.ejb.Local;
import java.util.List;

@Local
public interface ApplicationFacadeLocal {
    void create(Application app);
    void edit(Application app);
    void remove(Application app);
    Application find(Object id);
    List<Application> findAll();
    List<Application> findByJobId(int jobId);
    List<Application> findByStatus(String status);
    List<Application> searchByNameOrPhone(String keyword);
}