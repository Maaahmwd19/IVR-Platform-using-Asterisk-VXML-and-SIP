<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>

<%!
// User class
public class User {
    private String name;
    private String initials;
    private String msisdn;
    private String balance;
    private String service;
    private String status;
    
    public User(String name, String initials, String msisdn, String balance, String service, String status) {
        this.name = name;
        this.initials = initials;
        this.msisdn = msisdn;
        this.balance = balance;
        this.service = service;
        this.status = status;
    }
    
    public String getName() { return name; }
    public String getInitials() { return initials; }
    public String getMsisdn() { return msisdn; }
    public String getBalance() { return balance; }
    public String getService() { return service; }
    public String getStatus() { return status; }
}

// Service class
public class Service {
    private String name;
    private int users;
    private int calls;
    private String revenue;
    private String growth;
    
    public Service(String name, int users, int calls, String revenue, String growth) {
        this.name = name;
        this.users = users;
        this.calls = calls;
        this.revenue = revenue;
        this.growth = growth;
    }
    
    public String getName() { return name; }
    public int getUsers() { return users; }
    public int getCalls() { return calls; }
    public String getRevenue() { return revenue; }
    public String getGrowth() { return growth; }
}

// Get all users
public List<User> getAllUsers() {
    List<User> users = new ArrayList<>();
    
    try {
        // Create EntityManager
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        // Query database
        List<com.ivr.platform.entity.User> dbUsers = em.createQuery("SELECT u FROM User u", com.ivr.platform.entity.User.class)
            .getResultList();
            
        // Convert database users to display users
        for (com.ivr.platform.entity.User dbUser : dbUsers) {
            String initials = dbUser.getUserName().substring(0, 1).toUpperCase();
            if (dbUser.getUserName().length() > 1) {
                initials += dbUser.getUserName().substring(1, 2).toUpperCase();
            }
            
            users.add(new User(
                dbUser.getUserName(),
                initials,
                dbUser.getMsisdn(),
                String.format("$%.2f", dbUser.getBalance()),
                "Standard Plan",
                "active"
            ));
        }
        
        em.close();
        emf.close();
        
    } catch (Exception e) {
        System.out.println("Error fetching users from database: " + e.getMessage());
        e.printStackTrace();
    }
    
    return users;
}

// Get all services
public List<Service> getAllServices() {
    List<Service> services = new ArrayList<>();
    
    try {
        // Create EntityManager
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        // Query database for active services with their revenue
        String query = "SELECT s.service_name, " +
            "COUNT(DISTINCT us.user_id) as user_count, " +
            "COUNT(DISTINCT us.user_id) * 10 as call_count, " +
            "SUM(s.service_fees) as revenue, " +
            "'+5%' as growth " +
            "FROM user_service us " +
            "JOIN service s ON us.service_id = s.service_id " +
            "WHERE us.activation_status = 'Active' " +
            "GROUP BY s.service_name";
            
        System.out.println("Executing query: " + query);
        
        List<Object[]> activeServicesData = em.createNativeQuery(query).getResultList();
            
        System.out.println("Found " + activeServicesData.size() + " active services");
            
        // Convert database services to display services
        for (Object[] data : activeServicesData) {
            services.add(new Service(
                (String) data[0], // serviceName
                ((Number) data[1]).intValue(), // userCount
                ((Number) data[2]).intValue(), // callCount
                String.format("$%.2f", ((Number) data[3]).doubleValue()), // revenue
                (String) data[4] // growth
            ));
        }
        
        em.close();
        emf.close();
        
    } catch (Exception e) {
        System.out.println("Error fetching services from database: " + e.getMessage());
        e.printStackTrace();
    }
    
    return services;
}

// Get active services count
public int getActiveServicesCount() {
    try {
        // Create EntityManager
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        // Query database for count of active services
        String query = "SELECT COUNT(DISTINCT service_id) FROM user_service WHERE activation_status = 'Active'";
        System.out.println("Executing query: " + query);
        
        javax.persistence.Query nativeQuery = em.createNativeQuery(query);
        Object result = nativeQuery.getSingleResult();
        System.out.println("Query result: " + result);
        
        int count = ((Number) result).intValue();
        System.out.println("Active services count: " + count);
        
        em.close();
        emf.close();
        
        return count;
    } catch (Exception e) {
        System.out.println("Error fetching active services count: " + e.getMessage());
        e.printStackTrace();
        return 0;
    }
}

