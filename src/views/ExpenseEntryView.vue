<template>
  <div class="expense-container">
    <h2>Record Expense</h2>
    
    <div class="form-group">
      <label>Description</label>
      <input v-model="expense.description" type="text" placeholder="e.g. Electricity Bill" class="modern-input" />
    </div>

    <div class="form-group">
      <label>Category</label>
      <select v-model="expense.category" class="modern-input">
        <option disabled value="">Select Category</option>
        <option>Utilities</option>
        <option>Maintenance</option>
        <option>Salary</option>
        <option>Miscellaneous</option>
      </select>
    </div>

    <div class="form-group">
      <label>Amount</label>
      <!-- VIRTUAL INPUT: Opens the numpad drawer without triggering native keyboard -->
      <div class="virtual-input" @click="isDrawerOpen = true">
        <span v-if="expense.amount">${{ expense.amount.toFixed(2) }}</span>
        <span v-else class="placeholder">Tap to enter amount</span>
      </div>
    </div>

    <button class="save-btn" :disabled="!isValid" @click="saveExpense">Submit Expense</button>

    <BottomSheetDrawer v-model:isOpen="isDrawerOpen">
      <CustomNumpad 
        item-name="Expense Amount" 
        @save="handleAmountSave" 
      />
    </BottomSheetDrawer>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import BottomSheetDrawer from '../components/ui/BottomSheetDrawer.vue';
import CustomNumpad from '../components/ui/CustomNumpad.vue';
import { supabase } from '../services/supabase';

const isDrawerOpen = ref(false);
const expense = ref({
  description: '',
  category: '',
  amount: null
});

const isValid = computed(() => {
  return expense.value.description && expense.value.category && expense.value.amount;
});

const handleAmountSave = (amount) => {
  expense.value.amount = amount;
  isDrawerOpen.value = false;
};

const saveExpense = async () => {
  console.log('Saving Expense:', expense.value);
  
  const { error } = await supabase.from('expenses').insert({
    description: expense.value.description,
    category: expense.value.category,
    amount: expense.value.amount
  });

  if (error) {
    console.error("Error saving expense:", error);
    alert('Failed to save expense');
  } else {
    alert(`Expense of $${expense.value.amount} for ${expense.value.category} saved!`);
    expense.value = { description: '', category: '', amount: null };
  }
};
</script>

<style scoped>
.expense-container {
  padding: 10px 0 20px 0;
  max-width: 600px;
  margin: 0 auto;
}
h2 {
  font-size: 1.5rem;
  color: #111827;
  margin-top: 0;
  margin-bottom: 24px;
}
.form-group {
  margin-bottom: 20px;
}
label {
  display: block;
  font-size: 0.9rem;
  font-weight: 600;
  color: #4b5563;
  margin-bottom: 8px;
}
.modern-input, .virtual-input {
  width: 100%;
  padding: 16px;
  border: 1px solid #d1d5db;
  border-radius: 12px;
  font-size: 1rem;
  background-color: #f9fafb;
  box-sizing: border-box;
  transition: border-color 0.2s, box-shadow 0.2s;
  font-family: inherit;
}
.modern-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
  background-color: #ffffff;
}
.virtual-input {
  cursor: pointer;
  display: flex;
  align-items: center;
  min-height: 52px;
}
.placeholder {
  color: #9ca3af;
}
.save-btn {
  width: 100%;
  padding: 16px;
  background-color: #10b981;
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  margin-top: 10px;
  transition: background-color 0.2s;
}
.save-btn:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
}
.save-btn:not(:disabled):active {
  background-color: #059669;
}
</style>
