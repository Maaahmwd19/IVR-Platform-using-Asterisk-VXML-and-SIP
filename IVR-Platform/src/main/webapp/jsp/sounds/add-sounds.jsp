<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.File" %>

<%!
// Sound class
    public class Sound {
        private String id;
        private String name;
        private String path;
        private String size;
        private String uploadDate;

        public Sound(String id, String name, String path, String size, String uploadDate) {
            this.id = id;
            this.name = name;
            this.path = path;
            this.size = size;
            this.uploadDate = uploadDate;
        }

        public String getId() { return id; }
        public String getName() { return name; }
        public String getPath() { return path; }
        public String getSize() { return size; }
        public String getUploadDate() { return uploadDate; }
        public void setId(String id) { this.id = id; }
        public void setName(String name) { this.name = name; }
        public void setPath(String path) { this.path = path; }
        public void setSize(String size) { this.size = size; }
        public void setUploadDate(String uploadDate) { this.uploadDate = uploadDate; }
    }

    public List<Sound> getAllSounds() {
        List<Sound> sounds = new ArrayList<>();
        String soundsDir = "/var/lib/asterisk/sounds/ivr";
        File dir = new File(soundsDir);
        File[] files = dir.listFiles((d, name) -> name.toLowerCase().endsWith(".gsm"));

        if (files != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            for (int i = 0; i < files.length; i++) {
                File file = files[i];
                String id = String.valueOf(i + 1);
                String name = file.getName().replace(".gsm", "").replace("_", " ");
                String path = "/sounds/ivr/" + file.getName();
                String size = String.format("%.1f", file.length() / (1024.0 * 1024.0)); // Size in MB
                String uploadDate = dateFormat.format(new Date(file.lastModified()));
                sounds.add(new Sound(id, name, path, size, uploadDate));
            }
        }
        return sounds;
    }

    public double getTotalSize(List<Sound> sounds) {
        double total = 0;
        for (Sound sound : sounds) {
            total += Double.parseDouble(sound.getSize());
        }
        return total;
    }
%>

<%
// Initialize data
    List<Sound> allSounds = getAllSounds();
    List<Sound> currentSounds = allSounds; // Show all sounds at once

// Handle file upload
    String uploadMessage = "";
    if ("POST".equals(request.getMethod()) && request.getParameter("upload") != null) {
        uploadMessage = "Files uploaded successfully! (Demo mode)";
    }

