package com.example.mynotes.security.auth

import com.example.mynotes.email.MailService
import com.example.mynotes.security.config.JwtService
import com.example.mynotes.security.email.Message
import com.example.mynotes.security.user.Role
import com.example.mynotes.security.user.User
import com.example.mynotes.security.user.UserRepository
import org.springframework.http.HttpEntity
import org.springframework.http.HttpStatusCode
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class AuthenticationService(
    private val repository: UserRepository,
    private val passwordEncoder: PasswordEncoder,
    private val jwtService: JwtService,
    private val authenticationManager: AuthenticationManager,
    private val mailService: MailService
) {
    fun register(request: RegisterRequest): HttpEntity<String> {
        val validate = request.email.isBlank() || request.username.isBlank() || request.password.isBlank()
        if(validate) {
            return ResponseEntity(HttpStatusCode.valueOf(403))
        }
        val conflict = repository.findByUsernameOrEmail(request.username, request.email)
        if(conflict != null) {
            return ResponseEntity(HttpStatusCode.valueOf(409))
        } else {
            val encoded = passwordEncoder.encode(request.password)
            val activationCode = encoded.filter { it.isDigit() }.substring(3, 8)
            val user = User(
                username = request.username,
                email = request.email,
                password = passwordEncoder.encode(request.password),
                code = activationCode,
                role = Role.USER
            )
            repository.save(user)
            mailService.sendMail(
                Message(
                    user.email,
                    "Mynotes Activation Email",
                    "Your activation code: $activationCode"
                )
            )
            return AuthenticationResponse(jwtService.generateToken(user), user.id, user.username, user.email, user.role)
        }
    }

    fun activateAccount(request: AuthenticationRequest, code: String) : HttpEntity<String> {
        val user = repository.findByUsernameOrEmail(request.usernameOrEmail) ?: throw NoSuchElementException()
        if(user.code == code) {
            user.setEnabled()
            repository.save(user)
        } else {
            return ResponseEntity(HttpStatusCode.valueOf(403))
        }
        return authenticate(request)
    }

    fun authenticate(request: AuthenticationRequest): HttpEntity<String> {
        return try {
            authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(
                    request.usernameOrEmail,
                    request.password
                )
            )
            val user = repository.findByUsernameOrEmail(request.usernameOrEmail)!!
            AuthenticationResponse(jwtService.generateToken(user), user.id, user.username, user.email, user.role)
        } catch (e: DisabledException) {
            ResponseEntity(HttpStatusCode.valueOf(419))
        }
    }
}