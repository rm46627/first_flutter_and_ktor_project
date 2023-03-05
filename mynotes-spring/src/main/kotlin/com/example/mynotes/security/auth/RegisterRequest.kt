package com.example.mynotes.security.auth

import lombok.AllArgsConstructor
import lombok.Builder
import lombok.NoArgsConstructor

@Builder
@AllArgsConstructor
@NoArgsConstructor
data class RegisterRequest (
    private val firstName: String,
    private val lastname: String,
    private val email: String,
    private val password: String
)
