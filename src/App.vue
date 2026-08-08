<script setup>
import { computed } from 'vue'
import { RouterView, useRoute } from 'vue-router'
import MobileBottomNav from './components/layout/MobileBottomNav.vue'
import TopHeader from './components/layout/TopHeader.vue'

const route = useRoute()
const isLoginRoute = computed(() => route.path === '/login')
</script>

<template>
  <div class="app-container">
    <TopHeader v-if="!isLoginRoute" />
    <main class="main-content" :class="{ 'no-padding': isLoginRoute }">
      <RouterView />
    </main>
    <MobileBottomNav v-if="!isLoginRoute" />
  </div>
</template>

<style>
/* Reset and Premium Typography */
body, html {
  margin: 0;
  padding: 0;
  font-family: 'Inter', -apple-system, sans-serif;
  background-color: #f7f9fc;
  color: #1a1d20;
  -webkit-font-smoothing: antialiased;
}
* {
  box-sizing: border-box;
}
</style>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  width: 100vw;
  background-color: #f7f9fc;
}
.main-content {
  flex: 1;
  overflow-y: auto;
  padding: 24px 20px 100px 20px;
}
.main-content.no-padding {
  padding: 0;
}
</style>
