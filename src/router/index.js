import { createRouter, createWebHistory } from 'vue-router'
import { supabase } from '../services/supabase'
import DashboardView from '../views/DashboardView.vue'
import InventoryEntryView from '../views/InventoryEntryView.vue'
import ExpenseEntryView from '../views/ExpenseEntryView.vue'
import LoginView from '../views/LoginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', redirect: '/inventory' },
    { path: '/login', name: 'login', component: LoginView },
    { 
      path: '/dashboard', 
      name: 'dashboard', 
      component: DashboardView,
      meta: { requiresAuth: true }
    },
    { 
      path: '/inventory', 
      name: 'inventory', 
      component: InventoryEntryView,
      meta: { requiresAuth: true }
    },
    { 
      path: '/expenses', 
      name: 'expenses', 
      component: ExpenseEntryView,
      meta: { requiresAuth: true }
    }
  ]
})

// Navigation Guard
router.beforeEach(async (to, from, next) => {
  const { data: { session } } = await supabase.auth.getSession()
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)

  if (requiresAuth && !session) {
    next('/login')
  } else if (to.path === '/login' && session) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router
