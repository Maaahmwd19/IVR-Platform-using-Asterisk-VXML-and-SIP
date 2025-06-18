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
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background-color: #f3f4f6;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
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
                margin-left: 256px; /* التعديل الأصلي */
            }
            .header {
                background-color: white;
                border-bottom: 1px solid #e5e7eb;
                padding: 16px 24px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .header h1 {
                font-size: 24px;
                font-weight: 600;
                color: #111827;
            }
            .header-actions {
                display: flex;
                align-items: center;
                gap: 16px;
            }
            .search-container {
                position: relative;
                margin-bottom: 16px;
            }
            .search-input {
                padding: 8px 12px 8px 32px;
                width: 100%;
                max-width: 300px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                background-color: white;
                color: #111827;
            }
            .search-input:focus {
                outline: none;
                border-color: #8b5cf6;
                box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
            }
            .search-icon {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
            }
            .content {
                flex: 1;
                padding: 24px;
                background-color: #f9fafb;
            }
            .table-container {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid #e5e7eb;
                width: 100%;
                max-width: 100%;  /* <<< هنا التعديل */
                margin: 0 auto;
            }
            .table-header {
                padding: 24px;
                border-bottom: 1px solid #e5e7eb;
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 15px;
            }
            .table-title {
                font-size: 18px;
                font-weight: 600;
                color: #111827;
                margin-bottom: 4px;
            }
            .table-subtitle {
                font-size: 14px;
                color: #6b7280;
            }
            .add-user-btn {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            .add-user-btn:hover {
                opacity: 0.9;
            }
            .table-wrapper {
                overflow-x: auto;
            }
            .users-table {
                width: 100%;
                border-collapse: collapse;
                position: relative;
                z-index: 1;
            }
            .users-table th {
                background-color: #f9fafb;
                padding: 12px 20px;  /* قللناها شوية */
                text-align: left;
                font-weight: 600;
                color: #374151;
                border-bottom: 1px solid #e5e7eb;
            }
            .users-table td {
                padding: 14px 20px;  /* قللناها شوية */
                border-bottom: 1px solid #e5e7eb;
            }
            .users-table tr:hover {
                background-color: #f9fafb;
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .user-avatar-table {
                width: 32px;
                height: 32px;
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 12px;
                font-weight: 500;
            }
            .user-name {
                font-weight: 500;
                color: #111827;
            }
            .status-badge {
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
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
                width: 32px;
                height: 32px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
            }
            .edit-btn {
                background-color: transparent;
                color: #9ca3af;
            }
            .edit-btn:hover {
                background-color: #f3e8ff;
                color: #ad0da5;
            }
            .delete-btn {
                background-color: transparent;
                color: #9ca3af;
            }
            .delete-btn:hover {
                background-color: #fee2e2;
                color: #ef4444;
            }
            .view-btn {
                background-color: transparent;
                color: #9ca3af;
            }
            .view-btn:hover {
                background-color: #e0f2fe;
                color: #0284c7;
            }
            /* New Styles for Services Button and Modal */
            .services-btn {
                background-color: transparent;
                color: #9ca3af;
            }
            .services-btn:hover {
                background-color: #e6fffa;
                color: #14b8a6;
            }
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                justify-content: center;
                align-items: center;
            }
            .modal-content {
                background-color: white;
                border-radius: 8px;
                width: 90%;
                max-width: 600px;
                padding: 24px;
                position: relative;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 16px;
            }
            .modal-title {
                font-size: 18px;
                font-weight: 600;
                color: #111827;
            }
            .close-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #6b7280;
            }
            .close-btn:hover {
                color: #111827;
            }
            .services-table {
                width: 100%;
                border-collapse: collapse;
            }
            .services-table th,
            .services-table td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                text-align: left;
            }
            .services-table th {
                background-color: #f9fafb;
                font-weight: 600;
                color: #374151;
            }
            .status-badge.status-active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-badge.status-inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }
            .toggle-status-btn {
                padding: 4px 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                background: #f3f4f6;
                color: #333;
                transition: background 0.2s;
            }
            .toggle-status-btn:hover {
                background: #e5e7eb;
            }

            /* New Styles for Custom Delete Modal */
            .delete-confirm-modal .modal-content {
                max-width: 400px;
                text-align: center;
            }
            .delete-confirm-modal .modal-header {
                justify-content: center;
                border-bottom: none;
                margin-bottom: 0;
            }
            .delete-confirm-modal .modal-title {
                font-size: 20px;
                margin-bottom: 10px;
            }
            .delete-confirm-modal p {
                color: #4b5563;
                margin-bottom: 20px;
            }
            .delete-confirm-modal .modal-actions {
                display: flex;
                justify-content: center;
                gap: 15px;
            }
            .delete-confirm-modal .btn-delete-confirm {
                background-color: #ef4444;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            .delete-confirm-modal .btn-delete-confirm:hover {
                background-color: #dc2626;
            }
            .delete-confirm-modal .btn-cancel-delete {
                background-color: #e5e7eb;
                color: #374151;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            .delete-confirm-modal .btn-cancel-delete:hover {
                background-color: #d1d5db;
            }

            /* New Styles for Add User Modal */
            #addEditUserModal .modal-content {
                max-width: 500px;
            }
            #addEditUserModal .form-group {
                margin-bottom: 15px;
            }
            #addEditUserModal label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #374151;
            }
            #addEditUserModal input[type="text"],
            #addEditUserModal input[type="tel"],
            #addEditUserModal input[type="number"] {
                width: calc(100% - 20px);
                padding: 10px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 16px;
                color: #111827;
            }
            #addEditUserModal input[type="text"]:focus,
            #addEditUserModal input[type="tel"]:focus,
            #addEditUserModal input[type="number"]:focus {
                outline: none;
                border-color: #8b5cf6;
                box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
            }
            #addEditUserModal .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 20px;
            }
            #addEditUserModal .btn-primary {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            #addEditUserModal .btn-primary:hover {
                opacity: 0.9;
            }
            #addEditUserModal .btn-secondary {
                background-color: #e5e7eb;
                color: #374151;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            #addEditUserModal .btn-secondary:hover {
                background-color: #d1d5db;
            }

            /* New Styles for Custom Alert Modal (Success) */
            .custom-alert-modal .modal-content {
                max-width: 350px;
                text-align: center;
                padding: 30px;
            }
            .custom-alert-modal .modal-icon {
                font-size: 48px;
                color: #e74c3c; /* Red for error */
                margin-bottom: 20px;
            }
            .custom-alert-modal .modal-message {
                font-size: 18px;
                color: #333;
                margin-bottom: 25px;
            }
            .custom-alert-modal .modal-footer button {
                background: linear-gradient(45deg, #8b5cf6, #ec4899); /* Use existing button style */
                color: white;
                border: none;
                padding: 10px 25px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            .custom-alert-modal .modal-footer button:hover {
                opacity: 0.9;
            }

            /* Responsive */
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
                    <button class="close-btn" onclick="closeModal()">×</button>
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
                        <input type="tel" id="msisdn" name="msisdn" required minlength="11" maxlength="11" oninput="validateMsisdn()">
                        <span id="msisdnError" style="color: #e74c3c; font-size: 13px; display: none;"></span>
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
                <div class="modal-icon" id="customAlertIcon">
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
    document.getElementById('addServiceModal').style.display = 'none';
}
document.getElementById('addServiceModal').addEventListener('click', (e) => {
    if (e.target === document.getElementById('addServiceModal')) {
        closeAddServiceModal();
    }
});

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
    document.getElementById('addServiceModal').style.display = 'flex';
});

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
        console.log('userId for services:', userId);
        console.log('userServices:', userServices);

        // فلترة الخدمات الخاصة باليوزر
        const services = userServices.filter(service => service.user && service.user.userId == userId);
        console.log('Filtered services:', services);

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

                // حالة الخدمة مع زر التبديل
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
                    console.log('Toggle button clicked!');
                    console.log('Current userId:', userId);
                    console.log('Current serviceId:', serviceId);

                    if (!userId || !serviceId) {
                        alert('User or Service ID missing!');
                        console.log('User ID or Service ID missing!');
                        return;
                    }
                    const newStatus = service.activationStatus === 'Active' ? 'InActive' : 'Active';
                    console.log('New status to set:', newStatus);

                    const url = 'http://localhost:8080/IVR-Platform/api/userservices/' + userId + '/' + serviceId;
                    console.log('Constructed URL using concatenation:', url);

                    try {
                        const response = await fetch(url, {
                            method: 'PUT',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ activationStatus: newStatus })
                        });

                        console.log('Fetch response:', response);
                        if (!response.ok) {
                            const errorText = await response.text();
                            const isMsisdnConflict = errorText.includes('already exists') ||
                                                     errorText.includes('is already in use') ||
                                                     errorText.includes('ConstraintViolationException') ||
                                                     errorText.includes('Duplicate entry for key') ||
                                                     errorText.includes('unique constraint');
                            if (isMsisdnConflict) {
                                showCustomAlert('MSISDN already exists.');
                                return; // Stop further processing
                            } else {
                                throw new Error(`HTTP error! Status: ${response.status}, Details: ${errorText}`);
                            }
                        }
                        console.log('Service status updated successfully.');
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

        modal.style.display = 'flex';
    } catch (error) {
        console.error('Error fetching services:', error);
        const servicesTableBody = document.getElementById('servicesTableBody');
        servicesTableBody.innerHTML = '<tr><td colspan="2">Error fetching services</td></tr>';
    }
}

