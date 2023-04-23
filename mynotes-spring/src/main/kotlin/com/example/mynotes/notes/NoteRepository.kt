package com.example.mynotes.notes

import org.springframework.data.jpa.repository.JpaRepository

interface NoteRepository: JpaRepository<Note, Long>{

    fun findNotesByUserId(userId: Int): List<Note>

    fun deleteAllByUserId(userId: Int)

}