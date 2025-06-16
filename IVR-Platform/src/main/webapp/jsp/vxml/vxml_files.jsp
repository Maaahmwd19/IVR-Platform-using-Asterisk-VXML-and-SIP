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

            /* New Styles for Add/Edit VXML Modal */
            #addEditVXMLModal .modal-content {
                max-width: 700px; /* Wider for content textarea */
            }
            #addEditVXMLModal .form-group {
                margin-bottom: 15px;
            }
            #addEditVXMLModal label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
                color: #374151;
            }
            #addEditVXMLModal input[type="text"],
            #addEditVXMLModal textarea {
                width: calc(100% - 20px);
                padding: 10px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 16px;
                color: #111827;
            }
            #addEditVXMLModal input[type="text"]:focus,
            #addEditVXMLModal textarea:focus {
                outline: none;
                border-color: #8b5cf6;
                box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
            }
            #addEditVXMLModal textarea {
                min-height: 200px;
                font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;
            }
            #addEditVXMLModal .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 20px;
            }
            #addEditVXMLModal .btn-primary {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            .add-vxml-btn:hover {
                opacity: 0.9;
            }
            #addEditVXMLModal .btn-secondary {
                background-color: #e5e7eb;
                color: #374151;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            #addEditVXMLModal .btn-secondary:hover {
                background-color: #d1d5db;
            }

            /* New Styles for VXML Content Modal */
            #vxmlContentModal .modal-content {
                max-width: 800px;
                width: 95%;
            }
            #vxmlContentModal pre {
                background-color: #f4f6f8;
                border: 1px solid #e5e7eb;
                padding: 15px;
                border-radius: 6px;
                overflow-x: auto;
                max-height: 500px; /* Limit height */
                white-space: pre-wrap; /* Wrap long lines */
                word-wrap: break-word; /* Break long words */
                font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;
                font-size: 14px;
                color: #333;
            }

            /* Custom Success Alert Modal (reusing styles from list.jsp) */
            .custom-alert-modal .modal-content {
                max-width: 350px;
                text-align: center;
                padding: 30px;
            }
            .custom-alert-modal .modal-icon {
                font-size: 48px;
                color: #28a745; /* Green for success */
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

            .add-vxml-btn {
                background: linear-gradient(45deg, #8b5cf6, #ec4899);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: opacity 0.2s;
            }
            .add-vxml-btn:hover {
                opacity: 0.9;
            }

            /* New styles for VXML cards */
            .vxml-cards-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 20px;
                padding: 24px;
            }

            .vxml-card {
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

            .vxml-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            .vxml-card-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }

            .vxml-initial-circle {
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

            .vxml-file-name {
                font-size: 18px;
                font-weight: 600;
                color: #111827;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                flex-grow: 1;
                min-width: 0;
            }

            .vxml-card-status {
                font-size: 12px;
                font-weight: 500;
                padding: 4px 8px;
                border-radius: 4px;
                margin-left: auto;
            }

            .vxml-card-status.active {
                background-color: #d1fae5;
                color: #065f46;
            }

            .vxml-card-status.inactive {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .vxml-card-body {
                font-size: 14px;
                color: #4b5563;
                margin-bottom: 15px;
            }

            .vxml-card-body p {
                margin-bottom: 5px;
            }

            .vxml-card-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
                margin-top: auto;
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