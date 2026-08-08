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
/* Reset basic styles for mobile */
body, html {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  background-color: #f9fafb;
}
</style>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  width: 100vw;
}

.main-content {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  padding-bottom: 80px; /* Space for bottom nav */
}
.main-content.no-padding {
  padding: 0;
  padding-bottom: 0;
}
</style>
