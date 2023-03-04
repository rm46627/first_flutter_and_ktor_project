package com.example.mynotes

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class MynotesSpringApplication

fun main(args: Array<String>) {
    runApplication<MynotesSpringApplication>(*args)
}
