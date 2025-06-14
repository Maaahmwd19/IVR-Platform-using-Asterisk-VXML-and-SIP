package com.ivr.platform.rest;

import com.ivr.platform.entity.VXMLFile;
import com.ivr.platform.service.VXMLFileService;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.*;
import java.util.List;
import java.util.logging.Logger;
import javax.annotation.PreDestroy;

@Path("/vxmlfiles")
@Produces(MediaType.APPLICATION_JSON)
public class VXMLFileResource {

    private static final Logger LOGGER = Logger.getLogger(VXMLFileResource.class.getName());
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");
    private static final String VXML_DIR = "/var/lib/asterisk/vxml";

    /**
     * Retrieves all VXML files from the database.
     */
    @GET
    public Response getAllVXMLFiles() {
        EntityManager em = emf.createEntityManager();
        try {
            List<VXMLFile> vxmlFiles = em.createQuery("SELECT v FROM VXMLFile v", VXMLFile.class)
                    .getResultList();
            if (vxmlFiles.isEmpty()) {
                LOGGER.info("No VXML files found in database");
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("No VXML files found"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            LOGGER.info("Retrieved " + vxmlFiles.size() + " VXML files");
            return Response.ok(vxmlFiles).build();
        } catch (Exception e) {
            LOGGER.severe("Failed to retrieve VXML files: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to retrieve VXML files: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Retrieves a VXML file by ID.
     */
    @GET
    @Path("/{id}")
    public Response getVXMLFile(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                LOGGER.warning("VXML file not found for ID: " + id);
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("VXML file not found"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            LOGGER.info("Retrieved VXML file with ID: " + id);
            return Response.ok(vxmlFile).build();
        } catch (Exception e) {
            LOGGER.severe("Failed to retrieve VXML file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to retrieve VXML file: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Creates a VXML file and saves its content to disk.
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response createVXMLFile(VXMLFile vxmlFile) {
        if (vxmlFile == null || vxmlFile.getFileName() == null || vxmlFile.getFilePath() == null || vxmlFile.getContent() == null) {
            LOGGER.warning("Invalid VXMLFile request: missing required fields");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Missing required fields: fileName, filePath, and content are required"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        LOGGER.info("Received request to create VXML file: fileName=" + vxmlFile.getFileName() + ", filePath=" + vxmlFile.getFilePath());

        // Validate fileName
        if (!vxmlFile.getFileName().endsWith(".vxml") || vxmlFile.getFileName().trim().isEmpty()) {
            LOGGER.warning("Invalid file format or empty fileName: " + vxmlFile.getFileName());
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid fileName. Must be non-empty and end with .vxml"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Validate filePath
        if (!vxmlFile.getFilePath().startsWith(VXML_DIR + File.separator) || vxmlFile.getFilePath().equals(VXML_DIR) || !vxmlFile.getFilePath().endsWith(".vxml")) {
            LOGGER.warning("Invalid file path: " + vxmlFile.getFilePath());
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid filePath. Must start with " + VXML_DIR + "/, not be the directory itself, and end with .vxml"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Ensure fileName matches the filePath's basename
        String expectedFileName = new File(vxmlFile.getFilePath()).getName();
        if (!vxmlFile.getFileName().equals(expectedFileName)) {
            LOGGER.warning("fileName (" + vxmlFile.getFileName() + ") does not match filePath basename (" + expectedFileName + ")");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("fileName must match the basename of filePath"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Save content to file
        File targetFile = new File(vxmlFile.getFilePath());
        try {
            // Ensure the directory exists
            File parentDir = targetFile.getParentFile();
            if (!parentDir.exists() && !parentDir.mkdirs()) {
                LOGGER.severe("Failed to create directory: " + parentDir.getAbsolutePath());
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(new ErrorResponse("Failed to create directory: " + parentDir.getAbsolutePath()))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            // Check if directory is writable
            if (!parentDir.canWrite()) {
                LOGGER.severe("Directory is not writable: " + parentDir.getAbsolutePath());
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(new ErrorResponse("Directory is not writable: " + parentDir.getAbsolutePath()))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            // Write file (allows overwriting)
            try (FileWriter writer = new FileWriter(targetFile)) {
                writer.write(vxmlFile.getContent());
                writer.flush();
            }
            LOGGER.info("File written successfully: " + targetFile.getAbsolutePath());
        } catch (IOException e) {
            LOGGER.severe("Failed to save file: " + targetFile.getAbsolutePath() + ", Error: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to save file: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Save metadata to database
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            // Check for existing file_path
            Long count = em.createQuery("SELECT COUNT(v) FROM VXMLFile v WHERE v.filePath = :filePath", Long.class)
                    .setParameter("filePath", vxmlFile.getFilePath())
                    .getSingleResult();
            if (count > 0) {
                LOGGER.warning("File path already exists in database: " + vxmlFile.getFilePath());
                return Response.status(Response.Status.CONFLICT)
                        .entity(new ErrorResponse("A file with this path already exists in the database. Please choose a different name."))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            em.persist(vxmlFile);
            em.getTransaction().commit();
            LOGGER.info("VXML file metadata saved successfully: " + vxmlFile.getFilePath());
            return Response.status(Response.Status.CREATED).entity(vxmlFile).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            // Delete file if database save fails
            if (targetFile.exists() && !targetFile.delete()) {
                LOGGER.warning("Failed to delete file after database error: " + targetFile.getAbsolutePath());
            }
            LOGGER.severe("Failed to create VXML file in database: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to create VXML file in database: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Uploads a VXML file to the server and saves its metadata.
     */
    @POST
    @Path("/upload")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response uploadVXMLFile(
            @FormDataParam("file") InputStream fileInputStream,
            @FormDataParam("file") FormDataContentDisposition fileMetaData) {
        if (fileInputStream == null || fileMetaData == null) {
            LOGGER.warning("No file provided in upload request");
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("No file provided"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        String fileName = fileMetaData.getFileName();
        if (!fileName.endsWith(".vxml") || fileName.trim().isEmpty()) {
            LOGGER.warning("Invalid file format or empty fileName: " + fileName);
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid fileName. Must be non-empty and end with .vxml"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        String filePath = VXML_DIR + File.separator + fileName;
        File targetFile = new File(filePath);

        // Save file to disk
        try {
            // Ensure the directory exists
            File parentDir = targetFile.getParentFile();
            if (!parentDir.exists() && !parentDir.mkdirs()) {
                LOGGER.severe("Failed to create directory: " + parentDir.getAbsolutePath());
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(new ErrorResponse("Failed to create directory: " + parentDir.getAbsolutePath()))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            // Check if directory is writable
            if (!parentDir.canWrite()) {
                LOGGER.severe("Directory is not writable: " + parentDir.getAbsolutePath());
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(new ErrorResponse("Directory is not writable: " + parentDir.getAbsolutePath()))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            // Write file (allows overwriting)
            try (OutputStream out = new FileOutputStream(targetFile)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
            }
            LOGGER.info("File uploaded successfully: " + targetFile.getAbsolutePath());
        } catch (IOException e) {
            LOGGER.severe("Failed to save file: " + targetFile.getAbsolutePath() + ", Error: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to save file: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        // Save metadata to database
        VXMLFile vxmlFile = new VXMLFile(fileName, filePath);
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            // Check for existing file_path
            Long count = em.createQuery("SELECT COUNT(v) FROM VXMLFile v WHERE v.filePath = :filePath", Long.class)
                    .setParameter("filePath", filePath)
                    .getSingleResult();
            if (count > 0) {
                LOGGER.warning("File path already exists in database: " + filePath);
                return Response.status(Response.Status.CONFLICT)
                        .entity(new ErrorResponse("A file with this path already exists in the database. Please choose a different name."))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            em.persist(vxmlFile);
            em.getTransaction().commit();
            LOGGER.info("VXML file metadata saved successfully: " + filePath);
            return Response.status(Response.Status.CREATED).entity(vxmlFile).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            if (targetFile.exists() && !targetFile.delete()) {
                LOGGER.warning("Failed to delete file after database error: " + targetFile.getAbsolutePath());
            }
            LOGGER.severe("Failed to save VXML file metadata: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to save VXML file metadata: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Scans the VXML directory and stores metadata in the database.
     */
    @POST
    @Path("/scan")
    public Response scanVXMLFiles() {
        try {
            new VXMLFileService().scanAndStoreVXMLFiles();
            LOGGER.info("VXML files scanned and stored successfully");
            return Response.status(Response.Status.OK)
                    .entity(new ErrorResponse("VXML files scanned and stored successfully"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (Exception e) {
            LOGGER.severe("Failed to scan VXML files: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to scan VXML files: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }
    }

    /**
     * Updates a VXML file’s metadata.
     */
    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response updateVXMLFileMetadata(@PathParam("id") Integer id, VXMLFile updatedVXMLFile) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                LOGGER.warning("VXML file not found for ID: " + id);
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("VXML file not found"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            if (updatedVXMLFile == null || updatedVXMLFile.getFileName() == null || updatedVXMLFile.getFilePath() == null) {
                LOGGER.warning("Missing required fields for VXML file update: ID " + id);
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(new ErrorResponse("Missing required fields: fileName and filePath are required"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            if (!updatedVXMLFile.getFileName().endsWith(".vxml") || updatedVXMLFile.getFileName().trim().isEmpty()) {
                LOGGER.warning("Invalid file format or empty fileName: " + updatedVXMLFile.getFileName());
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(new ErrorResponse("Invalid fileName. Must be non-empty and end with .vxml"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            if (!updatedVXMLFile.getFilePath().startsWith(VXML_DIR + File.separator) || updatedVXMLFile.getFilePath().equals(VXML_DIR) || !updatedVXMLFile.getFilePath().endsWith(".vxml")) {
                LOGGER.warning("Invalid file path: " + updatedVXMLFile.getFilePath());
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(new ErrorResponse("Invalid filePath. Must start with " + VXML_DIR + "/, not be the directory itself, and end with .vxml"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            vxmlFile.setFileName(updatedVXMLFile.getFileName());
            vxmlFile.setFilePath(updatedVXMLFile.getFilePath());
            em.merge(vxmlFile);
            em.getTransaction().commit();
            LOGGER.info("VXML file metadata updated successfully: ID " + id);
            return Response.ok(vxmlFile).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            LOGGER.severe("Failed to update VXML file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to update VXML file: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Updates a VXML file by uploading a new file.
     */
    @PUT
    @Path("/{id}/file")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response updateVXMLFileWithUpload(
            @PathParam("id") Integer id,
            @FormDataParam("file") InputStream fileInputStream,
            @FormDataParam("file") FormDataContentDisposition fileMetaData) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                LOGGER.warning("VXML file not found for ID: " + id);
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(new ErrorResponse("VXML file not found"))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }
            if (fileInputStream == null || fileMetaData == null) {
                LOGGER.warning("No file provided for VXML file update: ID " + id);
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("No file provided"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
            }
            String fileName = fileMetaData.getFileName();
            if (!fileName.endsWith(".vxml") || fileName.trim().isEmpty()) {
                LOGGER.warning("Invalid file format or empty fileName: " + fileName);
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid fileName. Must be non-empty and end with .vxml"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
            }
            String filePath = VXML_DIR + File.separator + fileName;
            File targetFile = new File(filePath);
            try {
                // Ensure the directory exists
                File parentDir = targetFile.getParentFile();
                if (!parentDir.exists() && !parentDir.mkdirs()) {
                    LOGGER.severe("Failed to create directory: " + parentDir.getAbsolutePath());
                    return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                            .entity(new ErrorResponse("Failed to create directory: " + parentDir.getAbsolutePath()))
                            .type(MediaType.APPLICATION_JSON)
                            .build();
                }
                // Check if directory is writable
                if (!parentDir.canWrite()) {
                    LOGGER.severe("Directory is not writable: " + parentDir.getAbsolutePath());
                    return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                            .entity(new ErrorResponse("Directory is not writable: " + parentDir.getAbsolutePath()))
                            .type(MediaType.APPLICATION_JSON)
                            .build();
                }
                // Write file (allows overwriting)
                try (OutputStream out = new FileOutputStream(targetFile)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                    out.flush();
                }
                if (!vxmlFile.getFilePath().equals(filePath)) {
                    File oldFile = new File(vxmlFile.getFilePath());
                    if (oldFile.exists() && !oldFile.delete()) {
                        LOGGER.warning("Failed to delete old file: " + vxmlFile.getFilePath());
                    }
                }
                vxmlFile.setFileName(fileName);
                vxmlFile.setFilePath(filePath);
            } catch (IOException e) {
                LOGGER.severe("Failed to save file: " + targetFile.getAbsolutePath() + ", Error: " + e.getMessage());
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to save file: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
            }
            em.merge(vxmlFile);
            em.getTransaction().commit();
            LOGGER.info("VXML file updated successfully: ID " + id);
            return Response.ok(vxmlFile).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            LOGGER.severe("Failed to update VXML file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to update VXML file: " + e.getMessage()))
                .type(MediaType.APPLICATION_JSON)
                .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Deletes a VXML file and its associated file on disk.
     */
    @DELETE
    @Path("/{id}")
    public Response deleteVXMLFile(@PathParam("id") Integer id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            VXMLFile vxmlFile = em.find(VXMLFile.class, id);
            if (vxmlFile == null) {
                LOGGER.warning("VXML file not found for ID: " + id);
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("VXML file not found"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
            }
            // Delete file from disk
            File file = new File(vxmlFile.getFilePath());
            if (file.exists() && !file.delete()) {
                LOGGER.warning("Failed to delete file from disk: " + vxmlFile.getFilePath());
            }
            em.remove(vxmlFile);
            em.getTransaction().commit();
            LOGGER.info("VXML file deleted successfully: ID " + id);
            return Response.status(Response.Status.NO_CONTENT).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            LOGGER.severe("Failed to delete VXML file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to delete VXML file: " + e.getMessage()))
                .type(MediaType.APPLICATION_JSON)
                .build();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Closes the EntityManagerFactory.
     */
    @PreDestroy
    public void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            LOGGER.info("Closing EntityManagerFactory");
            emf.close();
        }
    }

    /**
     * Helper class for JSON error responses.
     */
    public static class ErrorResponse {
        private String message;

        public ErrorResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}