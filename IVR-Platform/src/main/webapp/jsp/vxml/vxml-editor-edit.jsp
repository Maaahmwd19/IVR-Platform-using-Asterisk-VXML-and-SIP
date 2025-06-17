<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        public String getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getPath() {
            return path;
        }

        public String getSize() {
            return size;
        }

        public String getUploadDate() {
            return uploadDate;
        }

        public void setId(String id) {
            this.id = id;
        }

        public void setName(String name) {
            this.name = name;
        }

        public void setPath(String path) {
            this.path = path;
        }

        public void setSize(String size) {
            this.size = size;
        }

        public void setUploadDate(String uploadDate) {
            this.uploadDate = uploadDate;
        }
    }

// Get all sounds from directory
    public List<Sound> getAllSounds() {
        List<Sound> sounds = new ArrayList<>();
        String soundsDir = "/var/lib/asterisk/sounds/ivr";
        File dir = new File(soundsDir);
        File[] files = dir.listFiles(( d,                                         name) -> name.toLowerCase().endsWith(".gsm"));

        if (files != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            for (int i = 0; i < files.length; i++) {
                File file = files[i];
                String id = String.valueOf(i + 1);
                String name = file.getName().replace(".gsm", "").replace("_", " ").replace("-", " ");                String path = "/sounds/en/" + file.getName();
                String size = String.format("%.1f", file.length() / (1024.0 * 1024.0)); // Size in MB
                String uploadDate = dateFormat.format(new Date(file.lastModified()));
                sounds.add(new Sound(id, name, path, size, uploadDate));
            }
        }
        return sounds;
    }

// Calculate total size
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

// Handle pagination
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }

    int itemsPerPage = 16; // 4 columns * 4 rows
    int totalPages = (allSounds.size() > 0) ? (int) Math.ceil((double) allSounds.size() / itemsPerPage) : 0;
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = Math.min(startIndex + itemsPerPage, allSounds.size());

    List<Sound> currentSounds = allSounds.isEmpty() ? new ArrayList<>() : allSounds.subList(startIndex, endIndex);

// Handle file upload
    String uploadMessage = "";
    if ("POST".equals(request.getMethod()) && request.getParameter("upload") != null) {
        uploadMessage = "Files uploaded successfully! (Demo mode)";
    }

