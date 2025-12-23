    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
     */
    package mypack;

    import jakarta.ejb.Stateless;
    import jakarta.persistence.EntityManager;
    import jakarta.persistence.PersistenceContext;
    import jakarta.persistence.TypedQuery;
    import java.util.ArrayList;
    import java.util.List;

    /**
     *
     * @author DANG KHOA
     */
    @Stateless
    public class SeatFacade extends AbstractFacade<Seat> implements SeatFacadeLocal {

        @PersistenceContext(unitName = "BookingStagePU")
        private EntityManager em;

        @Override
        protected jakarta.persistence.EntityManager getEntityManager() {
            return em;
        }

        public SeatFacade() {
            super(Seat.class);
        }

        @Override
        public Seat findBySeatNumber(String seatNumber) {
            try {
                TypedQuery<Seat> query = em.createQuery(
                        "SELECT s FROM Seat s WHERE s.seatNumber = :seatNumber", Seat.class
                );
                query.setParameter("seatNumber", seatNumber);
                return query.getSingleResult();
            } catch (Exception e) {
                return null; // không tìm thấy ghế
            }
        }

        @Override
        public List<Seat> findBySeatType(String seatType) {
            try {
                TypedQuery<Seat> query = em.createQuery(
                        "SELECT s FROM Seat s WHERE s.seatType = :seatType", Seat.class
                );
                query.setParameter("seatType", seatType);
                return query.getResultList();
            } catch (Exception e) {
                return new ArrayList<>();
            }
        }
    }
