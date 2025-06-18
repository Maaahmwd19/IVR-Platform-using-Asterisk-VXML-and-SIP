<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VXML Files Management</title>
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

            .add-vxml-btn {
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

            .add-vxml-btn::before {
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

            .add-vxml-btn:hover::before {
                left: 100%;
            }

            .add-vxml-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--primary-hover-shadow);
            }

            .vxml-cards-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 24px;
                padding: 32px;
            }

            .vxml-card {
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

            .vxml-card::before {
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

            .vxml-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            }

            .vxml-card:hover::before {
                opacity: 0.05;
            }

            .vxml-card-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
                position: relative;
            }

            .vxml-initial-circle {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                background: var(--primary-gradient);
                color: white;
                font-size: 24px;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 16px;
                box-shadow: var(--primary-shadow);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .vxml-initial-circle::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(
                    45deg,
                    transparent,
                    rgba(255, 255, 255, 0.1),
                    transparent
                );
                transform: rotate(45deg);
                transition: 0.5s;
            }

            .vxml-card:hover .vxml-initial-circle {
                transform: scale(1.1) rotate(5deg);
            }

            .vxml-card:hover .vxml-initial-circle::before {
                left: 100%;
            }

            .vxml-file-name {
                font-size: 18px;
                font-weight: 600;
                color: #0f172a;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                flex-grow: 1;
                min-width: 0;
                transition: color 0.3s ease;
            }

            .vxml-card:hover .vxml-file-name {
                color: #6366f1;
            }

            .vxml-card-status {
                font-size: 12px;
                font-weight: 500;
                padding: 6px 12px;
                border-radius: 8px;
                margin-left: auto;
                transition: all 0.3s ease;
            }

            .vxml-card-status.active {
                background-color: #dcfce7;
                color: #166534;
            }

            .vxml-card-status.inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .vxml-card-body {
                font-size: 14px;
                color: #475569;
                margin-bottom: 20px;
                position: relative;
            }

            .vxml-card-body p {
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .vxml-card-body i {
                color: #6366f1;
                font-size: 16px;
            }

            .vxml-card-actions {
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

            .view-btn:hover {
                color: #0284c7;
            }

            .edit-btn:hover {
                color: #0284c7;
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

            #vxmlContentModal .modal-content {
                max-width: 800px;
                width: 95%;
            }

            #vxmlContentModal pre {
                background: rgba(248, 250, 252, 0.8);
                border: var(--glass-border);
                padding: 20px;
                border-radius: 12px;
                overflow-x: auto;
                max-height: 500px;
                white-space: pre-wrap;
                word-wrap: break-word;
                font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;
                font-size: 14px;
                color: #1e293b;
                backdrop-filter: blur(8px);
                -webkit-backdrop-filter: blur(8px);
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
                .vxml-cards-container {
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
                    <h1>VXML Files Management</h1>
                    <div class="header-actions">
                        <button class="add-vxml-btn">Add New VXML File</button>
                    </div>
                </div>
                <div class="content">
                    <div class="table-container">
                        <div class="table-header">
                            <div>
                                <h2 class="table-title">All VXML Files</h2>
                                <p class="table-subtitle">Manage your VXML files</p>
                            </div>
                            <div class="header-actions-in-table-header">
                                <div class="search-container">
                                    <i class="fas fa-search search-icon"></i>
                                    <input type="text" class="search-input" placeholder="Search VXML files..." id="searchInput">
                                </div>
                            </div>
                        </div>
                        <div class="vxml-cards-container" id="vxmlCardsContainer">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- VXML Content Modal -->
        <div id="vxmlContentModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title" id="vxmlContentModalTitle">VXML File Content</h2>
                    <button class="close-btn" onclick="closeVXMLContentModal()">Ã</button>
                </div>
                <pre id="vxmlContentDisplay"></pre>
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
            async function fetchVXMLFiles() {
                try {
                    const response = await fetch('http://localhost:8080/IVR-Platform/api/vxmlfiles');
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: \${response.status}`);
                    }
                    const vxmlFiles = await response.json();
                    console.log('Fetched VXML files:', vxmlFiles);
                    renderVXMLFiles(vxmlFiles);
                } catch (error) {
                    console.error('Error fetching VXML files:', error);
                }
            }

            function renderVXMLFiles(vxmlFiles) {
                const cardsContainer = document.getElementById('vxmlCardsContainer');
                cardsContainer.innerHTML = '';

                if (!Array.isArray(vxmlFiles)) {
                    console.error('VXML files is not an array:', vxmlFiles);
                    return;
                }

                vxmlFiles.forEach(file => {
                    console.log('Processing file:', file);
                    const card = document.createElement('div');
                    card.className = 'vxml-card';

                    // Placeholder for status - you might want to fetch this from the backend if available
                    // For now, let's assume all files are 'active' for display purposes, or you can use a property from 'file' if it exists.
                    const statusClass = 'active'; // or file.status === 'some_active_state' ? 'active' : 'inactive';
                    const statusText = 'Active'; // or derived from file.status

                    // Ensure fileName exists before using it
                    const fileName = file.fileName || 'Unknown File';
                    const fileNameInitial = fileName.charAt(0).toUpperCase();

                    card.innerHTML = "" +
                        "<div class=\"vxml-card-header\">" +
                            "<div class=\"vxml-initial-circle\">" + fileNameInitial + "</div>" +
                            "<div class=\"vxml-file-name\" title=\"" + fileName + "\">" + fileName + "</div>" +
                            "<span class=\"vxml-card-status " + statusClass + "\">" + statusText + "</span>" +
                        "</div>" +
                        "<div class=\"vxml-card-body\">" +
                            "<p><i class=\"fas fa-info-circle\"></i> ID: " + (file.vxmlId || 'N/A') + "</p>" +
                        "</div>" +
                        "<div class=\"vxml-card-actions\">" +
                            "<button class=\"action-btn view-btn\" title=\"View Content\" onclick='viewVXMLContent(" + file.vxmlId + ", \"" + fileName + "\")'>" +
                                "<i class=\"fas fa-eye\"></i>" +
                            "</button>" +
                            "<button class=\"action-btn edit-btn\" title=\"Edit\" onclick='openEditVXMLModal(" + file.vxmlId + ", \"" + fileName + "\")'>" +
                                "<i class=\"fas fa-edit\"></i>" +
                            "</button>" +
                            "<button class=\"action-btn delete-btn\" title=\"Delete\" onclick='confirmDeleteVXML(\"" + file.vxmlId + "\", \"" + fileName + "\")'>" +
                                "<i class=\"fas fa-trash\"></i>" +
                            "</button>" +
                        "</div>";
                    cardsContainer.appendChild(card);
                });
            }

            document.getElementById('searchInput').addEventListener('input', async (e) => {
                const searchTerm = e.target.value.toLowerCase();
                try {
                    const response = await fetch('http://localhost:8080/IVR-Platform/api/vxmlfiles');
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: \${response.status}`);
                    }
                    const vxmlFiles = await response.json();
                    const filteredFiles = vxmlFiles.filter(file =>
                        file.fileName.toLowerCase().includes(searchTerm) ||
                        (file.filePath && file.filePath.toLowerCase().includes(searchTerm))
                    );
                    renderVXMLFiles(filteredFiles);
                } catch (error) {
                    console.error('Error searching VXML files:', error);
                }
            });

            // --- VXML Content Redirection Logic ---
            async function viewVXMLContent(vxmlId, fileName) {
                // Redirect to vxml-editor-view.jsp with vxmlId, readOnly flag, and fileName
                window.location.href = '../vxml/vxml-editor-view.jsp?vxmlId=' + vxmlId + '&readOnly=true&fileName=' + encodeURIComponent(fileName);
            }

            function closeVXMLContentModal() {
                // This function is no longer needed but kept for now as a placeholder or if other elements might call it.
                document.getElementById('vxmlContentModal').style.display = 'none';
            }

            document.getElementById('vxmlContentModal').addEventListener('click', (e) => {
                if (e.target === document.getElementById('vxmlContentModal')) {
                    closeVXMLContentModal();
                }
            });

            // --- Delete Confirmation Modal Logic ---
            async function confirmDeleteVXML(vxmlId, fileName) {
                document.getElementById('confirmDeleteBtn').dataset.vxmlId = vxmlId;
                document.getElementById('deleteConfirmMessage').textContent = `Are you sure you want to delete VXML file "${fileName}"? This action cannot be undone.`;
                openDeleteConfirmModal();
            }

            async function deleteVXML(vxmlId) {
                try {
                    const url = 'http://localhost:8080/IVR-Platform/api/vxmlfiles/' + vxmlId;
                    const response = await fetch(url, {
                        method: 'DELETE'
                    });

                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error(`HTTP error! Status: \${response.status}, Details: \${errorText}`);
                    }

                    showCustomAlert('VXML file deleted successfully!');
                    fetchVXMLFiles(); // Refresh the list
                } catch (error) {
                    console.error('Error deleting VXML file:', error);
                    showCustomAlert(`Error deleting VXML file: \${error.message}`);
                }
            }

            function openDeleteConfirmModal() {
                document.getElementById('deleteConfirmModal').style.display = 'flex';
            }

            function closeDeleteConfirmModal() {
                document.getElementById('deleteConfirmModal').style.display = 'none';
            }

            document.getElementById('confirmDeleteBtn').addEventListener('click', async () => {
                const vxmlId = document.getElementById('confirmDeleteBtn').dataset.vxmlId;
                if (vxmlId) {
                    await deleteVXML(vxmlId);
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

            // --- Add/Edit VXML Redirection Logic ---
            function openAddEditVXMLModal() {
                // Redirect to vxml-editor.jsp for adding a new file (no ID)
                window.location.href = '../vxml/vxml-editor.jsp';
            }

            async function openEditVXMLModal(vxmlId, fileName) {
                // Redirect to vxml-editor-edit.jsp with vxmlId and fileName
                window.location.href = '../vxml/vxml-editor-edit.jsp?vxmlId=' + vxmlId + '&fileName=' + encodeURIComponent(fileName);
            }

            document.querySelector('.add-vxml-btn').addEventListener('click', () => {
                openAddEditVXMLModal();
            });

            // --- Custom Alert Modal (reused from list.jsp) ---
            function showCustomAlert(message) {
                document.getElementById('customAlertMessage').textContent = message;
                document.getElementById('customSuccessAlertModal').style.display = 'flex';
            }

            function closeCustomAlert() {
                document.getElementById('customSuccessAlertModal').style.display = 'none';
            }

            fetchVXMLFiles(); // Initial fetch on page load
        </script>
    </body>
</html>