function closeModal() {
    const modal = document.getElementById('servicesModal');
    modal.style.display = 'none';
}

document.getElementById('servicesModal').addEventListener('click', (e) => {
    if (e.target === document.getElementById('servicesModal')) {
        closeModal();
    }
});

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
            const isMsisdnConflict = errorText.includes('already exists') ||
                                     errorText.includes('is already in use') ||
                                     errorText.includes('ConstraintViolationException') ||
                                     errorText.includes('Duplicate entry for key') ||
                                     errorText.includes('unique constraint');
            if (isMsisdnConflict) {
                showCustomAlert('MSISDN already exists.');
                return; // Stop further processing
            } else {
                throw new Error(`HTTP error! Status: ${response.status}, Details: ${errorText}`);
            }
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

function closeAddEditUserModal() {
    document.getElementById('addEditUserModal').style.display = 'none';
}

function openAddEditUserModal() {
    document.getElementById('addEditUserModalTitle').textContent = 'Add New User';
    document.getElementById('userId').value = ''; // Clear userId for add operation
    document.getElementById('userName').value = '';
    document.getElementById('msisdn').value = '';
    document.getElementById('balance').value = '';
    document.getElementById('addEditUserModal').style.display = 'flex';
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

        document.getElementById('addEditUserModal').style.display = 'flex';
    } catch (error) {
        console.error('Error fetching user for edit:', error);
        showCustomAlert('Error loading user data for editing.');
    }
}

