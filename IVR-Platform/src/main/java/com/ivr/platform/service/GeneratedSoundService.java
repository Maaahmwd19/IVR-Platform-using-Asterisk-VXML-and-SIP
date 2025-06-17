package com.ivr.platform.service;

import com.ivr.platform.entity.GeneratedSound;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.io.File;
import java.util.List;

public class GeneratedSoundService {
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");
    private static final String SOUND_DIR = "/var/lib/asterisk/sounds/ivr";

    public GeneratedSound generateSound(String text) {
        if (text == null || text.trim().isEmpty()) {
            throw new IllegalArgumentException("Text cannot be empty");
        }

        // Generate filename
        String filenameBase = text.toLowerCase().replace(" ", "_");
        String fileName = filenameBase + ".gsm";
        String filePath = SOUND_DIR + File.separator + fileName;
        String soundVXMLname = text;

        // Check if file already exists
        File existingFile = new File(filePath);
        if (existingFile.exists()) {
            throw new IllegalArgumentException("Sound file already exists: " + fileName);
        }

        // Generate sound using Python script
        executePythonScript(text);

        // Verify the file was created
        if (!existingFile.exists()) {
            throw new RuntimeException("Failed to generate sound file");
        }

        // Save to database
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            GeneratedSound sound = new GeneratedSound(fileName, filePath, soundVXMLname);
            em.persist(sound);
            em.getTransaction().commit();
            return sound;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            // Delete the file if database save fails
            existingFile.delete();
            throw new RuntimeException("Failed to save sound metadata: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    public List<GeneratedSound> getAllGeneratedSounds() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT s FROM GeneratedSound s ORDER BY s.createdAt DESC", GeneratedSound.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    private void executePythonScript(String text) {
        try {
            ProcessBuilder pb = new ProcessBuilder(
                "/usr/bin/python3",
                "/var/lib/asterisk/generate_tts.py",
                text
            );
            pb.redirectErrorStream(true);
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
                throw new RuntimeException("Failed to generate sound file: " + output.toString());
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to execute Python script: " + e.getMessage());
        }
    }
} 