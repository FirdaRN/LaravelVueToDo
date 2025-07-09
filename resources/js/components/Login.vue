<template>
  <main>
    <div class="container">
      <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
        <div class="container">
          <div class="row justify-content-center">
            <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">
              <div class="card mb-3">
                <div class="card-body">
                  <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Login to Your Account</h5>
                    <p class="text-center small">Enter your email & password to login</p>
                  </div>

                  <form class="row g-3 needs-validation" @submit.prevent="doLogin" novalidate>
                    <div class="col-12">
                      <label for="email" class="form-label">Email</label>
                      <input type="email" v-model="login.email" class="form-control" id="email" required>
                      <div class="invalid-feedback">Please enter your email.</div>
                    </div>

                    <div class="col-12">
                      <label for="password" class="form-label">Password</label>
                      <input type="password" v-model="login.password" class="form-control" id="password" required>
                      <div class="invalid-feedback">Please enter your password.</div>
                    </div>

                    <div class="col-12">
                      <button class="btn btn-primary w-100" type="submit">Login</button>
                    </div>

                    <div class="col-12">
                      <p class="small mb-0">Don't have account? <router-link to="/register">Create an account</router-link></p>
                    </div>
                  </form>

                </div>
              </div>

            </div>
          </div>
        </div>
      </section>
    </div>
  </main>
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
