package com.ivr.platform.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "generated_sounds")
public class GeneratedSound {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sound_id")
    private Integer soundId;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Column(name = "sound_vxml_name", nullable = false, unique = true)
    private String soundVXMLname;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // Default constructor
    public GeneratedSound() {
    }

    // Constructor with fields
    public GeneratedSound(String fileName, String filePath, String soundVXMLname) {
        this.fileName = fileName;
        this.filePath = filePath;
        this.soundVXMLname = soundVXMLname;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Integer getSoundId() {
        return soundId;
    }

    public void setSoundId(Integer soundId) {
        this.soundId = soundId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getSoundVXMLname() {
        return soundVXMLname;
    }

    public void setSoundVXMLname(String soundVXMLname) {
        this.soundVXMLname = soundVXMLname;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
} 