// Handle delete
    if ("POST".equals(request.getMethod()) && request.getParameter("delete") != null) {
        String deleteId = request.getParameter("deleteId");
        // In real implementation, you would delete from the filesystem
        uploadMessage = "Sound file deleted successfully! (Demo mode)";
    }

    double totalSize = getTotalSize(allSounds);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>VXML Editor - VoxRoute</title>
    <link rel="icon" type="image/png" href="../images/logo.png">

        <!-- Include Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Include Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <!-- Include CodeMirror -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/monokai.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/xml/xml.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/javascript/javascript.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/css/css.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/matchbrackets.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/closebrackets.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/fold/xml-fold.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/xml-hint.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/html-hint.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.css">
    </head>
    <body class="bg-gray-50">
        <div class="flex min-h-screen">
            <!-- Include Sidebar -->
            <jsp:include page="/jsp/includes/sidebar.jsp" />

            <!-- Main content -->
            <main class="flex-1 overflow-y-auto ml-[256px] h-screen">
                <div class="container mx-auto p-4 md:p-6">
                    <!-- Include Header -->
                    <jsp:include page="/jsp/includes/header.jsp" />

                    <!-- Editor Content -->
                    <div class="mt-6">
                        <!-- File Name Input -->
                        <div class="mb-4">
                            <div class="flex items-center gap-4">
                                <div class="flex-1">
                                    <label for="fileName" class="block text-sm font-medium text-gray-700 mb-1">File Name</label>
                                    <div class="flex gap-2">
                                        <input type="text" id="fileName" name="fileName" placeholder="Enter VXML file name" 
                                               class="block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-purple-500 focus:outline-none focus:ring-1 focus:ring-purple-500">
                                        <span class="text-sm text-gray-500 self-end mb-2">.vxml</span>
                                    </div>
                                </div>

                                <div class="w-48">
                                    <label class="block text-sm font-medium text-gray-700 mb-1">Show All Sounds</label>
                                    <button onclick="openModal()" class="flex w-full items-center justify-center gap-2 rounded-md border border-gray-300 bg-white px-3 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50">
                                        <i class="fa-solid fa-music"></i>
                                        <span>Show All Sounds</span>
                                    </button>
                                </div>


                                <div class="w-48">
                                    <label for="fileUpload" class="block text-sm font-medium text-gray-700 mb-1">Upload VXML</label>
                                    <label class="flex w-full items-center justify-center gap-2 rounded-md border border-gray-300 bg-gray-100 px-3 py-2 text-sm font-semibold text-gray-400 cursor-not-allowed">
                                        <i class="fa-solid fa-upload"></i>
                                        <span>Choose File</span>
                                        <input type="file" id="fileUpload" accept=".vxml" class="hidden" disabled>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Editor Toolbar -->
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-2">
                                <!-- Save Button with Dropdown -->
                                <!-- Save Button with Dropdown -->
                                <div class="relative">
                                    <button onclick="toggleSaveOptions()" class="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                        <i class="fa-solid fa-save"></i>
                                        <span>Save</span>
                                    </button>

                                    <!-- Save Options Dropdown -->
                                    <div id="saveOptions" class="absolute left-0 mt-2 w-48 rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 hidden z-10">
                                        <button onclick="saveToServer()" class="flex w-full items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            <i class="fa-solid fa-cloud-upload-alt"></i>
                                            <span>Save to Server</span>
                                        </button>
                                        <button onclick="downloadVXML()" class="flex w-full items-center gap-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                            <i class="fa-solid fa-download"></i>
                                            <span>Download Copy</span>
                                        </button>
                                    </div>
                                </div>


                                <button onclick="validateVXML()" class="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                    <i class="fa-solid fa-check mr-2"></i>
                                    Validate
                                </button>
                                <button onclick="copyToClipboard()" class="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                    <i class="fa-solid fa-copy mr-2"></i>
                                    Copy
                                </button>
                            </div>
                            <div class="flex items-center gap-2">
                                <select id="themeSelect" onchange="changeTheme()" class="rounded-md border border-gray-300 px-3 py-2 text-sm">
                                    <option value="monokai">Monokai</option>
                                    <option value="default">Default</option>
                                    <option value="eclipse">Eclipse</option>
                                    <option value="dracula">Dracula</option>
                                </select>
                                <button onclick="toggleFullscreen()" class="inline-flex items-center gap-2 rounded-md border border-gray-300 px-3 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50">
                                    <i class="fa-solid fa-expand"></i>
                                    <span>Fullscreen</span>
                                </button>
                            </div>
                        </div>

                        <!-- Editor Container -->
                        <div class="flex flex-col h-[calc(100vh-16rem)]">
                            <!-- Main Editor -->
                            <div class="flex-1">
                                <textarea id="vxmlEditor"></textarea>
                            </div>
                        </div>

                        <!-- Validation Popup -->
                        <div id="validationPopup" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
                            <div class="bg-white rounded-lg p-6 max-w-lg w-full mx-4">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center gap-3">
                                        <i id="validationIcon" class="text-2xl"></i>
                                        <h3 id="validationTitle" class="text-xl font-semibold"></h3>
                                    </div>
                                    <button onclick="closeValidationPopup()" class="text-gray-500 hover:text-gray-700">
                                        <i class="fa-solid fa-xmark text-xl"></i>
                                    </button>
                                </div>
                                <p id="validationMessage" class="text-gray-600 mb-4"></p>
                                <div id="errorDetails" class="bg-gray-50 rounded-lg p-4 mb-4 hidden">
                                    <div class="font-semibold mb-2">Error Details:</div>
                                    <div id="errorLine" class="text-sm"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Copy Notification -->
                        <div id="copyNotification" class="fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg transform translate-y-full opacity-0 transition-all duration-300">
                            <div class="flex items-center gap-2">
                                <i class="fa-solid fa-check"></i>
                                <span>Copied to clipboard!</span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <style>
            /* Custom styles for error highlighting and autocomplete */
            .error-line {
                background-color: rgba(255, 0, 0, 0.1) !important;
            }
            .CodeMirror-hints {
                z-index: 1000;
                font-family: monospace;
                max-height: 300px;
                overflow-y: auto;
            }
            .CodeMirror-hint {
                padding: 4px 8px;
                border-radius: 4px;
                white-space: pre;
                color: #333;
                background: white;
                border: 1px solid #ddd;
                margin: 2px 0;
            }
            .CodeMirror-hint-active {
                background-color: #7c3aed !important;
                color: white !important;
                border-color: #7c3aed;
            }
            .CodeMirror-hint-description {
                color: #666;
                font-size: 0.9em;
                margin-left: 8px;
            }

            /* Validation popup styles */
            .validation-popup {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                min-width: 400px;
                max-width: 600px;
            }

            .validation-popup.show {
                display: block;
            }

            .validation-popup-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e5e7eb;
            }

            .validation-popup-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #1f2937;
            }

            .validation-popup-close {
                cursor: pointer;
                padding: 4px;
                color: #6b7280;
            }

            .validation-popup-content {
                max-height: 400px;
                overflow-y: auto;
            }

            .validation-popup-success {
                color: #059669;
                padding: 10px;
                background-color: #ecfdf5;
                border-radius: 4px;
            }

            .validation-popup-error {
                color: #dc2626;
                padding: 10px;
                background-color: #fef2f2;
                border-radius: 4px;
            }

            .validation-popup-error-item {
                display: flex;
                align-items: flex-start;
                gap: 10px;
                padding: 8px;
                border-bottom: 1px solid #fee2e2;
            }

            .validation-popup-error-line {
                font-weight: 600;
                color: #dc2626;
                min-width: 40px;
            }

            .validation-popup-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
            }

            .validation-popup-overlay.show {
                display: block;
            }
        </style>

        <!-- Add validation popup HTML -->
        <div class="validation-popup-overlay" id="validationOverlay"></div>
        <div class="validation-popup" id="validationPopup">
            <div class="validation-popup-header">
                <div class="validation-popup-title">VXML Validation Results</div>
                <div class="validation-popup-close" onclick="closeValidationPopup()">
                    <i class="fa-solid fa-xmark"></i>
                </div>
            </div>
            <div class="validation-popup-content" id="validationContent"></div>
        </div>



        <!-- Modal -->
