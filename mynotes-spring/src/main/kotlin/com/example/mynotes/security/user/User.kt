package com.example.mynotes.security.user

import jakarta.persistence.*
import lombok.AllArgsConstructor
import lombok.Builder
import lombok.Data
import lombok.NoArgsConstructor
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

//@Data
//@Builder
//@NoArgsConstructor
//@AllArgsConstructor
@Entity
data class User(
    // inherits from UserDetails
    private val username: String,
    private val password: String,
    private val isEnabled: Boolean,
    private val isCredentialsNonExpired: Boolean,
    private val isAccountNonExpired: Boolean,
    private val isAccountNonLocked: Boolean,
    @ElementCollection
    private val authorities: Set<GrantedAuthority>,

    // Custom attributes
    @Id @GeneratedValue var id: Long,
    var email: String,
    @Enumerated(EnumType.STRING) var role: Role
): UserDetails {

    override fun getAuthorities(): Set<GrantedAuthority> = authorities
    override fun getPassword(): String = password
    override fun getUsername(): String = email
    override fun isAccountNonExpired(): Boolean = isAccountNonExpired
    override fun isAccountNonLocked(): Boolean = isAccountNonLocked
    override fun isCredentialsNonExpired(): Boolean = isCredentialsNonExpired
    override fun isEnabled(): Boolean = isEnabled
}