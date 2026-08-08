<template>
  <div class="inventory-wrapper">
    <div class="header-section" v-if="!isManageMode">
      <div class="title-row">
        <div>
          <h2>Catalog</h2>
          <p class="subtitle">Tap an item to record usage</p>
        </div>
        <button class="add-btn" @click="openAddItem">+ Add</button>
      </div>
    </div>

    <!-- MAIN INVENTORY LIST -->
    <div class="items-grid" v-if="!isManageMode">
      <div 
        v-for="item in inventoryItems" 
        :key="item.id"
        class="item-card"
        @click="openNumpad(item)"
      >
        <div class="item-info">
          <span class="item-name">{{ item.name }}</span>
          <span class="item-category">{{ item.category || 'General' }}</span>
        </div>
        <div class="item-price-action">
          <div class="item-price">
            <span class="currency">ETB</span>
            <span class="amount">{{ item.price_point.toFixed(2) }}</span>
          </div>
          <!-- Edit button stops propagation so it doesn't open the Numpad -->
          <button class="edit-icon" @click.stop="openEditItem(item)">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
          </button>
        </div>
      </div>
    </div>

    <!-- MANAGE ITEM SCREEN (Add/Edit) -->
    <div class="manage-screen" v-if="isManageMode">
      <div class="manage-header">
        <button class="back-btn" @click="closeManageMode">← Back</button>
        <h3>{{ editingItem.id ? 'Edit Item' : 'New Item' }}</h3>
        <button v-if="editingItem.id" class="delete-text-btn" @click="deleteItem">Delete</button>
        <div v-else style="width: 60px"></div>
      </div>

      <div class="form-container">
        <div class="input-group">
          <label>Item Name</label>
          <input v-model="editingItem.name" type="text" placeholder="e.g. Tomato Paste" class="sleek-input" />
        </div>

        <div class="input-group">
          <label>Category</label>
          <input v-model="editingItem.category" type="text" placeholder="e.g. Ingredients" class="sleek-input" />
        </div>

        <div class="input-group">
          <label>Price Point</label>
          <!-- Virtual Input for Amount to avoid native keyboard -->
          <div class="virtual-input" @click="isPriceDrawerOpen = true" :class="{'has-value': editingItem.price_point}">
            <span v-if="editingItem.price_point" class="currency">ETB</span>
            <span v-if="editingItem.price_point" class="value">{{ editingItem.price_point.toFixed(2) }}</span>
            <span v-else class="placeholder">Tap to enter price</span>
          </div>
        </div>

        <button class="action-btn" :disabled="!isManageValid" @click="saveItem">
          Save Item
        </button>
      </div>
    </div>

    <!-- TRANSACTION NUMPAD DRAWER -->
    <BottomSheetDrawer v-model:isOpen="isDrawerOpen">
      <CustomNumpad 
        v-if="selectedItem"
        :item-name="selectedItem.name" 
        @save="handleTransactionSave" 
      />
    </BottomSheetDrawer>

    <!-- PRICE NUMPAD DRAWER (For adding/editing item price) -->
    <BottomSheetDrawer v-model:isOpen="isPriceDrawerOpen">
      <CustomNumpad 
        item-name="Item Price" 
        @save="handlePriceSave" 
      />
    </BottomSheetDrawer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import BottomSheetDrawer from '../components/ui/BottomSheetDrawer.vue';
import CustomNumpad from '../components/ui/CustomNumpad.vue';
import { supabase } from '../services/supabase';

// Transaction State
const isDrawerOpen = ref(false);
const selectedItem = ref(null);
const inventoryItems = ref([]);

// Manage Item State
const isManageMode = ref(false);
const isPriceDrawerOpen = ref(false);
const editingItem = ref({ id: null, name: '', price_point: null, category: '' });

const fetchInventory = async () => {
  const { data, error } = await supabase.from('inventory_items').select('*').order('name');
  if (!error) inventoryItems.value = data;
};

