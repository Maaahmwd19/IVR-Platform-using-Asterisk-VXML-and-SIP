package com.ivr.platform.rest;

import com.ivr.platform.entity.User;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

    @GET
    @Path("/weekdays")
    public Response getWeekdays() {
        String[] weekdays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        return Response.ok(weekdays).build();
    }

    @GET
    @Path("/growth")
    public Response getUserGrowth() {
        Map<String, Integer> userGrowth = new LinkedHashMap<>();
        try {
            // Generate last 5 days
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("EEEE");
            LocalDate today = LocalDate.now();
            for (int i = 4; i >= 0; i--) {
                LocalDate date = today.minusDays(i);
                String dateStr = date.format(dateFormatter);
                String dayName = date.format(dayFormatter);
                userGrowth.put(dateStr + " (" + dayName + ")", 0);
            }

            // Query to get user count by date for the last 5 days
            String query = "SELECT to_char(created_timestamp, 'YYYY-MM-DD') as date, COUNT(*) as user_count " +
                          "FROM users " +
                          "WHERE created_timestamp >= CURRENT_DATE - INTERVAL '4 days' " +
                          "GROUP BY date " +
                          "ORDER BY date";
            
            EntityManager em = emf.createEntityManager();
            List<Object[]> results = em.createNativeQuery(query).getResultList();

            // Fill the map with user counts by date
            for (Object[] row : results) {
                String date = (String) row[0];
                int userCount = ((Number) row[1]).intValue();
                LocalDate d = LocalDate.parse(date, dateFormatter);
                String dayName = d.format(dayFormatter);
                userGrowth.put(date + " (" + dayName + ")", userCount);
            }

            em.close();
            return Response.ok(userGrowth).build();

        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("Error fetching user growth: " + e.getMessage())
                    .build();
        }
    }

    @GET
    @Path("/months")
    public Response getMonths() {
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
        return Response.ok(months).build();
    }

    @GET
    @Path("/count")
    public Response getTotalUsers() {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
            return Response.ok(count).build();
        } finally {
            em.close();
        }
    }

    @GET
    public List<User> getAllUsers() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u", User.class).getResultList();
        } finally {
            em.close();
        }
    }

    @GET
    @Path("/{id}")
    public User getUser(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, id);
            if (user == null) {
                throw new WebApplicationException("User not found", Response.Status.NOT_FOUND);
            }
            return user;
        } finally {
            em.close();
        }
    }

    @POST
    public Response createUser(User user) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(user).build();
        } finally {
            em.close();
        }
    }

    @PUT
    @Path("/{id}")
    public User updateUser(@PathParam("id") Integer id, User updatedUser) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, id);
            if (user == null) {
                throw new WebApplicationException("User not found", Response.Status.NOT_FOUND);
            }
            user.setUserName(updatedUser.getUserName());
            user.setMsisdn(updatedUser.getMsisdn());
            user.setBalance(updatedUser.getBalance());
            em.merge(user);
            em.getTransaction().commit();
            return user;
        } finally {
            em.close();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteUser(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, id);
            if (user == null) {
                throw new WebApplicationException("User not found", Response.Status.NOT_FOUND);
            }
            em.remove(user);
            em.getTransaction().commit();
            return Response.status(Response.Status.NO_CONTENT).build();
        } finally {
            em.close();
        }
    }
}