   package com.ivr.platform.dto;

   public class VXMLFileInfoDTO {
       private Integer vxmlId;
       private String fileName;
       private String filePath;
       private String shortCode;

       public VXMLFileInfoDTO() {}
       public VXMLFileInfoDTO(Integer vxmlId, String fileName, String filePath, String shortCode) {
           this.vxmlId = vxmlId;
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
   }