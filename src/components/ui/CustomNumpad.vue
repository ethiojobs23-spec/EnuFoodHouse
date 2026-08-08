<template>
  <div class="numpad-wrapper">
    <div class="header">
      <span class="item-name">{{ itemName }}</span>
      <!-- The display is a div, not an input, to block native keyboards -->
      <div class="amount-display">{{ displayValue || '0' }}</div>
    </div>

    <div class="keypad">
      <button v-for="n in 9" :key="n" @click="append(n.toString())" class="key">
        {{ n }}
      </button>
      <button @click="append('.')" class="key">.</button>
      <button @click="append('0')" class="key">0</button>
      <button @click="backspace" class="key delete-key">⌫</button>
    </div>

    <button class="submit-btn" :disabled="!displayValue" @click="submit">
      Save Transaction
    </button>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const props = defineProps({
  itemName: {
    type: String,
    default: 'Enter Amount'
  }
});

const emit = defineEmits(['save']);

const displayValue = ref('');

const append = (char) => {
  // Prevent multiple decimals
  if (char === '.' && displayValue.value.includes('.')) return;
  // Prevent leading zeros unless followed by decimal
  if (displayValue.value === '0' && char !== '.') {
    displayValue.value = char;
    return;
  }
  
  // Optional: Limit decimal places to 2 (for money/precise inventory)
  if (displayValue.value.includes('.')) {
    const decimals = displayValue.value.split('.')[1];
    if (decimals && decimals.length >= 2) return;
  }

  displayValue.value += char;
};

const backspace = () => {
  displayValue.value = displayValue.value.slice(0, -1);
};

const submit = () => {
  const numericValue = parseFloat(displayValue.value);
  if (!isNaN(numericValue) && numericValue > 0) {
    emit('save', numericValue);
    displayValue.value = ''; // Reset for next use
  }
};
</script>

<style scoped>
.numpad-wrapper {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.header {
  text-align: center;
  margin-bottom: 10px;
}

.item-name {
  color: #6b7280;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.amount-display {
  font-size: 2.5rem;
  font-weight: 700;
  color: #111827;
  min-height: 48px;
  margin-top: 8px;
}

.keypad {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
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
  touch-action: manipulation; /* Optimizes for touch devices */
}

.key:active {
  background-color: #e5e7eb;
}

.delete-key {
  color: #ef4444;
}

.submit-btn {
  background-color: #10b981;
  color: white;
  border: none;
  border-radius: 12px;
  padding: 16px;
  font-size: 1.1rem;
  font-weight: 600;
  margin-top: 8px;
  cursor: pointer;
}

.submit-btn:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
}
</style>
