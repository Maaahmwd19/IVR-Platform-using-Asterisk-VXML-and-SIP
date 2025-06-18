<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.io.FileWriter" %>

<%
    // Define the specific Java file path
    String javaFilePath = "/home/syousrei/Videos/itigraduationproject/IVR-Platform-using-Asterisk-VXML-and-SIP/IVR-VXML/src/IVRScript.java";
    File javaFile = new File(javaFilePath);
    
    // Handle file save
    if ("POST".equals(request.getMethod()) && request.getParameter("save") != null) {
        String content = request.getParameter("content");
        try {
            // Ensure the directory exists
            File directory = javaFile.getParentFile();
            if (!directory.exists()) {
                directory.mkdirs();
            }
            
            // Write content to file, overwriting if it exists
            FileWriter writer = new FileWriter(javaFile, false); // false means overwrite
            writer.write(content);
            writer.close();
            
            response.setContentType("text/plain");
            response.getWriter().write("success");
            return;
        } catch (Exception e) {
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
            return;
        }
    }
    
    // Read file content
    String fileContent = "";
    if (javaFile.exists()) {
        try {
            fileContent = new String(Files.readAllBytes(Paths.get(javaFilePath)), StandardCharsets.UTF_8);
        } catch (Exception e) {
            fileContent = "Error reading file: " + e.getMessage();
        }
    } else {
        fileContent = "// File not found at: " + javaFilePath;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>IVRScript.java Editor</title>

        <!-- Include Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Include Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="icon" type="image/png" href="../images/logo.png">

        <!-- Include CodeMirror -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/monokai.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/clike/clike.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/matchbrackets.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/closebrackets.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/anyword-hint.js"></script>
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
                        <!-- File Info -->
                        <div class="mb-4">
                            <div class="flex items-center gap-4">
                                <div class="flex-1">
                                    <h2 class="text-xl font-semibold text-gray-800">IVRScript.java</h2>
                                    <p class="text-sm text-gray-600">Path: <%= javaFilePath %></p>
                                </div>
                                <!-- VXML Files Buttons -->
                                <div class="flex gap-4">
                                    <div class="w-48">
                                        <label class="block text-sm font-medium text-gray-700 mb-1">Show All VXML Files</label>
                                        <button onclick="openModal()" class="flex w-full items-center justify-center gap-2 rounded-md border border-gray-300 bg-white px-3 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50">
                                            <i class="fa-solid fa-file-code"></i>
                                            <span>Show All VXML Files</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Editor Toolbar -->
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center gap-2">
                                <button onclick="saveFile()" class="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                    <i class="fa-solid fa-save"></i>
                                    <span>Save Changes</span>
                                </button>

                                <button id="compileRunButton" onclick="toggleCompileRun()" class="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                                    <i class="fa-solid fa-code"></i>
                                    <span>Compile</span>
                                </button>

                                <button id="asteriskButton" onclick="toggleAsterisk()" class="flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                                    <i class="fa-solid fa-phone"></i>
                                    <span>Run Asterisk</span>
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
                                <textarea id="javaEditor"><%= fileContent %></textarea>
                            </div>
                        </div>

                        <!-- Save Notification -->
                        <div id="saveNotification" class="fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg transform translate-y-full opacity-0 transition-all duration-300">
                            <div class="flex items-center gap-2">
                                <i class="fa-solid fa-check"></i>
                                <span>File saved successfully!</span>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Modal -->
        <div id="fileModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden justify-center items-center">
            <div class="bg-white rounded-xl w-full max-w-2xl p-6 shadow-2xl border border-gray-200">
                <!-- Header -->
                <div class="flex justify-between items-center mb-4 border-b pb-2">
                    <h2 class="text-xl font-semibold text-gray-800 flex items-center gap-2">
                        <i class="fa-solid fa-code text-blue-500"></i>
                        All VXML Files
                    </h2>
                    <button onclick="closeModal()" class="text-gray-500 hover:text-red-500 text-2xl font-bold">&times;</button>
                </div>

                <!-- Body -->
                <div class="max-h-96 overflow-y-auto">
                    <table class="w-full text-sm text-left text-gray-700 border">
                        <thead class="bg-gray-100 sticky top-0 border-b">
                            <tr>
                                <th class="py-2 px-3">#</th>
                                <th class="py-2 px-3">File Name</th>
                                <th class="py-2 px-3">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="vxmlFilesList">
                            <!-- Files will be loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Terminal Modal -->
        <div id="terminalModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden justify-center items-center">
            <div class="bg-gray-900 rounded-xl w-full max-w-4xl p-6 shadow-2xl border border-gray-700">
                <!-- Header -->
                <div class="flex justify-between items-center mb-4 border-b border-gray-700 pb-2">
                    <h2 class="text-xl font-semibold text-gray-200 flex items-center gap-2">
                        <i class="fa-solid fa-terminal text-green-500"></i>
                        Terminal Output
                    </h2>
                    <button onclick="closeTerminalModal()" class="text-gray-400 hover:text-red-500 text-2xl font-bold">&times;</button>
                </div>

                <!-- Terminal Body -->
                <div class="bg-black rounded-lg p-4 h-96 overflow-y-auto font-mono text-sm">
                    <div id="terminalOutput" class="text-green-400 whitespace-pre-wrap"></div>
                </div>

                <!-- Footer -->
                <div class="mt-4 flex justify-end">
                    <button onclick="closeTerminalModal()" class="px-4 py-2 bg-gray-700 text-white rounded-lg hover:bg-gray-600">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <style>
            .blink {
                animation: blink 1s step-end infinite;
            }
            
            @keyframes blink {
                50% { opacity: 0; }
            }
            
            #terminalOutput {
                font-family: 'Courier New', monospace;
                line-height: 1.5;
            }
        </style>

        <script>
            // Editor Configuration
            const editor = CodeMirror.fromTextArea(document.getElementById('javaEditor'), {
                mode: 'text/x-java',
                theme: 'monokai',
                lineNumbers: true,
                autoCloseBrackets: true,
                matchBrackets: true,
                indentUnit: 4,
                lineWrapping: true,
                extraKeys: {
                    "Ctrl-Space": "autocomplete",
                    "Ctrl-/": "toggleComment"
                },
                workTime: 200,
                workDelay: 300,
                lineWiseCopyCut: true,
                pasteLinesPerSelection: true
            });

            function openModal() {
                document.getElementById("fileModal").classList.remove("hidden");
                document.getElementById("fileModal").classList.add("flex");
                loadVXMLFiles();
            }

            function closeModal() {
                document.getElementById("fileModal").classList.add("hidden");
                document.getElementById("fileModal").classList.remove("flex");
            }

            // Load VXML files
            function loadVXMLFiles() {
                fetch('http://localhost:8080/IVR-Platform/api/vxmlfiles')
                    .then(response => response.json())
                    .then(files => {
                        const filesList = document.getElementById('vxmlFilesList');
                        filesList.innerHTML = '';
                        
                        files.forEach((file, index) => {
                            const row = document.createElement('tr');
                            row.className = 'border-b hover:bg-gray-50 transition';
                            
                            // ID cell
                            const idCell = document.createElement('td');
                            idCell.className = 'py-2 px-3';
                            idCell.textContent = index + 1;
                            
                            // File name cell
                            const nameCell = document.createElement('td');
                            nameCell.className = 'py-2 px-3';
                            nameCell.textContent = file.fileName;
                            
                            // Copy button cell
                            const copyCell = document.createElement('td');
                            copyCell.className = 'py-2 px-3';
                            
                            const copyButton = document.createElement('button');
                            copyButton.className = 'flex items-center gap-1 bg-green-100 hover:bg-green-200 text-green-800 font-medium px-3 py-1 rounded text-xs border border-green-400';
                            copyButton.innerHTML = '<i class="fa-solid fa-copy"></i> Copy';
                            copyButton.onclick = (e) => {
                                e.stopPropagation();
                                copyFileName(file.fileName);
                                closeModal();
                            };
                            
                            copyCell.appendChild(copyButton);
                            row.appendChild(idCell);
                            row.appendChild(nameCell);
                            row.appendChild(copyCell);
                            filesList.appendChild(row);
                        });
                    })
                    .catch(error => {
                        console.error('Error loading VXML files:', error);
                    });
            }

            // Update VXML file in Java code
            function updateVXMLFile(fileName) {
                const content = editor.getValue();
                // Find the line containing currentFile
                const lines = content.split('\n');
                for (let i = 0; i < lines.length; i++) {
                    if (lines[i].includes('String currentFile = basePath +')) {
                        lines[i] = `            String currentFile = basePath + "${fileName}";`;
                        break;
                    }
                }
                const updatedContent = lines.join('\n');
                editor.setValue(updatedContent);
                showSaveNotification('VXML file updated to: ' + fileName);
            }

            function saveFile() {
                const javaContent = editor.getValue();
                
                fetch('http://localhost:8080/IVR-Platform/api/javafiles/update', {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        content: javaContent
                    })
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => {
                            throw new Error(err.message || 'Failed to update file');
                        });
                    }
                    return response.json();
                })
                .then(result => {
                    if (result.message) {
                        showSaveNotification(result.message);
                    } else {
                        throw new Error('Unknown response format');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating file: ' + error.message);
                });
            }

            function toggleCompileRun() {
                const button = document.getElementById('compileRunButton');
                const isCompiled = button.querySelector('span').textContent === 'Run';
                
                if (isCompiled) {
                    // Run the file
                    const javaContent = editor.getValue();
                    showTerminalModal();
                    updateTerminalOutput("Starting server...\n");
                    
                    fetch('http://localhost:8080/IVR-Platform/api/javafiles/run', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            content: javaContent
                        })
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(err => {
                                throw new Error(err.message || 'Execution failed');
                            });
                        }
                        return response.json();
                    })
                    .then(result => {
                        if (result.message) {
                            updateTerminalOutput(result.message);
                        } else {
                            throw new Error('Unknown response format');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        updateTerminalOutput("Error: " + error.message);
                    });
                } else {
                    // Compile the file
                    const javaContent = editor.getValue();
                    
                    fetch('http://localhost:8080/IVR-Platform/api/javafiles/compile', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            content: javaContent
                        })
                    })
                    .then(response => {
                        if (!response.ok) {
                            return response.json().then(err => {
                                throw new Error(err.message || 'Compilation failed');
                            });
                        }
                        return response.json();
                    })
                    .then(result => {
                        if (result.message) {
                            showSaveNotification(result.message);
                            // Change button to Run if compilation was successful
                            button.querySelector('span').textContent = 'Run';
                            button.classList.remove('bg-green-600', 'hover:bg-green-700');
                            button.classList.add('bg-purple-600', 'hover:bg-purple-700');
                        } else {
                            throw new Error('Unknown response format');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Compilation error: ' + error.message);
                    });
                }
            }

            // Check compilation status on page load
            function checkCompilationStatus() {
                const button = document.getElementById('compileRunButton');
                // Reset to Compile state on page load
                button.querySelector('span').textContent = 'Compile';
                button.classList.remove('bg-purple-600', 'hover:bg-purple-700');
                button.classList.add('bg-green-600', 'hover:bg-green-700');
            }

            // Call checkCompilationStatus when page loads
            window.addEventListener('load', checkCompilationStatus);

            function showTerminalModal() {
                document.getElementById("terminalModal").classList.remove("hidden");
                document.getElementById("terminalModal").classList.add("flex");
            }

            function closeTerminalModal() {
                // Stop the server first
                fetch('http://localhost:8080/IVR-Platform/api/javafiles/stop', {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(result => {
                    if (result.message) {
                        updateTerminalOutput(result.message + "\n");
                    }
                })
                .catch(error => {
                    console.error('Error stopping server:', error);
                })
                .finally(() => {
                    // Close the modal regardless of the stop result
                    document.getElementById("terminalModal").classList.add("hidden");
                    document.getElementById("terminalModal").classList.remove("flex");
                });
            }

            function updateTerminalOutput(output) {
                const terminalOutput = document.getElementById('terminalOutput');
                terminalOutput.textContent = output;
                terminalOutput.scrollTop = terminalOutput.scrollHeight;
                
                // Add a blinking cursor effect
                const cursor = document.createElement('span');
                cursor.className = 'blink';
                cursor.textContent = '█';
                terminalOutput.appendChild(cursor);
            }

            function runFile() {
                const javaContent = editor.getValue();
                showTerminalModal();
                updateTerminalOutput("Starting server...\n");
                
                fetch('http://localhost:8080/IVR-Platform/api/javafiles/run', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        content: javaContent
                    })
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => {
                            throw new Error(err.message || 'Execution failed');
                        });
                    }
                    return response.json();
                })
                .then(result => {
                    if (result.message) {
                        updateTerminalOutput(result.message);
                    } else {
                        throw new Error('Unknown response format');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    updateTerminalOutput("Error: " + error.message);
                });
            }

            function toggleAsterisk() {
                const button = document.getElementById('asteriskButton');
                const isRunning = button.querySelector('span').textContent === 'Stop Asterisk';
                
                if (isRunning) {
                    // Stop Asterisk
                    fetch('http://localhost:8080/IVR-Platform/api/javafiles/stop-asterisk', {
                        method: 'POST'
                    })
                    .then(response => response.json())
                    .then(result => {
                        if (result.message) {
                            button.querySelector('span').textContent = 'Run Asterisk';
                            button.classList.remove('bg-green-600', 'hover:bg-green-700');
                            button.classList.add('bg-red-600', 'hover:bg-red-700');
                            showSaveNotification(result.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error: ' + error.message);
                    });
                } else {
                    // Start Asterisk
                    fetch('http://localhost:8080/IVR-Platform/api/javafiles/run-asterisk', {
                        method: 'POST'
                    })
                    .then(response => response.json())
                    .then(result => {
                        if (result.message) {
                            button.querySelector('span').textContent = 'Stop Asterisk';
                            button.classList.remove('bg-red-600', 'hover:bg-red-700');
                            button.classList.add('bg-green-600', 'hover:bg-green-700');
                            showSaveNotification(result.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error: ' + error.message);
                    });
                }
            }

            // Check Asterisk status on page load
            function checkAsteriskStatus() {
                fetch('http://localhost:8080/IVR-Platform/api/javafiles/asterisk-status')
                    .then(response => response.json())
                    .then(result => {
                        const button = document.getElementById('asteriskButton');
                        if (result.message === 'running') {
                            button.querySelector('span').textContent = 'Stop Asterisk';
                            button.classList.remove('bg-red-600', 'hover:bg-red-700');
                            button.classList.add('bg-green-600', 'hover:bg-green-700');
                        }
                    })
                    .catch(error => console.error('Error checking Asterisk status:', error));
            }

            // Call checkAsteriskStatus when page loads
            window.addEventListener('load', checkAsteriskStatus);

            function showSaveNotification(message) {
                const notification = document.getElementById('saveNotification');
                notification.querySelector('span').textContent = message;
                notification.classList.remove('translate-y-full', 'opacity-0');
                setTimeout(() => {
                    notification.classList.add('translate-y-full', 'opacity-0');
                }, 2000);
            }

            function copyToClipboard() {
                const content = editor.getValue();
                navigator.clipboard.writeText(content).then(() => {
                    showSaveNotification('Copied to clipboard!');
                }).catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Failed to copy content. Please try again.');
                });
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

            // Copy file name to clipboard and update Java code
            function copyFileName(fileName) {
                // Update the Java code
                const content = editor.getValue();
                const lines = content.split('\n');
                for (let i = 0; i < lines.length; i++) {
                    if (lines[i].includes('String currentFile = basePath +')) {
                        lines[i] = `            String currentFile = basePath + "${fileName}";`;
                        break;
                    }
                }
                const updatedContent = lines.join('\n');
                editor.setValue(updatedContent);

                // Copy to clipboard
                navigator.clipboard.writeText(fileName).then(() => {
                    showSaveNotification('File updated to: ' + fileName);
                }).catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Failed to copy file name. Please try again.');
                });
            }

            // Set initial editor height
            document.querySelector('.CodeMirror').style.height = '600px';

            tailwind.config = {
                theme: {
                    extend: {}
                }
            }

            // إضافة معالجة الأخطاء
            editor.on('beforeSelectionChange', function(cm, change) {
                try {
                    if (change.ranges) {
                        change.ranges = change.ranges.map(range => {
                            if (range.anchor && range.head) {
                                const doc = cm.getDoc();
                                const maxLine = doc.lastLine();
                                const maxCh = doc.getLine(maxLine).length;
                                
                                // التأكد من أن المؤشرات ضمن النطاق الصحيح
                                range.anchor.line = Math.max(0, Math.min(range.anchor.line, maxLine));
                                range.anchor.ch = Math.max(0, Math.min(range.anchor.ch, maxCh));
                                range.head.line = Math.max(0, Math.min(range.head.line, maxLine));
                                range.head.ch = Math.max(0, Math.min(range.head.ch, maxCh));
                            }
                            return range;
                        });
                    }
                } catch (e) {
                    console.error('Error in selection change:', e);
                }
            });
        </script>
    </body>
</html> 
