
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - VoxRoute</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
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
            margin-left: 250px;
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
        }

        .search-input {
            padding: 8px 12px 8px 40px;
            width: 320px;
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
            padding: 12px 24px;
            text-align: left;
            font-weight: 600;
            color: #374151;
            border-bottom: 1px solid #e5e7eb;
        }

        .users-table td {
            padding: 16px 24px;
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

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 9999;
        }

        .modal.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background-color: white;
            border-radius: 8px;
            padding: 24px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #ad0da5;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
        }

        .form-input.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .form-actions button {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .form-actions button[type="button"] {
            background-color: #f3f4f6;
            border: 1px solid #d1d5db;
            color: #374151;
        }

        .form-actions button[type="submit"] {
            background: linear-gradient(45deg, #8b5cf6, #ec4899);
            border: none;
            color: white;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
            border: 1px solid transparent;
        }
        
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
            padding: 0;
            height: auto;
            transform: scale(0.8);
            margin-right: 5px;
            accent-color: #007bff;
        }

        .checkbox-group .form-label {
            margin-bottom: 0;
        }

        .modal-content .modal-header {
            margin-bottom: 24px;
        }

        .error-message {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 5px;
            display: none;
        }
    </style>
</head>
<body>
    <% try { %>
    <div class="main-container">
    <jsp:include page="/jsp/includes/sidebar.jsp" />

    <body class="bg-gray-50">
        <div class="flex min-h-screen">
            <!-- Sidebar overlay for mobile -->
            <div class="sidebar-overlay fixed inset-0 bg-black bg-opacity-50 z-10 md:hidden" onclick="toggleSidebar()"></div>

            <!-- Main content -->
            <main class="flex-1 overflow-y-auto ml-[280px] h-screen">
                <div class="container mx-auto p-4 md:p-6">
                    <jsp:include page="/jsp/includes/header.jsp" />
                    <body class="bg-gradient-slate-blue">
                        <div class="flex-1 flex flex-col">
                            <!-- Main Content Area -->
                            <div class="flex-1 p-6">
                                <div class="mx-auto max-w-7xl">
                                    <!-- Content Header -->
                                    <div class="mb-8">
                                        <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                                            <div>
                                                <h1 class="text-3xl font-bold text-gray-900">Sound Library</h1>
                                                <p class="text-gray-600">Manage your audio files and sound resources</p>
                                            </div>

            <div class="content">


                <div class="table-container">
                    <div class="table-header">
                        <div>
                            <h2 class="table-title">All Users</h2>
                            <p class="table-subtitle">Manage your user accounts here.</p>
                        </div>
                        <button class="add-user-btn" onclick="showAddUserModal()">Add User</button>
                    </div>

                    <div class="table-wrapper">
                        <table class="users-table">
                            <thead>
                                <tr>
                                    <th>User Name</th>
                                    <th>MSISDN</th>
                                    <th>Balance</th>
                                    <th>Service Name</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div id="addUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-pencil-alt" style="color: #ad0da5; margin-right: 10px;"></i> Add User
                </h3>
            </div>
            <form action="../users/add-user.jsp" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">User Name</label>
                        <input type="text" name="userName" id="addUserName" class="form-input" required />
                    </div>
                    <div class="form-group">
                        <label class="form-label">MSISDN</label>
                        <input type="text" name="MSISDN" id="addMSISDN" class="form-input" required />
                        <div id="msisdnError" class="error-message"></div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Balance</label>
                        <input type="text" name="balance" id="addBalance" class="form-input" value="0.00" required />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Status</label>
                        <select name="activation_status" id="addActivationStatus" class="form-select" required>
                            <option value="Active">Active</option>
                            <option value="InActive">InActive</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="hasServicesAdd" />
                        <label class="form-label">Services</label>
                    </div>
                </div>
                <div id="serviceFieldsAdd" style="display: none;">
                    <div class="form-group">
                        <label class="form-label">Service Name</label>
                        <select name="service_id" id="addServiceId" class="form-select">
                            <option value="">Select Service</option>
                            <!-- Static options as placeholder -->
                            <option value="1">Service 1 (Voice)</option>
                            <option value="2">Service 2 (Interactive)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Service Type</label>
                        <select name="service_type" id="addServiceType" class="form-select">
                            <option value="">Select Type</option>
                            <option value="Voice">Voice</option>
                            <option value="Interactive">Interactive</option>
                        </select>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" onclick="closeModals()">Cancel</button>
                    <button type="submit">Add User</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">
                    ✏️ <span id="modalTitleText">Edit Profile</span>
                </h3>
            </div>
            <form action="../users/edit-user.jsp" method="POST">
                <input type="hidden" name="user_id" id="editUserId">
                <div class="form-group">
                    <label>User Name</label>
                    <input type="text" name="userName" id="editUserName" required>
                </div>
                <div class="form-group">
                    <label>MSISDN</label>
                    <input type="text" name="MSISDN" id="editUserMsisdn" required>
                </div>
                <div class="form-group">
                    <label>Balance</label>
                    <input type="number" step="0.01" name="balance" id="editUserBalance" required>
                </div>
                <div class="form-group">
                    <input type="checkbox" id="editEnableService" name="enableService">
                    <label for="editEnableService">Enable Service</label>
                </div>
                <div id="editServiceFields" style="display: none;">
                    <div class="form-group">
                        <label>Service Name</label>
                        <select name="service_id" id="editUserServiceId">
                            <!-- Static options as placeholder -->
                            <option value="1">Service 1</option>
                            <option value="2">Service 2</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Service Type</label>
                        <select name="service_type" id="editUserServiceType">
                            <option value="Prepaid">Prepaid</option>
                            <option value="Postpaid">Postpaid</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Quota</label>
                        <input type="number" step="0.01" name="quota" id="editUserQuota">
                    </div>
                    <div class="form-group">
                        <label>Service Fees</label>
                        <input type="number" step="0.01" name="service_fees" id="editUserServiceFees">
                    </div>
                </div>
                <div class="form-group">
                    <label>Status</label>
                    <select name="activation_status" id="editUserStatus" required>
                        <option value="Active">Active</option>
                        <option value="InActive">InActive</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="button" onclick="closeModals()">Cancel</button>
                    <button type="submit">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- View Modal -->
    <div id="viewModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">👁️ User Details</h3>
            </div>
            <div id="userDetails" class="user-details">
                <!-- User details will be populated here -->
            </div>
            <div class="modal-actions">
                <button class="btn btn-primary" onclick="closeModals()">OK</button>
            </div>
        </div>
    </div>

    <!-- Delete User Modal -->
    <div id="deleteUserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-trash-alt" style="color: #dc3545; margin-right: 10px;"></i> Delete User
                </h3>
            </div>
            <p style="margin: 20px 0;">Are you sure you want to delete this user? This action cannot be undone.</p>
            <form action="delete-user.jsp" method="POST">
                <input type="hidden" name="id" id="deleteUserId">
                <div class="form-actions">
                    <button type="button" onclick="closeModals()" style="padding: 8px 16px; border-radius: 4px; border: 1px solid #d1d5db; background-color: #f3f4f6; color: #374151;">Cancel</button>
                    <button type="submit" style="padding: 8px 16px; border-radius: 4px; background-color: #dc3545; color: white; border: none; margin-left: 10px;">Delete</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        console.log("user-management.jsp script loaded!");
        function showAddUserModal() {
            console.log('Attempting to show Add User modal');
            closeModals();
            document.getElementById('addUserName').value = '';
            document.getElementById('addMSISDN').value = '';
            document.getElementById('addBalance').value = '0.00';
            document.getElementById('addServiceId').selectedIndex = 0;
            document.getElementById('addActivationStatus').value = 'Active';
            document.getElementById('hasServicesAdd').checked = false;
            document.getElementById('serviceFieldsAdd').style.display = 'none';
            document.getElementById('addServiceType').selectedIndex = 0;

            const msisdnInput = document.getElementById('addMSISDN');
            const msisdnError = document.getElementById('msisdnError');
            msisdnInput.classList.remove('is-invalid');
            msisdnError.style.display = 'none';
            msisdnError.textContent = '';

            const addBalanceInput = document.getElementById('addBalance');
            if (addBalanceInput.value.indexOf('.') === -1) {
                addBalanceInput.value = parseFloat(addBalanceInput.value).toFixed(2);
            }
            addBalanceInput.setSelectionRange(addBalanceInput.value.indexOf('.'), addBalanceInput.value.indexOf('.'));

            document.getElementById('addUserModal').classList.add('active');
        }

        function hideAddUserModal() {
            document.getElementById('addUserModal').classList.remove('active');
        }

        function closeModals() {
            document.querySelectorAll('.modal').forEach(modal => {
                modal.classList.remove('active');
            });
        }

        function showEditUserModal(userId) {
            console.log('Attempting to show Edit User modal for ID:', userId);
            closeModals();
            fetch('/IVR-Platform/api/users/' + userId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(user => {
                    document.getElementById('editUserId').value = user.userId;
                    document.getElementById('editUserName').value = user.userName;
                    document.getElementById('editUserMsisdn').value = user.msisdn;
                    document.getElementById('editUserBalance').value = user.balance;
                    
                    const enableServiceCheckbox = document.getElementById('editEnableService');
                    const serviceFieldsDiv = document.getElementById('editServiceFields');

                    if (user.services && user.services.length > 0) {
                        const service = user.services[0];
                        enableServiceCheckbox.checked = true;
                        serviceFieldsDiv.style.display = 'block';
                        document.getElementById('editUserServiceId').value = service.serviceId;
                        document.getElementById('editUserServiceType').value = service.serviceType;
                        document.getElementById('editUserQuota').value = service.quota || '';
                        document.getElementById('editUserServiceFees').value = service.serviceFees || '';
                        document.getElementById('editUserStatus').value = service.activationStatus;
                    } else {
                        enableServiceCheckbox.checked = false;
                        serviceFieldsDiv.style.display = 'none';
                        document.getElementById('editUserServiceId').value = '';
                        document.getElementById('editUserServiceType').value = '';
                        document.getElementById('editUserQuota').value = '';
                        document.getElementById('editUserServiceFees').value = '';
                        document.getElementById('editUserStatus').value = 'InActive';
                    }

                    document.getElementById('editUserModal').classList.add('active');
                })
                .catch(error => {
                    console.error('Error fetching user data:', error);
                    alert('Failed to load user data: ' + error.message);
                });
        }

        function showDeleteUserModal(userId) {
            closeModals();
            document.getElementById('deleteUserId').value = userId;
            document.getElementById('deleteUserModal').classList.add('active');
        }

        function showViewUserModal(userId) {
            closeModals();
            fetch('/IVR-Platform/api/users/' + userId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(user => {
                    const userDetailsDiv = document.getElementById('userDetails');
                    let serviceDetails = '';
                    if (user.services && user.services.length > 0) {
                        const service = user.services[0];
                        serviceDetails = `
                            <p><strong>Service Name:</strong> ${service.serviceName || 'N/A'}</p>
                            <p><strong>Service Type:</strong> ${service.serviceType || 'N/A'}</p>
                            <p><strong>Quota:</strong> ${service.quota || 'N/A'}</p>
                            <p><strong>Service Fees:</strong> ${service.serviceFees || 'N/A'}</p>
                            <p><strong>Service Status:</strong> ${service.activationStatus || 'N/A'}</p>
                        `;
                    }

                    userDetailsDiv.innerHTML = `
                        <p><strong>User ID:</strong> ${user.userId || 'N/A'}</p>
                        <p><strong>User Name:</strong> ${user.userName || 'N/A'}</p>
                        <p><strong>MSISDN:</strong> ${user.msisdn || 'N/A'}</p>
                        <p><strong>Balance:</strong> ${user.balance || 'N/A'}</p>
                        ${serviceDetails}
                    `;
                    document.getElementById('viewModal').classList.add('active');
                })
                .catch(error => {
                    console.error('Error fetching user data for view modal:', error);
                    alert('Failed to load user details: ' + error.message);
                });
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal') && !event.target.classList.contains('modal-content')) {
                closeModals();
            }
        }

        document.addEventListener('click', function(event) {
            console.log('Click event target:', event.target);
            console.log('Closest edit button:', event.target.closest('.action-btn.edit-btn'));
            if (event.target.closest('.action-btn.edit-btn')) {
                const btn = event.target.closest('.action-btn.edit-btn');
                showEditUserModal(btn.dataset.userId);
            }
            if (event.target.closest('.action-btn.delete-btn')) {
                const btn = event.target.closest('.action-btn.delete-btn');
                showDeleteUserModal(btn.dataset.userId);
            }
            if (event.target.closest('.action-btn.view-btn')) {
                const btn = event.target.closest('.action-btn.view-btn');
                showViewUserModal(btn.dataset.userId);
            }
        });

        document.getElementById('hasServicesAdd').addEventListener('change', function() {
            const serviceFieldsAdd = document.getElementById('serviceFieldsAdd');
            if (this.checked) {
                serviceFieldsAdd.style.display = 'block';
            } else {
                serviceFieldsAdd.style.display = 'none';
            }
        });

        document.getElementById('addServiceId').addEventListener('change', function() {
            const serviceTypeSelect = document.getElementById('addServiceType');
            const selectedOption = this.options[this.selectedIndex];
            
            if (this.value) {
                const serviceType = selectedOption.textContent.includes('Voice') ? 'Voice' : 'Interactive';
                serviceTypeSelect.value = serviceType;
            } else {
                serviceTypeSelect.value = '';
            }
        });

        const addMsisdnInput = document.getElementById('addMSISDN');
        const addMsisdnError = document.getElementById('msisdnError');
        const addUserForm = document.querySelector('#addUserModal form');

        function validateAddMsisdn() {
            const msisdn = addMsisdnInput.value.trim();
            const validPrefixes = ['010', '011', '012', '015'];
            let isValid = true;
            let errorMessage = '';

            if (msisdn.length !== 11) {
                isValid = false;
                errorMessage = 'MSISDN must be exactly 11 digits.';
            } else if (!/^[0-9]+$/.test(msisdn)) {
                isValid = false;
                errorMessage = 'MSISDN must contain only digits.';
            } else {
                const prefix = msisdn.substring(0, 3);
                if (!validPrefixes.includes(prefix)) {
                    isValid = false;
                    errorMessage = 'MSISDN must start with 010, 011, 012, or 015.';
                }
            }

            if (!isValid) {
                addMsisdnInput.classList.add('is-invalid');
                addMsisdnError.textContent = errorMessage;
                addMsisdnError.style.display = 'block';
            } else {
                addMsisdnInput.classList.remove('is-invalid');
                addMsisdnError.textContent = '';
                addMsisdnError.style.display = 'none';
            }
            return isValid;
        }

        if (addUserForm) {
            addUserForm.addEventListener('submit', function(event) {
                if (!validateAddMsisdn()) {
                    event.preventDefault();
                }
            });
        }

        if (addMsisdnInput) {
            addMsisdnInput.addEventListener('input', validateAddMsisdn);
        }

        const addBalanceInput = document.getElementById('addBalance');
        if (addBalanceInput) {
            addBalanceInput.addEventListener('keydown', function(e) {
                if ([37, 39, 8, 46, 9].includes(e.keyCode)) {
                    return;
                }

                const currentValue = this.value;
                const dotIndex = currentValue.indexOf('.');
                const selectionStart = this.selectionStart;
                const selectionEnd = this.selectionEnd;

                if (selectionStart <= dotIndex && selectionEnd > dotIndex) {
                    e.preventDefault();
                }
            });

            addBalanceInput.addEventListener('input', function(e) {
                let value = this.value;

                if (value.indexOf('.') === -1) {
                    value = value.replace(/[^0-9]/g, '');
                    if (value.length > 2) {
                        value = value.slice(0, -2) + '.' + value.slice(-2);
                    } else if (value.length === 2) {
                        value = '0.' + value;
                    } else if (value.length === 1) {
                        value = '0.0' + value;
                    } else {
                        value = '0.00';
                    }
                }

                value = value.replace(/[^0-9.]/g, '');
                const parts = value.split('.');
                if (parts.length > 2) {
                    value = parts[0] + '.' + parts.slice(1).join('');
                }

                if (parts[1] && parts[1].length > 2) {
                    value = parts[0] + '.' + parts[1].substring(0, 2);
                }

                if (value === '') {
                    value = '0.00';
                }

                this.value = value;

                const dotIndex = this.value.indexOf('.');
                if (e.inputType === 'deleteContentBackward' && dotIndex !== -1 && this.selectionStart === dotIndex) {
                    this.setSelectionRange(dotIndex, dotIndex);
                }
            });
        }

        document.getElementById('editEnableService').addEventListener('change', function() {
            const serviceFieldsDiv = document.getElementById('editServiceFields');
            if (this.checked) {
                serviceFieldsDiv.style.display = 'block';
            } else {
                serviceFieldsDiv.style.display = 'none';
                document.getElementById('editUserServiceId').value = '';
                document.getElementById('editUserServiceType').value = '';
                document.getElementById('editUserQuota').value = '';
                document.getElementById('editUserServiceFees').value = '';
            }
        });
    </script>
    <% } catch (Exception e) { %>
        <p>Error: <%= e.getMessage() %></p>
    <% } %>
</body>
</html>