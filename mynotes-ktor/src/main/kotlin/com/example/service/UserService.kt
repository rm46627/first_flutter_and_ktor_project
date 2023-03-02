package com.example.service

import com.example.auth.hash
import com.example.data.model.User

class UserService {
    val hashFunction = { s: String  -> hash(s) }

//    fun createUser(email: String, password: String, username: String): User {
//
//    }
}

