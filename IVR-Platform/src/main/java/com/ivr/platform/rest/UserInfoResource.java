package com.ivr.platform.rest;

import com.ivr.platform.dto.ServiceInfoDTO;
import com.ivr.platform.dto.UserInfoDTO;
import com.ivr.platform.dto.VXMLFileInfoDTO;
import com.ivr.platform.entity.Service;
import com.ivr.platform.entity.User;
import com.ivr.platform.entity.UserService;
import com.ivr.platform.entity.VXMLFile;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.RollbackException;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;
import javax.persistence.PersistenceException;

@Path("user-info")
public class UserInfoResource {

    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllUserInfo() {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            List<User> users = em.createQuery("SELECT u FROM User u", User.class).getResultList();

            List<UserInfoDTO> userDTOs = users.stream().map(user -> {
                List<UserService> userServices = em.createQuery(
                        "SELECT us FROM UserService us WHERE us.user.userId = :userId", UserService.class)
                        .setParameter("userId", user.getUserId())
                        .getResultList();

                List<ServiceInfoDTO> serviceDTOs = userServices.stream().map(us -> {
                    Service service = us.getService();

                    return new ServiceInfoDTO(
                            service.getServiceId(),
                            service.getServiceName(),
                            service.getServiceType(),
                            service.getQuota(),
                            service.getServiceFees(),
                            us.getActivationStatus()
                    );
                }).collect(Collectors.toList());

                return new UserInfoDTO(
                        user.getUserId(),
                        user.getUserName(),
                        user.getMsisdn(),
                        user.getBalance(),
                        serviceDTOs
                );
            }).collect(Collectors.toList());

            em.getTransaction().commit();
            return Response.ok(userDTOs).build();
        } catch (Exception e) {
            e.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error retrieving user info: " + e.getMessage())
                           .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @GET
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getUserInfoById(@PathParam("id") Integer userId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, userId);
            if (user == null) {
                em.getTransaction().commit();
                return Response.status(Response.Status.NOT_FOUND)
                               .entity("User with ID " + userId + " not found")
                               .build();
            }

            List<UserService> userServices = em.createQuery(
                    "SELECT us FROM UserService us WHERE us.user.userId = :userId", UserService.class)
                    .setParameter("userId", user.getUserId())
                    .getResultList();

            List<ServiceInfoDTO> serviceDTOs = userServices.stream().map(us -> {
                Service service = us.getService();
                VXMLFile vxmlFile = service.getVxmlFile();
                VXMLFileInfoDTO vxmlDTO = new VXMLFileInfoDTO(
                        vxmlFile.getVxmlId(),
                        vxmlFile.getFileName(),
                        vxmlFile.getFilePath()
                );
                return new ServiceInfoDTO(
                        service.getServiceId(),
                        service.getServiceName(),
                        service.getServiceType(),
                        service.getQuota(),
                        service.getServiceFees(),
                        us.getActivationStatus()
                );
            }).collect(Collectors.toList());

            UserInfoDTO userDTO = new UserInfoDTO(
                    user.getUserId(),
                    user.getUserName(),
                    user.getMsisdn(),
                    user.getBalance(),
                    serviceDTOs
            );

            em.getTransaction().commit();
            return Response.ok(userDTO).build();
        } catch (Exception e) {
            e.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error retrieving user info: " + e.getMessage())
                           .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createUser(UserInfoDTO userDTO) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            // Validate input
            if (userDTO.getUserName() == null || userDTO.getMsisdn() == null || userDTO.getBalance() == null) {
                em.getTransaction().commit();
                return Response.status(Response.Status.BAD_REQUEST)
                               .entity("UserName, MSISDN, and balance are required")
                               .build();
            }

            // Validate MSISDN format (10 digits)
            if (!userDTO.getMsisdn().matches("\\d{11}")) {
                em.getTransaction().commit();
                return Response.status(Response.Status.BAD_REQUEST)
                               .entity("MSISDN must be a 11-digit number")
                               .build();
            }

            // Check if MSISDN already exists
            Long msisdnCount = em.createQuery(
                    "SELECT COUNT(u) FROM User u WHERE u.msisdn = :msisdn", Long.class)
                    .setParameter("msisdn", userDTO.getMsisdn())
                    .getSingleResult();
            if (msisdnCount > 0) {
                em.getTransaction().commit();
                return Response.status(Response.Status.CONFLICT)
                               .entity("User with MSISDN " + userDTO.getMsisdn() + " already exists")
                               .build();
            }

            User user = new User(
                    userDTO.getUserName(),
                    userDTO.getMsisdn(),
                    userDTO.getBalance()
            );
            em.persist(user);

            // Handle services if provided
            if (userDTO.getServices() != null && !userDTO.getServices().isEmpty()) {
                for (ServiceInfoDTO serviceDTO : userDTO.getServices()) {
                    Service service = em.find(Service.class, serviceDTO.getServiceId());
                    if (service == null) {
                        em.getTransaction().rollback();
                        return Response.status(Response.Status.BAD_REQUEST)
                                       .entity("Service with ID " + serviceDTO.getServiceId() + " not found")
                                       .build();
                    }
                    UserService userService = new UserService(
                            user,
                            service,
                            serviceDTO.getActivationStatus() != null ? serviceDTO.getActivationStatus() : "ACTIVE"
                    );
                    em.persist(userService);
                }
            }

            em.getTransaction().commit();
            userDTO.setUserId(user.getUserId());
            return Response.status(Response.Status.CREATED).entity(userDTO).build();
        } catch (PersistenceException pe) {
            pe.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.BAD_REQUEST)
                           .entity("Database error creating user: " + pe.getMessage())
                           .build();
        } catch (Exception e) {
            e.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error creating user: " + e.getMessage())
                           .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @PUT
    @Path("{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateUser(@PathParam("id") Integer userId, UserInfoDTO userDTO) {
        System.out.println("[DEBUG] updateUser called with userId: " + userId);
        System.out.println("[DEBUG] Payload: userId=" + userDTO.getUserId() + ", userName=" + userDTO.getUserName() + ", msisdn=" + userDTO.getMsisdn() + ", balance=" + userDTO.getBalance() + ", services=" + userDTO.getServices());
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, userId);
            if (user == null) {
                System.out.println("[ERROR] User not found for ID: " + userId);
                em.getTransaction().commit();
                return Response.status(Response.Status.NOT_FOUND)
                               .entity("User with ID " + userId + " not found")
                               .build();
            }

            // Update user fields if provided
            if (userDTO.getUserName() != null) {
                user.setUserName(userDTO.getUserName());
            }
            if (userDTO.getMsisdn() != null) {
                System.out.println("[DEBUG] Validating MSISDN: " + userDTO.getMsisdn());
                if (!userDTO.getMsisdn().matches("\\d{11}")) {
                    System.out.println("[ERROR] Invalid MSISDN format: " + userDTO.getMsisdn());
                    em.getTransaction().commit();
                    return Response.status(Response.Status.BAD_REQUEST)
                                   .entity("MSISDN must be an 11-digit number. Received: " + userDTO.getMsisdn())
                                   .build();
                }
                // Check if new MSISDN is unique
                Long msisdnCount = em.createQuery(
                        "SELECT COUNT(u) FROM User u WHERE u.msisdn = :msisdn AND u.userId != :userId", Long.class)
                        .setParameter("msisdn", userDTO.getMsisdn())
                        .setParameter("userId", userId)
                        .getSingleResult();
                if (msisdnCount > 0) {
                    System.out.println("[ERROR] MSISDN conflict for: " + userDTO.getMsisdn());
                    em.getTransaction().commit();
                    return Response.status(Response.Status.CONFLICT)
                                   .entity("MSISDN " + userDTO.getMsisdn() + " is already in use")
                                   .build();
                }
                user.setMsisdn(userDTO.getMsisdn());
            }
            if (userDTO.getBalance() != null) {
                System.out.println("[DEBUG] Setting balance: " + userDTO.getBalance());
                user.setBalance(userDTO.getBalance());
            }

            // Update services if provided
            if (userDTO.getServices() != null) {
                System.out.println("[DEBUG] Updating services: " + userDTO.getServices());
                // Remove existing user services
                em.createQuery("DELETE FROM UserService us WHERE us.user.userId = :userId")
                        .setParameter("userId", userId)
                        .executeUpdate();

                // Add new services
                for (ServiceInfoDTO serviceDTO : userDTO.getServices()) {
                    Service service = em.find(Service.class, serviceDTO.getServiceId());
                    if (service == null) {
                        System.out.println("[ERROR] Service not found for ID: " + serviceDTO.getServiceId());
                        em.getTransaction().rollback();
                        return Response.status(Response.Status.BAD_REQUEST)
                                       .entity("Service with ID " + serviceDTO.getServiceId() + " not found")
                                       .build();
                    }
                    UserService userService = new UserService(
                            user,
                            service,
                            serviceDTO.getActivationStatus() != null ? serviceDTO.getActivationStatus() : "ACTIVE"
                    );
                    em.persist(userService);
                }
            }

            em.getTransaction().commit();
            return Response.ok(userDTO).build();
        } catch (PersistenceException pe) {
            System.out.println("[ERROR] PersistenceException: " + pe.getMessage());
            pe.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.BAD_REQUEST)
                           .entity("Database error updating user: " + pe.getMessage())
                           .build();
        } catch (Exception e) {
            System.out.println("[ERROR] Exception: " + e.getMessage());
            e.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.BAD_REQUEST)
                           .entity("Error updating user: " + e.getMessage())
                           .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @DELETE
    @Path("{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteUser(@PathParam("id") Integer userId) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            User user = em.find(User.class, userId);
            if (user == null) {
                em.getTransaction().commit();
                return Response.status(Response.Status.NOT_FOUND)
                               .entity("User with ID " + userId + " not found")
                               .build();
            }

            // Delete associated user services
            em.createQuery("DELETE FROM UserService us WHERE us.user.userId = :userId")
                    .setParameter("userId", userId)
                    .executeUpdate();

            // Delete the user
            em.remove(user);
            em.getTransaction().commit();
            return Response.ok("User with ID " + userId + " deleted successfully").build();
        } catch (PersistenceException pe) {
            pe.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.BAD_REQUEST)
                           .entity("Database error deleting user: " + pe.getMessage())
                           .build();
        } catch (Exception e) {
            e.printStackTrace(); // Log for debugging
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Error deleting user: " + e.getMessage())
                           .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
