package com.ivr.platform.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "username", nullable = false, length = 100)
    private String userName;

    @Column(name = "msisdn", nullable = false, unique = true, length = 15)
    private String msisdn;

    @Column(name = "balance", nullable = false, precision = 10, scale = 2)
    private BigDecimal balance;

    @Column(name = "created_timestamp")
    private LocalDateTime createdTimestamp;

    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserService> userServices;

    public User() {
        this.balance = BigDecimal.ZERO;
        this.createdTimestamp = LocalDateTime.now();
    }

    public User(String userName, String msisdn, BigDecimal balance) {
        this.userName = userName;
        this.msisdn = msisdn;
        this.balance = balance;
        this.createdTimestamp = LocalDateTime.now();
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getMsisdn() { return msisdn; }
    public void setMsisdn(String msisdn) { this.msisdn = msisdn; }
    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }
    public LocalDateTime getCreatedTimestamp() { return createdTimestamp; }
    public void setCreatedTimestamp(LocalDateTime createdTimestamp) { this.createdTimestamp = createdTimestamp; }
    public List<UserService> getUserServices() { return userServices; }
    public void setUserServices(List<UserService> userServices) { this.userServices = userServices; }
}