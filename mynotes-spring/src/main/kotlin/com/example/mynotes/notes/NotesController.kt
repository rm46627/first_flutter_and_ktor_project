package com.example.mynotes.notes

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/notes")
class NotesController(
    private val repository: NoteRepository
) {
    @GetMapping("/hello")
    fun sayHello(): ResponseEntity<String> {
        return ResponseEntity.ok("Hello from secured endpoint")
    }

    @PostMapping("/sync")
    fun syncNotes(@RequestBody request: SyncRequest): ResponseEntity<Boolean> {
        try {
            repository.deleteAllByUserId(request.userId)
            repository.saveAll(request.notes)
        } catch (e: Exception){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false)
        }
        return ResponseEntity.ok(true)
    }

    @GetMapping("/get/{id}")
    fun getNotes(@PathVariable id: Int): ResponseEntity<List<Note>> {
        val notes = repository.findNotesByUserId(id)
        return ResponseEntity.ok(notes)
    }
}