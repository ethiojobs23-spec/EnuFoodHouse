<template>
  <header class="top-header">
    <div class="logo">Enu.</div>
    <div class="user-profile">
      <div class="avatar">A</div>
      <button class="logout-btn" @click="handleLogout">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
      </button>
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
  height: 70px;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(0,0,0,0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  position: sticky;
  top: 0;
  z-index: 50;
}
.logo {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.5px;
  color: #111;
}
.user-profile {
  display: flex;
  align-items: center;
  gap: 16px;
}
.avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #111;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 14px;
}
.logout-btn {
  background: none;
  border: none;
  color: #666;
  padding: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  transition: all 0.2s;
}
.logout-btn:active {
  background: #f1f3f5;
  color: #ef4444;
}
</style>
