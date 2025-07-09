<template>
  <div class="container mt-5">
    <div class="alert alert-info mb-4">{{ quote }}</div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <h1>Welcome, {{ username }}</h1>
      <button class="btn btn-secondary" @click="logout">Logout</button>
    </div>
    <h2>My To Do List</h2>

    <div class="input-group mb-3">
      <input
        v-model="newTask"
        class="form-control"
        placeholder="Add new task"
        @keyup.enter="addTask"
      />
      <button class="btn btn-primary" @click="addTask">Add</button>
    </div>

    <div class="mb-3">
      <label for="statusFilter" class="form-label me-2">Filter by Status:</label>
      <select
        id="statusFilter"
        v-model="filter"
        class="form-select w-auto d-inline-block"
      >
        <option value="all">All</option>
        <option value="completed">Completed</option>
        <option value="not_completed">Not Completed</option>
      </select>
    </div>

    <ul class="list-group">
      <li
        v-for="task in filteredTasks"
        :key="task.id"
        class="list-group-item d-flex justify-content-between align-items-start"
      >
        <div class="w-100">
          <div v-if="editingTaskId === task.id" class="d-flex gap-2 mb-2">
            <input
              v-model="editedTitle"
              class="form-control me-2"
              @keyup.enter="saveTask(task)"
            />
            <button class="btn btn-success btn-sm" @click="saveTask(task)">Save</button>
            <button class="btn btn-secondary btn-sm" @click="cancelEdit">Cancel</button>
          </div>

          <div v-else class="d-flex justify-content-between align-items-center">
            <div>
              <strong>{{ task.title }}</strong>
              <div class="text-muted small">
                Status:
                <span :class="task.completed ? 'text-success' : 'text-warning'">
                  {{ task.completed ? 'Completed' : 'Not Completed' }}
                </span>
              </div>
            </div>
            <div class="btn-group">
              <button class="btn btn-sm btn-warning" @click="editTask(task)">Edit</button>
              <button class="btn btn-sm btn-danger" @click="deleteTask(task)">Delete</button>
              <button
                class="btn btn-sm btn-outline-primary"
                @click="toggleCompleted(task)"
              >
                {{ task.completed ? 'Undo' : 'Complete' }}
              </button>
            </div>
          </div>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import api from '../api'

export default {
  name: 'TodoList',
  data() {
    return {
      tasks: [],
      newTask: '',
      editingTaskId: null,
      editedTitle: '',
      username: '',
      quote: 'Loading motivational quote...',
      filter: this.$route.query.filter || 'all',
    }
  },
  computed: {
    filteredTasks() {
      if (this.filter === 'completed') return this.tasks.filter(t => t.completed)
      if (this.filter === 'not_completed') return this.tasks.filter(t => !t.completed)
      return this.tasks
    }
  },
  watch: {
    filter(val) {
      this.$router.replace({ query: { ...this.$route.query, filter: val } })
    }
  },
  methods: {
    loadTasks() {
      api.get('/tasks')
        .then(res => {
          this.tasks = res.data.task
          this.username = res.data.username
        })
        .catch(() => alert('Failed to load tasks'))
    },
    loadQuote() {
      api.get('/quote')
        .then(res => {
          this.quote = `"${res.data.quote}" — ${res.data.author}`
        })
        .catch(() => {
          this.quote = 'Unable to load quote.'
        })
    },
    addTask() {
      if (!this.newTask) return
      api.post('/tasks', { title: this.newTask, completed: false })
        .then(res => {
          this.tasks.push(res.data)
          this.newTask = ''
        })
        .catch(() => alert('Failed to add task'))
    },
    deleteTask(task) {
      api.delete(`/tasks/${task.id}`)
        .then(() => {
          this.tasks = this.tasks.filter(t => t.id !== task.id)
        })
        .catch(() => alert('Failed to delete task'))
    },
    editTask(task) {
      this.editingTaskId = task.id
      this.editedTitle = task.title
    },
    cancelEdit() {
      this.editingTaskId = null
      this.editedTitle = ''
    },
    saveTask(task) {
      if (!this.editedTitle) return
      api.put(`/tasks/${task.id}`, { title: this.editedTitle })
        .then(res => {
          const index = this.tasks.findIndex(t => t.id === task.id)
          if (index !== -1) this.tasks[index].title = res.data.title
          this.cancelEdit()
        })
        .catch(() => alert('Failed to update task'))
    },
    toggleCompleted(task) {
      api.put(`/tasks/${task.id}`, { completed: !task.completed })
        .then(res => {
          const index = this.tasks.findIndex(t => t.id === task.id)
          if (index !== -1) this.tasks[index].completed = res.data.completed
        })
        .catch(() => alert('Failed to update status'))
    },
    logout() {
      api.post('/logout')
        .then(() => {
          localStorage.removeItem('token')
          this.$router.push('/')
        })
    }
  },
  mounted() {
    const token = localStorage.getItem('token')
    if (!token) {
      this.$router.push('/')
    } else {
      api.defaults.headers.common['Authorization'] = `Bearer ${token}`
      this.loadTasks()
      this.loadQuote()
    }
  }
}
</script>
