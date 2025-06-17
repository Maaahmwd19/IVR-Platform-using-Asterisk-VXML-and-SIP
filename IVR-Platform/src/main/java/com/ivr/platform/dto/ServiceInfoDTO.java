 package com.ivr.platform.dto;

   import java.math.BigDecimal;

   public class ServiceInfoDTO {
       private Integer serviceId;
       private String serviceName;
       private String serviceType;
       private Integer quota;
       private BigDecimal serviceFees;
       private String activationStatus;

       public ServiceInfoDTO() {}
       public ServiceInfoDTO(Integer serviceId, String serviceName, String serviceType, Integer quota,
                            BigDecimal serviceFees,String activationStatus) {
           this.serviceId = serviceId;
           this.serviceName = serviceName;
           this.serviceType = serviceType;
           this.quota = quota;
           this.serviceFees = serviceFees;
           this.activationStatus = activationStatus;
       }

       public Integer getServiceId() { return serviceId; }
       public void setServiceId(Integer serviceId) { this.serviceId = serviceId; }
       public String getServiceName() { return serviceName; }
       public void setServiceName(String serviceName) { this.serviceName = serviceName; }
       public String getServiceType() { return serviceType; }
       public void setServiceType(String serviceType) { this.serviceType = serviceType; }
       public Integer getQuota() { return quota; }
       public void setQuota(Integer quota) { this.quota = quota; }
       public BigDecimal getServiceFees() { return serviceFees; }
       public void setServiceFees(BigDecimal serviceFees) { this.serviceFees = serviceFees; }
       public String getActivationStatus() { return activationStatus; }
       public void setActivationStatus(String activationStatus) { this.activationStatus = activationStatus; }


   }