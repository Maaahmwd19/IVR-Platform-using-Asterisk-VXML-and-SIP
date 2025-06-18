<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Users Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="icon" type="image/png" href="../images/logo.png">

        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #6366f1, #8b5cf6);
                --primary-shadow: 0 4px 6px rgba(99, 102, 241, 0.2);
                --primary-hover-shadow: 0 6px 8px rgba(99, 102, 241, 0.3);
                --glass-bg: rgba(255, 255, 255, 0.95);
                --glass-border: 1px solid rgba(255, 255, 255, 0.2);
                --glass-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                color: #1e293b;
                line-height: 1.5;
            }

            .main-container {
                display: flex;
                flex: 1;
                min-height: 100vh;
            }

            .content-area {
                flex: 1;
                display: flex;
                flex-direction: column;
                margin-left: 280px;
                transition: margin-left 0.3s ease;
            }

            .header {
                background: var(--glass-bg);
                border-bottom: var(--glass-border);
                padding: 24px 32px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                box-shadow: var(--glass-shadow);
                position: sticky;
                top: 0;
                z-index: 100;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
            }

            .header h1 {
                font-size: 28px;
                font-weight: 700;
                color: #0f172a;
                letter-spacing: -0.025em;
                display: flex;
                align-items: center;
                gap: 12px;
                position: relative;
            }

            .header h1::before {
                content: '';
                display: block;
                width: 4px;
                height: 24px;
                background: var(--primary-gradient);
                border-radius: 2px;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% { opacity: 1; }
                50% { opacity: 0.5; }
                100% { opacity: 1; }
            }

            .header-actions {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .content {
                flex: 1;
                padding: 32px;
                background: transparent;
            }

            .table-container {
                background: var(--glass-bg);
                border-radius: 16px;
                box-shadow: var(--glass-shadow);
                border: var(--glass-border);
                width: 100%;
                max-width: 100%;
                margin: 0 auto;
                overflow: hidden;
                transition: all 0.3s ease;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
            }

            .table-container:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            }

            .table-header {
                padding: 28px 32px;
                border-bottom: var(--glass-border);
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: rgba(248, 250, 252, 0.8);
            }

            .table-title {
                font-size: 20px;
                font-weight: 600;
                color: #0f172a;
                margin-bottom: 6px;
                position: relative;
            }

            .table-subtitle {
                font-size: 14px;
                color: #64748b;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .table-subtitle::before {
                content: '';
                display: block;
                width: 6px;
                height: 6px;
                background: var(--primary-gradient);
                border-radius: 50%;
                animation: bounce 1s infinite;
            }

            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-3px); }
            }

            .search-container {
                position: relative;
                margin-bottom: 0;
                flex: 1;
                text-align: right;
                direction: rtl;
            }

            .search-input {
                padding: 12px 20px 12px 48px;
                width: 100%;
                max-width: 360px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                background: var(--glass-bg);
                color: #1e293b;
                font-size: 14px;
                transition: all 0.3s ease;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                backdrop-filter: blur(8px);
                -webkit-backdrop-filter: blur(8px);
                text-align: right;
                direction: rtl;
            }

            .search-input:focus {
                outline: none;
                border-color: #6366f1;
                box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                background-color: white;
                transform: translateY(-1px);
            }

            .search-icon {
                position: absolute;
                right: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #94a3b8;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .search-input:focus + .search-icon {
                color: #6366f1;
                transform: translateY(-50%) scale(1.1);
            }

            .add-user-btn {
                background: var(--primary-gradient);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 12px;
                cursor: pointer;
                font-weight: 500;
                font-size: 14px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 10px;
                box-shadow: var(--primary-shadow);
                position: relative;
                overflow: hidden;
            }

            .add-user-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(
                    90deg,
                    transparent,
                    rgba(255, 255, 255, 0.2),
                    transparent
                );
                transition: 0.5s;
            }

            .add-user-btn:hover::before {
                left: 100%;
            }

            .add-user-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-hover-shadow);
            }

            .table-wrapper {
                overflow-x: auto;
                padding: 0 32px 32px;
            }

            .users-table {
                width: 100%;
                border-collapse: collapse;
                position: relative;
                z-index: 1;
            }

            .users-table th {
                background-color: rgba(248, 250, 252, 0.8);
                padding: 16px 20px;
                text-align: left;
                font-weight: 600;
                color: #374151;
                border-bottom: var(--glass-border);
            }

            .users-table td {
                padding: 16px 20px;
                border-bottom: var(--glass-border);
            }

            .users-table tr:hover {
                background-color: rgba(248, 250, 252, 0.5);
            }

            .user-info {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .user-avatar-table {
                width: 40px;
                height: 40px;
                background: var(--primary-gradient);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 16px;
                font-weight: 500;
                box-shadow: var(--primary-shadow);
                transition: all 0.3s ease;
            }

            .user-name {
                font-weight: 500;
                color: #1e293b;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .status-active {
                background-color: #dcfce7;
                color: #166534;
            }

            .status-inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .actions {
                display: flex;
                gap: 8px;
            }

            .action-btn {
                width: 36px;
                height: 36px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
                background: var(--glass-bg);
                color: #64748b;
                font-size: 16px;
                position: relative;
                overflow: hidden;
            }

            .action-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: var(--primary-gradient);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .action-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-shadow);
            }

            .action-btn:hover::before {
                opacity: 0.1;
            }

            .action-btn i {
                position: relative;
                z-index: 1;
            }

            .edit-btn:hover {
                color: #0284c7;
            }

            .delete-btn:hover {
                color: #ef4444;
            }

            .services-btn:hover {
                color: #14b8a6;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(15, 23, 42, 0.7);
                z-index: 1000;
                justify-content: center;
                align-items: center;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .modal.show {
                opacity: 1;
            }

            .modal-content {
                background: var(--glass-bg);
                border-radius: 16px;
                width: 90%;
                max-width: 600px;
                padding: 32px;
                position: relative;
                box-shadow: var(--glass-shadow);
                border: var(--glass-border);
                transform: translateY(20px);
                opacity: 0;
                transition: all 0.3s ease;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
            }

            .modal.show .modal-content {
                transform: translateY(0);
                opacity: 1;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
                padding-bottom: 20px;
                border-bottom: var(--glass-border);
            }

            .modal-title {
                font-size: 24px;
                font-weight: 600;
                color: #0f172a;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .modal-title::before {
                content: '';
                display: block;
                width: 4px;
                height: 24px;
                background: var(--primary-gradient);
                border-radius: 2px;
                animation: pulse 2s infinite;
            }

            .close-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #64748b;
                transition: all 0.3s ease;
                width: 36px;
                height: 36px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                position: relative;
                overflow: hidden;
            }

            .close-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: var(--primary-gradient);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .close-btn:hover {
                color: #0f172a;
            }

            .close-btn:hover::before {
                opacity: 0.1;
            }

            .close-btn i {
                position: relative;
                z-index: 1;
            }

            /* Form Styles */
            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #374151;
            }

            .form-group input {
                width: 100%;
                padding: 12px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                color: #1e293b;
                transition: all 0.3s ease;
                background: var(--glass-bg);
            }

            .form-group input:focus {
                outline: none;
                border-color: #6366f1;
                box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                background-color: white;
            }

            .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 24px;
            }

            .btn-primary {
                background: var(--primary-gradient);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: var(--primary-shadow);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-hover-shadow);
            }

            .btn-secondary {
                background: var(--glass-bg);
                color: #475569;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                color: #1e293b;
                transform: translateY(-2px);
            }

            /* Services Table Styles */
            .services-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background: var(--glass-bg);
                border-radius: 12px;
                overflow: hidden;
                box-shadow: var(--glass-shadow);
            }

            .services-table th,
            .services-table td {
                padding: 16px 20px;
                text-align: left;
                border-bottom: var(--glass-border);
            }

            .services-table th {
                background: rgba(248, 250, 252, 0.8);
                font-weight: 600;
                color: #374151;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .services-table td {
                color: #1e293b;
                font-size: 14px;
            }

            .services-table tr:last-child td {
                border-bottom: none;
            }

            .services-table tr:hover td {
                background: rgba(248, 250, 252, 0.5);
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                transition: all 0.3s ease;
            }

            .status-badge::before {
                content: '';
                display: block;
                width: 6px;
                height: 6px;
                border-radius: 50%;
            }

            .status-badge.status-active {
                background-color: #dcfce7;
                color: #166534;
            }

            .status-badge.status-active::before {
                background-color: #166534;
            }

            .status-badge.status-inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .status-badge.status-inactive::before {
                background-color: #991b1b;
            }

            .toggle-status-btn {
                padding: 6px 12px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 12px;
                font-weight: 500;
                background: var(--glass-bg);
                color: #475569;
                transition: all 0.3s ease;
                margin-right: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .toggle-status-btn:hover {
                color: #1e293b;
                transform: translateY(-1px);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .toggle-status-btn[data-status="active"] {
                background: #dcfce7;
                color: #166534;
            }

            .toggle-status-btn[data-status="inactive"] {
                background: #fee2e2;
                color: #991b1b;
            }

            /* Update the services modal content */
            #servicesModal .modal-content {
                max-width: 700px;
            }

            #servicesModal .modal-header {
                margin-bottom: 0;
            }

            #addServiceBtn {
                margin: 20px 0;
            }

            /* Custom Alert Modal */
            .custom-alert-modal .modal-content {
                max-width: 350px;
                text-align: center;
                padding: 36px;
            }

            .custom-alert-modal .modal-icon {
                font-size: 56px;
                color: #16a34a;
                margin-bottom: 24px;
                animation: scaleIn 0.5s ease;
            }

            @keyframes scaleIn {
                0% {
                    transform: scale(0);
                    opacity: 0;
                }
                50% {
                    transform: scale(1.2);
                }
                100% {
                    transform: scale(1);
                    opacity: 1;
                }
            }

            .custom-alert-modal .modal-message {
                font-size: 16px;
                color: #1e293b;
                margin-bottom: 28px;
                line-height: 1.6;
            }

            .custom-alert-modal .modal-footer button {
                background: var(--primary-gradient);
                color: white;
                border: none;
                padding: 12px 28px;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: var(--primary-shadow);
            }

            .custom-alert-modal .modal-footer button:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-hover-shadow);
            }

            /* Responsive Styles */
            @media (max-width: 768px) {
                .content-area {
                    margin-left: 0;
                }
                .sidebar {
                    display: none;
                }
                .sidebar-overlay {
                    display: block;
                }
                .table-container {
                    max-width: 100%;
                }
                .header {
                    padding: 20px;
                }
                .header h1 {
                    font-size: 24px;
                }
                .search-input {
                    max-width: 100%;
                }
                .modal-content {
                    width: 95%;
                    margin: 16px;
                    padding: 24px;
                }
                .table-wrapper {
                    padding: 0 16px 16px;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/jsp/includes/sidebar.jsp" />
        <div class="main-container">
            <div class="content-area">
                <div class="header">
                    <h1>Users Management</h1>
                    <div class="header-actions">
                        <div class="search-container">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" class="search-input" placeholder="Search users..." id="searchInput">
                        </div>
                    </div>
                </div>
                <div class="content">
                    <div class="table-container">
                        <div class="table-header">
                            <div>
                                <h2 class="table-title">All Users</h2>
                                <p class="table-subtitle">Manage your users and their information</p>
                            </div>
                            <button class="add-user-btn">Add New User</button>
                        </div>
                        <div class="table-wrapper">
                            <table class="users-table">
                                <thead>
                                    <tr>
                                        <th>User</th>
                                        <th>MSISDN</th>
                                        <th>Balance</th>
                                        <th>Services</th> <!-- New Column -->
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="usersTableBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Services -->
        <div id="servicesModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">User Services</h2>
                    <button class="close-btn" onclick="closeServicesModal()">×</button>
                </div>
                <button id="addServiceBtn" class="add-user-btn" style="margin-bottom: 16px;">Add Service</button>
                <table class="services-table">
                    <thead>
                        <tr>
                            <th>Service Name</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="servicesTableBody">
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal for Add Service -->
        <div id="addServiceModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Add Service</h2>
                    <button class="close-btn" onclick="closeAddServiceModal()">×</button>
                </div>
                <select id="availableServicesSelect" style="width: 100%; padding: 8px; margin-bottom: 16px;">
                    <!-- Options will be filled dynamically -->
                </select>
                <button id="confirmAddServiceBtn" class="add-user-btn">Confirm</button>
            </div>
        </div>

        <!-- Custom Delete Confirmation Modal -->
        <div id="deleteConfirmModal" class="modal delete-confirm-modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Confirm Deletion</h2>
                </div>
                <p id="deleteConfirmMessage"></p>
                <div class="modal-actions">
                    <button class="btn-delete-confirm" id="confirmDeleteBtn">Delete</button>
                    <button class="btn-cancel-delete" id="cancelDeleteBtn">Cancel</button>
                </div>
            </div>
        </div>

        <!-- Add/Edit User Modal -->
        <div id="addEditUserModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title" id="addEditUserModalTitle">Add New User</h2>
                    <button class="close-btn" onclick="closeAddEditUserModal()">×</button>
                </div>
                <form id="addEditUserForm">
                    <input type="hidden" id="userId" name="userId">
                    <div class="form-group">
                        <label for="userName">User Name</label>
                        <input type="text" id="userName" name="userName" required>
                    </div>
                    <div class="form-group">
                        <label for="msisdn">MSISDN</label>
                        <input type="tel" id="msisdn" name="msisdn" required minlength="11" maxlength="11" oninput="this.value = this.value.replace(/[^0-9]/g, '').substring(0, 11);">
                    </div>
                    <div class="form-group">
                        <label for="balance">Balance</label>
                        <input type="number" id="balance" name="balance" step="0.01" required>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeAddEditUserModal()">Cancel</button>
                        <button type="submit" class="btn-primary">Save User</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Custom Success Alert Modal -->
        <div id="customSuccessAlertModal" class="modal custom-alert-modal">
            <div class="modal-content">
                <div class="modal-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <p class="modal-message" id="customAlertMessage"></p>
                <div class="modal-footer">
                    <button onclick="closeCustomAlert()">OK</button>
                </div>
            </div>
        </div>

        <script>


async function fetchUsers() {
    try {
        const response = await fetch('http://localhost:8080/IVR-Platform/api/users');
        console.log('Response:', response);
        console.log('Content-Type:', response.headers.get('Content-Type'));
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const text = await response.text();
        console.log('Raw Response:', text);
        let users;
        try {
            users = JSON.parse(text);
        } catch (e) {
            console.error('Error parsing JSON:', e);
            return;
        }
        console.log('Parsed Users:', users);
        renderUsers(users);
    } catch (error) {
        console.error('Error fetching users:', error);
    }
}

function renderUsers(users) {
    const tableBody = document.getElementById('usersTableBody');
    tableBody.innerHTML = '';

    if (!Array.isArray(users)) {
        console.error('Users is not an array:', users);
        return;
    }

    users.forEach(user => {
        if (!user || !user.userName) {
            console.error('Invalid user object:', user);
            return;
        }
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>
                <div class="user-info">
                    <div class="user-avatar-table">\${user.userName.charAt(0).toUpperCase()}</div>
                    <span class="user-name">\${user.userName}</span>
                </div>
            </td>
            <td>\${user.msisdn}</td>
            <td>\${user.balance.toFixed(2)} \EGP </td>
            <td>
                <div class="actions">
                    <button class="action-btn services-btn" title="Show Services" onclick='showServices(\${user.userId})'>
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </td>
            <td>
                <div class="actions">
                    <button class="action-btn edit-btn" title="Edit" onclick='openEditUserModal(\${user.userId})'>
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="action-btn delete-btn" title="Delete" onclick='confirmDeleteUser("\${user.userId}", "\${user.userName}")'>
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

document.getElementById('searchInput').addEventListener('input', async (e) => {
    const searchTerm = e.target.value.toLowerCase();
    try {
        const response = await fetch('http://localhost:8080/IVR-Platform/api/users');
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const text = await response.text();
        let users;
        try {
            users = JSON.parse(text);
        } catch (e) {
            console.error('Error parsing JSON:', e);
            return;
        }
        const filteredUsers = users.filter(user =>
            user.userName.toLowerCase().includes(searchTerm) ||
            user.msisdn.includes(searchTerm)
        );
        renderUsers(filteredUsers);
    } catch (error) {
        console.error('Error searching users:', error);
    }
});

// --- Add Service Modal Logic ---
let currentUserIdForServices = null;
let availableServicesForUser = [];

// عدل showServices لتخزين userId الحالي
const originalShowServices = showServices;
showServices = async function(userId) {
    userId = Number(userId);
    currentUserIdForServices = userId;
    await originalShowServices(userId);
}

function closeAddServiceModal() {
    closeModal('addServiceModal');
}

document.getElementById('addServiceBtn').addEventListener('click', async () => {
    if (!currentUserIdForServices) return;
    // 1. احضر كل الخدمات
    const servicesRes = await fetch('http://localhost:8080/IVR-Platform/api/services');
    const allServices = await servicesRes.json();
    // 2. احضر خدمات المستخدم
    const userServicesRes = await fetch('http://localhost:8080/IVR-Platform/api/userservices');
    const userServices = await userServicesRes.json();
    const userServiceIds = userServices
        .filter(s => s.user && s.user.userId == currentUserIdForServices)
        .map(s => s.service.serviceId);
    // 3. فلتر الخدمات غير المشترك فيها
    availableServicesForUser = allServices.filter(s => !userServiceIds.includes(s.serviceId));
    // 4. املأ السلكت
    const select = document.getElementById('availableServicesSelect');
    select.innerHTML = '';
    if (availableServicesForUser.length === 0) {
        select.innerHTML = '<option disabled>No available services</option>';
    } else {
        availableServicesForUser.forEach(service => {
            const option = document.createElement('option');
            option.value = service.serviceId;
            option.textContent = service.serviceName;
            select.appendChild(option);
        });
    }
    // 5. أظهر المودال
    showModal('addServiceModal');
});

document.getElementById('addServiceModal').addEventListener('click', (e) => {
    if (e.target === document.getElementById('addServiceModal')) {
        closeAddServiceModal();
    }
});

document.querySelector('#addServiceModal .close-btn').onclick = () => closeAddServiceModal();

document.getElementById('confirmAddServiceBtn').addEventListener('click', async () => {
    const select = document.getElementById('availableServicesSelect');
    const selectedServiceId = select.value;
    if (!selectedServiceId) return;
    // ابحث عن بيانات الخدمة المختارة
    const selectedService = availableServicesForUser.find(s => s.serviceId == selectedServiceId);
    // ابحث عن بيانات المستخدم
    const usersRes = await fetch('http://localhost:8080/IVR-Platform/api/users');
    const users = await usersRes.json();
    const user = users.find(u => u.userId == currentUserIdForServices);
    if (!user || !selectedService) return;
    // جهز الداتا
    const postData = {
        id: {
            userId: user.userId,
            serviceId: selectedService.serviceId
        },
        user: user,
        service: selectedService,
        activationStatus: "Active"
    };
    // أرسل POST
    await fetch('http://localhost:8080/IVR-Platform/api/userservices', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(postData)
    });
    // أغلق المودالين وحدث الخدمات
    closeAddServiceModal();
    showServices(currentUserIdForServices);
});

async function showServices(userId) {
    userId = Number(userId);
    try {
        const response = await fetch('http://localhost:8080/IVR-Platform/api/userservices');
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const text = await response.text();
        let userServices;
        try {
            userServices = JSON.parse(text);
        } catch (e) {
            console.error('Error parsing JSON:', e);
            return;
        }

        const services = userServices.filter(service => service.user && service.user.userId == userId);
        const modal = document.getElementById('servicesModal');
        const servicesTableBody = document.getElementById('servicesTableBody');
        servicesTableBody.innerHTML = '';

        if (!services || services.length === 0) {
            servicesTableBody.innerHTML = '<tr><td colspan="2">No services found</td></tr>';
        } else {
            services.forEach(service => {
                const row = document.createElement('tr');
                const td1 = document.createElement('td');
                const td2 = document.createElement('td');
                td1.textContent = service.service && service.service.serviceName ? service.service.serviceName : JSON.stringify(service.service);

                const statusSpan = document.createElement('span');
                statusSpan.textContent = service.activationStatus || '';
                statusSpan.className = 'status-badge ' + (service.activationStatus === 'Active' ? 'status-active' : 'status-inactive');

                const toggleBtn = document.createElement('button');
                toggleBtn.textContent = service.activationStatus === 'Active' ? 'Deactivate' : 'Activate';
                toggleBtn.className = 'toggle-status-btn';
                toggleBtn.style.marginLeft = '10px';
                const userId = service.user && service.user.userId ? service.user.userId : '';
                const serviceId = service.service && service.service.serviceId ? service.service.serviceId : '';
                toggleBtn.onclick = async () => {
                    if (!userId || !serviceId) {
                        alert('User or Service ID missing!');
                        return;
                    }
                    const newStatus = service.activationStatus === 'Active' ? 'InActive' : 'Active';
                    const url = 'http://localhost:8080/IVR-Platform/api/userservices/' + userId + '/' + serviceId;

                    try {
                        const response = await fetch(url, {
                            method: 'PUT',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ activationStatus: newStatus })
                        });

                        if (!response.ok) {
                            const errorText = await response.text();
                            throw new Error(`HTTP error! Status: ${response.status}, Details: ${errorText}`);
                        }
                        showServices(userId);
                    } catch (error) {
                        console.error('Error updating service status:', error);
                        alert('Error updating service status. Check console for details.');
                    }
                };

                td2.appendChild(statusSpan);
                td2.appendChild(toggleBtn);

                row.appendChild(td1);
                row.appendChild(td2);
                servicesTableBody.appendChild(row);
            });
        }

        showModal('servicesModal');
    } catch (error) {
        console.error('Error fetching services:', error);
        const servicesTableBody = document.getElementById('servicesTableBody');
        servicesTableBody.innerHTML = '<tr><td colspan="2">Error fetching services</td></tr>';
    }
}

function closeServicesModal() {
    closeModal('servicesModal');
}

// Update event listeners for modals
document.getElementById('servicesModal').addEventListener('click', (e) => {
    if (e.target === document.getElementById('servicesModal')) {
        closeServicesModal();
    }
});

document.getElementById('addEditUserModal').addEventListener('click', (e) => {
    if (e.target === document.getElementById('addEditUserModal')) {
        closeAddEditUserModal();
    }
});

// Update the close button click handlers
document.querySelector('#servicesModal .close-btn').onclick = () => closeServicesModal();
document.querySelector('#addEditUserModal .close-btn').onclick = () => closeAddEditUserModal();

async function confirmDeleteUser(userId, userName) {
    // Store userId temporarily for the modal's confirm button
    document.getElementById('confirmDeleteBtn').dataset.userId = userId;
    document.getElementById('deleteConfirmMessage').textContent = `Are you sure you want to delete user "${userName}"? This action cannot be undone.`;
    openDeleteConfirmModal();
}

async function deleteUser(userId) {
    try {
        const url = 'http://localhost:8080/IVR-Platform/api/users/' + userId;
        console.log('Constructed DELETE URL:', url);

        const response = await fetch(url, {
            method: 'DELETE'
        });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`HTTP error! Status: ${response.status}, Details: ${errorText}`);
        }

        showCustomAlert('User deleted successfully!');
        fetchUsers(); // Refresh the user list
    } catch (error) {
        console.error('Error deleting user:', error);
        alert(`Error deleting user: ${error.message}`);
    }
}

