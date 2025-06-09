package com.ivr.platform.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "userName", nullable = false)
    private String userName;

    @Column(name = "MSISDN", nullable = false, unique = true)
    private String msisdn;

    @Column(name = "balance", nullable = false)
    private BigDecimal balance;

    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserService> userServices;

    public User() {}

    public User(String userName, String msisdn, BigDecimal balance) {
        this.userName = userName;
        this.msisdn = msisdn;
        this.balance = balance;
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getMsisdn() { return msisdn; }
    public void setMsisdn(String msisdn) { this.msisdn = msisdn; }
    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }
    public List<UserService> getUserServices() { return userServices; }
    public void setUserServices(List<UserService> userServices) { this.userServices = userServices; }
}