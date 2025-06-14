package com.ivr.platform.entity;

import javax.persistence.*;

@Entity
@Table(name = "vxml_files")
public class VXMLFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vxml_id")
    private Integer vxmlId;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Transient // Not persisted in the database
    private String content;

    // Constructors
    public VXMLFile() {}

    public VXMLFile(String fileName, String filePath) {
        this.fileName = fileName;
        this.filePath = filePath;
    }

    // Getters and Setters
    public Integer getVxmlId() {
        return vxmlId;
    }

    public void setVxmlId(Integer vxmlId) {
        this.vxmlId = vxmlId;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}