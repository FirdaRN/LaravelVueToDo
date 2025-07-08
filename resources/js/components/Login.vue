<template>
  <div class="container mt-5">
    <h3>Login</h3>
    <input
      v-model="login.email"
      placeholder="Email"
      class="form-control mb-2"
    />
    <input
      v-model="login.password"
      type="password"
      placeholder="Password"
      class="form-control mb-2"
    />
    <button class="btn btn-primary" @click="doLogin">Login</button>
    <router-link to="/register" class="btn btn-link mt-2">Register</router-link>
  </div>
</template>

<script>
import api from '../api'

export default {
  name: 'Login',
  data() {
    return {
      login: {
        email: '',
        password: ''
      }
    }
  },
  methods: {
    doLogin() {
      api.post('/login', this.login)
        .then(res => {
          localStorage.setItem('token', res.data.token)
          api.defaults.headers.common['Authorization'] = `Bearer ${res.data.token}`
          this.$router.push('/tasks')
        })
        .catch(() => alert('Login failed'))
    }
  }
}
</script>
