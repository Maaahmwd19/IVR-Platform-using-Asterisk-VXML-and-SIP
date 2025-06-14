package com.ivr.platform.service;

import com.ivr.platform.entity.VXMLFile;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.io.File;
import javax.annotation.PreDestroy;

public class VXMLFileService {

    private static final String VXML_DIR = "/var/lib/asterisk/vxml";
    private final EntityManagerFactory emf = Persistence.createEntityManagerFactory("IVRPersistenceUnit");

    public void scanAndStoreVXMLFiles() {
        File directory = new File(VXML_DIR);
        if (!directory.exists() || !directory.isDirectory()) {
            throw new IllegalStateException("VXML directory does not exist or is not a directory: " + VXML_DIR);
        }

        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            for (File file : directory.listFiles()) {
                if (file.isFile() && file.getName().endsWith(".vxml")) {
                    String fileName = file.getName();
                    String filePath = file.getAbsolutePath();

                    // Check if file already exists in database
                    Long count = em.createQuery("SELECT COUNT(v) FROM VXMLFile v WHERE v.filePath = :filePath", Long.class)
                            .setParameter("filePath", filePath)
                            .getSingleResult();
                    if (count == 0) {
                        VXMLFile vxmlFile = new VXMLFile(fileName, filePath);
                        em.persist(vxmlFile);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Failed to scan and store VXML files: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @PreDestroy
    public void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}