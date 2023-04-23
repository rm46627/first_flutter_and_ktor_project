package com.example.mynotes.notes

data class SyncRequest(
    val userId: Int,
    val notes: List<Note>
)