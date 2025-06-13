<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% boolean isDirectAccess = request.getAttribute("javax.servlet.include.request_uri") == null; %>

<% if (isDirectAccess) { %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sidebar Preview</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            min-height: 100vh;
        }
    </style>
</head>
<body>
<% } %>

<div class="sidebar"
     style="background-image: url('../images/wallpaper.jpeg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;">

    <!-- Blur overlay -->
    <div class="sidebar-overlay"></div>

    <!-- Content -->
    <div class="sidebar-content">
        <div class="logo-container">
            <div class="logo-wrapper">
                <img src="../images/logo_vox_route_purple_blue .png" alt="VoxRoute" class="logo" />
            </div>
        </div>

        <nav class="sidebar-nav">
            <div class="nav-items">
                <a href="../dashboard/dashboard.jsp" class="nav-item">
                    <i class="fa-solid fa-gauge-high"></i>
                    <span>Dashboard</span>
                </a>
                <a href="../users/user-management.jsp" class="nav-item">
                    <i class="fa-solid fa-users"></i>
                    <span>User Management</span>
                </a>
                <a href="../service-management.jsp" class="nav-item">
                    <i class="fa-solid fa-gear"></i>
                    <span>Service Management</span>
                </a>
                <a href="../vxml/vxml-management.jsp" class="nav-item">
                    <i class="fa-solid fa-file-code"></i>
                    <span>VXML Management</span>
                </a>
                <a href="../vxml/vxml-editor.jsp" class="nav-item">
                    <i class="fa-solid fa-code"></i>
                    <span>VXML Editor</span>
                </a>
                <a href="../add-services.jsp" class="nav-item">
                    <i class="fa-solid fa-plus"></i>
                    <span>Add Services</span>
                </a>
            </div>
        </nav>
    </div>
</div>

<style>
.sidebar {
    width: 256px;
    color: white;
    display: flex;
    flex-direction: column;
    border-right: 1px solid rgba(107, 114, 128, 0.5);
    position: fixed;
    left: 0;
    top: 0;
    overflow: hidden;
    min-height: 100vh;
}

.sidebar-overlay {
    position: absolute;
    inset: 0;
    background-color: rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(12px);
}

.sidebar-content {
    position: relative;
    z-index: 3;
}

.logo-container {
    padding: 16px;
}

.logo-wrapper {
    display: flex;
    align-items: center;
}

.logo {
    height: 48px;
    width: auto;
    object-fit: contain;
    object-position: left;
}

.sidebar-nav {
    flex: 1;
    padding: 0 16px;
}

.nav-items {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.nav-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.2s;
    backdrop-filter: blur(4px);
    color: white;
    text-decoration: none;
}

.nav-item:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

.nav-item.active {
    background: linear-gradient(to right, rgba(6, 182, 212, 0.3), rgba(168, 85, 247, 0.3));
    border: 1px solid rgba(255, 255, 255, 0.2);
}

.nav-item i {
    width: 20px;
    height: 20px;
    color: white;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const navItems = document.querySelectorAll('.sidebar-nav .nav-item');
        const currentPathname = window.location.pathname;

        function getFilenameFromPath(path) {
            const lastSlashIndex = path.lastIndexOf('/');
            return lastSlashIndex !== -1 ? path.substring(lastSlashIndex + 1) : path;
        }

        const currentPageFilename = getFilenameFromPath(currentPathname);

        navItems.forEach(item => {
            item.classList.remove('active');
            const itemHref = item.getAttribute('href');
            if (itemHref) {
                const itemFilename = getFilenameFromPath(itemHref);
                if (currentPageFilename === itemFilename) {
                    item.classList.add('active');
                }
            }
        });
    });
</script>

<% if (isDirectAccess) { %>
</body>
</html>
<% } %> 