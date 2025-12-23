/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package mypack;

import jakarta.ejb.Local;
import java.math.BigDecimal;
import java.util.List;

@Local
public interface PromotionFacadeLocal {

    void create(Promotion promotion);

    void edit(Promotion promotion);

    void remove(Promotion promotion);

    Promotion find(Object id);

    List<Promotion> findAll();

    List<Promotion> findRange(int[] range);

    int count();
    
    // Tìm promotion theo mã code
    Promotion findByCode(String code);
    
    // Kiểm tra promotion có hợp lệ không
    boolean isPromotionValid(Promotion promotion, BigDecimal orderAmount);
    
    // Tính toán số tiền giảm
    BigDecimal calculateDiscount(Promotion promotion, BigDecimal orderAmount);
    
    boolean isPromotionValid(Promotion promotion, BigDecimal orderAmount, User user);
}