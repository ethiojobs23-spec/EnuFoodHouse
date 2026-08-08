<template>
  <div class="inventory-wrapper">
    <div class="header-section">
      <h2>Catalog</h2>
      <p class="subtitle">Tap an item to record usage</p>
    </div>

    <div class="items-grid">
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
        <div class="item-price">
          <span class="currency">ETB</span>
          <span class="amount">{{ item.price_point.toFixed(2) }}</span>
        </div>
      </div>
    </div>

    <BottomSheetDrawer v-model:isOpen="isDrawerOpen">
      <CustomNumpad 
        v-if="selectedItem"
        :item-name="selectedItem.name" 
        @save="handleTransactionSave" 
      />
    </BottomSheetDrawer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import BottomSheetDrawer from '../components/ui/BottomSheetDrawer.vue';
import CustomNumpad from '../components/ui/CustomNumpad.vue';
import { supabase } from '../services/supabase';

const isDrawerOpen = ref(false);
const selectedItem = ref(null);
const inventoryItems = ref([]);

const fetchInventory = async () => {
  const { data, error } = await supabase.from('inventory_items').select('*');
  if (!error) inventoryItems.value = data;
};

onMounted(() => fetchInventory());

const openNumpad = (item) => {
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
</script>

<style scoped>
.header-section {
  margin-bottom: 24px;
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
</style>
