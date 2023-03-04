package com.example.mynotes.config

import com.example.mynotes.security.user.JwtService
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import lombok.RequiredArgsConstructor
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter

@Component
@RequiredArgsConstructor
class JwtAuthenticationFilter : OncePerRequestFilter() {

    val jwtService: JwtService = TODO()

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val authHeader: String? = request.getHeader("Authorization")
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response)
            return
        }

        val jwt = authHeader.substring(7)
        val userEmail: String = jwtService.extractUsername(jwt)
    }
}