// Get weekdays
public String[] getWeekdays() {
    return new String[] {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
}

// Get user growth data
public int[] getUserGrowth() {
    try {
        // Create EntityManager
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        // Query to get user count by day of week
        String query = "SELECT " +
            "EXTRACT(DOW FROM created_timestamp) as day_of_week, " +
            "COUNT(*) as user_count " +
            "FROM users " +
            "GROUP BY EXTRACT(DOW FROM created_timestamp) " +
            "ORDER BY day_of_week";
            
        System.out.println("Executing user growth query: " + query);
        
        List<Object[]> results = em.createNativeQuery(query).getResultList();
        
        // Initialize array with 7 days
        int[] userGrowth = new int[7];
        
        // Fill the array with user counts
        for (Object[] row : results) {
            int dayOfWeek = ((Number) row[0]).intValue();
            int userCount = ((Number) row[1]).intValue();
            userGrowth[dayOfWeek] = userCount;
        }
        
        em.close();
        emf.close();
        
        return userGrowth;
    } catch (Exception e) {
        System.out.println("Error fetching user growth: " + e.getMessage());
        e.printStackTrace();
        return new int[7];
    }
}

// Get months
public String[] getMonths() {
    return new String[] {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
}

// Get total revenue
public double getTotalRevenue() {
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        String query = "SELECT SUM(s.service_fees) FROM user_service us JOIN service s ON us.service_id = s.service_id WHERE us.activation_status = 'Active'";
        Object result = em.createNativeQuery(query).getSingleResult();
        double revenue = result != null ? ((Number) result).doubleValue() : 0.0;
        em.close();
        emf.close();
        return revenue;
    } catch (Exception e) {
        System.out.println("Error calculating revenue: " + e.getMessage());
        e.printStackTrace();
        return 0.0;
    }
}

// Get user growth percentage
public String getUserGrowthPercentage() {
    try {
        // Create EntityManager
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        // Query to get user counts for today and yesterday
        String query = "SELECT " +
            "COUNT(CASE WHEN DATE(created_timestamp) = CURRENT_DATE THEN 1 END) as today_count, " +
            "COUNT(CASE WHEN DATE(created_timestamp) = CURRENT_DATE - INTERVAL '1 day' THEN 1 END) as yesterday_count " +
            "FROM users";
            
        System.out.println("Executing user growth percentage query: " + query);
        
        Object[] result = (Object[]) em.createNativeQuery(query).getSingleResult();
        
        int todayCount = ((Number) result[0]).intValue();
        int yesterdayCount = ((Number) result[1]).intValue();
        
        System.out.println("Today's users: " + todayCount + ", Yesterday's users: " + yesterdayCount);
        
        // Calculate percentage change
        double percentageChange = 0.0;
        if (yesterdayCount > 0) {
            percentageChange = ((double)(todayCount - yesterdayCount) / yesterdayCount) * 100;
        }
        
        String sign = percentageChange >= 0 ? "+" : "";
        String growthText = String.format("%s%.1f%% from yesterday", sign, percentageChange);
        
        em.close();
        emf.close();
        
        return growthText;
    } catch (Exception e) {
        System.out.println("Error calculating user growth percentage: " + e.getMessage());
        e.printStackTrace();
        return "+0% from yesterday";
    }
}

// Get active services growth
public String getActiveServicesGrowth() {
    try {
        // Create EntityManager
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        // Query to get active services counts for today and yesterday
        String query = "SELECT " +
            "COUNT(DISTINCT CASE WHEN DATE(us.created_timestamp) = CURRENT_DATE THEN us.service_id END) as today_count, " +
            "COUNT(DISTINCT CASE WHEN DATE(us.created_timestamp) = CURRENT_DATE - INTERVAL '1 day' THEN us.service_id END) as yesterday_count " +
            "FROM user_service us " +
            "WHERE us.is_active = true";
            
        System.out.println("Executing active services growth query: " + query);
        
        Object[] result = (Object[]) em.createNativeQuery(query).getSingleResult();
        
        int todayCount = ((Number) result[0]).intValue();
        int yesterdayCount = ((Number) result[1]).intValue();
        
        System.out.println("Today's active services: " + todayCount + ", Yesterday's active services: " + yesterdayCount);
        
        // Calculate difference
        int difference = todayCount - yesterdayCount;
        String sign = difference >= 0 ? "+" : "";
        
        String growthText = String.format("%s%d new services", sign, Math.abs(difference));
        
        em.close();
        emf.close();
        
        return growthText;
    } catch (Exception e) {
        System.out.println("Error calculating active services growth: " + e.getMessage());
        e.printStackTrace();
        return "+0 new services";
    }
}

// Get revenue growth percentage
public String getRevenueGrowthPercentage() {
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        String query = "SELECT " +
            "COALESCE(SUM(CASE WHEN DATE(us.created_timestamp) = CURRENT_DATE THEN s.service_fees ELSE 0 END), 0) as today_revenue, " +
            "COALESCE(SUM(CASE WHEN DATE(us.created_timestamp) = CURRENT_DATE - INTERVAL '1 day' THEN s.service_fees ELSE 0 END), 0) as yesterday_revenue " +
            "FROM user_service us " +
            "JOIN service s ON us.service_id = s.service_id " +
            "WHERE us.activation_status = 'Active'";
        Object[] result = (Object[]) em.createNativeQuery(query).getSingleResult();
        double todayRevenue = ((Number) result[0]).doubleValue();
        double yesterdayRevenue = ((Number) result[1]).doubleValue();
        double percentageChange = 0.0;
        if (yesterdayRevenue > 0) {
            percentageChange = ((todayRevenue - yesterdayRevenue) / yesterdayRevenue) * 100;
        }
        String sign = percentageChange >= 0 ? "+" : "";
        String growthText = String.format("%s%.1f%% from yesterday", sign, percentageChange);
        em.close();
        emf.close();
        return growthText;
    } catch (Exception e) {
        System.out.println("Error calculating revenue growth: " + e.getMessage());
        e.printStackTrace();
        return "+0% from yesterday";
    }
}

