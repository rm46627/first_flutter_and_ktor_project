package com.example.repository

import com.example.data.model.User
import com.example.data.model.userFromRow
import com.example.data.DatabaseFactory.dbQuery
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.mapLazy
import org.jetbrains.exposed.sql.select

class UserRepository {

    suspend fun addUser(user: User) {
        dbQuery {
            UserTable.insert { table ->
                table[UserTable.email] = user.email
                table[UserTable.hashPassword] = user.hashPassword
                table[UserTable.name] = user.userName
            }
        }
    }

    suspend fun findUserByEmail(email:String) = dbQuery {
        // select equal emails and map from row to user
        UserTable.select { UserTable.email eq email }.limit(1).mapLazy { userFromRow(it) }
    }
}