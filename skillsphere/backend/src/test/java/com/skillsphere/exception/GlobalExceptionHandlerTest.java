package com.skillsphere.exception;

import com.skillsphere.dto.ApiError;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class GlobalExceptionHandlerTest {

    private GlobalExceptionHandler handler;
    private HttpServletRequest request;

    @BeforeEach
    void setUp() {
        handler = new GlobalExceptionHandler();
        request = mock(HttpServletRequest.class);
        when(request.getRequestURI()).thenReturn("/api/assessments/not-a-number");
    }

    @Test
    @DisplayName("SS-BE-002: handleTypeMismatch returns HTTP 400 Bad Request with standardized ApiError")
    void testHandleTypeMismatch_StandardLongMismatch() {
        MethodArgumentTypeMismatchException ex = new MethodArgumentTypeMismatchException(
                "not-a-number", Long.class, "id", mock(MethodParameter.class), new NumberFormatException()
        );

        ResponseEntity<ApiError> response = handler.handleTypeMismatch(ex, request);

        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());

        ApiError body = response.getBody();
        assertEquals(400, body.status());
        assertEquals("Bad Request", body.error());
        assertEquals("Parameter 'id' must be of type Long.", body.message());
        assertNotNull(body.fieldErrors());
        assertEquals("Invalid value format", body.fieldErrors().get("id"));
        assertEquals("/api/assessments/not-a-number", body.path());
        assertNotNull(body.timestamp());
    }

    @Test
    @DisplayName("SS-BE-002: handleTypeMismatch handles null parameter name safely")
    void testHandleTypeMismatch_NullParamName() {
        MethodArgumentTypeMismatchException ex = new MethodArgumentTypeMismatchException(
                "invalid", Integer.class, null, mock(MethodParameter.class), new NumberFormatException()
        );

        ResponseEntity<ApiError> response = handler.handleTypeMismatch(ex, request);

        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals(400, response.getBody().status());
        assertTrue(response.getBody().message().contains("Parameter 'null' must be of type Integer"));
    }

    @Test
    @DisplayName("handleUnreadable returns HTTP 400 Bad Request")
    void testHandleUnreadable() {
        ResponseEntity<ApiError> response = handler.handleUnreadable(null, request);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertEquals(400, response.getBody().status());
    }

    @Test
    @DisplayName("handleDenied returns HTTP 403 Forbidden")
    void testHandleDenied() {
        ResponseEntity<ApiError> response = handler.handleDenied(null, request);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        assertEquals(403, response.getBody().status());
    }

    @Test
    @DisplayName("handleIntegrity returns HTTP 409 Conflict")
    void testHandleIntegrity() {
        ResponseEntity<ApiError> response = handler.handleIntegrity(null, request);
        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
        assertEquals(409, response.getBody().status());
    }

    @Test
    @DisplayName("handleOther returns HTTP 500 for generic unhandled exceptions")
    void testHandleOther() {
        ResponseEntity<ApiError> response = handler.handleOther(new RuntimeException("Crash"), request);
        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertEquals(500, response.getBody().status());
    }
}
