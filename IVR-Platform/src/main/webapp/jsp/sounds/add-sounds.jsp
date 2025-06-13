<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Comparator" %>
<%
    String soundsDir = "/var/lib/asterisk/sounds/en";
    File dir = new File(soundsDir);
    File[] files = dir.listFiles((d, name) -> name.toLowerCase().endsWith(".gsm"));
    int totalFiles = (files != null) ? files.length : 0;
    int filesPerPage = 16; // 4 columns * 4 rows
    int totalPages = (totalFiles > 0) ? (int) Math.ceil((double) totalFiles / filesPerPage) : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sounds Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: #f3f4f6;
            background-color: #f0f8ff;
            box-sizing: border-box; /* Added for consistent box model */
        }

        .container {
            padding: 2rem;
            margin-left: 256px; /* Space for sidebar */
            padding-top: 64px; /* Changed margin-top to padding-top for fixed header */
        }
        
        .sounds-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* 4 columns */
            grid-auto-rows: minmax(150px, auto); /* Ensure rows have a minimum height */
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .sound-card {
            background: white;
            border-radius: 0.5rem;
            padding: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            position: relative;
        }
        
        .sound-card .icon {
            font-size: 2rem;
            color: #06b6d4;
            text-align: center;
        }
        
        .sound-card .name {
            font-weight: 500;
            text-align: center;
            word-break: break-all;
        }
        
        .sound-card .path {
            color: #666;
            font-size: 0.875rem;
            text-align: center;
            word-break: break-all;
        }

        .sound-card .actions {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .sound-card .actions button {
            background: none;
            border: none;
            color: #666;
            cursor: pointer;
            padding: 0.25rem;
            border-radius: 0.25rem;
            transition: all 0.2s;
        }

        .sound-card .actions button:hover {
            background: #f5f5f5;
            color: #06b6d4;
        }

        .sound-card .actions button.delete:hover {
            color: #EF4444;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem;
        }

        .pagination-btn {
            background: white;
            border: 1px solid #ddd;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .pagination-btn:hover {
            background: #f5f5f5;
        }

        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .sounds-counter {
            background: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            border: 1px solid #ddd;
        }

        .sounds-page {
            display: none;
        }

        .sounds-page.active {
            display: grid;
        }
        
        #uploadModal {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 50;
        }
        
        .modal-content {
            background: white;
            width: 90%;
            max-width: 500px;
            margin: 2rem auto;
            padding: 2rem;
            border-radius: 0.5rem;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .close-btn {
            font-size: 1.5rem;
            cursor: pointer;
            color: #666;
        }
        
        .file-input {
            border: 2px dashed #ddd;
            padding: 2rem;
            text-align: center;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .file-input.dragover {
            border-color: #06b6d4;
            background: rgba(6,182,212,0.1);
        }
        
        .submit-btn {
            background: linear-gradient(to right, #06b6d4, #a855f7);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            width: 100%;
            cursor: pointer;
        }
        
        .submit-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .progress-bar {
            height: 4px;
            background: #eee;
            border-radius: 2px;
            margin-top: 1rem;
            overflow: hidden;
        }
        
        .progress-bar .progress {
            height: 100%;
            background: linear-gradient(to right, #06b6d4, #a855f7);
            width: 0;
            transition: width 0.3s;
        }

        .notification {
            position: fixed;
            bottom: 1rem;
            right: 1rem;
            padding: 1rem;
            border-radius: 0.5rem;
            color: white;
            display: none;
            z-index: 100;
        }

        .notification.success {
            background-color: #10B981;
        }

        .notification.error {
            background-color: #EF4444;
        }
    </style>
</head>
<body>
        <jsp:include page="/jsp/includes/sidebar.jsp" />
        <jsp:include page="/jsp/includes/header.jsp" />
    <div class="container">
        
        <div id="soundsContainer">
            <%
            if (files != null) {
                Arrays.sort(files, Comparator.comparing(File::getName));
                
                for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
            %>
                <div class="sounds-page <%= pageIndex == 0 ? "active" : "" %>" data-page="<%= pageIndex %>">
                    <div class="sounds-grid">
                        <%
                        for (int i = pageIndex * filesPerPage; i < Math.min((pageIndex + 1) * filesPerPage, totalFiles); i++) {
                            File file = files[i];
                            String fileName = file.getName();
                            String filePath = file.getAbsolutePath(); // Get absolute path
                            long fileSize = file.length();
                            String sizeStr = fileSize < 1024 ? fileSize + " B" :
                                           fileSize < 1024 * 1024 ? (fileSize / 1024) + " KB" :
                                           (fileSize / (1024 * 1024)) + " MB";
                        %>
                            <div class="sound-card">
                                <div class="icon">
                                    <i class="fa-solid fa-volume-high"></i>
                                </div>
                                <div class="name"><%= fileName %></div>
                                <div class="path" title="<%= filePath %>">Path: <%= fileName %></div> <%-- Display filename for brevity, full path on hover --%>
                                <div class="actions">
                                    <button onclick="playSound('<%= fileName %>')" title="Play">
                                        <i class="fa-solid fa-play"></i>
                                    </button>
                                    <button onclick="downloadSound('<%= fileName %>')" title="Download">
                                        <i class="fa-solid fa-download"></i>
                                    </button>
                                    <button onclick="showDeleteModal('<%= fileName %>')" class="delete" title="Delete">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        <%
                        }
                        %>
                    </div>
                </div>
            <%
                }
            %>
                <div class="pagination">
                    <button class="pagination-btn" onclick="previousPage()" id="prevBtn">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <div class="sounds-counter">
                        <span id="currentPage">1</span> / <span id="totalPages"><%= totalPages %></span>
                        (<span id="totalSounds"><%= totalFiles %></span> sounds)
                    </div>
                    <button class="pagination-btn" onclick="nextPage()" id="nextBtn">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>
            <%
            }
            %>
        </div>
    </div>
    
    <div id="uploadModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Upload Sound Files</h2>
                <span class="close-btn" onclick="closeUploadModal()">&times;</span>
            </div>
            
            <form id="uploadForm" action="${pageContext.request.contextPath}/upload-sound" method="post" enctype="multipart/form-data">
                <div class="file-input" id="dropZone">
                    <i class="fa-solid fa-cloud-upload-alt" style="font-size: 2rem; color: #06b6d4;"></i>
                    <p>Drag and drop .GSM files here or click to select</p>
                    <input type="file" name="sounds" multiple accept=".gsm" style="display: none;" id="fileInput">
                </div>
                
                <div id="fileList"></div>
                
                <div class="progress-bar">
                    <div class="progress" id="uploadProgress"></div>
                </div>
                
                <button type="submit" class="submit-btn" id="submitBtn" disabled>
                    Upload Files
                </button>
            </form>
        </div>
    </div>

    <div id="notification" class="notification"></div>
    
    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 50;">
        <div style="background: white; width: 90%; max-width: 400px; margin: 2rem auto; padding: 2rem; border-radius: 0.5rem; text-align: center;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <div style="font-size: 1.25rem; font-weight: 600; color: #333;">ØªØ£ÙÙØ¯ Ø§ÙØ­Ø°Ù</div>
                <div style="font-size: 1.5rem; cursor: pointer; color: #666;" onclick="hideDeleteModal()">&times;</div>
            </div>
            <p>ÙÙ Ø£ÙØª ÙØªØ£ÙØ¯ Ø£ÙÙ ØªØ±ÙØ¯ Ø­Ø°Ù ÙØ°Ø§ Ø§ÙØµÙØªØ</p>
            <div style="display: flex; justify-content: center; gap: 1rem; margin-top: 1.5rem;">
                <button onclick="hideDeleteModal()" style="padding: 0.75rem 1.5rem; border-radius: 0.5rem; cursor: pointer; font-weight: 500; background: #E5E7EB; color: #374151; border: none;">Ø¥ÙØºØ§Ø¡</button>
                <button onclick="confirmDelete()" style="padding: 0.75rem 1.5rem; border-radius: 0.5rem; cursor: pointer; font-weight: 500; background: #EF4444; color: white; border: none;">Ø­Ø°Ù</button>
            </div>
        </div>
    </div>

</body>
</html> 