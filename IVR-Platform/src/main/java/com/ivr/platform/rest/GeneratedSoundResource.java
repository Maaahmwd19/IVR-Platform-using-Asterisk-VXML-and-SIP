package com.ivr.platform.rest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ivr.platform.entity.GeneratedSound;
import com.ivr.platform.service.GeneratedSoundService;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("/generated-sounds")
@Produces(MediaType.APPLICATION_JSON)
public class GeneratedSoundResource {
    private final GeneratedSoundService generatedSoundService = new GeneratedSoundService();
    private final ObjectMapper objectMapper;

    public GeneratedSoundResource() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }

    @GET
    public Response getAllGeneratedSounds() {
        try {
            List<GeneratedSound> sounds = generatedSoundService.getAllGeneratedSounds();
            return Response.ok(objectMapper.writeValueAsString(sounds))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to retrieve generated sounds: " + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/generate")
    @Consumes(MediaType.TEXT_PLAIN)
    public Response generateSound(String text) throws JsonProcessingException {
        try {
            GeneratedSound sound = generatedSoundService.generateSound(text);
            return Response.status(Response.Status.CREATED)
                    .entity(objectMapper.writeValueAsString(sound))
                    .type(MediaType.APPLICATION_JSON)
                    .build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        } catch (RuntimeException e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
} 