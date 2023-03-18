package com.example.mynotes.security.auth
data class AuthenticationRequest(
    val usernameOrEmail: String,
    val password: String
)