<!-- Modal -->
<div id="soundModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden justify-center items-center">
  <div class="bg-white rounded-xl w-full max-w-2xl p-6 shadow-2xl border border-gray-200">
    <!-- Header -->
    <div class="flex justify-between items-center mb-4 border-b pb-2">
      <h2 class="text-xl font-semibold text-gray-800 flex items-center gap-2">
        <i class="fa-solid fa-music text-blue-500"></i>
        All Sounds
      </h2>
      <button onclick="closeModal()" class="text-gray-500 hover:text-red-500 text-2xl font-bold">&times;</button>
    </div>

    <!-- Body -->
    <div class="max-h-96 overflow-y-auto">
      <table class="w-full text-sm text-left text-gray-700 border">
        <thead class="bg-gray-100 sticky top-0 border-b">
          <tr>
            <th class="py-2 px-3">#</th>
            <th class="py-2 px-3">Sound Name</th>
            <th class="py-2 px-3">Copy</th>
          </tr>
        </thead>
        <tbody>
          <% for (Sound s : allSounds) { %>
          <tr class="border-b hover:bg-gray-50 transition">
            <td class="py-2 px-3"><%= s.getId() %></td>
            <td class="py-2 px-3" id="name-<%= s.getId() %>"><%= s.getName() %></td>
            <td class="py-2 px-3">
              <button onclick="copySoundName('<%= s.getName() %>')" class="flex items-center gap-1 bg-green-100 hover:bg-green-200 text-green-800 font-medium px-3 py-1 rounded text-xs border border-green-400">
                <i class="fa-solid fa-copy"></i> Copy
              </button>

            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>
</div>




        <script>
            let soundVXMLnames = [];

            fetch('http://localhost:8080/IVR-Platform/api/soundfiles')
                    .then(response => response.json())
                    .then(data => {
                        soundVXMLnames = data.map(item => item.soundVXMLname);
                    })
                    .catch(err => {
                        console.error('Failed to fetch soundVXMLnames:', err);
                    });

            // Editor Configuration with Tag Autocomplete
            const editor = CodeMirror.fromTextArea(document.getElementById('vxmlEditor'), {
                mode: 'xml',
                theme: 'monokai',
                lineNumbers: true,
                autoCloseTags: true,
                autoCloseBrackets: true,
                matchBrackets: true,
                indentUnit: 4,
                lineWrapping: true,
                readOnly: false, // Changed to false to enable editing
                extraKeys: {
                    "Ctrl-Space": "autocomplete",
                    "Ctrl-/": "toggleComment"
                },
                hintOptions: {
                    completeSingle: false,
                    closeOnUnfocus: false,
                    schemaInfo: {
                        "vxml": {attrs: {version: null, xmlns: null}},
                        "form": {attrs: {id: null}},
                        "field": {attrs: {name: null, type: null}},
                        "prompt": {attrs: {bargein: null}},
                        "grammar": {attrs: {src: null, type: null}},
                        "block": {attrs: {name: null}},
                        "goto": {attrs: {next: null}},
                        "submit": {attrs: {next: null}},
                        "if": {attrs: {cond: null}},
                        "elseif": {attrs: {cond: null}},
                        "else": {},
                        "var": {attrs: {name: null, expr: null}},
                        "script": {attrs: {src: null}}
                    }
                }
            });

// Add autocomplete trigger on typing for tags and attributes
            editor.on('inputRead', function (cm, change) {
                const cursor = cm.getCursor();
                const token = cm.getTokenAt(cursor);

                // Trigger autocomplete for tags when typing '<' or tag names
                if (change.text[0] === '<' || (token.type === 'tag' && /[\w]/.test(change.text[0]))) {
                    console.log('Triggering tag autocomplete:', change.text[0], token); // Debug
                    CodeMirror.commands.autocomplete(cm);
                }
                // Trigger autocomplete for attributes
                else if (token.type === 'attribute' && /[\w-]/.test(change.text[0])) {
                    console.log('Triggering attribute autocomplete:', change.text[0], token); // Debug
                    CodeMirror.commands.autocomplete(cm);
                }
            });


// Set default VXML example
            






            // Remove real-time validation
            // editor.on('change', function() {
            //     clearTimeout(validationTimeout);
            //     validationTimeout = setTimeout(validateVXML, 500);
            // });

            function validateVXML() {
                try {
                    const xmlCode = editor.getValue();
                    const parser = new DOMParser();
                    const xmlDoc = parser.parseFromString(xmlCode, "application/xml");

                    // Check for parser errors
                    const parserError = xmlDoc.querySelector('parsererror');
                    if (parserError) {
                        const errorDetails = document.getElementById('errorDetails');
                        const errorLine = document.getElementById('errorLine');
                        errorDetails.classList.remove('hidden');

                        // Extract line number from error message
                        const lineMatch = parserError.textContent.match(/line (\d+)/i);
                        const lineNumber = lineMatch ? lineMatch[1] : 'unknown';

                        errorLine.textContent = `Error found in line ${lineNumber}`;

                        showValidationPopup(false, 'XML Parse Error', parserError.textContent);
                        return;
                    }

                    // Validate VXML structure
                    const vxmlElement = xmlDoc.querySelector('vxml');
                    if (!vxmlElement) {
                        const errorDetails = document.getElementById('errorDetails');
                        const errorLine = document.getElementById('errorLine');
                        errorDetails.classList.remove('hidden');
                        errorLine.textContent = 'Missing root <vxml> element';

                        showValidationPopup(false, 'Missing Root Element', 'VXML document must have a <vxml> root element');
                        return;
                    }

                    // If no errors found
                    const errorDetails = document.getElementById('errorDetails');
                    errorDetails.classList.add('hidden');
                    showValidationPopup(true, 'Valid VXML', 'No errors detected');

                } catch (error) {
                    const errorDetails = document.getElementById('errorDetails');
                    const errorLine = document.getElementById('errorLine');
                    errorDetails.classList.remove('hidden');
                    errorLine.textContent = error.message;

                    showValidationPopup(false, 'Validation Error', error.message);
                }
            }

            // Toggle Save Options
            function toggleSaveOptions() {
                const dropdown = document.getElementById('saveOptions');
                dropdown.classList.toggle('hidden');

                // Close dropdown when clicking outside
                document.addEventListener('click', function closeDropdown(e) {
                    if (!e.target.closest('.relative')) {
                        dropdown.classList.add('hidden');
                        document.removeEventListener('click', closeDropdown);
                    }
                });
            }

            // Save to server function
            function saveToServer() {
                const fileNameInput = document.getElementById('fileName').value.trim();
                console.log('fileNameInput:', fileNameInput); // Debug: Log raw input

                // Validate base file name (without .vxml)
                if (!fileNameInput) {
                    showValidationPopup(false, 'Save Error', 'Please enter a valid file name');
                    console.error('Validation failed: Empty file name');
                    return;
                }
                if (!fileNameInput.match(/^[a-zA-Z0-9_-]+$/)) {
                    showValidationPopup(false, 'Save Error', 'File name must contain only letters, numbers, underscores, or hyphens');
                    console.error('Validation failed: Invalid file name characters');
                    return;
                }

                // Always add .vxml extension for the server
                const formattedFileName = fileNameInput + '.vxml';
                console.log('formattedFileName:', formattedFileName); // Debug: Log formatted file name

                // Construct filePath
                const filePath = '/var/lib/asterisk/vxml/' + formattedFileName;
                console.log('filePath:', filePath); // Debug: Log constructed filePath

                const vxmlContent = editor.getValue();
                if (!vxmlContent) {
                    showValidationPopup(false, 'Save Error', 'VXML content cannot be empty');
                    console.error('Validation failed: Empty VXML content');
                    return;
                }

                // Get vxmlId from URL parameters
                const urlParams = new URLSearchParams(window.location.search);
                const vxmlId = urlParams.get('vxmlId');

                // Create JSON data matching VXMLFile entity
                const data = {
                    fileName: formattedFileName,
                    filePath: filePath,
                    content: vxmlContent
                };

                // Log the payload for debugging
                console.log('Sending payload:', data);

                // Send PUT request to the correct endpoint with vxmlId
                fetch('http://localhost:8080/IVR-Platform/api/vxmlfiles/' + vxmlId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(data)
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => {
                            if (response.status === 409) {
                                throw new Error(err.message || 'File already exists');
                            }
                            throw new Error(err.message || 'Network response was not ok');
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.vxmlId) {
                        showValidationPopup(true, 'Save Successful', `File '${formattedFileName}' saved successfully to server!`);
                        console.log('Save successful, vxmlId:', data.vxmlId);
                    } else {
                        showValidationPopup(false, 'Save Error', 'Error saving file: ' + (data.message || 'Unknown error'));
                        console.error('Save failed: No vxmlId in response');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    let errorMessage = error.message;
                    if (errorMessage.includes('File already exists')) {
                        errorMessage = `File '${formattedFileName}' already exists. Please choose a different name.`;
                    }
                    showValidationPopup(false, 'Save Error', errorMessage);
                });
            }
            // Download VXML function
            function downloadVXML() {
                const fileName = document.getElementById('fileName').value.trim();
                if (!fileName) {
                    alert('Please enter a file name');
                    return;
                }

                const vxmlContent = editor.getValue();
                const blob = new Blob([vxmlContent], {type: 'application/xml'});
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = fileName.endsWith('.vxml') ? fileName : fileName + '.vxml';
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                document.body.removeChild(a);
            }

            // Handle file upload
            function handleFileUpload(event) {
                const file = event.target.files[0];
                if (!file)
                    return;

                // Set the file name in the input field (without .vxml extension)
                const fileName = file.name.replace('.vxml', '');
                document.getElementById('fileName').value = fileName;

                const reader = new FileReader();
                reader.onload = function (e) {
                    editor.setValue(e.target.result);
                };
                reader.readAsText(file);
            }

            // Show validation popup
            function showValidationPopup(isValid, title, message) {
                const popup = document.getElementById('validationPopup');
                const icon = document.getElementById('validationIcon');
                const titleElement = document.getElementById('validationTitle');
                const messageElement = document.getElementById('validationMessage');

                // Set icon and colors based on validation result
                if (isValid) {
                    icon.className = 'fa-solid fa-circle-check text-green-500';
                    titleElement.className = 'text-xl font-semibold text-green-700';
                } else {
                    icon.className = 'fa-solid fa-circle-xmark text-red-500';
                    titleElement.className = 'text-xl font-semibold text-red-700';
                }

                titleElement.textContent = title;
                messageElement.textContent = message;

                popup.classList.remove('hidden');
            }

            // Close validation popup
            function closeValidationPopup() {
                const popup = document.getElementById('validationPopup');
                popup.classList.add('hidden');
            }

            // Close popup when clicking outside
            document.getElementById('validationOverlay').addEventListener('click', closeValidationPopup);

            // Editor Functions
            function formatVXML() {
                try {
                    const xmlCode = editor.getValue();
                    const parser = new DOMParser();
                    const xmlDoc = parser.parseFromString(xmlCode, "application/xml");

                    // Ø§ÙØªØ­ÙÙ ÙÙ ÙØ¬ÙØ¯ Ø£Ø®Ø·Ø§Ø¡ ÙÙ Ø§ÙØªÙØ³ÙÙ
                    const parserError = xmlDoc.querySelector('parsererror');
                    if (parserError) {
                        showValidationPopup(false, 'Ø§ÙØªÙØ³ÙÙ ØºÙØ± ØµØ­ÙØ­', 'ÙÙØ¬Ø¯ Ø£Ø®Ø·Ø§Ø¡ ÙÙ ØªÙØ³ÙÙ VXML:\n' + parserError.textContent);
                        return;
                    }

                    // ØªÙØ³ÙÙ Ø§ÙÙÙØ¯
                    const serializer = new XMLSerializer();
                    const formatted = serializer.serializeToString(xmlDoc)
                            .replace(/></g, '>\n<')
                            .replace(/(<[^>]+>)/g, (match) => {
                                return match.replace(/\s+/g, ' ').trim();
                            });

                    // ØªØ­Ø¯ÙØ« Ø§ÙÙØ­Ø±Ø± Ø¨Ø§ÙØªÙØ³ÙÙ Ø§ÙØ¬Ø¯ÙØ¯
                    editor.setValue(formatted);

                    // Ø¹Ø±Ø¶ Ø±Ø³Ø§ÙØ© ÙØ¬Ø§Ø­
                    showValidationPopup(true, 'Ø§ÙØªÙØ³ÙÙ ØµØ­ÙØ­', 'ØªÙ ØªÙØ³ÙÙ ÙÙØ¯ VXML Ø¨ÙØ¬Ø§Ø­. Ø§ÙÙÙØ¯ Ø§ÙØ¢Ù ÙÙØ¸Ù ÙÙÙØ±ÙØ¡.');
                } catch (error) {
                    showValidationPopup(false, 'Ø§ÙØªÙØ³ÙÙ ØºÙØ± ØµØ­ÙØ­', 'Ø­Ø¯Ø« Ø®Ø·Ø£ Ø£Ø«ÙØ§Ø¡ ØªÙØ³ÙÙ Ø§ÙÙÙØ¯:\n' + error.message);
                }
            }

            function changeTheme() {
                const theme = document.getElementById('themeSelect').value;
                editor.setOption("theme", theme);
            }

            function toggleFullscreen() {
                const editorElement = document.querySelector('.CodeMirror');
                if (!document.fullscreenElement) {
                    editorElement.requestFullscreen();
                } else {
                    document.exitFullscreen();
                }
            }

            // Handle fullscreen change
            document.addEventListener('fullscreenchange', function () {
                const editorElement = document.querySelector('.CodeMirror');
                if (document.fullscreenElement) {
                    editorElement.style.height = 'calc(100vh - 100px)';
                } else {
                    editorElement.style.height = '600px';
                }
                editor.refresh();
            });

            // Set initial editor height
            document.querySelector('.CodeMirror').style.height = '600px';

            // Copy VXML function
            function copyVXML() {
                const vxmlContent = editor.getValue();
                if (!vxmlContent) {
                    alert('No content to copy');
                    return;
                }

                navigator.clipboard.writeText(vxmlContent).then(() => {
                    // Show success message
                    const button = document.querySelector('button[onclick="copyVXML()"]');
                    const originalText = button.innerHTML;
                    button.innerHTML = '<i class="fa-solid fa-check"></i> <span>Copied!</span>';

                    setTimeout(() => {
                        button.innerHTML = originalText;
                    }, 2000);
                }).catch(err => {
                    console.error('Failed to copy text: ', err);
                    alert('Failed to copy content');
                });
            }

            // Copy to clipboard function
            function copyToClipboard() {
                const content = editor.getValue();
                navigator.clipboard.writeText(content).then(() => {
                    // Show notification
                    const notification = document.getElementById('copyNotification');
                    notification.classList.remove('translate-y-full', 'opacity-0');

                    // Hide notification after 2 seconds
                    setTimeout(() => {
                        notification.classList.add('translate-y-full', 'opacity-0');
                    }, 2000);
                }).catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Failed to copy content. Please try again.');
                });
            }



            function openModal() {
                document.getElementById("soundModal").classList.remove("hidden");
                document.getElementById("soundModal").classList.add("flex");
            }

            function closeModal() {
                document.getElementById("soundModal").classList.add("hidden");
                document.getElementById("soundModal").classList.remove("flex");
            }

            function copySoundName(name) {
                navigator.clipboard.writeText(name).then(function () {
closeModal();
showCopiedToast(name);
                }, function (err) {
                    alert('An error occurred while copying');
                });
            }


            function showCopiedToast(name) {
                const toast = document.createElement('div');
                toast.textContent = `Copied: ` + name;
                toast.className = 'fixed top-5 left-1/2 transform -translate-x-1/2 bg-green-600 text-white px-4 py-2 rounded shadow z-50 animate-bounce';
                document.body.appendChild(toast);
                setTimeout(() => {
                    toast.remove();
                }, 2000);
            }

            // Get URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            const vxmlId = urlParams.get('vxmlId');
            const fileName = urlParams.get('fileName');

            // Set the file name in the input field (without .vxml extension)
            if (fileName) {
                const fileNameInput = document.getElementById('fileName');
                if (fileNameInput) {
                    // Remove .vxml extension if present
                    const baseFileName = fileName.replace('.vxml', '');
                    fileNameInput.value = baseFileName;
                }
            }

            // Read VXML content from file
            if (fileName) {
                fetch('http://localhost:8080/IVR-Platform/api/vxmlfiles/content/' + encodeURIComponent(fileName))
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Failed to fetch file content: ' + response.statusText);
                        }
                        return response.text();
                    })
                    .then(content => {
                        if (editor) {
                            editor.setValue(content);
                        }
                    })
                    .catch(error => {
                        console.error('Error reading VXML file:', error);
                        showValidationPopup(false, 'Error', 'Failed to read VXML file content: ' + error.message);
                    });
            }

            // Show save and edit buttons
            const addVxmlBtn = document.querySelector('.add-vxml-btn');
            const saveBtn = document.querySelector('button[onclick="toggleSaveOptions()"]');
            const validateBtn = document.querySelector('button[onclick="validateVXML()"]');

            if (addVxmlBtn) addVxmlBtn.style.display = 'block';
            if (saveBtn) saveBtn.style.display = 'block';
            if (validateBtn) validateBtn.style.display = 'block';

            // Remove default VXML example since we're in view mode
            if (editor) {
                editor.setValue('');
            }

        </script>


    </body>
</html> 