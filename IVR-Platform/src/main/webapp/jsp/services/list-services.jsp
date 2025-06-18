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

            .search-container {
                position: relative;
                margin-bottom: 0;
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
                left: 16px;
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

            .add-service-btn {
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

            .add-service-btn::before {
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

            .add-service-btn:hover::before {
                left: 100%;
            }

            .add-service-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-hover-shadow);
            }

            .add-service-btn:active {
                transform: translateY(0);
            }

            .service-cards-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 24px;
                padding: 32px;
            }

            .service-card {
                background: var(--glass-bg);
                border-radius: 16px;
                box-shadow: var(--glass-shadow);
                border: var(--glass-border);
                padding: 24px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                transition: all 0.3s ease;
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                position: relative;
                overflow: hidden;
            }

            .service-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: var(--primary-gradient);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .service-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            }

            .service-card:hover::before {
                opacity: 1;
            }

            .service-card-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }

            .service-initial-circle {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                background: var(--primary-gradient);
                color: white;
                font-size: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 16px;
                box-shadow: var(--primary-shadow);
                transition: all 0.3s ease;
            }

            .service-card:hover .service-initial-circle {
                transform: scale(1.1) rotate(5deg);
            }

            .service-name {
                font-size: 18px;
                font-weight: 600;
                color: #0f172a;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                flex-grow: 1;
                min-width: 0;
            }

            .service-card-body {
                margin-bottom: 20px;
            }

            .service-card-body p {
                color: #64748b;
                font-size: 14px;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .service-card-body i {
                color: #6366f1;
                font-size: 16px;
            }

            .service-card-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
                margin-top: auto;
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

            .delete-btn:hover {
                color: #ef4444;
            }

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
                display: flex !important;
                opacity: 1;
            }

            .modal-content {
                background: var(--glass-bg);
                border-radius: 16px;
                width: 90%;
                max-width: 500px;
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

            .form-group {
                margin-bottom: 24px;
            }

            .form-group label {
                display: block;
                margin-bottom: 10px;
                font-weight: 500;
                color: #475569;
                font-size: 14px;
            }

            .form-group input[type="text"] {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #e2e8f0;
                border-radius: 10px;
                font-size: 14px;
                color: #1e293b;
                transition: all 0.3s ease;
                background: var(--glass-bg);
                backdrop-filter: blur(8px);
                -webkit-backdrop-filter: blur(8px);
            }

            .form-group input[type="text"]:focus {
                outline: none;
                border-color: #6366f1;
                box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                background-color: white;
                transform: translateY(-1px);
            }

            .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 16px;
                margin-top: 32px;
            }

            .btn-primary {
                background: var(--primary-gradient);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: var(--primary-shadow);
                position: relative;
                overflow: hidden;
            }

            .btn-primary::before {
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

            .btn-primary:hover::before {
                left: 100%;
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
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .btn-secondary::before {
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

            .btn-secondary:hover {
                color: #0f172a;
                transform: translateY(-2px);
            }

            .btn-secondary:hover::before {
                opacity: 0.1;
            }

            .btn-secondary span {
                position: relative;
                z-index: 1;
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
                font-size: 24px;
                margin-bottom: 16px;
            }

            .delete-confirm-modal p {
                color: #475569;
                margin-bottom: 28px;
                font-size: 16px;
                line-height: 1.6;
            }

            .delete-confirm-modal .modal-actions {
                display: flex;
                justify-content: center;
                gap: 16px;
            }

            .delete-confirm-modal .btn-delete-confirm {
                background: linear-gradient(135deg, #ef4444, #dc2626);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px rgba(239, 68, 68, 0.2);
                position: relative;
                overflow: hidden;
            }

            .delete-confirm-modal .btn-delete-confirm::before {
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

            .delete-confirm-modal .btn-delete-confirm:hover::before {
                left: 100%;
            }

            .delete-confirm-modal .btn-delete-confirm:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 8px rgba(239, 68, 68, 0.3);
            }

            .delete-confirm-modal .btn-cancel-delete {
                background: var(--glass-bg);
                color: #475569;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 500;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .delete-confirm-modal .btn-cancel-delete::before {
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

            .delete-confirm-modal .btn-cancel-delete:hover {
                color: #0f172a;
                transform: translateY(-2px);
            }

            .delete-confirm-modal .btn-cancel-delete:hover::before {
                opacity: 0.1;
            }

            .delete-confirm-modal .btn-cancel-delete span {
                position: relative;
                z-index: 1;
            }

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
                position: relative;
                overflow: hidden;
            }

            .custom-alert-modal .modal-footer button::before {
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

            .custom-alert-modal .modal-footer button:hover::before {
                left: 100%;
            }

            .custom-alert-modal .modal-footer button:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-hover-shadow);
            }

            .no-services {
                text-align: center;
                padding: 48px;
                color: #64748b;
                font-size: 16px;
                background: var(--glass-bg);
                border-radius: 16px;
                border: var(--glass-border);
                margin: 24px;
                box-shadow: var(--glass-shadow);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
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
                .service-cards-container {
                    grid-template-columns: 1fr;
                    padding: 16px;
                }
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
        
        <script>
            // Add static services data for fallback
            const staticServices = [
                {
                    serviceId: 1,
                    serviceName: "Basic IVR",
                    serviceType: "Voice",
                    quota: 100,
                    serviceFees: 5.00
                },
                {
                    serviceId: 2,
                    serviceName: "Premium IVR",
                    serviceType: "Voice",
                    quota: 500,
                    serviceFees: 15.00
                },
                {
                    serviceId: 3,
                    serviceName: "Billing Service",
                    serviceType: "Interactive",
                    quota: 200,
                    serviceFees: 8.50
                },
                {
                    serviceId: 4,
                    serviceName: "Support Service",
                    serviceType: "Interactive",
                    quota: 300,
                    serviceFees: 10.00
                }
            ];

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
                    const serviceId = service.serviceId || service.service_id;
                    if (!serviceId || isNaN(parseInt(serviceId))) {
                        console.warn('Service without valid ID will be skipped:', service);
                        return;
                    }
                    const card = document.createElement('div');
                    card.className = 'service-card';

                    const serviceName = service.serviceName || service.service_name || 'Unknown Service';
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
                            'Content-Type': 'application/json'
                        },
                        credentials: 'include'
                    });

                    console.log('Response status:', response.status);

                    if (!response.ok) {
                        const errorText = await response.text();
                        console.error('Server response:', errorText);
                        throw new Error(`Server error: ${response.status} - ${errorText}`);
                    }

                    const data = await response.json();
                    console.log('API response data:', data);

                    if (!data) {
                        throw new Error('No data received from server');
                    }

                    // Handle both array and object responses
                    const services = Array.isArray(data) ? data : (data.services || data.data || []);
                    
                    if (services.length === 0) {
                        const cardsContainer = document.getElementById('serviceCardsContainer');
                        if (cardsContainer) {
                            cardsContainer.innerHTML = `
                                <div class="no-services">
                                    <i class="fas fa-info-circle" style="font-size: 48px; color: #6b7280; margin-bottom: 16px;"></i>
                                    <p>No services found</p>
                                    <p style="color: #6b7280; font-size: 14px; margin-top: 8px;">Add your first service using the "Add New Service" button</p>
                                </div>
                            `;
                        }
                        return;
                    }

                    renderServices(services);
                } catch (error) {
                    console.error('Error fetching services:', error);
                    
                    // Show error state with retry button
                    const cardsContainer = document.getElementById('serviceCardsContainer');
                    if (cardsContainer) {
                        cardsContainer.innerHTML = `
                            <div class="no-services">
                                <i class="fas fa-exclamation-circle" style="font-size: 48px; color: #ef4444; margin-bottom: 16px;"></i>
                                <p>Failed to load services</p>
                                <p style="color: #6b7280; font-size: 14px; margin-top: 8px;">${error.message}</p>
                                <button onclick="fetchServices()" style="margin-top: 16px; padding: 8px 16px; background: #8b5cf6; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                    Try Again
                                </button>
                            </div>
                        `;
                    }
                }
            }

            // Search functionality
            document.getElementById('searchInput').addEventListener('input', (e) => {
                const searchTerm = e.target.value.toLowerCase();
                const services = document.querySelectorAll('.service-card');
                
                services.forEach(card => {
                    const serviceName = card.querySelector('.service-name').textContent.toLowerCase();
                    if (serviceName.includes(searchTerm)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                }
                });
            });

            // Add Service Modal
            function openAddServiceModal() {
                console.log('Opening add service modal...');
                const modal = document.getElementById('addServiceModal');
                if (!modal) {
                    console.error('Add service modal element not found!');
                    return;
                }
                console.log('Modal element found, setting display to flex');
                modal.style.display = 'flex';
                // Add show class after a small delay to trigger the animation
                setTimeout(() => {
                    modal.classList.add('show');
                }, 10);
            }

            function closeAddServiceModal() {
                console.log('Closing add service modal...');
                const modal = document.getElementById('addServiceModal');
                if (!modal) {
                    console.error('Add service modal element not found!');
                    return;
                }
                modal.classList.remove('show');
                // Remove display: flex after animation completes
                setTimeout(() => {
                    modal.style.display = 'none';
                }, 300);
                document.getElementById('addServiceForm').reset();
            }

            // Custom Alert
            function showCustomAlert(message, isError = false) {
                const modal = document.getElementById('customSuccessAlertModal');
                const messageEl = document.getElementById('customAlertMessage');
                const iconEl = modal.querySelector('.modal-icon i');
                
                // Set message
                messageEl.textContent = message;
                
                // Update icon and color based on message type
                if (isError) {
                    iconEl.className = 'fas fa-exclamation-circle';
                    iconEl.style.color = '#ef4444'; // Red color for error
                } else {
                    iconEl.className = 'fas fa-check-circle';
                    iconEl.style.color = '#16a34a'; // Green color for success
                }
                
                modal.style.display = 'flex';
                setTimeout(() => {
                    modal.classList.add('show');
                }, 10);
            }

            function closeCustomAlert() {
                const modal = document.getElementById('customSuccessAlertModal');
                modal.classList.remove('show');
                setTimeout(() => {
                    modal.style.display = 'none';
                }, 300);
            }

            // Initialize on page load
            document.addEventListener('DOMContentLoaded', () => {
                console.log('DOM loaded, initializing...');
                
                // Fetch initial services
                console.log('Fetching initial services...');
                fetchServices();
                
                // Debug: Check if button exists
                const addServiceBtn = document.querySelector('.add-service-btn');
                console.log('Add Service button found:', !!addServiceBtn);
                
                if (addServiceBtn) {
                    console.log('Adding click event listener to Add Service button');
                    addServiceBtn.addEventListener('click', () => {
                        console.log('Add Service button clicked');
                        openAddServiceModal();
                    });
                } else {
                    console.error('Add Service button not found!');
                }

                // Debug: Check if form exists
                const addServiceForm = document.getElementById('addServiceForm');
                console.log('Add Service form found:', !!addServiceForm);
                
                if (addServiceForm) {
                    console.log('Adding submit event listener to Add Service form');
                    addServiceForm.addEventListener('submit', async (e) => {
                        console.log('Form submitted');
                        e.preventDefault();
                        const serviceName = document.getElementById('serviceName').value;
                        console.log('Service name:', serviceName);

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
                                showCustomAlert('Service already exists!', true);
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
                            showCustomAlert(`Error adding service: ${error.message}`, true);
                        }
                    });
                } else {
                    console.error('Add Service form not found!');
                }
            });

            // Delete Service
            async function deleteService(serviceId) {
                try {
                    if (!serviceId) {
                        throw new Error('Service ID is required');
                    }
                    
                    // تحويل معرف الخدمة إلى رقم
                    const numericId = parseInt(serviceId);
                    if (isNaN(numericId) || numericId <= 0) {
                        throw new Error('Invalid service ID: ' + serviceId);
                    }
                    
                    // طباعة القيم للتأكد
                    console.log("Raw serviceId:", serviceId);
                    console.log("Numeric ID:", numericId);
                    
                    // تكوين الرابط مع معرف الخدمة
                    const deleteUrl = 'http://localhost:8080/IVR-Platform/api/services/' + numericId;
                    console.log("Delete URL:", deleteUrl);
                    
                    // إرسال طلب الحذف
                    const response = await fetch(deleteUrl, {
                        method: 'DELETE',
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json'
                        },
                        credentials: 'include'
                    });
                    
                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error(`Failed to delete service: ${errorText}`);
                    }
                    
                    showCustomAlert('Service deleted successfully!');
                    await fetchServices(); // تحديث القائمة
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
                
                // طباعة معرف الخدمة للتأكد
                console.log("Service ID for deletion:", serviceId);
                
                const serviceName = decodeURIComponent(encodedServiceName);
                const modal = document.getElementById('deleteConfirmModal');
                const message = document.getElementById('deleteConfirmMessage');
                const confirmBtn = document.getElementById('confirmDeleteBtn');
                const cancelBtn = document.getElementById('cancelDeleteBtn');
                
                message.textContent = `Are you sure you want to delete "${serviceName}"?`;
                
                // إزالة أي event listeners موجودة
                const newConfirmBtn = confirmBtn.cloneNode(true);
                confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);
                
                // إضافة event listener جديد
                newConfirmBtn.addEventListener('click', async () => {
                    try {
                        await deleteService(serviceId);
                        modal.style.display = 'none';
                    } catch (error) {
                        console.error('Error in delete confirmation:', error);
                        showCustomAlert(`Error: ${error.message}`);
                    }
                });
                
                cancelBtn.onclick = () => {
                    modal.style.display = 'none';
                };
                
                modal.style.display = 'flex';
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
        </script>
    </body>
</html>