package com.example.mynotes.security.user

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import java.util.*

interface UserRepository: JpaRepository<User, Long> {
    fun findByEmail(email: String): User?
    fun findByUsername(username: String): User?
    fun findByUsernameOrEmail(username: String, email: String): User?
    @Query("select t from User t where t.email = ?1 OR t.username = ?1")
    fun findByUsernameOrEmail(usernameOrEmail: String): User?

}