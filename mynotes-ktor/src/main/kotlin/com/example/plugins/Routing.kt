package com.example.plugins

import io.ktor.server.routing.*
import io.ktor.server.response.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.util.reflect.*

fun Application.configureRouting() {

    routing {
        get("/") {
            call.respondText("Hello World!")
        }

        route("/note") {

            get {
                val id = call.request.queryParameters["id"]
                call.respond("$id")
            }

            get("/{id}") {
                val id = call.parameters["id"]
                call.respond("$id")
            }
        }

        route("/notes"){

            route("/create") {

                post {
                    val body = call.receive<String>()
                    call.respond(body)
                }
            }

            delete {
                val body = call.receive<String>()
                call.respond(body)
            }
        }

        route("/auth") {
            get("/token") {
                val email = call.request.queryParameters["email"]
                val password = call.request.queryParameters["password"]
                val username = call.request.queryParameters["username"]

                if(email == null || password == null || username == null) {
                    call.respond("passed wrong details")
                    return@get
                }

//                createUser(email, password, username)
            }
        }

    }
}
