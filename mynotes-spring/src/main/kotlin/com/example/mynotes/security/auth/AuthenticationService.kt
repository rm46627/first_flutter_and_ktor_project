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
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.LockedException
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
        val conflict =
            repository.findByEmail(request.email).isPresent || repository.findByUsername(request.username).isPresent
        if (conflict) {
            return ResponseEntity(HttpStatusCode.valueOf(409))
        }

        val encoded = passwordEncoder.encode(request.password)
        val activationCode = encoded.subSequence(0,5) as String
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
        return AuthenticationResponse(jwtService.generateToken(user))
    }

    fun activateAccount(request: ActivationRequest) : HttpEntity<String> {
        val user = repository.findByEmail(request.email).orElseThrow()
        if(user.code == request.code) {
            user.setEnabled()
        } else {
            return ResponseEntity(HttpStatusCode.valueOf(401))
        }
        return AuthenticationResponse(jwtService.generateToken(user))
    }

    fun authenticate(request: AuthenticationRequest): HttpEntity<String> {
        try {
            authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(
                    request.email,
                    request.password
                )
            )
        } catch (e: BadCredentialsException) {
            return ResponseEntity(HttpStatusCode.valueOf(401))
        } catch (e: DisabledException) {
            return ResponseEntity(HttpStatusCode.valueOf(422))
        }
        val user = repository.findByEmail(request.email).orElseThrow()
        // doing manual isEnabled check because authManager doesnt
        if(!user.isEnabled) {
            return ResponseEntity(HttpStatusCode.valueOf(422))
        }
        return AuthenticationResponse(jwtService.generateToken(user))
    }
}