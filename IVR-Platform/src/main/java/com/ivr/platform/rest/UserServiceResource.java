package com.ivr.platform.rest;

import com.ivr.platform.entity.Service;
import com.ivr.platform.entity.User;
import com.ivr.platform.entity.UserService;
import com.ivr.platform.entity.UserServiceId;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/userservices")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserServiceResource {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

    @GET
    public List<UserService> getAllUserServices() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT us FROM UserService us", UserService.class).getResultList();
        } finally {
            em.close();
        }
    }

    @GET
    @Path("/{userId}/{serviceId}")
    public UserService getUserService(@PathParam("userId") Integer userId, @PathParam("serviceId") Integer serviceId) {
        EntityManager em = emf.createEntityManager();
        try {
            UserServiceId id = new UserServiceId(userId, serviceId);
            UserService userService = em.find(UserService.class, id);
            if (userService == null) {
                throw new WebApplicationException("UserService not found", Response.Status.NOT_FOUND);
            }
            return userService;
        } finally {
            em.close();
        }
    }

    @POST
    public Response createUserService(UserService userService) {
        if (userService.getUser() == null || userService.getService() == null || userService.getActivationStatus() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        if (!userService.getActivationStatus().equals("Active") && !userService.getActivationStatus().equals("InActive")) {
            throw new WebApplicationException("Invalid activation status", Response.Status.BAD_REQUEST);
        }
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, userService.getUser().getUserId());
            Service service = em.find(Service.class, userService.getService().getServiceId());
            if (user == null || service == null) {
                throw new WebApplicationException("Invalid user or service ID", Response.Status.BAD_REQUEST);
            }
            userService.setUser(user);
            userService.setService(service);
            userService.setId(new UserServiceId(user.getUserId(), service.getServiceId()));
            em.persist(userService);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(userService).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to create user service: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @PUT
    @Path("/{userId}/{serviceId}")
    public UserService updateUserService(@PathParam("userId") Integer userId, @PathParam("serviceId") Integer serviceId, UserService updatedUserService) {
        if (updatedUserService.getActivationStatus() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        if (!updatedUserService.getActivationStatus().equals("Active") && !updatedUserService.getActivationStatus().equals("InActive")) {
            throw new WebApplicationException("Invalid activation status", Response.Status.BAD_REQUEST);
        }
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            UserServiceId id = new UserServiceId(userId, serviceId);
            UserService userService = em.find(UserService.class, id);
            if (userService == null) {
                throw new WebApplicationException("UserService not found", Response.Status.NOT_FOUND);
            }
            userService.setActivationStatus(updatedUserService.getActivationStatus());
            em.merge(userService);
            em.getTransaction().commit();
            return userService;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to update user service: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @DELETE
    @Path("/{userId}/{serviceId}")
    public Response deleteUserService(@PathParam("userId") Integer userId, @PathParam("serviceId") Integer serviceId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            UserServiceId id = new UserServiceId(userId, serviceId);
            UserService userService = em.find(UserService.class, id);
            if (userService == null) {
                throw new WebApplicationException("UserService not found", Response.Status.NOT_FOUND);
            }
            em.remove(userService);
            em.getTransaction().commit();
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to delete user service: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }
}