// Event listener for the 'Add New User' button
document.querySelector('.add-user-btn').addEventListener('click', () => {
    openAddEditUserModal();
});

document.getElementById('addEditUserForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    if (!validateMsisdn()) {
        return;
    }
    const userId = document.getElementById('userId').value;
    const userName = document.getElementById('userName').value;
    const msisdn = document.getElementById('msisdn').value;
    const balance = parseFloat(document.getElementById('balance').value);

    const method = userId ? 'PUT' : 'POST';
    const url = userId
        ? 'http://localhost:8080/IVR-Platform/api/users/' + userId
        : 'http://localhost:8080/IVR-Platform/api/users';

    // Build the correct UserInfoDTO payload
    const payload = {
        userId: userId ? parseInt(userId) : undefined,
        userName: userName,
        msisdn: msisdn,
        balance: balance // as number
        // Do not include services
    };

    try {
        const response = await fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        if (!response.ok) {
            const errorText = await response.text();
            const isMsisdnConflict = errorText.includes('already exists') ||
                                     errorText.includes('is already in use') ||
                                     errorText.includes('ConstraintViolationException') ||
                                     errorText.includes('Duplicate entry for key') ||
                                     errorText.includes('unique constraint');
            if (isMsisdnConflict) {
                showCustomAlert('MSISDN already exists.');
                return;
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

function validateMsisdn() {
    const msisdnInput = document.getElementById('msisdn');
    const errorSpan = document.getElementById('msisdnError');
    const value = msisdnInput.value;

    // Only allow digits
    msisdnInput.value = value.replace(/[^0-9]/g, '').substring(0, 11);

    // Validation
    let errorMsg = '';
    if (!/^(010|011|012|015)/.test(msisdnInput.value)) {
        errorMsg = 'MSISDN must start with 010, 011, 012, or 015.';
    } else if (msisdnInput.value.length !== 11) {
        errorMsg = 'MSISDN must be exactly 11 digits.';
    }

    if (errorMsg) {
        msisdnInput.style.borderColor = '#e74c3c';
        errorSpan.textContent = errorMsg;
        errorSpan.style.display = 'block';
    } else {
        msisdnInput.style.borderColor = '';
        errorSpan.textContent = '';
        errorSpan.style.display = 'none';
    }
    return !errorMsg;
}

function showCustomAlert(message) {
    document.getElementById('customAlertMessage').textContent = message;
    const iconDiv = document.getElementById('customAlertIcon');
    const icon = iconDiv.querySelector('i');
    if (message.toLowerCase().includes('msisdn already exists') || message.toLowerCase().includes('error')) {
        icon.className = 'fas fa-times-circle';
        iconDiv.style.color = '#e74c3c'; // Red
    } else {
        icon.className = 'fas fa-check-circle';
        iconDiv.style.color = '#28a745'; // Green
    }
    document.getElementById('customSuccessAlertModal').style.display = 'flex';
}

function closeCustomAlert() {
    document.getElementById('customSuccessAlertModal').style.display = 'none';
}

fetchUsers();
        </script>
    
    </body>
</html>