function openDeleteConfirmModal() {
    document.getElementById('deleteConfirmModal').style.display = 'flex';
}

function closeDeleteConfirmModal() {
    document.getElementById('deleteConfirmModal').style.display = 'none';
}

// Event listeners for the custom delete modal buttons
document.getElementById('confirmDeleteBtn').addEventListener('click', async () => {
    const userId = document.getElementById('confirmDeleteBtn').dataset.userId;
    if (userId) {
        await deleteUser(userId);
    }
    closeDeleteConfirmModal();
});

document.getElementById('cancelDeleteBtn').addEventListener('click', () => {
    closeDeleteConfirmModal();
});

document.getElementById('deleteConfirmModal').addEventListener('click', (e) => {
    if (e.target === document.getElementById('deleteConfirmModal')) {
        closeDeleteConfirmModal();
    }
});

function openAddEditUserModal() {
    document.getElementById('addEditUserModalTitle').textContent = 'Add New User';
    document.getElementById('userId').value = '';
    document.getElementById('userName').value = '';
    document.getElementById('msisdn').value = '';
    document.getElementById('balance').value = '';
    showModal('addEditUserModal');
}

function closeAddEditUserModal() {
    closeModal('addEditUserModal');
}

async function openEditUserModal(userId) {
    console.log('openEditUserModal called with userId:', userId); // DEBUG LOG 1
    try {
        console.log('UserId before URL construction:', userId, 'Type:', typeof userId); // DEBUG LOG: Check userId just before URL
        const url = 'http://localhost:8080/IVR-Platform/api/users/' + userId;
        console.log('Fetching user from URL:', url); // DEBUG LOG: Check the exact URL
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const user = await response.json();
        console.log('Fetched user data:', user); // DEBUG LOG 2

        document.getElementById('addEditUserModalTitle').textContent = 'Edit User';
        document.getElementById('userId').value = user.userId;
        console.log('Hidden userId field set to:', document.getElementById('userId').value); // DEBUG LOG 3
        document.getElementById('userName').value = user.userName;
        document.getElementById('msisdn').value = user.msisdn;
        document.getElementById('balance').value = user.balance;

        showModal('addEditUserModal');
    } catch (error) {
        console.error('Error fetching user for edit:', error);
        showCustomAlert('Error loading user data for editing.');
    }
}

