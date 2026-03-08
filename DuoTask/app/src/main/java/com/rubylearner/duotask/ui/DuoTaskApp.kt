package com.rubylearner.duotask.ui

import androidx.activity.compose.BackHandler
import androidx.compose.material3.adaptive.ExperimentalMaterial3AdaptiveApi
import androidx.compose.material3.adaptive.layout.AnimatedPane
import androidx.compose.material3.adaptive.layout.ListDetailPaneScaffold
import androidx.compose.material3.adaptive.layout.ListDetailPaneScaffoldRole
import androidx.compose.material3.adaptive.navigation.rememberListDetailPaneScaffoldNavigator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import com.rubylearner.duotask.data.Task

@OptIn(ExperimentalMaterial3AdaptiveApi::class)
@Composable
fun DuoTaskApp(
    viewModel: TaskViewModel,
    modifier: Modifier = Modifier
) {
    val navigator = rememberListDetailPaneScaffoldNavigator<Task>()
    val tasks by viewModel.tasks.collectAsState()

    BackHandler(navigator.canNavigateBack()) {
        navigator.navigateBack()
    }

    ListDetailPaneScaffold(
        directive = navigator.scaffoldDirective,
        value = navigator.scaffoldValue,
        listPane = {
            AnimatedPane(modifier = Modifier) {
                TaskListScreen(
                    viewModel = viewModel,
                    onTaskClick = { task ->
                        navigator.navigateTo(ListDetailPaneScaffoldRole.Detail, task)
                    },
                    onAddTaskClick = {
                        navigator.navigateTo(ListDetailPaneScaffoldRole.Detail, null)
                    }
                )
            }
        },
        detailPane = {
            AnimatedPane(modifier = Modifier) {
                val selectedTask = navigator.currentDestination?.content
                TaskEditorScreen(
                    task = selectedTask,
                    onSave = { title, description ->
                        if (selectedTask == null) {
                            viewModel.addTask(title, description)
                        } else {
                            viewModel.updateTask(selectedTask.copy(title = title, description = description))
                        }
                        navigator.navigateBack()
                    },
                    onBack = {
                        navigator.navigateBack()
                    }
                )
            }
        },
        modifier = modifier
    )
}
