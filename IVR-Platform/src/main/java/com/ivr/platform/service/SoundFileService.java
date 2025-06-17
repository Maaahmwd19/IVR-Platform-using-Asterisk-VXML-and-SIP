package com.ivr.platform.service;

import com.ivr.platform.entity.SoundFile;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.io.*;
import java.util.UUID;

public class SoundFileService {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");
    private static final String SOUND_DIR = "/var/lib/asterisk/sounds/ivr";

    public void scanAndStoreSoundFiles() {
        File directory = new File(SOUND_DIR);
        if (!directory.exists() || !directory.isDirectory()) {
            throw new IllegalStateException("Sound directory does not exist or is not a directory: " + SOUND_DIR);
        }

        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            File[] files = directory.listFiles((dir, name) -> name.endsWith(".gsm") || name.endsWith(".wav") || name.endsWith(".mp3"));
            if (files != null) {
                for (File file : files) {
                    String fileName = file.getName();
                    String filePath = file.getAbsolutePath();
                    // Transform file name to soundVXMLname (e.g., incorrect_number_ar.gsm -> incorrect number ar)
                    String soundVXMLname = fileName.substring(0, fileName.lastIndexOf('.')).replace('_', ' ');

                    // Check if file already exists in the database
                    boolean exists = !em.createQuery("SELECT s FROM SoundFile s WHERE s.filePath = :filePath", SoundFile.class)
                            .setParameter("filePath", filePath)
                            .getResultList().isEmpty();

                    if (!exists) {
                        SoundFile soundFile = new SoundFile(fileName, filePath, soundVXMLname);
                        em.persist(soundFile);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Failed to store sound files: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    /**
     * Generates a sound file from text using TTS.
     * @param text The text to convert to speech
     * @return The created SoundFile entity
     * @throws RuntimeException if sound generation fails
     */
    public SoundFile generateSound(String text) {
        if (text == null || text.trim().isEmpty()) {
            throw new IllegalArgumentException("Text is required");
        }

        // Generate filename similar to Python script
        String filenameBase = text.toLowerCase().replace(" ", "_");
        String fileName = filenameBase + ".gsm";
        String filePath = SOUND_DIR + File.separator + fileName;
        String soundVXMLname = text;

        // Check if file already exists
        File existingFile = new File(filePath);
        if (existingFile.exists()) {
            throw new IllegalArgumentException("Sound file already exists: " + fileName);
        }

        // Generate the sound file using Python script
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

            // Verify the file was created
            if (!existingFile.exists()) {
                throw new RuntimeException("Sound file was not created: " + filePath);
            }

            // Save metadata to database
            SoundFile soundFile = new SoundFile(fileName, filePath, soundVXMLname);
            EntityManager em = emf.createEntityManager();
            try {
                em.getTransaction().begin();
                em.persist(soundFile);
                em.getTransaction().commit();
                return soundFile;
            } catch (Exception e) {
                em.getTransaction().rollback();
                // Delete the file if database save fails
                existingFile.delete();
                throw new RuntimeException("Failed to save sound file metadata: " + e.getMessage());
            } finally {
                em.close();
            }
        } catch (Exception e) {
            System.err.println("Error executing Python script for text " + text + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to generate sound file: " + e.getMessage());
        }
    }
}