// Event listener for the 'Add New User' button
document.querySelector('.add-user-btn').addEventListener('click', () => {
    openAddEditUserModal();
});

document.getElementById('addEditUserForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const userId = document.getElementById('userId').value;
    console.log('Submitting form. userId from hidden field:', userId); // DEBUG LOG 4
    const userName = document.getElementById('userName').value;
    const msisdn = document.getElementById('msisdn').value;
    const balance = parseFloat(document.getElementById('balance').value);

    // Explicit client-side validation for MSISDN length
    if (msisdn.length !== 11) {
        showCustomAlert('MSISDN must be exactly 11 digits long.');
        return;
    }

    const method = userId ? 'PUT' : 'POST';
    const url = userId ? 'http://localhost:8080/IVR-Platform/api/users/' + userId : 'http://localhost:8080/IVR-Platform/api/users';

    try {
        const response = await fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                userName: userName,
                msisdn: msisdn,
                balance: balance
            })
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error('API Error Response Text:', errorText); // Log the raw error text for debugging

            const isMsisdnConflict = errorText.includes('ConstraintViolationException') ||
                                     errorText.includes('Duplicate entry for key') || // More specific for MySQL unique constraint
                                     errorText.includes('unique constraint'); // Generic for other DBs

            console.log('Is MSISDN conflict detected?', isMsisdnConflict);

            if (isMsisdnConflict) {
                showCustomAlert('MSISDN already exists.');
                return; // Stop further processing
            } else {
                throw new Error(`HTTP error! Status: ${response.status}, Details: ${errorText}`);
            }
        }

        showCustomAlert(`User ${userId ? 'updated' : 'added'} successfully!`);
        fetchUsers();
        closeAddEditUserModal();
    } catch (error) {
        console.error(`Error ${userId ? 'updating' : 'adding'} user:`, error);
        showCustomAlert(`Error ${userId ? 'updating' : 'adding'} user. Check console for details.`);
    }
});

function showCustomAlert(message) {
    document.getElementById('customAlertMessage').textContent = message;
    document.getElementById('customSuccessAlertModal').style.display = 'flex';
}

function closeCustomAlert() {
    document.getElementById('customSuccessAlertModal').style.display = 'none';
}

function showModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.style.display = 'flex';
    setTimeout(() => {
        modal.classList.add('show');
    }, 10);
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.remove('show');
    setTimeout(() => {
        modal.style.display = 'none';
    }, 300);
}

fetchUsers();
        </script>
    
    </body>
</html>