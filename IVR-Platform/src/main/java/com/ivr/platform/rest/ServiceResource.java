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
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

// Helper method to execute the Python script for sound generation
private void generateSoundScript(String serviceName) {
    try {
        ProcessBuilder pb = new ProcessBuilder(
            "/usr/bin/python3", // Use absolute path for python3
            "/var/lib/asterisk/generate_tts.py",
            serviceName
        );
        pb.redirectErrorStream(true);
        System.out.println("Executing command: " + String.join(" ", pb.command()));
        Process process = pb.start();
        
        // Capture output for debugging
        java.io.BufferedReader reader = new java.io.BufferedReader(
            new java.io.InputStreamReader(process.getInputStream())
        );
        StringBuilder output = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
            System.out.println("Python script output: " + line);
        }
        
        int exitCode = process.waitFor();
        if (exitCode != 0) {
            System.err.println("Python script failed for service: " + serviceName + " with exit code: " + exitCode);
            System.err.println("Python script output: " + output.toString());
        } else {
            System.out.println("Python script executed successfully for service: " + serviceName);
        }
    } catch (Exception e) {
        System.err.println("Error executing Python script for service " + serviceName + ": " + e.getMessage());
        e.printStackTrace();
    }
}

    @GET
    public List<Service> getAllServices() {
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            return em.createQuery(
                "SELECT s FROM Service s", 
                Service.class)
                .getResultList();
        } catch (Exception e) {
            System.err.println("Error fetching services: " + e.getMessage());
            e.printStackTrace();
            throw new WebApplicationException("Failed to fetch services", Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @GET
    @Path("/{id}")
    public Service getService(@PathParam("id") Integer id) {
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            Service service = em.find(Service.class, id);
            if (service == null) {
                throw new WebApplicationException("Service not found", Response.Status.NOT_FOUND);
            }
            return service;
        } catch (Exception e) {
            System.err.println("Error fetching service: " + e.getMessage());
            e.printStackTrace();
            throw new WebApplicationException("Failed to fetch service", Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @POST
    public Response createService(Service service) {
        if (service.getServiceName() == null) {
            throw new WebApplicationException("Service name is required", Response.Status.BAD_REQUEST);
        }
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            em.getTransaction().begin();
            // If vxmlFile is provided, validate it
            if (service.getVxmlFile() != null && service.getVxmlFile().getVxmlId() != null) {
                VXMLFile vxmlFile = em.find(VXMLFile.class, service.getVxmlFile().getVxmlId());
                if (vxmlFile == null) {
                    throw new WebApplicationException("Invalid VXML file ID", Response.Status.BAD_REQUEST);
                }
                service.setVxmlFile(vxmlFile);
            } else {
                service.setVxmlFile(null); // Explicitly allow null vxmlFile
            }
            em.persist(service);
            em.getTransaction().commit();
            generateSoundScript(service.getServiceName()); // Generate sound for new service
            return Response.status(Response.Status.CREATED).entity(service).build();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Error creating service: " + e.getMessage());
            e.printStackTrace();
            throw new WebApplicationException("Failed to create service", Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @PUT
    @Path("/{id}")
    public Service updateService(@PathParam("id") Integer id, Service updatedService) {
        if (updatedService.getServiceName() == null || updatedService.getServiceType() == null || 
            updatedService.getServiceFees() == null || updatedService.getVxmlFile() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            em.getTransaction().begin();
            Service service = em.find(Service.class, id);
            if (service == null) {
                throw new WebApplicationException("Service not found", Response.Status.NOT_FOUND);
            }
            VXMLFile vxmlFile = em.find(VXMLFile.class, updatedService.getVxmlFile().getVxmlId());
            if (vxmlFile == null) {
                throw new WebApplicationException("Invalid VXML file ID", Response.Status.BAD_REQUEST);
            }
            boolean nameChanged = !service.getServiceName().equals(updatedService.getServiceName());
            service.setServiceName(updatedService.getServiceName());
            service.setServiceType(updatedService.getServiceType());
            service.setQuota(updatedService.getQuota());
            service.setServiceFees(updatedService.getServiceFees());
            service.setVxmlFile(vxmlFile);
            em.merge(service);
            em.getTransaction().commit();
            if (nameChanged) {
                generateSoundScript(updatedService.getServiceName()); // Generate sound if name changed
            }
            return service;
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Error updating service: " + e.getMessage());
            e.printStackTrace();
            throw new WebApplicationException("Failed to update service", Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteService(@PathParam("id") Integer id) {
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            em.getTransaction().begin();
            Service service = em.find(Service.class, id);
            if (service == null) {
                throw new WebApplicationException("Service not found", Response.Status.NOT_FOUND);
            }
            em.remove(service);
            em.getTransaction().commit();
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            System.err.println("Error deleting service: " + e.getMessage());
            e.printStackTrace();
            throw new WebApplicationException("Failed to delete service", Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}