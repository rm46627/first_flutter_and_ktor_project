package com.example.mynotes.security.auth

import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor

@Builder
@AllArgsConstructor
@NoArgsConstructor
data class AuthenticationResponse(
    private val token: String
)