<template>
  <div class="auth-wrapper">
    <div class="auth-card">
      <div class="brand">
        <div class="brand-icon">E</div>
        <h1>Enu Food House</h1>
      </div>
      
      <p class="prompt">Enter 6-digit PIN</p>

      <div class="pin-display">
        <div class="dot" v-for="n in 6" :key="n" :class="{'filled': pin.length >= n}"></div>
      </div>
      
      <div v-if="errorMessage" class="error-msg">{{ errorMessage }}</div>
      <div v-if="loading" class="loading-msg">Authenticating...</div>

      <div class="numpad" :class="{ 'disabled': loading }">
        <button v-for="n in 9" :key="n" @click="append(n.toString())" class="num-btn">{{ n }}</button>
        <div class="empty"></div>
        <button @click="append('0')" class="num-btn">0</button>
        <button @click="backspace" class="num-btn action">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2z"></path><line x1="18" y1="9" x2="12" y2="15"></line><line x1="12" y1="9" x2="18" y2="15"></line></svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { supabase } from '../services/supabase';

const router = useRouter();
const pin = ref('');
const errorMessage = ref('');
const loading = ref(false);

const EXPECTED_PIN = computed(() => localStorage.getItem('ADMIN_PIN') || import.meta.env.VITE_ADMIN_PIN || '123456');
const ADMIN_EMAIL = import.meta.env.VITE_ADMIN_EMAIL || 'admin@enu.local';
const ADMIN_PASSWORD = import.meta.env.VITE_ADMIN_PASSWORD || 'EnuAdmin123!';

const append = (num) => {
  if (loading.value) return;
  if (pin.value.length < 6) {
    pin.value += num;
    errorMessage.value = '';
    if (pin.value.length === 6) verifyPin();
  }
};

const backspace = () => {
  pin.value = pin.value.slice(0, -1);
};

const verifyPin = async () => {
  if (pin.value !== EXPECTED_PIN.value) {
    errorMessage.value = 'Incorrect PIN';
    pin.value = '';
    return;
  }
  loading.value = true;
  const { error } = await supabase.auth.signInWithPassword({ email: ADMIN_EMAIL, password: ADMIN_PASSWORD });
  if (error) {
    errorMessage.value = 'Auth Error. Check dummy user.';
    loading.value = false;
    pin.value = '';
  } else {
    router.push('/dashboard');
  }
};
</script>

<style scoped>
.auth-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background-color: #111;
  color: white;
}
.auth-card {
  width: 100%;
  max-width: 360px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}
.brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 40px;
}
.brand-icon {
  width: 56px;
  height: 56px;
  background: white;
  color: #111;
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 16px;
}
.brand h1 {
  font-size: 1.5rem;
  margin: 0;
  font-weight: 600;
  letter-spacing: -0.5px;
}
.prompt {
  color: #868e96;
  font-size: 0.9rem;
  margin-bottom: 20px;
}
.pin-display {
  display: flex;
  gap: 16px;
  margin-bottom: 40px;
}
.dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  border: 2px solid rgba(255,255,255,0.2);
  transition: all 0.2s;
}
.dot.filled {
  background: white;
  border-color: white;
}
.error-msg { color: #ff6b6b; margin-bottom: 16px; font-weight: 500; font-size: 0.9rem; }
.loading-msg { color: #4dabf7; margin-bottom: 16px; font-weight: 500; font-size: 0.9rem; }

.numpad {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px 30px;
  width: 100%;
}
.num-btn {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: rgba(255,255,255,0.1);
  color: white;
  border: none;
  font-size: 2rem;
  font-weight: 400;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
  cursor: pointer;
  transition: all 0.15s;
}
.num-btn:active {
  background: rgba(255,255,255,0.3);
  transform: scale(0.95);
}
.num-btn.action {
  background: transparent;
  color: #868e96;
}
.num-btn.action:active {
  color: white;
}
.disabled {
  opacity: 0.5;
  pointer-events: none;
}
</style>
