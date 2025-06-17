package com.ivr.platform.rest;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.*;
import java.util.logging.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.util.ArrayList;
import java.util.List;

@Path("/javafiles")
@Produces(MediaType.APPLICATION_JSON)
public class JavaFileResource {

    private static final Logger LOGGER = Logger.getLogger(JavaFileResource.class.getName());
    private static final String JAVA_DIR = "/home/mibrahim/ITI_Projects/IVR GP/V2/IVR-Platform-using-Asterisk-VXML-and-SIP/IVR-VXML/src"; // it must br change with your 
    private static final String LIB_DIR = JAVA_DIR + "/../lib";
    private static final String OUT_DIR = JAVA_DIR + "/../out";
    private static final String SRC_DIR = JAVA_DIR;
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private static Process serverProcess = null;
    private static Process asteriskProcess = null;

    @POST
    @Path("/save")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response saveJavaFile(String content) {
        try {
            // Parse the JSON string to get the actual content
            String actualContent = objectMapper.readValue(content, String.class);
            return saveOrUpdateFile(actualContent, false);
        } catch (Exception e) {
            LOGGER.severe("Failed to parse content: " + e.getMessage());
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Invalid content format"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }
    }

    @PUT
    @Path("/update")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response updateJavaFile(String jsonContent) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(jsonContent);
            String content = jsonNode.get("content").asText();
            
            if (content == null || content.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Content cannot be empty"))
                    .build();
            }

            File file = new File(JAVA_DIR, "IVRScript.java");
            if (!file.exists()) {
                // Create the file if it doesn't exist
                try {
                    file.getParentFile().mkdirs();
                    file.createNewFile();
                } catch (IOException e) {
                    LOGGER.severe("Failed to create file: " + e.getMessage());
                    return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(new ErrorResponse("Failed to create file: " + e.getMessage()))
                        .build();
                }
            }

            try (FileWriter writer = new FileWriter(file, false)) {
                writer.write(content);
                LOGGER.info("Successfully updated Java file");
                return Response.ok(new SuccessResponse("File updated successfully")).build();
            }
        } catch (Exception e) {
            LOGGER.severe("Failed to update Java file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to update file: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/compile")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response compileJavaFile(String jsonContent) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(jsonContent);
            String content = jsonNode.get("content").asText();
            
            if (content == null || content.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Content cannot be empty"))
                    .build();
            }

            // Save the file first
            File file = new File(SRC_DIR, "IVRScript.java");
            try (FileWriter writer = new FileWriter(file, false)) {
                writer.write(content);
            }

            // Create out directory if it doesn't exist
            File outDir = new File(OUT_DIR);
            if (!outDir.exists()) {
                outDir.mkdirs();
            }

            // Get all Java files in the src directory
            File srcDir = new File(SRC_DIR);
            File[] javaFiles = srcDir.listFiles((dir, name) -> name.endsWith(".java"));
            
            if (javaFiles == null || javaFiles.length == 0) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("No Java files found in src directory"))
                    .build();
            }

            // Build the javac command with all Java files
            List<String> command = new ArrayList<>();
            command.add("javac");
            command.add("-cp");
            command.add(LIB_DIR + "/*");
            command.add("-d");
            command.add(OUT_DIR);
            
            // Add all Java files to the command
            for (File javaFile : javaFiles) {
                command.add(javaFile.getAbsolutePath());
            }

            // Compile the files
            ProcessBuilder processBuilder = new ProcessBuilder(command);
            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();

            // Read the compilation output
            StringBuilder output = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line).append("\n");
                }
            }

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                return Response.ok(new SuccessResponse("Compilation successful")).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Compilation failed: " + output.toString()))
                    .build();
            }
        } catch (Exception e) {
            LOGGER.severe("Failed to compile Java file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to compile: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/stop")
    public Response stopServer() {
        try {
            if (serverProcess != null && serverProcess.isAlive()) {
                serverProcess.destroy();
                serverProcess = null;
                return Response.ok(new SuccessResponse("Server stopped successfully")).build();
            } else {
                return Response.ok(new SuccessResponse("Server is not running")).build();
            }
        } catch (Exception e) {
            LOGGER.severe("Failed to stop server: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to stop server: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/run")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response runJavaFile(String jsonContent) {
        try {
            // Stop existing server if running
            if (serverProcess != null && serverProcess.isAlive()) {
                serverProcess.destroy();
                serverProcess = null;
            }

            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(jsonContent);
            String content = jsonNode.get("content").asText();
            
            if (content == null || content.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Content cannot be empty"))
                    .build();
            }

            // Save the file first
            File file = new File(SRC_DIR, "IVRScript.java");
            try (FileWriter writer = new FileWriter(file, false)) {
                writer.write(content);
            }

            // Create out directory if it doesn't exist
            File outDir = new File(OUT_DIR);
            if (!outDir.exists()) {
                outDir.mkdirs();
            }

            // Get all Java files in the src directory
            File srcDir = new File(SRC_DIR);
            File[] javaFiles = srcDir.listFiles((dir, name) -> name.endsWith(".java"));
            
            if (javaFiles == null || javaFiles.length == 0) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("No Java files found in src directory"))
                    .build();
            }

            // Build the javac command with all Java files
            List<String> compileCommand = new ArrayList<>();
            compileCommand.add("javac");
            compileCommand.add("-cp");
            compileCommand.add(LIB_DIR + "/*");
            compileCommand.add("-d");
            compileCommand.add(OUT_DIR);
            
            // Add all Java files to the command
            for (File javaFile : javaFiles) {
                compileCommand.add(javaFile.getAbsolutePath());
            }

            // Compile first
            ProcessBuilder compileBuilder = new ProcessBuilder(compileCommand);
            compileBuilder.redirectErrorStream(true);
            Process compileProcess = compileBuilder.start();
            int compileExitCode = compileProcess.waitFor();

            if (compileExitCode != 0) {
                StringBuilder compileOutput = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(compileProcess.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        compileOutput.append(line).append("\n");
                    }
                }
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Compilation failed: " + compileOutput.toString()))
                    .build();
            }

            // Run the compiled class
            ProcessBuilder runBuilder = new ProcessBuilder(
                "java",
                "-cp", OUT_DIR + ":" + LIB_DIR + "/*",
                "IVRServer"
            );
            runBuilder.redirectErrorStream(true);
            serverProcess = runBuilder.start();

            // Read the initial output
            StringBuilder output = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(serverProcess.getInputStream()))) {
                // Wait for initial output with timeout
                long startTime = System.currentTimeMillis();
                long timeout = 5000; // 5 seconds timeout
                
                while (System.currentTimeMillis() - startTime < timeout) {
                    if (reader.ready()) {
                        String line = reader.readLine();
                        if (line != null) {
                            output.append(line).append("\n");
                        }
                    } else {
                        Thread.sleep(100); // Small delay to prevent CPU spinning
                    }
                }
                
                // If we got some output, return it
                if (output.length() > 0) {
                    return Response.ok(new SuccessResponse("Server started successfully:\n" + output.toString() + 
                        "\nServer is running in the background on port 4573")).build();
                }
                
                // If no output after timeout, check if process is still running
                if (serverProcess.isAlive()) {
                    return Response.ok(new SuccessResponse("Server started successfully (no output after 5 seconds)\n" +
                        "Server is running in the background on port 4573")).build();
                }
            }

            // If we get here, something went wrong
            return Response.status(Response.Status.BAD_REQUEST)
                .entity(new ErrorResponse("Failed to start server"))
                .build();
        } catch (Exception e) {
            LOGGER.severe("Failed to run Java file: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to run: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/stop-asterisk")
    public Response stopAsterisk() {
        try {
            if (asteriskProcess != null && asteriskProcess.isAlive()) {
                // Send SIGTERM to asterisk process
                ProcessBuilder killBuilder = new ProcessBuilder("sudo", "-S", "asterisk", "-rx", "core stop now");
                Process killProcess = killBuilder.start();
                
                // Send sudo password
                try (OutputStreamWriter writer = new OutputStreamWriter(killProcess.getOutputStream())) {
                    writer.write("19012001\n");
                    writer.flush();
                }
                
                killProcess.waitFor();
                asteriskProcess = null;
                return Response.ok(new SuccessResponse("Asterisk stopped successfully")).build();
            } else {
                return Response.ok(new SuccessResponse("Asterisk is not running")).build();
            }
        } catch (Exception e) {
            LOGGER.severe("Failed to stop Asterisk: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to stop Asterisk: " + e.getMessage()))
                .build();
        }
    }

    @POST
    @Path("/run-asterisk")
    public Response runAsterisk() {
        try {
            // Check if Asterisk is already running
            if (asteriskProcess != null && asteriskProcess.isAlive()) {
                return Response.ok(new SuccessResponse("Asterisk is already running")).build();
            }

            // Run asterisk with sudo
            ProcessBuilder processBuilder = new ProcessBuilder(
                "sudo", "-S", "asterisk", "-rvvvv"
            );
            processBuilder.redirectErrorStream(true);
            asteriskProcess = processBuilder.start();

            // Send the password to sudo
            try (OutputStreamWriter writer = new OutputStreamWriter(asteriskProcess.getOutputStream())) {
                writer.write("19012001\n");
                writer.flush();
            }

            // Wait a bit to check if process started successfully
            Thread.sleep(2000);
            
            if (asteriskProcess.isAlive()) {
                return Response.ok(new SuccessResponse("Asterisk started successfully")).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Failed to start Asterisk"))
                    .build();
            }
        } catch (Exception e) {
            LOGGER.severe("Failed to run Asterisk: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to run Asterisk: " + e.getMessage()))
                .build();
        }
    }

    @GET
    @Path("/asterisk-status")
    public Response getAsteriskStatus() {
        try {
            boolean isRunning = asteriskProcess != null && asteriskProcess.isAlive();
            return Response.ok(new SuccessResponse(isRunning ? "running" : "stopped")).build();
        } catch (Exception e) {
            LOGGER.severe("Failed to get Asterisk status: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(new ErrorResponse("Failed to get Asterisk status: " + e.getMessage()))
                .build();
        }
    }

    private Response saveOrUpdateFile(String content, boolean isUpdate) {
        if (content == null || content.trim().isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("Content cannot be empty"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        String filePath = JAVA_DIR + File.separator + "IVRScript.java";
        File targetFile = new File(filePath);

        // For update, check if file exists
        if (isUpdate && !targetFile.exists()) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("File does not exist"))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }

        try {
            // Ensure the directory exists
            File parentDir = targetFile.getParentFile();
            if (!parentDir.exists() && !parentDir.mkdirs()) {
                LOGGER.severe("Failed to create directory: " + parentDir.getAbsolutePath());
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(new ErrorResponse("Failed to create directory: " + parentDir.getAbsolutePath()))
                        .type(MediaType.APPLICATION_JSON)
                        .build();
            }

            // Write file
            try (FileWriter writer = new FileWriter(targetFile)) {
                writer.write(content);
                writer.flush();
            }
            LOGGER.info("File " + (isUpdate ? "updated" : "saved") + " successfully: " + targetFile.getAbsolutePath());
            return Response.ok(new SuccessResponse("File " + (isUpdate ? "updated" : "saved") + " successfully")).build();
        } catch (IOException e) {
            LOGGER.severe("Failed to " + (isUpdate ? "update" : "save") + " file: " + targetFile.getAbsolutePath() + ", Error: " + e.getMessage());
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(new ErrorResponse("Failed to " + (isUpdate ? "update" : "save") + " file: " + e.getMessage()))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        }
    }

    private static class ErrorResponse {
        private String message;

        public ErrorResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }

    private static class SuccessResponse {
        private String message;

        public SuccessResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }
} 