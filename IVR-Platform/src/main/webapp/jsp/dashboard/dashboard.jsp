<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.File" %>

<%!
// =============================================
// Model Classes
// =============================================

/**
 * User model class for dashboard display
 */
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
    
    // Getters
    public String getName() { return name; }
    public String getInitials() { return initials; }
    public String getMsisdn() { return msisdn; }
    public String getBalance() { return balance; }
    public String getService() { return service; }
    public String getStatus() { return status; }
}

/**
 * Service model class for dashboard display
 */
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
    
    // Getters
    public String getName() { return name; }
    public int getUsers() { return users; }
    public int getCalls() { return calls; }
    public String getRevenue() { return revenue; }
    public String getGrowth() { return growth; }
}

// =============================================
// Database Access Methods
// =============================================

/**
 * Retrieves all users from the database
 */
public List<User> getAllUsers() {
    List<User> users = new ArrayList<>();
    
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        String query = "SELECT u FROM User u";
        System.out.println("Executing query: " + query);
        
        List<com.ivr.platform.entity.User> dbUsers = em.createQuery(query, com.ivr.platform.entity.User.class)
            .getResultList();
            
        System.out.println("Found " + dbUsers.size() + " users in database");
            
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

/**
 * Retrieves all services from the database
 */
public List<Service> getAllServices() {
    List<Service> services = new ArrayList<>();
    
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
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
            
        for (Object[] data : activeServicesData) {
            services.add(new Service(
                (String) data[0],
                ((Number) data[1]).intValue(),
                ((Number) data[2]).intValue(),
                String.format("$%.2f", ((Number) data[3]).doubleValue()),
                (String) data[4]
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

// =============================================
// Statistics Methods
// =============================================

/**
 * Gets the count of active services
 */
public int getActiveServicesCount() {
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
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

/**
 * Gets user growth data for the last 5 days
 */
public Map<String, Integer> getUserGrowth() {
    Map<String, Integer> userGrowth = new LinkedHashMap<>();
    try {
        java.time.format.DateTimeFormatter dateFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
        java.time.format.DateTimeFormatter dayFormatter = java.time.format.DateTimeFormatter.ofPattern("EEEE");
        java.time.LocalDate today = java.time.LocalDate.now();
        
        for (int i = 4; i >= 0; i--) {
            java.time.LocalDate date = today.minusDays(i);
            String dateStr = date.format(dateFormatter);
            String dayName = date.format(dayFormatter);
            userGrowth.put(dateStr + " (" + dayName + ")", 0);
        }

        String query = "SELECT to_char(created_timestamp, 'YYYY-MM-DD') as date, COUNT(*) as user_count " +
                       "FROM users " +
                       "WHERE created_timestamp >= CURRENT_DATE - INTERVAL '4 days' " +
                       "GROUP BY date " +
                       "ORDER BY date";
                       
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        List<Object[]> results = em.createNativeQuery(query).getResultList();

        for (Object[] row : results) {
            String date = (String) row[0];
            int userCount = ((Number) row[1]).intValue();
            java.time.LocalDate d = java.time.LocalDate.parse(date, dateFormatter);
            String dayName = d.format(dayFormatter);
            userGrowth.put(date + " (" + dayName + ")", userCount);
        }

        em.close();
        emf.close();

    } catch (Exception e) {
        System.out.println("Error fetching user growth: " + e.getMessage());
        e.printStackTrace();
    }

    return userGrowth;
}

// =============================================
// File System Methods
// =============================================

/**
 * Gets the count of sound files in the IVR sounds directory
 */
public int getSoundFilesCount() {
    String soundsDir = "/var/lib/asterisk/sounds/ivr";
    File dir = new File(soundsDir);
    File[] files = dir.listFiles((d, name) -> name.toLowerCase().endsWith(".gsm"));
    return files != null ? files.length : 0;
}

/**
 * Gets the count of VXML files in the VXML directory
 */
public int getVXMLFilesCount() {
    String vxmlDir = "/var/lib/asterisk/vxml";
    File dir = new File(vxmlDir);
    File[] files = dir.listFiles((d, name) -> name.toLowerCase().endsWith(".vxml"));
    return files != null ? files.length : 0;
}

// =============================================
// Growth Calculation Methods
// =============================================

/**
 * Calculates user growth percentage
 */
public String getUserGrowthPercentage() {
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
        String query = "SELECT " +
            "COUNT(CASE WHEN DATE(created_timestamp) = CURRENT_DATE THEN 1 END) as today_count, " +
            "COUNT(CASE WHEN DATE(created_timestamp) = CURRENT_DATE - INTERVAL '1 day' THEN 1 END) as yesterday_count " +
            "FROM users";
            
        System.out.println("Executing user growth percentage query: " + query);
        
        Object[] result = (Object[]) em.createNativeQuery(query).getSingleResult();
        
        int todayCount = ((Number) result[0]).intValue();
        int yesterdayCount = ((Number) result[1]).intValue();
        
        System.out.println("Today's users: " + todayCount + ", Yesterday's users: " + yesterdayCount);
        
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

/**
 * Calculates active services growth
 */
public String getActiveServicesGrowth() {
    try {
        javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
        javax.persistence.EntityManager em = emf.createEntityManager();
        
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

/**
 * Calculates revenue growth percentage
 */
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

// Get weekdays
public String[] getWeekdays() {
    return new String[] {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
}

// Get months
public String[] getMonths() {
    return new String[] {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
}

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
// =============================================
// Initialize Dashboard Data
// =============================================

// Get user data
List<User> users = getAllUsers();
int totalUsers = users.size();
System.out.println("Total users count: " + totalUsers);

// Get service data
int activeServices = getActiveServicesCount();
List<Service> services = getAllServices();

// Get statistics
int sipCallsToday = 867;
String userGrowthPercentage = getUserGrowthPercentage();
String activeServicesGrowth = getActiveServicesGrowth();
String revenueGrowthPercentage = getRevenueGrowthPercentage();
int soundsCount = getSoundFilesCount();
int vxmlFilesCount = getVXMLFilesCount();

// Get chart data
String[] weekdays = getWeekdays();
int[] userGrowth = getUserGrowth().values().stream().mapToInt(Integer::intValue).toArray();
String[] months = getMonths();
List<Map<String, Object>> serviceUserGrowthByDay = getServiceUserGrowthByDay();

// Get active tab
String activeTab = request.getParameter("tab");
if (activeTab == null) {
    activeTab = "overview";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VoxRoute Dashboard</title>
    
    <!-- External CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <!-- External JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Custom styles -->
    <style>
        /* Sidebar styles */
        .bg-gradient-blue-purple {
            background: linear-gradient(to bottom, #1e3a8a, #5b21b6);
        }
        
        /* Tab styles */
        .tab-active {
            border-bottom: 2px solid #7c3aed;
            color: #7c3aed;
            font-weight: 500;
        }
        
        /* Badge styles */
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

        /* Mobile styles */
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
            
            main {
                margin-left: 0 !important;
            }
        }
    </style>
</head>

<body class="bg-gray-50">
    <div class="flex min-h-screen">
        <!-- Sidebar overlay for mobile -->
        <div class="sidebar-overlay fixed inset-0 bg-black bg-opacity-50 z-10 md:hidden" onclick="toggleSidebar()"></div>
        
        <!-- Include sidebar -->
        <jsp:include page="/jsp/includes/sidebar.jsp" />
        
        <!-- Main content -->
        <main class="flex-1 overflow-y-auto ml-[280px] h-screen">
            <div class="container mx-auto p-4 md:p-6">
                <!-- Include header -->
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
                        <% if (activeTab.equals("overview")) { %>
                            <!-- Stats cards -->
                            <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                                <!-- Total Users Card -->
                                <div class="rounded-lg border bg-white p-4 shadow-sm">
                                    <div class="flex flex-row items-center justify-between pb-2">
                                        <h3 class="text-sm font-medium">Total Users</h3>
                                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="9" cy="7" r="4"></circle>
                                                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                            </svg>
                                        </div>
                                    </div>
                                    <div class="text-2xl font-bold"><%= totalUsers %></div>
                                    <p class="text-xs text-gray-500">Total  Users</p>

                                </div>

                                <!-- Active Services Card -->
                                <div class="rounded-lg border bg-white p-4 shadow-sm">
                                    <div class="flex flex-row items-center justify-between pb-2">
                                        <h3 class="text-sm font-medium">Active Services</h3>
                                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                                            </svg>
                                        </div>
                                    </div>
                                    <div class="text-2xl font-bold" id="totalServicesCount">Loading...</div>
                                    <p class="text-xs text-gray-500">Total  Services</p>

                                </div>

                                <!-- Sounds Card -->
                                <div class="rounded-lg border bg-white p-4 shadow-sm">
                                    <div class="flex flex-row items-center justify-between pb-2">
                                        <h3 class="text-sm font-medium">Sounds</h3>
                                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5L6 9H2v6h4l5 4V5z"></path>
                                                <polygon points="23 9 17 15 23 21"></polygon>
                                            </svg>
                                        </div>
                                    </div>
                                    <div class="text-2xl font-bold"><%= soundsCount %></div>
                                    <p class="text-xs text-gray-500">Total sound files</p>
                                </div>

                                <!-- VXML Files Card -->
                                <div class="rounded-lg border bg-white p-4 shadow-sm">
                                    <div class="flex flex-row items-center justify-between pb-2">
                                        <h3 class="text-sm font-medium">VXML Files</h3>
                                        <div class="p-3 rounded-full bg-blue-100 text-blue-600">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path>
                                                <polyline points="14 2 14 8 20 8"></polyline>
                                            </svg>
                                        </div>
                                    </div>
                                    <div class="text-2xl font-bold"><%= vxmlFilesCount %></div>
                                    <p class="text-xs text-gray-500">Total VXML Files</p>
                                </div>
                            </div>

                            <!-- Charts -->
                            <div class="mt-6 grid gap-4 md:grid-cols-2">
                                <!-- User Growth Chart -->
                                <div class="rounded-lg border bg-white p-4 shadow-sm">
                                    <div class="mb-4">
                                        <h3 class="text-lg font-medium">User Growth</h3>
                                        <p class="text-sm text-gray-500">New user registrations over time</p>
                                    </div>
                                    <div style="height: 300px;">
                                        <canvas id="userGrowthChart"></canvas>
                                    </div>
                                </div>

                                <!-- Service Usage Chart -->
                                <div class="rounded-lg border bg-white p-4 shadow-sm">
                                    <div class="mb-4">
                                        <h3 class="text-lg font-medium">Service Usage</h3>
                                        <p class="text-sm text-gray-500">Active services distribution</p>
                                    </div>
                                    <div style="height: 300px;">
                                        <canvas id="serviceUsageChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script>
        // =============================================
        // UI Functions
        // =============================================
        
        /**
         * Toggles the sidebar visibility on mobile
         */
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.querySelector('.sidebar-overlay');
            
            sidebar.classList.toggle('open');
            overlay.classList.toggle('open');
        }
        
        /**
         * Toggles the profile menu visibility
         */
        function toggleProfileMenu() {
            const menu = document.getElementById('profileMenu');
            menu.classList.toggle('hidden');
            
            document.addEventListener('click', function closeMenu(e) {
                if (!e.target.closest('.relative')) {
                    menu.classList.add('hidden');
                    document.removeEventListener('click', closeMenu);
                }
            });
        }

        // =============================================
        // Data Fetching Functions
        // =============================================
        
        /**
         * Updates the total users count
         */
        function updateTotalUsers() {
            fetch('/users/count')
                .then(response => response.json())
                .then(count => {
                    document.querySelector('.text-2xl.font-bold').textContent = count;
                })
                .catch(error => console.error('Error fetching user count:', error));
        }

        /**
         * Updates the service count
         */
        function updateServiceCount() {
            fetch('http://localhost:8080/IVR-Platform/api/services/count')
                .then(response => response.json())
                .then(count => {
                    document.getElementById('totalServicesCount').textContent = count;
                })
                .catch(error => {
                    console.error('Error fetching service count:', error);
                });
        }

        /**
         * Updates the sounds count
         */
        function updateSoundsCount() {
            fetch('http://localhost:8080/IVR-Platform/api/soundfiles/count')
                .then(response => response.json())
                .then(count => {
                    document.getElementById('totalSoundsCount').textContent = count;
                })
                .catch(error => {
                    console.error('Error fetching sounds count:', error);
                });
        }

        // =============================================
        // Chart Initialization
        // =============================================
        
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize data fetching
            updateTotalUsers();
            updateServiceCount();
            updateSoundsCount();
            
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
            const userGrowthData = <%= new com.google.gson.Gson().toJson(getUserGrowth()) %>;
            
            // Initialize User Growth Chart
            const userGrowthChartEl = document.getElementById('userGrowthChart');
            if (userGrowthChartEl) {
                const dates = Object.keys(userGrowthData);
                const counts = Object.values(userGrowthData);
                
                new Chart(userGrowthChartEl, {
                    type: 'line',
                    data: {
                        labels: dates,
                        datasets: [{
                            label: 'New Users',
                            data: counts,
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
                                text: 'User Registration by Date'
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: false,
                                min: 0,
                                max: 3,
                                ticks: {
                                    stepSize: 1,
                                    precision: 0
                                },
                                title: {
                                    display: true,
                                    text: 'Number of Users'
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Date'
                                }
                            }
                        }
                    }
                });
            }

            // Initialize Service Usage Chart
            const serviceUsageCtx = document.getElementById('serviceUsageChart').getContext('2d');
            new Chart(serviceUsageCtx, {
                type: 'bar',
                data: {
                    labels: [
                        <% 
                        try {
                            javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
                            javax.persistence.EntityManager em = emf.createEntityManager();
                            
                            String query = "SELECT s.service_name, COUNT(us.user_id) as active_users " +
                                         "FROM service s " +
                                         "LEFT JOIN user_service us ON s.service_id = us.service_id AND us.activation_status = 'Active' " +
                                         "GROUP BY s.service_name " +
                                         "ORDER BY s.service_name";
                                         
                            List<Object[]> results = em.createNativeQuery(query).getResultList();
                            
                            for (int i = 0; i < results.size(); i++) {
                                Object[] row = results.get(i);
                                out.print("'" + row[0] + "'");
                                if (i < results.size() - 1) {
                                    out.print(", ");
                                }
                            }
                            
                            em.close();
                            emf.close();
                        } catch (Exception e) {
                            System.out.println("Error fetching services: " + e.getMessage());
                            e.printStackTrace();
                        }
                        %>
                    ],
                    datasets: [{
                        label: 'Active Users',
                        data: [
                            <% 
                            try {
                                javax.persistence.EntityManagerFactory emf = javax.persistence.Persistence.createEntityManagerFactory("IVRPersistenceUnit");
                                javax.persistence.EntityManager em = emf.createEntityManager();
                                
                                String query = "SELECT s.service_name, COUNT(us.user_id) as active_users " +
                                           "FROM service s " +
                                           "LEFT JOIN user_service us ON s.service_id = us.service_id AND us.activation_status = 'Active' " +
                                           "GROUP BY s.service_name " +
                                           "ORDER BY s.service_name";
                                           
                                List<Object[]> results = em.createNativeQuery(query).getResultList();
                                
                                for (int i = 0; i < results.size(); i++) {
                                    Object[] row = results.get(i);
                                    out.print(((Number) row[1]).intValue());
                                    if (i < results.size() - 1) {
                                        out.print(", ");
                                    }
                                }
                                
                                em.close();
                                emf.close();
                            } catch (Exception e) {
                                System.out.println("Error fetching service data: " + e.getMessage());
                                e.printStackTrace();
                            }
                            %>
                        ],
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.8)',
                            'rgba(75, 192, 192, 0.8)',
                            'rgba(255, 206, 86, 0.8)',
                            'rgba(255, 99, 132, 0.8)',
                            'rgba(153, 102, 255, 0.8)',
                            'rgba(255, 159, 64, 0.8)',
                            'rgba(199, 199, 199, 0.8)',
                            'rgba(83, 102, 255, 0.8)',
                            'rgba(40, 159, 64, 0.8)',
                            'rgba(210, 199, 199, 0.8)'
                        ],
                        borderColor: [
                            'rgb(54, 162, 235)',
                            'rgb(75, 192, 192)',
                            'rgb(255, 206, 86)',
                            'rgb(255, 99, 132)',
                            'rgb(153, 102, 255)',
                            'rgb(255, 159, 64)',
                            'rgb(199, 199, 199)',
                            'rgb(83, 102, 255)',
                            'rgb(40, 159, 64)',
                            'rgb(210, 199, 199)'
                        ],
                        borderWidth: 1
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
                            text: 'Active Users per Service'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Number of Active Users'
                            },
                            ticks: {
                                stepSize: 1
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Service Type'
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
