package com.ivr.platform.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "VXML_files")
public class VXMLFile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vxml_id")
    private Integer vxmlId;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Column(name = "short_code", nullable = false, unique = true)
    private String shortCode;

    @JsonIgnore
    @OneToMany(mappedBy = "vxmlFile", cascade = CascadeType.ALL)
    private List<Service> services;

    public VXMLFile() {}

    public VXMLFile(String fileName, String filePath, String shortCode) {
        this.fileName = fileName;
        this.filePath = filePath;
        this.shortCode = shortCode;
    }

    public Integer getVxmlId() { return vxmlId; }
    public void setVxmlId(Integer vxmlId) { this.vxmlId = vxmlId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public String getShortCode() { return shortCode; }
    public void setShortCode(String shortCode) { this.shortCode = shortCode; }
    public List<Service> getServices() { return services; }
    public void setServices(List<Service> services) { this.services = services; }
}