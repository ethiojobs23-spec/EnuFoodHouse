<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import { supabase } from '../services/supabase';

const router = useRouter();
const pin = ref('');
const errorMessage = ref('');
const loading = ref(false);

// Configurable via .env, defaults to 123456
const EXPECTED_PIN = import.meta.env.VITE_ADMIN_PIN || '123456';
const ADMIN_EMAIL = import.meta.env.VITE_ADMIN_EMAIL || 'admin@enu.local';
const ADMIN_PASSWORD = import.meta.env.VITE_ADMIN_PASSWORD || 'EnuAdmin123!';

const maskedPin = computed(() => {
  if (pin.value.length === 0) return 'Tap PIN';
  return '•'.repeat(pin.value.length);
});

const append = (num) => {
  if (loading.value) return;
  if (pin.value.length < 6) {
    pin.value += num;
    errorMessage.value = '';
    
    if (pin.value.length === 6) {
      verifyPin();
    }
  }
};

const backspace = () => {
  pin.value = pin.value.slice(0, -1);
};

const verifyPin = async () => {
  if (pin.value !== EXPECTED_PIN) {
    errorMessage.value = 'Incorrect PIN';
    pin.value = '';
    return;
  }

  loading.value = true;
  
  // Background auth to satisfy Supabase Row Level Security (RLS)
  const { error } = await supabase.auth.signInWithPassword({
    email: ADMIN_EMAIL,
    password: ADMIN_PASSWORD,
  });

  if (error) {
    errorMessage.value = 'Backend Error: Create dummy user in Supabase first!';
    loading.value = false;
    pin.value = '';
  } else {
    router.push('/dashboard');
  }
};
</script>

<template>
  <div class="login-wrapper">
    <div class="login-card">
      <div class="logo">🍽️</div>
      <h2>Enu Food House</h2>
      <p class="subtitle">Enter 6-Digit Admin PIN</p>

      <div class="pin-display">
        <div class="pin-dots" :class="{ 'placeholder': pin.length === 0 }">{{ maskedPin }}</div>
      </div>
      
      <div v-if="errorMessage" class="error-msg">{{ errorMessage }}</div>
      <div v-if="loading" class="loading-msg">Unlocking...</div>

      <div class="keypad" :class="{ 'disabled': loading }">
        <button v-for="n in 9" :key="n" @click="append(n.toString())" class="key">
          {{ n }}
        </button>
        <button class="key empty"></button>
        <button @click="append('0')" class="key">0</button>
        <button @click="backspace" class="key delete-key">⌫</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background-color: #f9fafb;
}
.login-card {
  background: white;
  padding: 40px 30px;
  border-radius: 24px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.05);
  width: 100%;
  max-width: 400px;
  text-align: center;
}
.logo {
  font-size: 3.5rem;
  margin-bottom: 10px;
}
h2 {
  margin: 0;
  color: #111827;
  font-size: 1.8rem;
}
.subtitle {
  color: #6b7280;
  margin-top: 8px;
  margin-bottom: 30px;
}
.pin-display {
  margin-bottom: 24px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 16px;
}
.pin-dots {
  font-size: 2.5rem;
  letter-spacing: 0.5rem;
  color: #111827;
  font-weight: 700;
  transform: translateY(4px);
}
.pin-dots.placeholder {
  font-size: 1.2rem;
  letter-spacing: normal;
  color: #9ca3af;
  font-weight: 500;
  transform: none;
}
.error-msg {
  color: #ef4444;
  margin-bottom: 16px;
  font-weight: 500;
}
.loading-msg {
  color: #3b82f6;
  margin-bottom: 16px;
  font-weight: 500;
}

/* Numpad Styles */
.keypad {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}
.keypad.disabled {
  opacity: 0.5;
  pointer-events: none;
}
.key {
  background-color: #f3f4f6;
  border: none;
  border-radius: 12px;
  padding: 20px;
  font-size: 1.5rem;
  font-weight: 600;
  color: #374151;
  cursor: pointer;
  touch-action: manipulation;
}
.key:active {
  background-color: #e5e7eb;
}
.key.empty {
  background-color: transparent;
  pointer-events: none;
}
.delete-key {
  color: #ef4444;
}
</style>
