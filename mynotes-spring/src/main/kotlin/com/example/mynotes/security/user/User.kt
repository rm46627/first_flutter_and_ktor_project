package com.example.mynotes.security.user

import jakarta.persistence.*
import org.springframework.security.config.core.GrantedAuthorityDefaults
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.AuthorityUtils
import org.springframework.security.core.userdetails.UserDetails

    @Entity
    data class User(
        // inherits from UserDetails
        private val username: String,
        private val password: String,
        private var isEnabled: Boolean = false,
        private val isCredentialsNonExpired: Boolean = true,
        private val isAccountNonExpired: Boolean = true,
        private val isAccountNonLocked: Boolean = true,

        // Custom attributes
        @Id @GeneratedValue var id: Long = 0,
        var email: String,
        var code: String,
        @Enumerated(EnumType.STRING) var role: Role
    ): UserDetails {

        override fun getAuthorities(): Collection<GrantedAuthority> = AuthorityUtils.createAuthorityList("USER")
        override fun getPassword(): String = password
        override fun getUsername(): String = email
        override fun isAccountNonExpired(): Boolean = isAccountNonExpired
        override fun isAccountNonLocked(): Boolean = isAccountNonLocked
        override fun isCredentialsNonExpired(): Boolean = isCredentialsNonExpired
        override fun isEnabled(): Boolean = isEnabled

        fun setEnabled() {
            isEnabled = true
        }

    }