import { createRouter, createWebHistory } from 'vue-router'
import DashboardView from '../views/DashboardView.vue'
import InventoryEntryView from '../views/InventoryEntryView.vue'
import ExpenseEntryView from '../views/ExpenseEntryView.vue'
import LoginView from '../views/LoginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', redirect: '/inventory' },
    { path: '/login', name: 'login', component: LoginView },
    { path: '/dashboard', name: 'dashboard', component: DashboardView },
    { path: '/inventory', name: 'inventory', component: InventoryEntryView },
    { path: '/expenses', name: 'expenses', component: ExpenseEntryView }
  ]
})

export default router
