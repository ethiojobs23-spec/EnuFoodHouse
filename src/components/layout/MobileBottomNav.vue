<template>
  <nav class="bottom-nav">
    <router-link to="/dashboard" class="nav-item">Dashboard</router-link>
    <router-link to="/inventory" class="nav-item">Inventory</router-link>
    <router-link to="/expenses" class="nav-item">Expenses</router-link>
  </nav>
</template>

<style scoped>
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 65px;
  background: white;
  border-top: 1px solid #eaeaea;
  display: flex;
  justify-content: space-around;
  align-items: center;
  box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
}
.nav-item {
  text-decoration: none;
  color: #666;
  font-weight: 500;
  font-size: 14px;
}
.router-link-active {
  color: #007bff;
}
</style>
