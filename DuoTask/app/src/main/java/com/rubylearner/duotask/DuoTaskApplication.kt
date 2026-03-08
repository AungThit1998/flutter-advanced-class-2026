package com.rubylearner.duotask

import android.app.Application
import com.rubylearner.duotask.data.TaskDatabase
import com.rubylearner.duotask.data.TaskRepository

class DuoTaskApplication : Application() {
    val database: TaskDatabase by lazy { TaskDatabase.getDatabase(this) }
    val repository: TaskRepository by lazy { TaskRepository(database.taskDao()) }
}
