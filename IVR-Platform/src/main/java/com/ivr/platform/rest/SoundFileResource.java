package com.ivr.platform.rest;

import com.ivr.platform.entity.SoundFile;
import com.ivr.platform.service.SoundFileService;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.JsonObjectBuilder;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.*;
import java.util.List;
import javax.annotation.PreDestroy;
import java.util.UUID;

@Path("/soundfiles")
@Produces(MediaType.APPLICATION_JSON)
public class SoundFileResource {

    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");
    private final SoundFileService soundFileService = new SoundFileService();
    private static final String SOUND_DIR = "/var/lib/asterisk/sounds/ivr";
    
    private void generateSoundScript(String text) {
        try {
            ProcessBuilder pb = new ProcessBuilder(
                "/usr/bin/python3",
                "/var/lib/asterisk/generate_tts.py",
                text
            );
            pb.redirectErrorStream(true);
            System.out.println("Executing command: " + String.join(" ", pb.command()));
            Process process = pb.start();
            
            // Capture output for debugging
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
                System.out.println("Python script output: " + line);
            }
            
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                System.err.println("Python script failed for text: " + text + " with exit code: " + exitCode);
                System.err.println("Python script output: " + output.toString());
                throw new RuntimeException("Failed to generate sound file: " + output.toString());
            }
        } catch (Exception e) {
            System.err.println("Error executing Python script for text " + text + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to generate sound file: " + e.getMessage());
        }
    }

    /**
     * Retrieves all sound files from the database.
     * Handles GET /soundfiles.
     */
    @GET
    public Response getAllSoundFiles() {
        EntityManager em = emf.createEntityManager();
        try {
            List<SoundFile> soundFiles = em.createQuery("SELECT s FROM SoundFile s", SoundFile.class)
                    .getResultList();
            if (soundFiles.isEmpty()) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("No sound files found")
                        .build();
            }
            return Response.ok(soundFiles).build();
        } catch (Exception e) {
            throw new WebApplicationException("Failed to retrieve sound files: " + e.getMessage(),
                    Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    /**
     * Gets the total count of sound files.
     * Handles GET /soundfiles/count
     */
    @GET
    @Path("/count")
    public Response getSoundFilesCount() {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery("SELECT COUNT(s) FROM SoundFile s", Long.class)
                    .getSingleResult();
            return Response.ok(count).build();
        } catch (Exception e) {
            throw new WebApplicationException("Failed to get sound files count: " + e.getMessage(),
                    Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    /**
     * Uploads a sound file to the server and saves its metadata to the database.
     * Handles POST /soundfiles/upload.
     */
    @POST
    @Path("/upload")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response uploadSoundFile(
            @FormDataParam("file") InputStream fileInputStream,
            @FormDataParam("file") FormDataContentDisposition fileMetaData) {
        if (fileInputStream == null || fileMetaData == null) {
            throw new WebApplicationException("No file provided", Response.Status.BAD_REQUEST);
        }

        String fileName = fileMetaData.getFileName();
        if (!fileName.endsWith(".gsm") && !fileName.endsWith(".wav") && !fileName.endsWith(".mp3")) {
            throw new WebApplicationException("Invalid file format. Only .gsm, .wav, or .mp3 allowed",
                    Response.Status.BAD_REQUEST);
        }

        String filePath = SOUND_DIR + File.separator + fileName;
        String soundVXMLname = fileName.substring(0, fileName.lastIndexOf('.')).replace('_', ' ');

        // Save file to disk
        try {
            File targetFile = new File(filePath);
            if (targetFile.exists()) {
                throw new WebApplicationException("File already exists", Response.Status.CONFLICT);
            }
            try (OutputStream out = new FileOutputStream(targetFile)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
        } catch (IOException e) {
            throw new WebApplicationException("Failed to save file: " + e.getMessage(),
                    Response.Status.INTERNAL_SERVER_ERROR);
        }

        // Save metadata to database
        SoundFile soundFile = new SoundFile(fileName, filePath, soundVXMLname);
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(soundFile);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(soundFile).build();
        } catch (Exception e) {
            em.getTransaction().rollback();
            // Delete the file if database save fails
            new File(filePath).delete();
            throw new WebApplicationException("Failed to save sound file metadata: " + e.getMessage(),
                    Response.Status.INTERNAL_SERVER_ERROR);
        } finally {
            em.close();
        }
    }

    /**
     * Scans the sound file directory and stores metadata in the database.
     * Handles POST /soundfiles/scan.
     */
    @POST
    @Path("/scan")
    public Response scanSoundFiles() {
        try {
            soundFileService.scanAndStoreSoundFiles();
            return Response.status(Response.Status.OK)
                    .entity("Sound files scanned and stored successfully")
                    .build();
        } catch (Exception e) {
            throw new WebApplicationException("Failed to scan sound files: " + e.getMessage(),
                    Response.Status.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Generates a sound file from text using TTS.
     * Handles POST /soundfiles/generate.
     */
    @POST
    @Path("/generate")
    @Consumes(MediaType.TEXT_PLAIN)
    @Produces(MediaType.APPLICATION_JSON)
    public Response generateSoundFile(String text) {
        if (text == null || text.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                .entity("{\"error\": \"Text cannot be empty\"}")
                .build();
        }

        EntityManager em = emf.createEntityManager();
        try {
            // Generate filename similar to Python script
            String filenameBase = text.toLowerCase().replace(" ", "_");
            String fileName = filenameBase + ".gsm";
            String filePath = SOUND_DIR + File.separator + fileName;
            String soundVXMLname = text;

            // Check if file already exists
            File existingFile = new File(filePath);
            if (existingFile.exists()) {
                return Response.status(Response.Status.CONFLICT)
                    .entity("{\"error\": \"Sound file already exists: " + fileName + "\"}")
                    .build();
            }

            // Generate sound using Python script
            generateSoundScript(text);

            // Verify the file was created
            if (!existingFile.exists()) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to generate sound file\"}")
                    .build();
            }

            // Save metadata to database
            em.getTransaction().begin();
            SoundFile soundFile = new SoundFile(fileName, filePath, soundVXMLname);
            em.persist(soundFile);
            em.getTransaction().commit();

            return Response.status(Response.Status.CREATED)
                .entity(soundFile)
                .build();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity("{\"error\": \"Failed to generate sound: " + e.getMessage() + "\"}")
                .build();
        } finally {
            em.close();
        }
    }

    /**
     * Closes the EntityManagerFactory when the resource is destroyed.
     */
    @PreDestroy
    public void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}