// Get sounds count
public int getSoundsCount() {
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        String query = "SELECT COUNT(*) FROM sound_files";
        Object result = em.createNativeQuery(query).getSingleResult();
        int count = ((Number) result).intValue();
        em.close();
        emf.close();
        return count;
    } catch (Exception e) {
        System.out.println("Error fetching sounds count: " + e.getMessage());
        e.printStackTrace();
        return 0;
    }
}

// دالة لجلب بيانات عدد المستخدمين النشطين لكل خدمة لكل يوم خلال آخر 7 أيام
public List<Map<String, Object>> getServiceUserGrowthByDay() {
    List<Map<String, Object>> data = new ArrayList<>();
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        String query = "SELECT s.service_name, to_char(us.created_timestamp, 'YYYY-MM-DD') as day, COUNT(DISTINCT us.user_id) as user_count " +
            "FROM user_service us " +
            "JOIN service s ON us.service_id = s.service_id " +
            "WHERE us.activation_status = 'Active' AND us.created_timestamp >= CURRENT_DATE - INTERVAL '6 days' " +
            "GROUP BY s.service_name, day " +
            "ORDER BY day, s.service_name";
        List<Object[]> results = em.createNativeQuery(query).getResultList();
        for (Object[] row : results) {
            Map<String, Object> entry = new HashMap<>();
            entry.put("service", row[0]);
            entry.put("day", row[1]);
            entry.put("count", ((Number) row[2]).intValue());
            data.add(entry);
        }
        em.close();
        emf.close();
    } catch (Exception e) {
        System.out.println("Error fetching service user growth by day: " + e.getMessage());
        e.printStackTrace();
    }
    return data;
}
%>

<%
// Initialize data
List<User> users = getAllUsers();
int totalUsers = users.size();
int activeServices = getActiveServicesCount();
int sipCallsToday = 867;
double revenue = getTotalRevenue();
String userGrowthPercentage = getUserGrowthPercentage();
String activeServicesGrowth = getActiveServicesGrowth();
String revenueGrowthPercentage = getRevenueGrowthPercentage();
int soundsCount = getSoundsCount();

