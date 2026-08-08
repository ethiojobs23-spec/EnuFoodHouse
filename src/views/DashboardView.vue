<template>
  <div class="dashboard-container">
    <h2>Weekly Overview</h2>
    
    <div class="metrics-grid">
      <div class="metric-card expense">
        <h3>Total Expenses</h3>
        <p class="value">$1,245.50</p>
      </div>
      <div class="metric-card usage">
        <h3>Inventory Used</h3>
        <p class="value">$850.00</p>
      </div>
    </div>

    <div class="chart-section">
      <h3>Burn Rate</h3>
      <div class="mock-chart">
        <!-- Mock bars for visual aesthetics -->
        <div class="bar-group" v-for="day in 7" :key="day">
          <div class="bar expense-bar" :style="{ height: Math.random() * 80 + 20 + '%' }"></div>
          <div class="bar usage-bar" :style="{ height: Math.random() * 80 + 20 + '%' }"></div>
        </div>
      </div>
      <div class="chart-legend">
        <span class="legend-item"><span class="dot exp-dot"></span> Expenses</span>
        <span class="legend-item"><span class="dot use-dot"></span> Usage</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard-container {
  padding: 10px 0;
}
h2 {
  font-size: 1.5rem;
  color: #111827;
  margin-top: 0;
  margin-bottom: 20px;
}
.metrics-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 30px;
}
.metric-card {
  padding: 20px;
  border-radius: 16px;
  color: white;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}
.metric-card.expense {
  background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
}
.metric-card.usage {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}
.metric-card h3 {
  margin: 0;
  font-size: 0.9rem;
  opacity: 0.9;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.metric-card .value {
  margin: 10px 0 0 0;
  font-size: 1.6rem;
  font-weight: 700;
}

.chart-section {
  background: white;
  padding: 24px;
  border-radius: 16px;
  border: 1px solid #f3f4f6;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.02);
}
.chart-section h3 {
  margin-top: 0;
  font-size: 1.1rem;
  color: #374151;
  margin-bottom: 20px;
}
.mock-chart {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  height: 200px;
  padding-bottom: 10px;
  border-bottom: 1px dashed #e5e7eb;
}
.bar-group {
  display: flex;
  gap: 4px;
  align-items: flex-end;
  height: 100%;
}
.bar {
  width: 14px;
  border-radius: 4px 4px 0 0;
  transition: height 1s ease-in-out;
}
.expense-bar { background-color: #ef4444; }
.usage-bar { background-color: #f59e0b; }

.chart-legend {
  display: flex;
  gap: 16px;
  margin-top: 16px;
  font-size: 0.85rem;
  color: #6b7280;
  justify-content: center;
}
.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
}
.dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
.exp-dot { background-color: #ef4444; }
.use-dot { background-color: #f59e0b; }
</style>
