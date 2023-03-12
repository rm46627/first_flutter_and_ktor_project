package com.example.mynotes.security.email

data class Message(
    val to: String,
    val subject: String,
    val text: String,
)
