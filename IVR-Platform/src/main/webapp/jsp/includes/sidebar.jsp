<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% boolean isDirectAccess = request.getAttribute("javax.servlet.include.request_uri") == null; %>

<% if (isDirectAccess) { %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sidebar Preview</title>
        <link rel="icon" type="image/png" href="../images/logo.png">
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
                        <a href="../users/list-users.jsp" class="nav-item">
                            <i class="fa-solid fa-users"></i>
                            <span>User Management</span>
                        </a>
                        <a href="../services/list-services.jsp" class="nav-item">
                            <i class="fa-solid fa-gear"></i>
                            <span>Service Management</span>
                        </a>
                        <a href="../vxml/vxml_files.jsp" class="nav-item">
                            <i class="fa-solid fa-file-code"></i>
                            <span>VXML Management</span>
                        </a>

                        <a href="../sounds/add-sounds.jsp" class="nav-item">
                            <i class="fa-solid fa-volume-high"></i>
                            <span>Sounds Management</span>
                        </a>
                        <a href="../java/java-editor.jsp" class="nav-item">
                            <i class="fa-solid fa-code"></i>
                            <span>IVR Management</span>
                        </a>
                    </div>
                </nav>
            </div>
        </div>

        <style>
            .sidebar {
                width: 280px;
                color: white;
                display: flex;
                flex-direction: column;
                border-right: 1px solid rgba(107, 114, 128, 0.2);
                position: fixed;
                left: 0;
                top: 0;
                overflow: hidden;
                min-height: 100vh;
                box-shadow: 4px 0 15px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            .sidebar-overlay {
                position: absolute;
                inset: 0;
                background: linear-gradient(135deg, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.5));
                backdrop-filter: blur(15px);
            }

            .sidebar-content {
                position: relative;
                z-index: 3;
                padding: 20px 0;
            }

            .logo-container {
                padding: 20px;
                margin-bottom: 10px;
            }

            .logo-wrapper {
                display: flex;
                align-items: center;
                transition: transform 0.3s ease;
            }

            .logo-wrapper:hover {
                transform: scale(1.02);
            }

            .logo {
                height: 52px;
                width: auto;
                object-fit: contain;
                object-position: left;
                filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
            }

            .sidebar-nav {
                flex: 1;
                padding: 0 16px;
            }

            .nav-items {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            .nav-item {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 14px 18px;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                backdrop-filter: blur(8px);
                color: white;
                text-decoration: none;
                border: 1px solid rgba(255, 255, 255, 0.1);
                position: relative;
                overflow: hidden;
            }

            .nav-item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
                transform: translateX(-100%);
                transition: transform 0.6s ease;
            }

            .nav-item:hover::before {
                transform: translateX(100%);
            }

            .nav-item:hover {
                background-color: rgba(255, 255, 255, 0.15);
                transform: translateX(5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            .nav-item.active {
                background: linear-gradient(135deg, rgba(6, 182, 212, 0.4), rgba(168, 85, 247, 0.4));
                border: 1px solid rgba(255, 255, 255, 0.3);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            }

            .nav-item i {
                width: 24px;
                height: 24px;
                color: white;
                font-size: 1.2rem;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: transform 0.3s ease;
            }

            .nav-item:hover i {
                transform: scale(1.1);
            }

            .nav-item span {
                font-weight: 500;
                letter-spacing: 0.3px;
                transition: transform 0.3s ease;
            }

            .nav-item:hover span {
                transform: translateX(2px);
            }
        </style>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
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
<% }%> 