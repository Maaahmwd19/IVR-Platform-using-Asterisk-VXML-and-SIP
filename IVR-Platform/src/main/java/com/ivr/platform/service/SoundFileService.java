package com.ivr.platform.service;

import com.ivr.platform.entity.SoundFile;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.io.File;

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
}