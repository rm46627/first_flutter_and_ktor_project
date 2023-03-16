package com.example.mynotes.security.auth

import org.springframework.http.HttpEntity
import org.springframework.web.bind.annotation.*
import java.util.logging.Logger

@RestController
@RequestMapping("/api/auth")
class AuthenticationController(
    private val service: AuthenticationService
){
    @PostMapping("/register")
    fun register(@RequestBody request: RegisterRequest): HttpEntity<String> {
        return service.register(request)
    }

    @PostMapping("/activate/{code}")
    fun activate(@RequestBody request: AuthenticationRequest, @PathVariable code: String): HttpEntity<String> {
        return service.activateAccount(request, code)
    }

    @PostMapping("/authenticate")
    fun authenticate(@RequestBody request: AuthenticationRequest): HttpEntity<String> {
        return service.authenticate(request)
    }
}