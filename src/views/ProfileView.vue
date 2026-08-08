<template>
  <div class="profile-wrapper">
    <div class="header-section">
      <div class="header-top">
        <button class="back-btn" @click="router.back()">← Back</button>
        <h2>Profile Settings</h2>
      </div>
      <p class="subtitle">Manage your account & security</p>
    </div>

    <div class="profile-card">
      <div class="avatar-section">
        <div class="avatar-large">{{ displayName.charAt(0).toUpperCase() }}</div>
        <div class="user-info">
          <h3>{{ displayName }}</h3>
          <p>Administrator</p>
        </div>
      </div>
      
      <div class="form-container">
        <div class="input-group">
          <label>Display Name</label>
          <input v-model="form.displayName" type="text" class="sleek-input" />
        </div>

        <div class="input-group">
          <label>Admin PIN (6 Digits)</label>
          <input v-model="form.pin" type="password" inputmode="numeric" maxlength="6" class="sleek-input" />
          <span class="help-text">This PIN is used to unlock the app.</span>
        </div>

        <button class="action-btn" :disabled="!isValid" @click="saveProfile">
          Save Changes
        </button>
      </div>
    </div>
    
    <div class="danger-zone">
      <button class="logout-btn" @click="handleLogout">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
        Sign Out
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { supabase } from '../services/supabase';

const router = useRouter();

const displayName = ref('Admin');
const form = ref({ displayName: '', pin: '' });

onMounted(() => {
  const savedName = localStorage.getItem('ADMIN_NAME') || 'Admin';
  const savedPin = localStorage.getItem('ADMIN_PIN') || '123456';
  
  displayName.value = savedName;
  form.value.displayName = savedName;
  form.value.pin = savedPin;
});

const isValid = computed(() => {
  return form.value.displayName.trim() !== '' && form.value.pin.length === 6;
});

const saveProfile = () => {
  localStorage.setItem('ADMIN_NAME', form.value.displayName);
  localStorage.setItem('ADMIN_PIN', form.value.pin);
  displayName.value = form.value.displayName;
  alert('Profile updated successfully!');
};

const handleLogout = async () => {
  await supabase.auth.signOut();
  router.push('/login');
};
</script>

<style scoped>
.profile-wrapper {
  padding-top: 10px;
}
.header-section {
  margin-bottom: 32px;
}
.header-top {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 4px;
}
.back-btn {
  background: #f1f3f5;
  border: none;
  padding: 8px 12px;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.9rem;
  color: #111;
  cursor: pointer;
}
h2 {
  font-size: 1.75rem;
  font-weight: 700;
  letter-spacing: -0.5px;
  color: #111;
  margin: 0;
}
.subtitle {
  color: #6c757d;
  font-size: 0.95rem;
  margin: 0;
}

.profile-card {
  background: white;
  border-radius: 24px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  border: 1px solid #eaeaea;
  margin-bottom: 24px;
}

.avatar-section {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 32px;
  padding-bottom: 24px;
  border-bottom: 1px solid #f1f3f5;
}
.avatar-large {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: #111;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: 700;
}
.user-info h3 {
  margin: 0 0 4px 0;
  font-size: 1.25rem;
  font-weight: 700;
}
.user-info p {
  margin: 0;
  color: #868e96;
  font-size: 0.9rem;
  font-weight: 500;
}

.form-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.input-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
label {
  font-size: 0.85rem;
  font-weight: 600;
  color: #495057;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.sleek-input {
  width: 100%;
  padding: 16px 20px;
  background: #f7f9fc;
  border: 1px solid #eaeaea;
  border-radius: 16px;
  font-size: 1rem;
  color: #111;
  font-family: inherit;
  transition: all 0.2s;
}
.sleek-input:focus {
  outline: none;
  border-color: #111;
  background: white;
  box-shadow: 0 0 0 4px rgba(17,17,17,0.05);
}
.help-text {
  font-size: 0.8rem;
  color: #adb5bd;
}

.action-btn {
  width: 100%;
  padding: 18px;
  background: #111;
  color: white;
  border: none;
  border-radius: 16px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  margin-top: 8px;
  transition: all 0.2s;
}
.action-btn:disabled {
  background: #e9ecef;
  color: #adb5bd;
  cursor: not-allowed;
}

.danger-zone {
  display: flex;
  justify-content: center;
}
.logout-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: transparent;
  border: 1px solid #ef4444;
  color: #ef4444;
  padding: 16px 32px;
  border-radius: 16px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.2s;
}
.logout-btn:active {
  background: #fff0f0;
}
</style>
