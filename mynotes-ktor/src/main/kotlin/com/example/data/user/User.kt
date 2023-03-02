package com.example.data.user

import org.jetbrains.exposed.sql.ResultRow
import org.jetbrains.exposed.sql.Table

data class User(
    val id: Int,
    val email:String,
    val password:String,
    val username:String
)

object UserTable: Table() {

    val id = integer("id").autoIncrement()
    val email = varchar("email", 512)
    val username = varchar("name", 512)
    val password = varchar("hashPassword", 512)

    override val primaryKey: PrimaryKey = PrimaryKey(email)
}