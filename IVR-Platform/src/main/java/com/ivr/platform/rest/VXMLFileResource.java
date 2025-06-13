package com.ivr.platform.rest;

import com.ivr.platform.entity.VXMLFile;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;
import javax.servlet.annotation.WebServlet;

@WebServlet("/vxmlfiles")
//@Path("/vxmlfiles")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class VXMLFileResource {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

    @GET
    public List<VXMLFile> getAllVXMLFiles() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT v FROM VXMLFile v", VXMLFile.class).getResultList();
        } finally {
            em.close();
        }
    }

    @GET
    @Path("/{id}")
    public VXMLFile getVXMLFile(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                throw new WebApplicationException("VXML file not found", Response.Status.NOT_FOUND);
            }
            return vxmlFile;
        } finally {
            em.close();
        }
    }

    @POST
    public Response createVXMLFile(VXMLFile vxmlFile) {
        if (vxmlFile.getFileName() == null || vxmlFile.getFilePath() == null || vxmlFile.getShortCode() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(vxmlFile);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(vxmlFile).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to create VXML file: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @PUT
    @Path("/{id}")
    public VXMLFile updateVXMLFile(@PathParam("id") Integer id, VXMLFile updatedVXMLFile) {
        if (updatedVXMLFile.getFileName() == null || updatedVXMLFile.getFilePath() == null || updatedVXMLFile.getShortCode() == null) {
            throw new WebApplicationException("Missing required fields", Response.Status.BAD_REQUEST);
        }
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                throw new WebApplicationException("VXML file not found", Response.Status.NOT_FOUND);
            }
            vxmlFile.setFileName(updatedVXMLFile.getFileName());
            vxmlFile.setFilePath(updatedVXMLFile.getFilePath());
            vxmlFile.setShortCode(updatedVXMLFile.getShortCode());
            em.merge(vxmlFile);
            em.getTransaction().commit();
            return vxmlFile;
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to update VXML file: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteVXMLFile(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                throw new WebApplicationException("VXML file not found", Response.Status.NOT_FOUND);
            }
            em.remove(vxmlFile);
            em.getTransaction().commit();
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new WebApplicationException("Failed to delete VXML file: " + e.getMessage(), Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }
}