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
    
    users.add(new User("John Smith", "JS", "+1234567890", "$125.50", "Premium Plan", "active"));
    users.add(new User("Sarah Johnson", "SJ", "+1234567891", "$89.25", "Basic Plan", "inactive"));
    users.add(new User("Mike Wilson", "MW", "+1234567892", "$200.00", "Enterprise Plan", "active"));
    users.add(new User("Emily Davis", "ED", "+1234567893", "$45.75", "Standard Plan", "active"));
    users.add(new User("David Brown", "DB", "+1234567894", "$0.00", "Basic Plan", "inactive"));
    
    return users;
}

// Get all services
public List<Service> getAllServices() {
    List<Service> services = new ArrayList<>();
    
    services.add(new Service("Premium Plan", 342, 5280, "$42,750.00", "+12%"));
    services.add(new Service("Enterprise Plan", 128, 3450, "$25,600.00", "+8%"));
    services.add(new Service("Standard Plan", 567, 4120, "$25,515.00", "+5%"));
    services.add(new Service("Basic Plan", 211, 1840, "$6,330.00", "-2%"));
    
    return services;
}

// Get calls by day
public int[] getCallsByDay() {
    return new int[] {65, 120, 98, 75, 42};
}

// Get weekdays
public String[] getWeekdays() {
    return new String[] {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
}

// Get user growth data
public int[] getUserGrowth() {
    return new int[] {30, 45, 57, 75, 92, 108};
}

// Get months
public String[] getMonths() {
    return new String[] {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
}
%>

<%
// Initialize data
int totalUsers = 1248;
int activeServices = 24;
int sipCallsToday = 867;
double revenue = 24563.00;

// Get the active tab from request parameter or default to "overview"
String activeTab = request.getParameter("tab");
if (activeTab == null) {
    activeTab = "overview";
}

// Get users and services
List<User> users = getAllUsers();
List<Service> services = getAllServices();

// Get chart data
int[] callsByDay = getCallsByDay();
String[] weekdays = getWeekdays();
int[] userGrowth = getUserGrowth();
String[] months = getMonths();
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
              <li class="mr-2">
                <a href="?tab=calls" class="inline-block p-4 <%= activeTab.equals("calls") ? "tab-active" : "border-transparent hover:text-gray-600 hover:border-gray-300" %>">SIP Calls</a>
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
                  <p class="text-xs text-gray-500">+12% from last month</p>
                </div>
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">Active Services</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"></path>
                      <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold"><%= activeServices %></div>
                  <p class="text-xs text-gray-500">+2 new services</p>
                </div>
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">SIP Calls Today</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold"><%= sipCallsToday %></div>
                  <p class="text-xs text-gray-500">+18.2% from yesterday</p>
                </div>
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="flex flex-row items-center justify-between pb-2">
                    <h3 class="text-sm font-medium">Revenue</h3>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4 text-gray-500">
                      <path d="m7 7 10 10"></path>
                      <path d="M17 7v10H7"></path>
                    </svg>
                  </div>
                  <div class="text-2xl font-bold">$<fmt:formatNumber value="<%= revenue %>" pattern="#,##0.00"/></div>
                  <p class="text-xs text-gray-500">+7.4% from last month</p>
                </div>
              </div>

              <!-- Charts -->
              <div class="mt-6 grid gap-4 md:grid-cols-2">
                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="mb-4">
                    <h3 class="text-lg font-medium">SIP Calls by Day</h3>
                    <p class="text-sm text-gray-500">Number of SIP client calls per weekday</p>
                  </div>
                  <div style="height: 300px;">
                    <canvas id="callsChart"></canvas>
                  </div>
                </div>
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

            <!-- Calls Tab -->
            <% if (activeTab.equals("calls")) { %>
              <div class="grid gap-4 md:grid-cols-2">
                <div class="rounded-lg border bg-white p-4 shadow-sm md:col-span-2">
                  <div class="mb-4">
                    <h3 class="text-lg font-medium">SIP Calls by Day</h3>
                    <p class="text-sm text-gray-500">Detailed breakdown of SIP client calls per weekday</p>
                  </div>
                  <div style="height: 400px;">
                    <canvas id="callsDetailChart"></canvas>
                  </div>
                </div>

                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="mb-4">
                    <h3 class="text-lg font-medium">Tuesday Calls</h3>
                    <p class="text-sm text-gray-500">SIP client calls on Tuesday</p>
                  </div>
                  <div class="space-y-4">
                    <div class="flex items-center justify-between">
                      <div class="text-sm font-medium">Total Calls</div>
                      <div class="text-xl font-bold">120</div>
                    </div>
                    <div class="space-y-2">
                      <div class="flex items-center justify-between text-sm">
                        <div>Premium Users</div>
                        <div>48 calls (40%)</div>
                      </div>
                      <div class="h-2 w-full rounded-full bg-gray-100">
                        <div class="h-2 rounded-full bg-purple-600" style="width: 40%"></div>
                      </div>
                    </div>
                    <div class="space-y-2">
                      <div class="flex items-center justify-between text-sm">
                        <div>Enterprise Users</div>
                        <div>36 calls (30%)</div>
                      </div>
                      <div class="h-2 w-full rounded-full bg-gray-100">
                        <div class="h-2 rounded-full bg-blue-600" style="width: 30%"></div>
                      </div>
                    </div>
                    <div class="space-y-2">
                      <div class="flex items-center justify-between text-sm">
                        <div>Standard Users</div>
                        <div>24 calls (20%)</div>
                      </div>
                      <div class="h-2 w-full rounded-full bg-gray-100">
                        <div class="h-2 rounded-full bg-indigo-600" style="width: 20%"></div>
                      </div>
                    </div>
                    <div class="space-y-2">
                      <div class="flex items-center justify-between text-sm">
                        <div>Basic Users</div>
                        <div>12 calls (10%)</div>
                      </div>
                      <div class="h-2 w-full rounded-full bg-gray-100">
                        <div class="h-2 rounded-full bg-violet-600" style="width: 10%"></div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="rounded-lg border bg-white p-4 shadow-sm">
                  <div class="mb-4">
                    <h3 class="text-lg font-medium">Wednesday & Thursday</h3>
                    <p class="text-sm text-gray-500">SIP client calls comparison</p>
                  </div>
                  <div class="space-y-6">
                    <div>
                      <h4 class="mb-2 text-sm font-medium">Wednesday</h4>
                      <div class="flex items-center justify-between">
                        <div class="text-sm text-gray-500">Total Calls</div>
                        <div class="text-xl font-bold">98</div>
                      </div>
                      <div class="mt-2 h-2 w-full rounded-full bg-gray-100">
                        <div class="h-2 rounded-full bg-purple-600" style="width: 82%"></div>
                      </div>
                    </div>

                    <div>
                      <h4 class="mb-2 text-sm font-medium">Thursday</h4>
                      <div class="flex items-center justify-between">
                        <div class="text-sm text-gray-500">Total Calls</div>
                        <div class="text-xl font-bold">75</div>
                      </div>
                      <div class="mt-2 h-2 w-full rounded-full bg-gray-100">
                        <div class="h-2 rounded-full bg-blue-600" style="width: 63%"></div>
                      </div>
                    </div>

                    <div class="rounded-lg border p-4">
                      <h4 class="mb-2 font-medium">Key Insights</h4>
                      <ul class="space-y-2 text-sm">
                        <li class="flex items-center gap-2">
                          <span class="h-2 w-2 rounded-full bg-purple-600"></span>
                          <span>Peak hours: 10AM - 2PM</span>
                        </li>
                        <li class="flex items-center gap-2">
                          <span class="h-2 w-2 rounded-full bg-blue-600"></span>
                          <span>23% higher call duration on Wednesday</span>
                        </li>
                        <li class="flex items-center gap-2">
                          <span class="h-2 w-2 rounded-full bg-indigo-600"></span>
                          <span>12% more international calls on Thursday</span>
                        </li>
                      </ul>
                    </div>
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
      const callsByDay = <%= Arrays.toString(callsByDay) %>;
      const months = <%= Arrays.toString(months).replace("[", "['").replace("]", "']").replace(", ", "', '") %>;
      const userGrowth = <%= Arrays.toString(userGrowth) %>;
      
      // SIP Calls Chart
      const callsChartEl = document.getElementById('callsChart');
      if (callsChartEl) {
        new Chart(callsChartEl, {
          type: 'bar',
          data: {
            labels: weekdays,
            datasets: [{
              label: 'SIP Calls',
              data: callsByDay,
              backgroundColor: 'rgba(124, 58, 237, 0.8)',
              borderColor: 'rgba(124, 58, 237, 1)',
              borderWidth: 1
            }]
          },
          options: chartOptions
        });
      }
      
      // User Growth Chart
      const userGrowthChartEl = document.getElementById('userGrowthChart');
      if (userGrowthChartEl) {
        new Chart(userGrowthChartEl, {
          type: 'line',
          data: {
            labels: months,
            datasets: [{
              label: 'New Users',
              data: userGrowth,
              fill: false,
              borderColor: 'rgba(59, 130, 246, 1)',
              tension: 0.4
            }]
          },
          options: chartOptions
        });
      }
      
      // Detailed Calls Chart
      const callsDetailChartEl = document.getElementById('callsDetailChart');
      if (callsDetailChartEl) {
        new Chart(callsDetailChartEl, {
          type: 'bar',
          data: {
            labels: weekdays,
            datasets: [{
              label: 'SIP Calls',
              data: callsByDay,
              backgroundColor: 'rgba(124, 58, 237, 0.8)',
              borderColor: 'rgba(124, 58, 237, 1)',
              borderWidth: 1
            }]
          },
          options: chartOptions
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
</body>
</html>
