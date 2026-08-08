<template>
  <div class="inventory-container">
    <h2>Inventory Entry</h2>
    <!-- Your list of items -->
    <div class="items-grid">
      <div 
        v-for="item in inventoryItems" 
        :key="item.id"
        class="item-card"
        @click="openNumpad(item)"
      >
        <span class="item-name">{{ item.name }}</span>
        <span class="item-price">${{ item.price_point.toFixed(2) }}</span>
      </div>
    </div>

    <!-- The Drawer holding the Numpad -->
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
import { ref } from 'vue';
import BottomSheetDrawer from '../components/ui/BottomSheetDrawer.vue';
import CustomNumpad from '../components/ui/CustomNumpad.vue';

const isDrawerOpen = ref(false);
const selectedItem = ref(null);

const inventoryItems = ref([
  { id: 1, name: 'Tomato Paste', price_point: 15.50 },
  { id: 2, name: 'Cooking Oil (5L)', price_point: 45.00 }
]);

const openNumpad = (item) => {
  selectedItem.value = item;
  isDrawerOpen.value = true;
};

const handleTransactionSave = async (quantity) => {
  console.log(`Saving ${quantity} of ${selectedItem.value.name}`);
  
  // TODO: Call Supabase to insert into public.inventory_transactions
  
  isDrawerOpen.value = false;
  selectedItem.value = null;
};
</script>

<style scoped>
.inventory-container {
  padding-bottom: 20px;
}
.items-grid {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 16px;
}
.item-card {
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  border: 1px solid #f3f4f6;
}
.item-card:active {
  background: #f9fafb;
}
.item-name {
  font-weight: 600;
  font-size: 1.1rem;
}
.item-price {
  color: #6b7280;
  font-size: 0.95rem;
}
</style>
