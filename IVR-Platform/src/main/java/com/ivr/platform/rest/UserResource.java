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