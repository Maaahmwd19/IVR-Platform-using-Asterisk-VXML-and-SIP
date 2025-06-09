package com.ivr.platform.entity;

import javax.persistence.*;

@Entity
@Table(name = "user_service")
public class UserService {
    @EmbeddedId
    private UserServiceId id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @MapsId("serviceId")
    @JoinColumn(name = "service_id")
    private Service service;

    @Column(name = "activation_status", nullable = false)
    private String activationStatus;

    public UserService() {}

    public UserService(User user, Service service, String activationStatus) {
        this.id = new UserServiceId(user.getUserId(), service.getServiceId());
        this.user = user;
        this.service = service;
        this.activationStatus = activationStatus;
    }

    public UserServiceId getId() { return id; }
    public void setId(UserServiceId id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public Service getService() { return service; }
    public void setService(Service service) { this.service = service; }
    public String getActivationStatus() { return activationStatus; }
    public void setActivationStatus(String activationStatus) { this.activationStatus = activationStatus; }
}