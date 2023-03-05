package com.example.mynotes.security.auth

import lombok.AllArgsConstructor
import lombok.Builder
import lombok.NoArgsConstructor

@Builder
@AllArgsConstructor
@NoArgsConstructor
data class AuthenticationRequest(
    private val email: String,
    private val password: String
)