// Get the active tab from request parameter or default to "overview"
String activeTab = request.getParameter("tab");
if (activeTab == null) {
    activeTab = "overview";
}

// Get services
List<Service> services = getAllServices();

// Get chart data
String[] weekdays = getWeekdays();
int[] userGrowth = getUserGrowth();
String[] months = getMonths();

List<Map<String, Object>> serviceUserGrowthByDay = getServiceUserGrowthByDay();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>VoxRoute Dashboard</title>
  
  <!-- Include Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- Include Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <!-- Include Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  
  <!-- Custom styles -->
  <style>
    /* Custom gradient for sidebar */
    .bg-gradient-blue-purple {
      background: linear-gradient(to bottom, #1e3a8a, #5b21b6);
    }
    
    /* Custom styles for active tab */
    .tab-active {
      border-bottom: 2px solid #7c3aed;
      color: #7c3aed;
      font-weight: 500;
    }
    
    /* Custom styles for badges */
    .badge-active {
      background-color: #dcfce7;
      color: #166534;
      padding: 0.25rem 0.5rem;
      border-radius: 0.375rem;
      font-size: 0.75rem;
    }
    
    .badge-inactive {
      background-color: #fee2e2;
      color: #991b1b;
      padding: 0.25rem 0.5rem;
      border-radius: 0.375rem;
      font-size: 0.75rem;
    }

    /* Mobile sidebar toggle */
    @media (max-width: 768px) {
      .sidebar {
        transform: translateX(-100%);
        transition: transform 0.3s ease-in-out;
      }
      
      .sidebar.open {
        transform: translateX(0);
      }
      
      .sidebar-overlay {
        display: none;
      }
      
      .sidebar-overlay.open {
        display: block;
      }
    }
  </style>
</head>
        <jsp:include page="/jsp/includes/sidebar.jsp" />

<body class="bg-gray-50">
  <div class="flex min-h-screen">
    <!-- Sidebar overlay for mobile -->
    <div class="sidebar-overlay fixed inset-0 bg-black bg-opacity-50 z-10 md:hidden" onclick="toggleSidebar()"></div>
    
    <!-- Main content -->
    <main class="flex-1 overflow-y-auto ml-[280px] h-screen">
      <div class="container mx-auto p-4 md:p-6">
            <jsp:include page="/jsp/includes/header.jsp" />
        <!-- Tabs -->
        <div class="mb-6">
          <div class="border-b border-gray-200">
            <ul class="flex flex-wrap -mb-px">
              <li class="mr-2">
                <a href="?tab=overview" class="inline-block p-4 <%= activeTab.equals("overview") ? "tab-active" : "border-transparent hover:text-gray-600 hover:border-gray-300" %>">Overview</a>
              </li>
            </ul>
          </div>
          
          <!-- Tab content -->
          <div class="mt-4">
            <!-- Overview Tab -->
            <% if (activeTab.equals("overview")) { %>
              <!-- Stats cards -->
              <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">Total Users</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                      <circle cx="9" cy="7" r="4"></circle>
                      <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                      <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold"><%= totalUsers %></div>
                  <p class="text-xs text-gray-500"><%= userGrowthPercentage %></p>
                </div>
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">Active Services</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold"><%= activeServices %></div>
                  <p class="text-xs text-gray-500"><%= activeServicesGrowth %></p>
                </div>
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">Sounds</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="M11 5L6 9H2v6h4l5 4V5z"></path>
                      <polygon points="23 9 17 15 23 21"></polygon>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold"><%= soundsCount %></div>
                  <p class="text-xs text-gray-500">Total sound files</p>
                </div>
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">Revenue</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold">$<%= String.format("%.2f", revenue) %></div>
                  <p class="text-xs text-gray-500"><%= revenueGrowthPercentage %></p>
                </div>
              </div>

              <!-- Charts -->
              <div class="mt-6 grid gap-4 md:grid-cols-2">
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="mb-4">
                    <h3 class="text-lg font-medium">User Growth</h3>
                    <p class="text-sm text-gray-500">New user registrations over time</p>
                  </div>
                  <div style="height: 300px;">
                    <canvas id="userGrowthChart"></canvas>
                  </div>
                </div>
              </div>
            <% } %>
          </div>
        </div>
      </div>
    </main>
  </div>

  <style>
    @media (max-width: 768px) {
      main {
        margin-left: 0 !important;
      }
    }
  </style>

  <!-- Initialize charts -->
  <script>
    // Toggle sidebar on mobile
    function toggleSidebar() {
      const sidebar = document.querySelector('.sidebar');
      const overlay = document.querySelector('.sidebar-overlay');
      
      sidebar.classList.toggle('open');
      overlay.classList.toggle('open');
    }
    
    // Only initialize charts if they exist on the page
    document.addEventListener('DOMContentLoaded', function() {
      // Chart configuration
      const chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top'
          }
        }
      };
      
      // Convert Java arrays to JavaScript arrays
      const weekdays = <%= Arrays.toString(weekdays).replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
      const months = <%= Arrays.toString(months).replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
      const userGrowth = <%= Arrays.toString(userGrowth) %>;
      
      // User Growth Chart
      const userGrowthChartEl = document.getElementById('userGrowthChart');
      if (userGrowthChartEl) {
        new Chart(userGrowthChartEl, {
          type: 'line',
          data: {
            labels: weekdays,
            datasets: [{
              label: 'New Users',
              data: userGrowth,
              fill: false,
              borderColor: 'rgba(59, 130, 246, 1)',
              tension: 0.4
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                position: 'top'
              },
              title: {
                display: true,
                text: 'User Registration by Day'
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                title: {
                  display: true,
                  text: 'Number of Users'
                },
                ticks: {
                  stepSize: 5,
                  callback: function(value) {
                    return value;
                  }
                }
              },
              x: {
                title: {
                  display: true,
                  text: 'Day of Week'
                }
              }
            }
          }
        });
      }
    });

    // Profile Menu Toggle
    function toggleProfileMenu() {
      const menu = document.getElementById('profileMenu');
      menu.classList.toggle('hidden');
      
      // Close menu when clicking outside
      document.addEventListener('click', function closeMenu(e) {
        if (!e.target.closest('.relative')) {
          menu.classList.add('hidden');
          document.removeEventListener('click', closeMenu);
        }
      });
    }
  </script>

  <!-- رسم بياني لعدد المستخدمين النشطين لكل خدمة لكل يوم -->
  <div class="mt-8">
    <h2 class="text-lg font-semibold mb-4">Service User Growth by Day</h2>
    <div class="bg-white p-4 rounded-lg shadow">
      <canvas id="serviceUserGrowthChart" width="400" height="200"></canvas>
    </div>
  </div>

  <script>
  document.addEventListener('DOMContentLoaded', function() {
    var chartData = [];
    <% 
    for (Map<String, Object> item : serviceUserGrowthByDay) {
    %>
        chartData.push({
            service: '<%= item.get("service") %>',
            day: '<%= item.get("day") %>',
            count: <%= item.get("count") %>
        });
    <% } %>
    
    // Extract days and services
    var days = [...new Set(chartData.map(item => item.day))];
    var services = [...new Set(chartData.map(item => item.service))];
    // تجهيز بيانات كل خدمة
    var datasets = services.map(function(service, idx) {
      var color = ['#6366f1', '#f59e42', '#10b981', '#ef4444', '#a21caf', '#0ea5e9'][idx % 6];
      return {
        label: service,
        data: days.map(day => {
          var found = chartData.find(item => item.day === day && item.service === service);
          return found ? found.count : 0;
        }),
        backgroundColor: color + '80',
        borderColor: color,
        borderWidth: 2,
        fill: false,
        tension: 0.3
      };
    });
    var ctx = document.getElementById('serviceUserGrowthChart').getContext('2d');
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: days,
        datasets: datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'top' },
          title: { display: true, text: 'Active Users per Service by Day' }
        },
        scales: {
          y: {
            beginAtZero: true,
            title: { display: true, text: 'Active Users' }
          },
          x: {
            title: { display: true, text: 'Day' }
          }
        }
      }
    });
  });
  </script>
</body>
</html>
