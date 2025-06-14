package com.ivr.platform.entity;

import javax.persistence.*;

@Entity
@Table(name = "sound_files")
public class SoundFile {
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

    public SoundFile() {}

    public SoundFile(String fileName, String filePath, String soundVXMLname) {
        this.fileName = fileName;
        this.filePath = filePath;
        this.soundVXMLname = soundVXMLname;
    }

    public Integer getSoundId() { return soundId; }
    public void setSoundId(Integer soundId) { this.soundId = soundId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    public String getSoundVXMLname() { return soundVXMLname; }
    public void setSoundVXMLname(String soundVXMLname) { this.soundVXMLname = soundVXMLname; }
}