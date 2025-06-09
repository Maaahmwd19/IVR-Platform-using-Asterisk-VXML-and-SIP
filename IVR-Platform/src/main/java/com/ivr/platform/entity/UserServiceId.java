package com.ivr.platform.entity;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Embeddable
public class UserServiceId implements Serializable {
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "service_id")
    private Integer serviceId;

    public UserServiceId() {}

    public UserServiceId(Integer userId, Integer serviceId) {
        this.userId = userId;
        this.serviceId = serviceId;
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getServiceId() { return serviceId; }
    public void setServiceId(Integer serviceId) { this.serviceId = serviceId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserServiceId that = (UserServiceId) o;
        return userId.equals(that.userId) && serviceId.equals(that.serviceId);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(userId, serviceId);
    }
}