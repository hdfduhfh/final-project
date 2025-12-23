/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mypack;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.util.Date;

@Stateless
public class PromotionFacade extends AbstractFacade<Promotion> implements PromotionFacadeLocal {

    @PersistenceContext(unitName = "BookingStagePU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public PromotionFacade() {
        super(Promotion.class);
    }
    
    @Override
    public Promotion findByCode(String code) {
        try {
            TypedQuery<Promotion> query = em.createQuery(
                "SELECT p FROM Promotion p WHERE p.code = :code AND p.status = 'ACTIVE'",
                Promotion.class
            );
            query.setParameter("code", code.trim().toUpperCase());
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
    
    @Override
    public boolean isPromotionValid(Promotion promotion, BigDecimal orderAmount) {
        if (promotion == null) {
            return false;
        }
        
        Date now = new Date();
        
        // Kiểm tra thời gian hiệu lực
        if (now.before(promotion.getStartDate()) || now.after(promotion.getEndDate())) {
            return false;
        }
        
        // Kiểm tra trạng thái
        if (!"ACTIVE".equals(promotion.getStatus())) {
            return false;
        }
        
        // Kiểm tra giá trị đơn hàng tối thiểu
        if (promotion.getMinOrderAmount() != null) {
            if (orderAmount.compareTo(promotion.getMinOrderAmount()) < 0) {
                return false;
            }
        }
        
        return true;
    }
    
    @Override
    public BigDecimal calculateDiscount(Promotion promotion, BigDecimal orderAmount) {
        if (promotion == null || orderAmount == null) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal discount = BigDecimal.ZERO;
        
        // Tính giảm giá theo loại
        if ("PERCENTAGE".equals(promotion.getDiscountType())) {
            // Giảm theo phần trăm
            discount = orderAmount.multiply(promotion.getDiscountValue())
                                 .divide(BigDecimal.valueOf(100));
            
            // Áp dụng giới hạn giảm tối đa
            if (promotion.getMaxDiscount() != null) {
                if (discount.compareTo(promotion.getMaxDiscount()) > 0) {
                    discount = promotion.getMaxDiscount();
                }
            }
        } else if ("FIXED".equals(promotion.getDiscountType())) {
            // Giảm cố định
            discount = promotion.getDiscountValue();
            
            // Không cho giảm quá tổng tiền
            if (discount.compareTo(orderAmount) > 0) {
                discount = orderAmount;
            }
        }
        
        return discount;
    }
    
    @Override
    // Thêm tham số User user
    public boolean isPromotionValid(Promotion promotion, BigDecimal orderAmount, User user) {
        if (promotion == null) {
            return false;
        }
        
        // 1. Kiểm tra cơ bản (Ngày, Active, MinAmount...) - GIỮ NGUYÊN CODE CŨ
        Date now = new Date();
        if (now.before(promotion.getStartDate()) || now.after(promotion.getEndDate())) {
            return false;
        }
        if (!"ACTIVE".equals(promotion.getStatus())) {
            return false;
        }
        if (promotion.getMinOrderAmount() != null) {
            if (orderAmount.compareTo(promotion.getMinOrderAmount()) < 0) {
                return false;
            }
        }
        
        // 2. LOGIC MỚI: Kiểm tra số lượng tổng (MaxUsage)
        if (promotion.getMaxUsage() != null) {
            // Đếm tổng số đơn dùng mã này (trừ đơn hủy)
            long totalUsed = (long) em.createQuery(
                "SELECT COUNT(o) FROM Order1 o WHERE o.promotionID = :promo AND o.status <> 'CANCELLED'")
                .setParameter("promo", promotion)
                .getSingleResult();
                
            if (totalUsed >= promotion.getMaxUsage()) {
                return false; // Hết lượt toàn hệ thống
            }
        }

        // 3. LOGIC MỚI: Kiểm tra số lượng User (MaxUsagePerUser)
        if (promotion.getMaxUsagePerUser() != null && user != null) {
            // Đếm số đơn của user này đã dùng mã này (trừ đơn hủy)
            long userUsed = (long) em.createQuery(
                "SELECT COUNT(o) FROM Order1 o WHERE o.promotionID = :promo AND o.userID = :user AND o.status <> 'CANCELLED'")
                .setParameter("promo", promotion)
                .setParameter("user", user)
                .getSingleResult();

            if (userUsed >= promotion.getMaxUsagePerUser()) {
                return false; // User này đã hết lượt
            }
        }
        
        return true;
    }
}
