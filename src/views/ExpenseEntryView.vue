<template>
  <div class="expense-wrapper">
    <div class="header-section">
      <h2>Register Expense</h2>
      <p class="subtitle">Log operational costs</p>
    </div>
    
    <div class="form-container">
      <div class="input-group">
        <label>Description</label>
        <input v-model="expense.description" type="text" placeholder="e.g. Electricity Bill" class="sleek-input" />
      </div>

      <div class="input-group">
        <label>Category</label>
        <div class="select-wrapper">
          <select v-model="expense.category" class="sleek-input">
            <option disabled value="">Select Category</option>
            <option>Utilities</option>
            <option>Maintenance</option>
            <option>Salary</option>
            <option>Miscellaneous</option>
          </select>
        </div>
      </div>

      <div class="input-group">
        <label>Total Amount</label>
        <div class="virtual-input" @click="isDrawerOpen = true" :class="{'has-value': expense.amount}">
          <span v-if="expense.amount" class="currency">ETB</span>
          <span v-if="expense.amount" class="value">{{ expense.amount.toFixed(2) }}</span>
          <span v-else class="placeholder">Tap to enter amount</span>
        </div>
      </div>

      <button class="action-btn" :disabled="!isValid" @click="saveExpense">
        Submit Expense
      </button>
    </div>

    <BottomSheetDrawer v-model:isOpen="isDrawerOpen">
      <CustomNumpad item-name="Expense Amount" @save="handleAmountSave" />
    </BottomSheetDrawer>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import BottomSheetDrawer from '../components/ui/BottomSheetDrawer.vue';
import CustomNumpad from '../components/ui/CustomNumpad.vue';
import { supabase } from '../services/supabase';

const isDrawerOpen = ref(false);
const expense = ref({ description: '', category: '', amount: null });

const isValid = computed(() => expense.value.description && expense.value.category && expense.value.amount);

const handleAmountSave = (amount) => {
  expense.value.amount = amount;
  isDrawerOpen.value = false;
};

const saveExpense = async () => {
  const { error } = await supabase.from('expenses').insert({
    description: expense.value.description,
    category: expense.value.category,
    amount: expense.value.amount
  });
  if (!error) {
    alert(`Expense of ETB ${expense.value.amount} saved!`);
    expense.value = { description: '', category: '', amount: null };
  }
};
</script>

<style scoped>
.header-section {
  margin-bottom: 32px;
}
h2 {
  font-size: 1.75rem;
  font-weight: 700;
  letter-spacing: -0.5px;
  color: #111;
  margin: 0 0 4px 0;
}
.subtitle {
  color: #6c757d;
  font-size: 0.95rem;
  margin: 0;
}
.form-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
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
  background: white;
  border: 1px solid #eaeaea;
  border-radius: 16px;
  font-size: 1rem;
  color: #111;
  font-family: inherit;
  transition: all 0.2s;
  appearance: none;
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
}
.sleek-input:focus {
  outline: none;
  border-color: #111;
  box-shadow: 0 0 0 4px rgba(17,17,17,0.05);
}
.select-wrapper {
  position: relative;
}
.select-wrapper::after {
  content: "▼";
  font-size: 10px;
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  color: #868e96;
  pointer-events: none;
}
.virtual-input {
  width: 100%;
  padding: 16px 20px;
  background: white;
  border: 1px solid #eaeaea;
  border-radius: 16px;
  min-height: 54px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
  transition: all 0.2s;
}
.virtual-input:active {
  transform: scale(0.99);
  background: #fafafa;
}
.virtual-input.has-value {
  border-color: #111;
}
.placeholder {
  color: #adb5bd;
}
.currency {
  font-weight: 600;
  color: #868e96;
  font-size: 0.9rem;
}
.value {
  font-size: 1.25rem;
  font-weight: 700;
  color: #111;
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
  margin-top: 16px;
  transition: all 0.2s;
}
.action-btn:disabled {
  background: #e9ecef;
  color: #adb5bd;
  cursor: not-allowed;
}
.action-btn:not(:disabled):active {
  transform: scale(0.98);
}
</style>
