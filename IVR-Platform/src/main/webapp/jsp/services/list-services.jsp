<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Services Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
                margin-left: 256px;
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
                flex: 1;
                justify-content: flex-end;
            }
            .search-container {
                position: relative;
                margin-bottom: 0;
                flex: 1;
                text-align: right;
                direction: rtl;
            }
            .search-input {
                padding: 8px 32px 8px 12px;
                width: 100%;
                max-width: 300px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                background-color: white;
                color: #111827;
                text-align: right;
                direction: rtl;
            }
            .search-input:focus {
                outline: none;
                border-color: #8b5cf6;
                box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
            }
            .search-icon {
                position: absolute;
                right: 12px;
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
                max-width: 100%;
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
            .header-actions-in-table-header {
                display: flex;
                align-items: center;
                gap: 16px;
                flex: 1;
                justify-content: flex-end;
            }
            .add-service-btn {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            .add-service-btn:hover {
                opacity: 0.9;
            }
            .service-cards-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
                padding: 24px;
            }
            .service-card {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid #e5e7eb;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                transition: all 0.2s ease-in-out;
            }
            .service-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            .service-card-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }
            .service-initial-circle {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                font-size: 24px;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
            }
            .service-name {
                font-size: 18px;
                font-weight: 600;
                color: #111827;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                flex-grow: 1;
                min-width: 0;
            }
            .service-card-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
                margin-top: auto;
            }
            .action-btn {
                background-color: transparent;
                color: #9ca3af;
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
            .action-btn:hover {
                background-color: #fee2e2;
                color: #ef4444;
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
                max-width: 400px;
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
            #addServiceModal .form-group {
                margin-bottom: 15px;
            }
            #addServiceModal label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #374151;
            }
            #addServiceModal input[type="text"] {
                width: 100%;
                padding: 10px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 16px;
                color: #111827;
            }
            #addServiceModal input[type="text"]:focus {
                outline: none;
                border-color: #8b5cf6;
                box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
            }
            .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 20px;
            }
            .btn-primary {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            .btn-secondary {
                background-color: #e5e7eb;
                color: #374151;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            .btn-secondary:hover {
                background-color: #d1d5db;
            }
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
            .custom-alert-modal .modal-content {
                max-width: 350px;
                text-align: center;
                padding: 30px;
            }
            .custom-alert-modal .modal-icon {
                font-size: 48px;
                color: #28a745;
                margin-bottom: 20px;
            }
            .custom-alert-modal .modal-message {
                font-size: 18px;
                color: #333;
                margin-bottom: 25px;
            }
            .custom-alert-modal .modal-footer button {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
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
            .no-services {
                text-align: center;
                padding: 40px;
                color: #6b7280;
                font-size: 16px;
                background-color: #f9fafb;
                border-radius: 8px;
                border: 1px dashed #d1d5db;
                margin: 20px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/jsp/includes/sidebar.jsp" />
        <div class="main-container">
            <div class="content-area">
                <div class="header">
                    <h1>Services Management</h1>
                    <div class="header-actions">
                        <button class="add-service-btn">Add New Service</button>
                    </div>
                </div>
                <div class="content">
                    <div class="table-container">
                        <div class="table-header">
                            <div>
                                <h2 class="table-title">All Services</h2>
                                <p class="table-subtitle">Manage your services</p>
                            </div>
                            <div class="header-actions-in-table-header">
                                <div class="search-container">
                                    <i class="fas fa-search search-icon"></i>
                                    <input type="text" class="search-input" placeholder="Search services..." id="searchInput">
                                </div>
                            </div>
                        </div>
                        <div class="service-cards-container" id="serviceCardsContainer"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Service Modal -->
        <div id="addServiceModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Add New Service</h2>
                    <button class="close-btn" onclick="closeAddServiceModal()">×</button>
                </div>
                <form id="addServiceForm">
                    <div class="form-group">
                        <label for="serviceName">Service Name</label>
                        <input type="text" id="serviceName" name="serviceName" required>
                    </div>
                    <div class="modal-actions">
                        <button type="button" class="btn-secondary" onclick="closeAddServiceModal()">Cancel</button>
                        <button type="submit" class="btn-primary">Add Service</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
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

        <!-- Success Alert Modal -->
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

        <div id="deleteConfirmModal" class="modal">
            <div class="modal-content">
                <p id="deleteConfirmMessage"></p>
                <div class="modal-actions">
                    <button id="confirmDeleteBtn">Yes, Delete</button>
                    <button id="cancelDeleteBtn">Cancel</button>
                </div>
            </div>
        </div>
<!-- اختبر هذا الزر -->
<button onclick='confirmDeleteService("5", "Test%20Service")'>Test Delete Service</button>
        
        <script>

            // Placeholder for edit modal
            function openEditServiceModal(serviceId) {
                console.log('Editing service:', serviceId);
                showCustomAlert('Edit functionality not implemented yet.');
            }

            function renderServices(services) {
                const cardsContainer = document.getElementById('serviceCardsContainer');
                if (!cardsContainer) {
                    console.error('Service cards container not found!');
                    return;
                }

                cardsContainer.innerHTML = '';

                if (!Array.isArray(services) || services.length === 0) {
                    const noServices = document.createElement('div');
                    noServices.className = 'no-services';
                    noServices.textContent = 'No services found';
                    cardsContainer.appendChild(noServices);
                    return;
                }

                services.forEach(function(service) {
                    const card = document.createElement('div');
                    card.className = 'service-card';

                    const serviceId = service.serviceId || 'N/A';
                    const serviceName = service.serviceName || 'Unknown Service';

                    const initial = serviceName.charAt(0).toUpperCase();
                    const encodedName = encodeURIComponent(serviceName);

                    card.innerHTML = "" +
                        "<div class=\"service-card-header\">" +
                            "<div class=\"service-initial-circle\">" + initial + "</div>" +
                            "<div class=\"service-name\" title=\"" + serviceName + "\">" + serviceName + "</div>" +
                        "</div>" +
                        "<div class=\"service-card-body\">" +
                            "<p><i class=\"fas fa-id-badge\"></i> ID: " + serviceId + "</p>" +
                        "</div>" +
                        "<div class=\"service-card-actions\">" +
                            "<button class=\"action-btn\" onclick=\"confirmDeleteService('" + serviceId + "', '" + encodedName + "')\">" +
                                "<i class=\"fas fa-trash\"></i>" +
                            "</button>" +
                        "</div>";

                    cardsContainer.appendChild(card);
                });
            }

            // Fetch services from API
            async function fetchServices() {
                try {
                    console.log('Fetching services from API...');
                    const response = await fetch('http://localhost:8080/IVR-Platform/api/services', {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json',
                            // Add authentication header if required (e.g., Bearer token)
                            // 'Authorization': 'Bearer your-token-here'
                        },
                        credentials: 'include' // Include cookies for session-based auth
                    });

                    console.log('Response status:', response.status);
                    console.log('Response headers:', Object.fromEntries(response.headers.entries()));

                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error(`HTTP error! Status: ${response.status}, Message: ${errorText}`);
                    }

                    const data = await response.json();
                    console.log('API response data:', data);

                    // Check for logical errors in response (e.g., code: 403)
                    if (data.code === 403 || data.name === 'i') {
                        throw new Error('Access forbidden: ' + (data.message || 'Unauthorized request'));
                    }

                    renderServices(data);
                } catch (error) {
                    console.error('Error fetching services:', error);
                    showCustomAlert(`Failed to load services: ${error.message}. Using static data.`);
                    renderServices(staticServices); // Fallback to static data
                }
            }

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', async (e) => {
                const searchTerm = e.target.value.toLowerCase();
                try {
                    const response = await fetch('http://localhost:8080/IVR-Platform/api/services', {
                        headers: { 'Accept': 'application/json' },
                        credentials: 'include'
                    });
                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error(`HTTP error! Status: ${response.status}, Message: ${errorText}`);
                    }
                    const data = await response.json();
                    if (data.code === 403 || data.name === 'i') {
                        throw new Error('Access forbidden: ' + (data.message || 'Unauthorized request'));
                    }
                    const filteredServices = data.filter(service =>
                        service.serviceName.toLowerCase().includes(searchTerm)
                    );
                    renderServices(filteredServices);
                } catch (error) {
                    console.error('Error searching services:', error);
                    showCustomAlert(`Error searching: ${error.message}. Showing static data.`);
                    renderServices(staticServices.filter(service =>
                        service.serviceName.toLowerCase().includes(searchTerm)
                    ));
                }
            });

            // Add Service Modal
            function openAddServiceModal() {
                document.getElementById('addServiceModal').style.display = 'flex';
            }

            function closeAddServiceModal() {
                document.getElementById('addServiceModal').style.display = 'none';
                document.getElementById('addServiceForm').reset();
            }

            document.querySelector('.add-service-btn').addEventListener('click', openAddServiceModal);

            document.getElementById('addServiceForm').addEventListener('submit', async (e) => {
                e.preventDefault();
                const serviceName = document.getElementById('serviceName').value;

                try {
                    // First check if service exists
                    const checkResponse = await fetch('http://localhost:8080/IVR-Platform/api/services', {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json'
                        },
                        credentials: 'include'
                    });

                    if (!checkResponse.ok) {
                        throw new Error(`HTTP error! Status: ${checkResponse.status}`);
                    }

                    const existingServices = await checkResponse.json();
                    const serviceExists = existingServices.some(service => 
                        service.serviceName.toLowerCase() === serviceName.toLowerCase()
                    );

                    if (serviceExists) {
                        showCustomAlert('Service already exists!');
                        return;
                    }

                    // If service doesn't exist, proceed with adding it
                    const response = await fetch('http://localhost:8080/IVR-Platform/api/services', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json'
                        },
                        credentials: 'include',
                        body: JSON.stringify({ serviceName })
                    });

                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error(`HTTP error! Status: ${response.status}, Message: ${errorText}`);
                    }

                    const data = await response.json();
                    if (data.code === 403 || data.name === 'i') {
                        throw new Error('Access forbidden: ' + (data.message || 'Unauthorized request'));
                    }

                    showCustomAlert('Service added successfully!');
                    closeAddServiceModal();
                    fetchServices();
                } catch (error) {
                    console.error('Error adding service:', error);
                    showCustomAlert(`Error adding service: ${error.message}`);
                }
            });

            // Delete Service
            async function deleteService(serviceId) {
                try {
                    if (!serviceId) {
                        throw new Error('Service ID is required');
                    }
                    
                    console.log("Attempting to delete service with ID:", serviceId);
                    const url = `http://localhost:8080/IVR-Platform/api/services/${serviceId}`;
                    console.log("Delete URL:", url);
                    
                    const response = await fetch(url, {
                        method: 'DELETE',
                        headers: {
                            'Accept': 'application/json'
                        },
                        credentials: 'include'
                    });

                    console.log("Delete response status:", response.status);
                    console.log("Delete response headers:", Object.fromEntries(response.headers.entries()));
                    
                    if (!response.ok) {
                        const errorText = await response.text();
                        console.error("Delete failed with status:", response.status);
                        console.error("Error response:", errorText);
                        throw new Error(`HTTP error! Status: ${response.status}, Message: ${errorText}`);
                    }

                    console.log("Service deleted successfully");
                    showCustomAlert('Service deleted successfully!');
                    await fetchServices(); // Refresh the list
                } catch (error) {
                    console.error('Error deleting service:', error);
                    showCustomAlert(`Error deleting service: ${error.message}`);
                }
            }

            function confirmDeleteService(serviceId, encodedServiceName) {
                if (!serviceId) {
                    console.error("No service ID provided for deletion");
                    showCustomAlert("Error: No service ID provided");
                    return;
                }
                
                console.log("Confirming deletion for service ID:", serviceId);
                const serviceName = decodeURIComponent(encodedServiceName);
                document.getElementById('confirmDeleteBtn').dataset.serviceId = serviceId;
                document.getElementById('deleteConfirmMessage').textContent = `Are you sure you want to delete "${serviceName}"?`;
                openDeleteConfirmModal();
            }

            function openDeleteConfirmModal() {
                document.getElementById('deleteConfirmModal').style.display = 'flex';
            }

            function closeDeleteConfirmModal() {
                document.getElementById('deleteConfirmModal').style.display = 'none';
            }

            document.getElementById('confirmDeleteBtn').addEventListener('click', async () => {
                const serviceId = document.getElementById('confirmDeleteBtn').dataset.serviceId;
                console.log("Clicked confirm delete, ID:", serviceId);

                if (serviceId) {
                    await deleteService(serviceId);
                } else {
                    showCustomAlert("Service ID is missing!");
                }

                closeDeleteConfirmModal();
            });

            document.getElementById('cancelDeleteBtn').addEventListener('click', closeDeleteConfirmModal);

            // Custom Alert
            function showCustomAlert(message) {
                document.getElementById('customAlertMessage').textContent = message;
                document.getElementById('customSuccessAlertModal').style.display = 'flex';
            }

            function closeCustomAlert() {
                document.getElementById('customSuccessAlertModal').style.display = 'none';
            }

            // Close modals on outside click
            window.addEventListener('click', (e) => {
                if (e.target.classList.contains('modal')) {
                    e.target.style.display = 'none';
                }
            });

            // Error handling
            window.onerror = function(message, source, lineno, colno, error) {
                console.error('Global error:', { message, source, lineno, colno, error });
                showCustomAlert(`An error occurred: ${message}`);
                return false;
            };

            window.onunhandledrejection = function(event) {
                console.error('Unhandled promise rejection:', event.reason);
                showCustomAlert(`An error occurred: ${event.reason.message || event.reason}`);
            };

            // Fetch services on page load
            document.addEventListener('DOMContentLoaded', () => {
                console.log('DOM loaded, fetching services...');
                fetchServices();
            });
        </script>
    </body>
</html>