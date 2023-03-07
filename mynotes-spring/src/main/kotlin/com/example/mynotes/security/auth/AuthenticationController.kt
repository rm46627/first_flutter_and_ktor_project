package com.example.mynotes.security.auth

import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/auth")
class AuthenticationController(
    private val service: AuthenticationService
){
    @PostMapping("/register")
    fun register(@RequestBody request: RegisterRequest): AuthenticationResponse {
        return AuthenticationResponse(service.register(request))
    }

    @PostMapping("/authenticate")
    fun register(@RequestBody request: AuthenticationRequest): AuthenticationResponse {
        return AuthenticationResponse(service.authenticate(request))
    }
}