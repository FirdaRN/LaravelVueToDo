import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import Login from './components/Login.vue'
import Register from './components/Register.vue'
import Tasks from './components/Tasks.vue'

const routes = [
  { path: '/', component: Login },
  { path: '/register', component: Register },
  { path: '/tasks', component: Tasks }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

createApp(App).use(router).mount('#app')
