package com.example.data.user

import com.example.data.DatabaseFactory.dbQuery
import kotlinx.coroutines.runBlocking
import org.jetbrains.exposed.sql.ResultRow
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.selectAll

class UserDAO {

    private fun resultRowToUser(row: ResultRow): User = User(
            id = row[UserTable.id],
            email = row[UserTable.email],
            password = row[UserTable.password],
            username = row[UserTable.username]
    )

    suspend fun allUsers(): List<User> = dbQuery {
        UserTable.selectAll().map(::resultRowToUser)
    }

    suspend fun userByEmail(email: String): User? = dbQuery {
        UserTable
            .select { UserTable.email eq email }
            .map(::resultRowToUser)
            .singleOrNull()
    }

    suspend fun addNewUser(email: String, password: String, username: String): User? = dbQuery {
        val insertStatement = UserTable.insert {
            it[UserTable.email] = email
            it[UserTable.password] = password
            it[UserTable.username] = username
        }
        insertStatement.resultedValues?.singleOrNull()?.let(::resultRowToUser)
    }

    val dao: UserDAO = UserDAO().apply {
        runBlocking {
            if(allUsers().isEmpty()) {
                addNewUser("admin", "admin","admin")
            }
        }
    }
}

