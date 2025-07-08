<template>
  <div class="container mt-5">
    <h3>Register</h3>
    <input
      v-model="form.name"
      placeholder="Name"
      class="form-control mb-2"
    />
    <input
      v-model="form.email"
      placeholder="Email"
      class="form-control mb-2"
    />
    <input
      v-model="form.password"
      type="password"
      placeholder="Password"
      class="form-control mb-2"
    />
    <input
      v-model="form.password_confirmation"
      type="password"
      placeholder="Confirm Password"
      class="form-control mb-2"
    />
    <button class="btn btn-primary" @click="doRegister">Register</button>
    <router-link to="/" class="btn btn-link mt-2">Login</router-link>
  </div>
</template>

<script>
import api from '../api'

export default {
  name: 'Register',
  data() {
    return {
      form: {
        name: '',
        email: '',
        password: '',
        password_confirmation: ''
      }
    }
  },
  methods: {
    doRegister() {
      api.post('/register', this.form)
        .then(() => {
          alert('Registered successfully! Please login.')
          this.$router.push('/')
        })
        .catch(() => alert('Registration failed'))
    }
  }
}
</script>
