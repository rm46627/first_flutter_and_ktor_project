package com.example.mynotes.security.auth

data class ActivationRequest(
    val email: String,
    val code: String
)
