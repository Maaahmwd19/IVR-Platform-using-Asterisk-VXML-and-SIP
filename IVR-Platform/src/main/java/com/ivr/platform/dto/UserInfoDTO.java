   package com.ivr.platform.dto;

   import java.math.BigDecimal;
   import java.util.List;

   public class UserInfoDTO {
       private Integer userId;
       private String userName;
       private String msisdn;
       private BigDecimal balance;
       private List<ServiceInfoDTO> services;

       public UserInfoDTO() {}
       public UserInfoDTO(Integer userId, String userName, String msisdn, BigDecimal balance, List<ServiceInfoDTO> services) {
           this.userId = userId;
           this.userName = userName;
           this.msisdn = msisdn;
           this.balance = balance;
           this.services = services;
       }

       public Integer getUserId() { return userId; }
       public void setUserId(Integer userId) { this.userId = userId; }
       public String getUserName() { return userName; }
       public void setUserName(String userName) { this.userName = userName; }
       public String getMsisdn() { return msisdn; }
       public void setMsisdn(String msisdn) { this.msisdn = msisdn; }
       public BigDecimal getBalance() { return balance; }
       public void setBalance(BigDecimal balance) { this.balance = balance; }
       public List<ServiceInfoDTO> getServices() { return services; }
       public void setServices(List<ServiceInfoDTO> services) { this.services = services; }
   }