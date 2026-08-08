<template>
  <div class="dashboard-wrapper">
    <div class="header-section">
      <div class="header-top">
        <h2>Reports</h2>
        <div class="filter-toggle">
          <button :class="{ active: timeFilter === 'weekly' }" @click="timeFilter = 'weekly'">Week</button>
          <button :class="{ active: timeFilter === 'monthly' }" @click="timeFilter = 'monthly'">Month</button>
        </div>
      </div>
      <p class="subtitle">Performance & History</p>
    </div>
    
    <div v-if="loading" class="loading-state">
      <div class="spinner"></div>
    </div>

    <div v-else>
      <div class="metrics-grid">
        <div class="metric-card dark">
          <div class="metric-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
          </div>
          <div class="metric-info">
            <h3>Total Expenses</h3>
            <p class="value">ETB {{ totalExpenses.toFixed(2) }}</p>
          </div>
        </div>
        
        <div class="metric-card light">
          <div class="metric-icon">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path></svg>
          </div>
          <div class="metric-info">
            <h3>Inventory Used</h3>
            <p class="value">ETB {{ totalUsage.toFixed(2) }}</p>
          </div>
        </div>
      </div>

      <div class="history-section">
        <div class="history-header">
          <h3>Activity Feed</h3>
        </div>
        
        <div class="activity-list">
          <div v-if="recentActivity.length === 0" class="empty-state">
            No activity found for this period.
          </div>
          
          <div v-for="item in recentActivity" :key="item.id" class="activity-card">
            <div class="activity-icon" :class="item.type.toLowerCase()">
              <svg v-if="item.type === 'Expense'" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
              <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path></svg>
            </div>
            
            <div class="activity-details">
              <div class="activity-top">
                <span class="activity-title">{{ item.title }}</span>
                <span class="activity-amount" :class="item.type.toLowerCase()">- ETB {{ Number(item.amount).toFixed(2) }}</span>
              </div>
              <div class="activity-bottom">
                <span class="activity-subtitle">{{ item.subtitle }}</span>
                <span class="activity-date">{{ formatDate(item.date) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue';
import { supabase } from '../services/supabase';

const timeFilter = ref('weekly'); 
const loading = ref(true);

const expenses = ref([]);
const inventoryUsage = ref([]);

const fetchData = async () => {
  loading.value = true;
  
  const now = new Date();
  let startDate = new Date();
  if (timeFilter.value === 'weekly') {
    startDate.setDate(now.getDate() - 7);
  } else {
    startDate.setMonth(now.getMonth() - 1);
  }
  const startDateStr = startDate.toISOString();

  // Fetch Expenses
  const { data: expData } = await supabase
    .from('expenses')
    .select('*')
    .gte('created_at', startDateStr)
    .order('created_at', { ascending: false });
    
  expenses.value = expData || [];

  // Fetch Inventory Usage joined with inventory_items to get the name
  const { data: invData } = await supabase
    .from('inventory_transactions')
    .select('*, inventory_items(name)')
    .gte('created_at', startDateStr)
    .order('created_at', { ascending: false });

  inventoryUsage.value = invData || [];
  
  loading.value = false;
};

onMounted(() => {
  fetchData();
});

watch(timeFilter, () => {
  fetchData();
});

const totalExpenses = computed(() => {
  return expenses.value.reduce((sum, exp) => sum + Number(exp.amount), 0);
});

const totalUsage = computed(() => {
  return inventoryUsage.value.reduce((sum, inv) => sum + Number(inv.total_value), 0);
});

const recentActivity = computed(() => {
  const activity = [];
  
  expenses.value.forEach(exp => {
    activity.push({
      id: `exp-${exp.id}`,
      type: 'Expense',
      title: exp.description,
      subtitle: `Expense: ${exp.category}`,
      amount: exp.amount,
      date: new Date(exp.created_at)
    });
  });
  
  inventoryUsage.value.forEach(inv => {
    activity.push({
      id: `inv-${inv.id}`,
      type: 'Inventory',
      title: inv.inventory_items?.name || 'Unknown Item',
      subtitle: `Usage: ${inv.quantity} units`,
      amount: inv.total_value,
      date: new Date(inv.created_at)
    });
  });
  
  // Sort combined array by newest first
  return activity.sort((a, b) => b.date - a.date);
});

const formatDate = (date) => {
  return new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }).format(date);
};
</script>

<style scoped>
.header-section {
  margin-bottom: 24px;
}
.header-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
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
.filter-toggle {
  background: #f1f3f5;
  border-radius: 12px;
  padding: 4px;
  display: flex;
  gap: 4px;
}
.filter-toggle button {
  background: transparent;
  border: none;
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 600;
  color: #6c757d;
  cursor: pointer;
  transition: all 0.2s;
}
.filter-toggle button.active {
  background: white;
  color: #111;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.metrics-grid {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 32px;
}
.metric-card {
  display: flex;
  align-items: center;
  padding: 24px;
  border-radius: 20px;
  gap: 16px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}
.metric-icon {
  width: 48px;
  height: 48px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.metric-info h3 {
  margin: 0 0 6px 0;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  opacity: 0.8;
}
.metric-info .value {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: -0.5px;
}
.metric-card.dark { background: #111; color: white; }
.metric-card.dark .metric-icon { background: rgba(255,255,255,0.1); color: white; }
.metric-card.light { background: white; color: #111; border: 1px solid #eaeaea; }
.metric-card.light .metric-icon { background: #f1f3f5; color: #111; }

.history-header h3 {
  margin: 0 0 16px 0;
  font-size: 1.1rem;
  font-weight: 700;
  color: #111;
}
.activity-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.activity-card {
  display: flex;
  align-items: center;
  background: white;
  padding: 16px;
  border-radius: 16px;
  border: 1px solid #eaeaea;
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
  gap: 16px;
}
.activity-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.activity-icon.expense { background: #fff0f0; color: #ef4444; }
.activity-icon.inventory { background: #f1f3f5; color: #495057; }

.activity-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.activity-top, .activity-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.activity-title {
  font-weight: 600;
  font-size: 0.95rem;
  color: #111;
}
.activity-amount {
  font-weight: 700;
  font-size: 0.95rem;
}
.activity-amount.expense { color: #ef4444; }
.activity-amount.inventory { color: #111; }

.activity-subtitle, .activity-date {
  font-size: 0.8rem;
  color: #868e96;
  font-weight: 500;
}
.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: #adb5bd;
  font-size: 0.95rem;
  background: white;
  border-radius: 16px;
  border: 1px dashed #dee2e6;
}
.loading-state {
  display: flex;
  justify-content: center;
  padding: 40px;
}
.spinner {
  width: 32px;
  height: 32px;
  border: 3px solid #f3f3f3;
  border-top: 3px solid #111;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
</style>
