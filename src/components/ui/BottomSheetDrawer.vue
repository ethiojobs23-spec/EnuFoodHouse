<template>
  <Teleport to="body">
    <Transition name="drawer">
      <div v-if="isOpen" class="drawer-overlay" @click.self="closeDrawer">
        <div class="drawer-content">
          <!-- Small visual indicator that it's a pull-up drawer -->
          <div class="drawer-handle"></div>
          
          <!-- Numpad or other content injected here -->
          <slot></slot>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { onMounted, onUnmounted, watch } from 'vue';

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  }
});

const emit = defineEmits(['update:isOpen']);

const closeDrawer = () => {
  emit('update:isOpen', false);
};

// Prevent background scrolling when drawer is open on mobile
watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
});

onUnmounted(() => {
  document.body.style.overflow = '';
});
</script>

<style scoped>
.drawer-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 9999;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
}

.drawer-content {
  background-color: #ffffff;
  width: 100%;
  border-top-left-radius: 20px;
  border-top-right-radius: 20px;
  padding: 16px 24px 32px;
  box-shadow: 0 -4px 12px rgba(0,0,0,0.1);
}

.drawer-handle {
  width: 40px;
  height: 4px;
  background-color: #e5e7eb;
  border-radius: 2px;
  margin: 0 auto 20px;
}

/* Slide Up Animation */
.drawer-enter-active,
.drawer-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.drawer-enter-from,
.drawer-leave-to {
  transform: translateY(100%);
  opacity: 0;
}
</style>
