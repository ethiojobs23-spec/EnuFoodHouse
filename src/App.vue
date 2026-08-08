<script setup>
import { RouterView } from 'vue-router'
import MobileBottomNav from './components/layout/MobileBottomNav.vue'
import TopHeader from './components/layout/TopHeader.vue'
</script>

<template>
  <div class="app-container">
    <TopHeader />
    <main class="main-content">
      <RouterView />
    </main>
    <MobileBottomNav />
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
</style>
