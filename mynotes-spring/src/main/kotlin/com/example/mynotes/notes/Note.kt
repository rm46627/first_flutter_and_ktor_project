package com.example.mynotes.notes

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.Id

@Entity
data class Note(
    @Id @GeneratedValue var id: Long = 0,
    private val userId: Int,
    private val content: String,
    private val isSynced: Boolean
)
