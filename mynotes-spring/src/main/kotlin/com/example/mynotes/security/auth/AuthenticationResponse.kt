package com.example.mynotes.security.auth

import org.springframework.http.HttpEntity

data class AuthenticationResponse(
    val token: String
) : HttpEntity<String>()