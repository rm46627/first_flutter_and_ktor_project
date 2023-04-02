package com.example.mynotes.security.auth

import com.example.mynotes.security.user.Role
import org.springframework.http.HttpEntity
data class AuthenticationResponse(
    val token: String,
    val userId: Long,
    val username: String,
    val email: String,
    val role: Role
) : HttpEntity<Map<String, Any>>(mapOf("token" to token, "userId" to userId, "username" to username, "email" to email, "role" to role))