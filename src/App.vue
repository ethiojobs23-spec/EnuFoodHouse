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
  background-color: #e9ecef; /* Dark background on desktop to frame the app */
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
  width: 100%;
  max-width: 420px;
  margin: 0 auto;
  background-color: #f7f9fc;
  position: relative;
  box-shadow: 0 0 40px rgba(0,0,0,0.1);
  overflow: hidden;
}
.main-content {
  flex: 1;
  overflow-y: auto;
  padding: 94px 20px 100px 20px;
}
.main-content.no-padding {
  padding: 0;
}
</style>
