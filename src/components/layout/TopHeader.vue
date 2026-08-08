<template>
  <header class="top-header">
    <h1>Enu Food House</h1>
    <div class="user-profile">
      <span class="user-name">Admin</span>
      <button class="logout-btn" @click="handleLogout">Logout</button>
    </div>
  </header>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { supabase } from '../../services/supabase';

const router = useRouter();

const handleLogout = async () => {
  await supabase.auth.signOut();
  router.push('/login');
};
</script>

<style scoped>
.top-header {
  height: 60px;
  background: white;
  border-bottom: 1px solid #eaeaea;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 16px;
}
h1 {
  font-size: 18px;
  margin: 0;
  color: #333;
}
.user-profile {
  display: flex;
  align-items: center;
  gap: 12px;
}
.user-name {
  font-size: 14px;
  color: #666;
}
.logout-btn {
  background-color: #f3f4f6;
  border: none;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 0.85rem;
  color: #ef4444;
  cursor: pointer;
  font-weight: 600;
}
</style>
