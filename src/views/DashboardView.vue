<template>
  <div class="dashboard-wrapper">
    <div class="header-section">
      <h2>Overview</h2>
      <p class="subtitle">Your weekly performance metrics</p>
    </div>
    
    <div class="metrics-grid">
      <div class="metric-card dark">
        <div class="metric-icon">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
        </div>
        <div class="metric-info">
          <h3>Total Expenses</h3>
          <p class="value">ETB 14,245.50</p>
        </div>
      </div>
      
      <div class="metric-card light">
        <div class="metric-icon">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path></svg>
        </div>
        <div class="metric-info">
          <h3>Inventory Used</h3>
          <p class="value">ETB 8,850.00</p>
        </div>
      </div>
    </div>

    <div class="chart-card">
      <div class="chart-header">
        <h3>Burn Rate Activity</h3>
      </div>
      <div class="chart-area">
        <div class="bar-column" v-for="day in 7" :key="day">
          <div class="bar expense" :style="{ height: Math.random() * 60 + 20 + '%' }"></div>
          <div class="bar usage" :style="{ height: Math.random() * 60 + 20 + '%' }"></div>
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
  transition: transform 0.2s;
}
.metric-card:active {
  transform: scale(0.98);
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

/* Card Themes */
.metric-card.dark {
  background: #111;
  color: white;
  box-shadow: 0 10px 30px rgba(17, 17, 17, 0.15);
}
.metric-card.dark .metric-icon {
  background: rgba(255,255,255,0.1);
  color: white;
}
.metric-card.light {
  background: white;
  color: #111;
  border: 1px solid #eaeaea;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}
.metric-card.light .metric-icon {
  background: #f1f3f5;
  color: #111;
}

/* Chart */
.chart-card {
  background: white;
  border-radius: 20px;
  padding: 24px;
  border: 1px solid #eaeaea;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}
.chart-header h3 {
  margin: 0 0 24px 0;
  font-size: 1.1rem;
  font-weight: 600;
  color: #111;
}
.chart-area {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  height: 180px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f1f3f5;
}
.bar-column {
  display: flex;
  gap: 4px;
  align-items: flex-end;
  height: 100%;
}
.bar {
  width: 14px;
  border-radius: 4px 4px 0 0;
  transition: height 1s cubic-bezier(0.4, 0, 0.2, 1);
}
.bar.expense { background-color: #111; }
.bar.usage { background-color: #e0e0e0; }

.chart-legend {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-top: 20px;
}
.legend-item {
  display: flex;
  align-items: center;
  font-size: 0.85rem;
  font-weight: 500;
  color: #666;
}
.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: 8px;
}
.exp-dot { background-color: #111; }
.use-dot { background-color: #e0e0e0; }
</style>
