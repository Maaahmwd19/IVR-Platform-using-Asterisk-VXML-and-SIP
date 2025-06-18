package com.ivr.platform.rest;

import com.ivr.platform.entity.User;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

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
    public Response updateUser(@PathParam("id") Integer id, User updatedUser) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, id);
            if (user == null) {
                em.getTransaction().rollback();
                return Response.status(Response.Status.NOT_FOUND).entity("User not found").build();
            }
            // MSISDN uniqueness check (excluding current user)
            if (updatedUser.getMsisdn() != null) {
                Long msisdnCount = em.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.msisdn = :msisdn AND u.userId != :userId", Long.class)
                    .setParameter("msisdn", updatedUser.getMsisdn())
                    .setParameter("userId", id)
                    .getSingleResult();
                if (msisdnCount > 0) {
                    em.getTransaction().rollback();
                    return Response.status(Response.Status.CONFLICT)
                        .entity("MSISDN " + updatedUser.getMsisdn() + " is already in use").build();
                }
            }
            user.setUserName(updatedUser.getUserName());
            user.setMsisdn(updatedUser.getMsisdn());
            user.setBalance(updatedUser.getBalance());
            em.merge(user);
            em.getTransaction().commit();
            return Response.ok(user).build();
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