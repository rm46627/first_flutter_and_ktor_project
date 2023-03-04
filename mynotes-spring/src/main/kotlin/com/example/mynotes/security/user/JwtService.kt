package com.example.mynotes.security.user

import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.io.Decoders
import io.jsonwebtoken.security.Keys
import org.springframework.stereotype.Service
import java.security.Key
import java.util.function.Function

@Service
class JwtService {

    val SECRET_KEY: String = "2A462D4A404E635266556A586E3272357538782F413F4428472B4B6250645367"

    fun extractUsername(): String {
        return ""
    }

    fun <T> extractClaim(token: String, claimsResolver: (Claims) -> T) : T {
        val claims = extractAllClaims(token)
        return claimsResolver(claims)
    }

    fun extractAllClaims(token: String): Claims {
        return Jwts
            .parserBuilder()
            .setSigningKey(getSignInKey())
            .build()
            .parseClaimsJws(token)
            .body
    }

    private fun getSignInKey(): Key {
        return Keys.hmacShaKeyFor(
            Decoders.BASE64.decode(SECRET_KEY)
        )
    }


}
