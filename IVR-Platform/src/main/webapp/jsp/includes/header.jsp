<%-- 
    Document   : header
    Created on : Jun 5, 2025, 7:32:16 AM
    Author     : mibrahim
--%>
<%-- 
    Document   : header
    Created on : Jun 11, 2025, 5:23:39 AM
    Author     : syousrei
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
// Get the current page name from the request URI
String requestURI = request.getRequestURI();
String pageName = requestURI.substring(requestURI.lastIndexOf("/") + 1);

// Set title and description based on the current page
String title = "Dashboard";
String description = "Overview of your VoxRoute platform";

if (pageName.contains("user-management")) {
    title = "User Management";
    description = "Manage your VoxRoute users";
} else if (pageName.contains("service-management")) {
    title = "Service Management";
    description = "Manage your VoxRoute services";
} else if (pageName.contains("vxml-management")) {
    title = "VXML Management";
    description = "Manage your VXML applications";
} else if (pageName.contains("vxml-editor")) {
    title = "VXML Editor";
    description = "Edit and manage your VXML files";
} else if (pageName.contains("add-services")) {
    title = "Add Services";
    description = "Add new services to your platform";
} else if (pageName.contains("user-profile")) {
    title = "User Profile";
    description = "Manage your account settings";
} else if (pageName.contains("settings")) {
    title = "Settings";
    description = "Configure your platform settings";
}
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>header page</title>
    </head>
    <!-- Header -->
    <div class="mb-6 flex flex-col items-start justify-between gap-4 md:flex-row md:items-center sticky top-0 bg-gray-50 z-10 py-4">
        <div class="flex items-center gap-2">
            <!-- Mobile menu button -->
            <button class="md:hidden rounded-md p-2 text-gray-500 hover:bg-gray-100" onclick="toggleSidebar()">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="3" y1="12" x2="21" y2="12"></line>
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>
            <div>
                <h1 class="text-2xl font-bold tracking-tight"><%= title %></h1>
                <p class="text-gray-500"><%= description %></p>
            </div>
        </div>
        <div class="flex items-center gap-2">
            <div class="relative">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-2.5 top-2.5 h-4 w-4 text-gray-500">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.3-4.3"></path>
                </svg>
                <input type="search" placeholder="Search..." class="w-[200px] rounded-md border border-gray-300 pl-8 py-1.5 md:w-[260px]">
            </div>
            <!-- Profile Dropdown -->
            <div class="relative">
                <button onclick="toggleProfileMenu()" class="flex h-9 items-center gap-2 rounded-md border border-gray-300 px-3 hover:bg-gray-50">
                    <div class="h-6 w-6 rounded-full bg-purple-600 flex items-center justify-center text-white text-sm font-medium">
                        <%= session.getAttribute("userInitials") != null ? session.getAttribute("userInitials") : "U" %>
                    </div>
                    <span class="hidden md:inline-block text-sm font-medium">Admin</span>
                    <i class="fa-solid fa-chevron-down text-xs text-gray-500"></i>
                </button>
                
                <!-- Dropdown Menu -->
                <div id="profileMenu" class="absolute right-0 mt-2 w-48 rounded-md border border-gray-200 bg-white py-1 shadow-lg hidden">
                    <a href="../profile/profile.jsp" class="flex items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                        <i class="fa-solid fa-user text-gray-500"></i>
                        <span>My Profile</span>
                    </a>
                    <a href="../profile/settings.jsp" class="flex items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                        <i class="fa-solid fa-gear text-gray-500"></i>
                        <span>Settings</span>
                    </a>
                    <div class="border-t border-gray-100 my-1" action="/logout"></div>
                    <a href="${pageContext.request.contextPath}/logout" class="flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-gray-50">
                        <i class="fa-solid fa-right-from-bracket text-red-500"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

<script>
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
</html>
