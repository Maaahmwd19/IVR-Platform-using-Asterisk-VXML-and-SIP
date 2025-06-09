package com.ivr.platform.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "service")
public class Service {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "service_id")
    private Integer serviceId;

    @Column(name = "service_name", nullable = false)
    private String serviceName;

    @Column(name = "service_type", nullable = false)
    private String serviceType;

    @Column(name = "quota")
    private Integer quota;

    @Column(name = "service_fees", nullable = false)
    private BigDecimal serviceFees;

    @ManyToOne
    @JoinColumn(name = "vxml_id", nullable = false)
    private VXMLFile vxmlFile;

@JsonIgnore
@OneToMany(mappedBy = "service", cascade = CascadeType.ALL)
private List<UserService> userServices;

    public Service() {}

    public Service(String serviceName, String serviceType, Integer quota, BigDecimal serviceFees, VXMLFile vxmlFile) {
        this.serviceName = serviceName;
        this.serviceType = serviceType;
        this.quota = quota;
        this.serviceFees = serviceFees;
        this.vxmlFile = vxmlFile;
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
    public VXMLFile getVxmlFile() { return vxmlFile; }
    public void setVxmlFile(VXMLFile vxmlFile) { this.vxmlFile = vxmlFile; }
    public java.util.List<UserService> getUserServices() { return userServices; }
    public void setUserServices(java.util.List<UserService> userServices) { this.userServices = userServices; }
}