onMounted(() => fetchInventory());

/* --- Transaction Logic --- */
const openNumpad = (item) => {
  if (isManageMode.value) return;
  selectedItem.value = item;
  isDrawerOpen.value = true;
};

const handleTransactionSave = async (quantity) => {
  const { error } = await supabase.from('inventory_transactions').insert({
    item_id: selectedItem.value.id,
    quantity: quantity,
    price_point: selectedItem.value.price_point,
    transaction_type: 'OUT'
  });
  if (!error) {
    alert(`Successfully recorded ${quantity} of ${selectedItem.value.name}`);
  }
  isDrawerOpen.value = false;
  selectedItem.value = null;
};

/* --- Manage Item Logic --- */
const openAddItem = () => {
  editingItem.value = { id: null, name: '', price_point: null, category: '' };
  isManageMode.value = true;
};

const openEditItem = (item) => {
  editingItem.value = { ...item };
  isManageMode.value = true;
};

const closeManageMode = () => {
  isManageMode.value = false;
};

const handlePriceSave = (amount) => {
  editingItem.value.price_point = amount;
  isPriceDrawerOpen.value = false;
};

const isManageValid = computed(() => {
  return editingItem.value.name.trim() !== '' && editingItem.value.price_point !== null;
});

const saveItem = async () => {
  const itemData = {
    name: editingItem.value.name,
    category: editingItem.value.category,
    price_point: editingItem.value.price_point
  };

  if (editingItem.value.id) {
    await supabase.from('inventory_items').update(itemData).eq('id', editingItem.value.id);
  } else {
    await supabase.from('inventory_items').insert(itemData);
  }
  
  await fetchInventory();
  isManageMode.value = false;
};

const deleteItem = async () => {
  if (!confirm(`Are you sure you want to delete ${editingItem.value.name}?`)) return;
  
  await supabase.from('inventory_items').delete().eq('id', editingItem.value.id);
  await fetchInventory();
  isManageMode.value = false;
};
</script>

<style scoped>
.header-section {
  margin-bottom: 24px;
}
.title-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
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
.add-btn {
  background: #111;
  color: white;
  border: none;
  border-radius: 12px;
  padding: 8px 16px;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  transition: transform 0.2s;
}
.add-btn:active {
  transform: scale(0.95);
}
.items-grid {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.item-card {
  background: white;
  padding: 20px 24px;
  border-radius: 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  border: 1px solid #eaeaea;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
}
.item-card:active {
  transform: scale(0.98);
  background: #fafafa;
}
.item-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.item-name {
  font-weight: 600;
  font-size: 1.1rem;
  color: #111;
}
.item-category {
  font-size: 0.8rem;
  color: #868e96;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 600;
}
.item-price-action {
  display: flex;
  align-items: center;
  gap: 16px;
}
.item-price {
  display: flex;
  align-items: baseline;
  gap: 4px;
}
.currency {
  font-size: 0.8rem;
  font-weight: 600;
  color: #868e96;
}
.amount {
  font-size: 1.25rem;
  font-weight: 700;
  color: #111;
}
.edit-icon {
  background: #f1f3f5;
  border: none;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #495057;
  cursor: pointer;
  padding: 0;
  transition: background-color 0.2s;
}
.edit-icon:active {
  background: #e9ecef;
}

/* Manage Screen Styles */
.manage-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.manage-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
}
.back-btn {
  background: none;
  border: none;
  color: #111;
  font-weight: 600;
  font-size: 0.95rem;
  cursor: pointer;
  padding: 8px 0;
}
.delete-text-btn {
  background: none;
  border: none;
  color: #ef4444;
  font-weight: 600;
  font-size: 0.95rem;
  cursor: pointer;
  padding: 8px 0;
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
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
}
.sleek-input:focus {
  outline: none;
  border-color: #111;
  box-shadow: 0 0 0 4px rgba(17,17,17,0.05);
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