// Handle delete
    if ("POST".equals(request.getMethod()) && request.getParameter("delete") != null) {
        String deleteId = request.getParameter("deleteId");
        uploadMessage = "Sound file deleted successfully! (Demo mode)";
    }

    double totalSize = getTotalSize(allSounds);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sound Library - VoxRoute</title>

    <!-- Include Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Include Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="icon" type="image/png" href="../images/logo.png">

    <!-- Custom styles -->
    <style>
        .bg-gradient-slate-blue {
            background: linear-gradient(to bottom right, #f8fafc, #dbeafe);
        }
        .bg-gradient-blue-purple {
            background: linear-gradient(to right, #3b82f6, #7c3aed);
        }
        .bg-gradient-purple-pink {
            background: linear-gradient(to right, #7c3aed, #ec4899);
        }
        .bg-gradient-pink-red {
            background: linear-gradient(to right, #ec4899, #ef4444);
        }
        .bg-gradient-blue-purple-light {
            background: linear-gradient(to bottom right, #dbeafe, #e9d5ff);
        }
        .sound-card {
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .sound-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .sound-card-overlay {
            background: linear-gradient(to bottom right, rgba(59, 130, 246, 0.05), rgba(124, 58, 237, 0.05));
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .sound-card:hover .sound-card-overlay {
            opacity: 1;
        }
        .btn-play {
            transition: all 0.2s ease;
        }
        .btn-play:hover {
            background-color: #dbeafe;
            border-color: #93c5fd;
            color: #1d4ed8;
        }
        .btn-play.playing {
            background-color: #dcfce7;
            border-color: #86efac;
            color: #166534;
        }
        .btn-download:hover {
            background-color: #f3e8ff;
            border-color: #c4b5fd;
            color: #7c3aed;
        }
        .btn-delete:hover {
            background-color: #fee2e2;
            border-color: #fca5a5;
            color: #dc2626;
        }
        .upload-area {
            background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%);
            color: white;
            transition: all 0.2s ease;
            border-radius: 0.5rem;
            box-shadow: 0 2px 4px rgba(139, 92, 246, 0.2);
            border: none;
        }
        .upload-area:hover {
            background: linear-gradient(135deg, #7c3aed 0%, #5b21b6 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(139, 92, 246, 0.3);
        }
        .generate-area {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            transition: all 0.2s ease;
            border-radius: 0.5rem;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
            border: none;
        }
        .generate-area:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(16, 185, 129, 0.3);
        }
        .loading-spinner {
            border: 2px solid #ffffff;
            border-top: 2px solid transparent;
            border-radius: 50%;
            width: 16px;
            height: 16px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .tooltip {
            position: relative;
        }
        .tooltip:hover .tooltip-text {
            visibility: visible;
            opacity: 1;
        }
        .tooltip-text {
            visibility: hidden;
            opacity: 0;
            width: 80px;
            background-color: #374151;
            color: white;
            text-align: center;
            border-radius: 6px;
            padding: 5px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            margin-left: -40px;
            font-size: 12px;
            transition: opacity 0.3s;
        }
        .tooltip-text::after {
            content: "";
            position: absolute;
            top: 100%;
            left: 50%;
            margin-left: -5px;
            border-width: 5px;
            border-style: solid;
            border-color: #374151 transparent transparent transparent;
        }
        @media (max-width: 768px) {
            .sound-grid { grid-template-columns: repeat(1, 1fr); }
        }
        @media (min-width: 769px) and (max-width: 1024px) {
            .sound-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (min-width: 1025px) and (max-width: 1280px) {
            .sound-grid { grid-template-columns: repeat(3, 1fr); }
        }
        @media (min-width: 1281px) {
            .sound-grid { grid-template-columns: repeat(4, 1fr); }
        }
        .sound-grid {
            display: grid;
            gap: 1.5rem;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        }
        .sound-card-content {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .sound-card-header {
            margin-bottom: 1rem;
            text-align: center;
        }
        .sound-card-body {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .sound-card-footer {
            margin-top: 1rem;
            text-align: center;
        }
    </style>
</head>
<jsp:include page="/jsp/includes/sidebar.jsp" />

<body class="bg-gray-50">
    
    <div class="flex min-h-screen">
        <!-- Sidebar overlay for mobile -->
        <div class="sidebar-overlay fixed inset-0 bg-black bg-opacity-50 z-10 md:hidden" onclick="toggleSidebar()"></div>

        <!-- Main content -->
        <main class="flex-1 overflow-y-auto ml-[280px] h-screen">
            <div class="container mx-auto p-4 md:p-6">
                <jsp:include page="/jsp/includes/header.jsp" />
                <div class="bg-gradient-slate-blue">
                    <div class="flex-1 flex flex-col">
                        <!-- Main Content Area -->
                        <div class="flex-1 p-6">
                            <div class="mx-auto max-w-7xl">
                                <!-- Content Header -->
                                <div class="mb-8">
                                    <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                                        <div class="w-4/5">
                                            <input
                                                type="text"
                                                id="searchInput"
                                                onkeyup="filterSounds()"
                                                placeholder="Search sound name..."
                                                class="w-full px-4 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
                                            />
                                        </div>

                                           <!-- Generate Sound Button -->
                                           <label for="generate-sound" class="generate-area flex cursor-pointer items-center gap-2 px-4 py-2">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M12 2a3 3 0 0 0-3 3v7a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3Z"></path>
                                                <path d="M19 10v2a7 7 0 0 1-14 0v-2"></path>
                                                <line x1="12" y1="19" x2="12" y2="22"></line>
                                            </svg>
                                            Generate Sound
                                        </label>
                                        <input type="button" id="generate-sound" class="hidden" onclick="openGenerateSoundModal()">

                                        <!-- Upload Section -->
                                        <div class="flex flex-col gap-4 md:flex-row md:items-center">
                                            <label for="file-upload" class="upload-area flex cursor-pointer items-center gap-2 px-4 py-2">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                                    <polyline points="7 10 12 15 17 10"></polyline>
                                                    <line x1="12" y1="15" x2="12" y2="3"></line>
                                                </svg>
                                                Select GSM Files
                                            </label>
                                            <input type="file" id="file-upload" name="files" multiple accept=".gsm" class="hidden" onchange="handleFileSelect(this)">
                                            <div id="selected-files" class="hidden">
                                                <span id="file-count" class="inline-flex items-center rounded-md bg-blue-100 px-2 py-1 text-xs font-medium text-blue-800"></span>
                                                <button type="button" id="upload-btn" class="ml-2 inline-flex items-center rounded-md bg-gradient-to-r from-purple-600 to-blue-600 px-4 py-2 text-sm font-medium text-white hover:from-purple-700 hover:to-blue-700">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2 h-4 w-4">
                                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                                        <polyline points="7 10 12 15 17 10"></polyline>
                                                        <line x1="12" y1="15" x2="12" y2="3"></line>
                                                    </svg>
                                                    Upload Files
                                                </button>
                                            </div>
 
                                        </div>
                                    </div>

                                    <!-- Upload Message -->
                                    <div id="api-upload-message" class="hidden mt-4 rounded-md p-4">
                                        <div class="flex">
                                            <svg id="api-upload-icon" class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                                            </svg>
                                            <div class="ml-3">
                                                <p id="api-upload-text" class="text-sm font-medium"></p>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Stats -->
                                    <div class="mt-6 grid grid-cols-1 gap-4 md:grid-cols-1">
                                        <div class="bg-gradient-blue-purple rounded-lg p-4 text-white">
                                            <div class="flex items-center gap-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                                                    <path d="M15.54 8.46a5 5 0 0 1 0 7.07"></path>
                                                    <path d="M19.07 4.93a10 10 0 0 1 0 14.14"></path>
                                                </svg>
                                                <div>
                                                    <p class="text-sm opacity-90">Total Sounds</p>
                                                    <p class="text-2xl font-bold"><%= allSounds.size()%></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Sound Cards Grid -->
                                <div class="mb-8">
                                    <div class="sound-grid">
                                        <% for (Sound sound : currentSounds) {%>
                                        <div class="sound-card relative overflow-hidden rounded-lg border-0 bg-white shadow-md">
                                            <div class="sound-card-overlay absolute inset-0"></div>
                                            <div class="sound-card-content">
                                                <!-- Sound Icon -->
                                                <div class="sound-card-header">
                                                    <div class="bg-gradient-blue-purple-light flex h-16 w-16 items-center justify-center rounded-full mx-auto">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-purple-600">
                                                            <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                                                            <path d="M15.54 8.46a5 5 0 0 1 0 7.07"></path>
                                                            <path d="M19.07 4.93a10 10 0 0 1 0 14.14"></path>
                                                        </svg>
                                                    </div>
                                                </div>

                                                <!-- Sound Info -->
                                                <div class="sound-card-body">
                                                    <div>
                                                        <h3 class="mb-2 font-semibold text-gray-900 text-center"><%= sound.getName()%></h3>
                                                    </div>

                                                    <!-- Action Buttons -->
                                                    <div class="flex items-center justify-center gap-2 mt-4">
                                                        <!-- Delete Button -->
                                                        <div class="tooltip">
                                                            <form method="post" style="display: inline;">
                                                                <input type="hidden" name="delete" value="true">
                                                                <input type="hidden" name="deleteId" value="<%= sound.getId()%>">
                                                                <button type="submit" onclick="return confirm('Are you sure you want to delete this sound file?')" class="btn-delete h-8 w-8 rounded-md border border-gray-300 bg-white p-0">
                                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                        <polyline points="3 6 5 6 21 6"></polyline>
                                                                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                                    </svg>
                                                                </button>
                                                            </form>
                                                            <span class="tooltip-text">Delete</span>
                                                        </div>

                                                        <!-- Copy Name Button -->
                                                        <div class="tooltip">
                                                            <%
                                                                String soundName = sound.getName();
                                                            %>
                                                            <button
                                                                type="button"
                                                                class="btn-copy h-8 w-8 rounded-md border border-gray-300 bg-white p-0"
                                                                onclick="copyNameFromButton(this)"
                                                                data-name="<%= soundName.replace("\"", "")%>">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                    <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                                                                    <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                                                                </svg>
                                                            </button>
                                                            <span class="tooltip-text">Copy Name</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Upload Date -->
                                                <div class="sound-card-footer">
                                                    <span class="inline-flex items-center rounded-md bg-gray-100 px-2 py-1 text-xs font-medium text-gray-800">
                                                        <%= new SimpleDateFormat("MMM dd, yyyy").format(new SimpleDateFormat("yyyy-MM-dd").parse(sound.getUploadDate()))%>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <% } %>
                                    </div>

                                    <!-- Empty State -->
                                    <% if (allSounds.isEmpty()) { %>
                                    <div class="flex flex-col items-center justify-center py-16">
                                        <div class="mb-4 flex h-24 w-24 items-center justify-center rounded-full bg-gray-100">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-400">
                                                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
                                                <path d="M15.54 8.46a5 5 0 0 1 0 7.07"></path>
                                                <path d="M19.07 4.93a10 10 0 0 1 0 14.14"></path>
                                            </svg>
                                        </div>
                                        <h3 class="mb-2 text-lg font-semibold text-gray-900">No sounds found</h3>
                                        <p class="mb-4 text-gray-500">Upload your first GSM audio file to get started</p>
                                        <label for="file-upload" class="cursor-pointer rounded-md bg-gradient-to-r from-purple-600 to-blue-600 px-4 py-2 text-white hover:from-purple-700 hover:to-blue-700">
                                            Upload Sounds
                                        </label>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Generate Sound Modal -->
    <div id="generateSoundModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 hidden overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <h3 class="text-lg font-medium leading-6 text-gray-900 mb-4">Generate Sound from Text</h3>
                <div class="mt-2 px-7 py-3">
                    <textarea id="soundText" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="Enter text to convert to sound..."></textarea>
                </div>
                <div class="flex items-center justify-end gap-3 mt-4">
                    <button type="button" onclick="closeGenerateSoundModal()" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-400">
                        Cancel
                    </button>
                    <button type="button" onclick="generateSound()" class="px-4 py-2 bg-gradient-to-r from-green-600 to-emerald-600 text-white rounded-md hover:from-green-700 hover:to-emerald-700 focus:outline-none focus:ring-2 focus:ring-green-400">
                        Generate
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for interactions -->
    <script>
        let selectedFiles = [];

        // Handle file selection
        function handleFileSelect(input) {
            selectedFiles = Array.from(input.files);
            const selectedFilesDiv = document.getElementById('selected-files');
            const fileCountSpan = document.getElementById('file-count');

            if (selectedFiles.length > 0) {
                const invalidFiles = selectedFiles.filter(file => !file.name.toLowerCase().endsWith('.gsm'));
                if (invalidFiles.length > 0) {
                    showApiMessage('Only .gsm files are allowed!', 'red');
                    input.value = '';
                    selectedFilesDiv.classList.add('hidden');
                    return;
                }
                fileCountSpan.textContent = `${selectedFiles.length} file${selectedFiles.length > 1 ? 's' : ''} selected`;
                selectedFilesDiv.classList.remove('hidden');
            } else {
                selectedFilesDiv.classList.add('hidden');
            }
        }

        // Handle upload button click
        document.getElementById('upload-btn').addEventListener('click', async () => {
            if (selectedFiles.length === 0) {
                showApiMessage('Please select files first', 'red');
                return;
            }

            const uploadBtn = document.getElementById('upload-btn');
            uploadBtn.disabled = true;
            uploadBtn.innerHTML = `
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Uploading...
            `;

            try {
                const results = await uploadFilesToApi(selectedFiles);
                const successCount = results.filter(r => r.success).length;
                if (successCount === selectedFiles.length) {
                    showApiMessage(`All ${successCount} files uploaded successfully!`, 'green');
                } else if (successCount > 0) {
                    const errorCount = selectedFiles.length - successCount;
                    showApiMessage(`${successCount} files uploaded, ${errorCount} failed`, 'yellow');
                } else {
                    showApiMessage('failed to upload Sound File Already Exist', 'red');
                }
                setTimeout(() => {
                    window.location.reload();
                }, 4000);
            } catch (error) {
                showApiMessage('Error uploading files: ' + error.message, 'red');
            } finally {
                uploadBtn.disabled = false;
                uploadBtn.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2 h-4 w-4">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                    Upload Files
                `;
            }
        });

        // Function to upload files to API
        async function uploadFilesToApi(files) {
            const results = [];
            for (const file of files) {
                const formData = new FormData();
                formData.append('file', file);
                try {
                    const response = await fetch('http://localhost:8080/IVR-Platform/api/soundfiles/upload', {
                        method: 'POST',
                        body: formData
                    });
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    const data = await response.json();
                    results.push({success: true, file: file.name, data});
                } catch (error) {
                    results.push({success: false, file: file.name, error: error.message});
                }
            }
            return results;
        }

        // Function to show API messages
        function showApiMessage(message, color) {
            const messageElement = document.getElementById('api-upload-message');
            const textElement = document.getElementById('api-upload-text');
            const iconElement = document.getElementById('api-upload-icon');

            messageElement.className = 'hidden mt-4 rounded-md p-4';
            textElement.className = 'text-sm font-medium';
            iconElement.className = 'h-5 w-5';

            if (color === 'green') {
                messageElement.classList.add('bg-green-50');
                textElement.classList.add('text-green-800');
                iconElement.classList.add('text-green-400');
            } else if (color === 'red') {
                messageElement.classList.add('bg-red-50');
                textElement.classList.add('text-red-800');
                iconElement.classList.add('text-red-400');
            } else {
                messageElement.classList.add('bg-yellow-50');
                textElement.classList.add('text-yellow-800');
                iconElement.classList.add('text-yellow-400');
            }

            if (textElement) {
                textElement.innerText = message;
            }

            messageElement.classList.remove('hidden');
            setTimeout(() => {
                messageElement.classList.add('hidden');
            }, 5000);
        }

        // Function to copy sound name
        function copyNameFromButton(button) {
            const name = button.getAttribute('data-name');
            if (!name) {
                console.error('No data-name attribute found');
                showApiMessage('Error: Missing name', 'red');
                return;
            }
            navigator.clipboard.writeText(name).then(() => {
                showApiMessage(`Copied: `+ name, 'green');
            }).catch(err => {
                console.error('Copy failed:', err);
                showApiMessage('Failed to copy', 'red');
            });
        }

        // Function to filter sound cards
        function filterSounds() {
            const input = document.getElementById("searchInput").value.toLowerCase();
            const soundCards = document.querySelectorAll(".sound-card");

            soundCards.forEach(card => {
                const soundName = card.querySelector("h3").textContent.toLowerCase();
                card.style.display = soundName.startsWith(input) ? "" : "none";
            });
        }

        // Generate Sound Modal Functions
        function openGenerateSoundModal() {
            document.getElementById('generateSoundModal').classList.remove('hidden');
        }

        function closeGenerateSoundModal() {
            document.getElementById('generateSoundModal').classList.add('hidden');
            document.getElementById('soundText').value = '';
        }

        async function generateSound() {
            const text = document.getElementById('soundText').value.trim();
            if (!text) {
                showApiMessage('Please enter text to convert to sound', 'red');
                return;
            }

            try {
                const response = await fetch('http://localhost:8080/IVR-Platform/api/generated-sounds/generate', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'text/plain',
                        'Accept': 'application/json'
                    },
                    body: text
                });

                let responseData;
                const contentType = response.headers.get('content-type');
                if (contentType && contentType.includes('application/json')) {
                    try {
                        responseData = await response.json();
                    } catch (e) {
                        console.error('Error parsing JSON response:', e);
                        throw new Error('Invalid JSON response from server');
                    }
                } else {
                    const text = await response.text();
                    try {
                        responseData = JSON.parse(text);
                    } catch (e) {
                        console.error('Error parsing text as JSON:', e);
                        throw new Error(text || 'Server error occurred');
                    }
                }

                if (!response.ok) {
                    throw new Error(responseData.error || responseData.message || 'Failed to generate sound');
                }

                const message = 'Sound generated successfully';
                const fileName = responseData.fileName || 'Unknown file';
                showApiMessage(`Sound generated successfully: `+ fileName , 'green');
                closeGenerateSoundModal();
                setTimeout(() => {
                    window.location.reload();
                }, 4000);
            } catch (error) {
                console.error('Error generating sound:', error);
                showApiMessage('Error generating sound: ' + error.message, 'red');
            }
        }
    </script>
</body>
</html>