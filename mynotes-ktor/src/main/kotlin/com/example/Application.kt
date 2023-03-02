package com.example

import com.example.auth.JwtService
import com.example.auth.hash
import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import com.example.plugins.*
import com.example.data.DatabaseFactory
import com.example.repository.Repository

fun main(args: Array<String>) = io.ktor.server.netty.EngineMain.main(args)

@Suppress("unused") // referenced in application.conf
fun Application.module() {

    DatabaseFactory.init()
    val repository = Repository()
    val jwtService = JwtService()
    val hashFunction = { s: String  -> hash(s)}

    configureSecurity()
    configureSerialization()
    configureRouting()
}
