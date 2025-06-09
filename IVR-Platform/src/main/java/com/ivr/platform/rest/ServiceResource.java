package com.ivr.platform.rest;

import com.ivr.platform.entity.Service;
import com.ivr.platform.entity.VXMLFile;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/services")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ServiceResource {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

    @GET
    public List<Service> getAllServices() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                "SELECT DISTINCT s FROM Service s LEFT JOIN FETCH s.vxmlFile", 
                Service.class)
                .getResultList();
        } finally {
            em.close();
        }
    }

    @GET
    @Path("/{id}")
    public Service getService(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            Service service = em.createQuery(
                "SELECT s FROM Service s LEFT JOIN FETCH s.vxmlFile WHERE s.serviceId = :id", 
                Service.class)
                .setParameter("id", id)
                .getSingleResult();
            
            if (service == null) {
                throw new WebApplicationException("Service not found", Response.Status.NOT_FOUND);
            }
            return service;
        } finally {
            em.close();
        }
    }

    @POST
    public Response createService(Service service) {
        if (service.getServiceName() == null || service.getServiceType() == null || 
            service.getServiceFees() == null || service.getVxmlFile() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            VXMLFile vxmlFile = em.find(VXMLFile.class, service.getVxmlFile().getVxmlId());
            if (vxmlFile == null) {
                throw new WebApplicationException("Invalid VXML file ID", Response.Status.BAD_REQUEST);
            }
            service.setVxmlFile(vxmlFile);
            em.persist(service);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(service).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to create service: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @PUT
    @Path("/{id}")
    public Service updateService(@PathParam("id") Integer id, Service updatedService) {
        if (updatedService.getServiceName() == null || updatedService.getServiceType() == null || 
            updatedService.getServiceFees() == null || updatedService.getVxmlFile() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Service service = em.find(Service.class, id);
            if (service == null) {
                throw new WebApplicationException("Service not found", Response.Status.NOT_FOUND);
            }
            VXMLFile vxmlFile = em.find(VXMLFile.class, updatedService.getVxmlFile().getVxmlId());
            if (vxmlFile == null) {
                throw new WebApplicationException("Invalid VXML file ID", Response.Status.BAD_REQUEST);
            }
            service.setServiceName(updatedService.getServiceName());
            service.setServiceType(updatedService.getServiceType());
            service.setQuota(updatedService.getQuota());
            service.setServiceFees(updatedService.getServiceFees());
            service.setVxmlFile(vxmlFile);
            em.merge(service);
            em.getTransaction().commit();
            return service;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to update service: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteService(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Service service = em.find(Service.class, id);
            if (service == null) {
                throw new WebApplicationException("Service not found", Response.Status.NOT_FOUND);
            }
            em.remove(service);
            em.getTransaction().commit();
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to delete service: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }
}