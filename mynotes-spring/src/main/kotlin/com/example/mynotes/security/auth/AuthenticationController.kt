package com.example.mynotes.security.auth

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/auth")
class AuthenticationController @Autowired constructor(
    private val service: AuthenticationService
){

    @PostMapping("/register")
    fun register(@RequestBody request: RegisterRequest): AuthenticationResponse {
        val jwttoken = service.register(request)
        println("moj token: $jwttoken")
        return AuthenticationResponse(token = jwttoken)
    }

    @GetMapping("/hello")
    fun sayHello(): ResponseEntity<String> {
        return ResponseEntity.ok("Hello from get endpoint")
    }

    @PostMapping("/authenticate")
    fun register(@RequestBody request: AuthenticationRequest): ResponseEntity<AuthenticationResponse> {
        val authResponse = service.authenticate(request)
        return ResponseEntity.ok(authResponse)
    }

}