<template>
    <div class="relative overflow-hidden" ref="container">
        <div class="flex space-x-2">
            <button
                v-for="(value, i) in data"
                :key="i"
                @click="setActive(i)"
                class="relative px-4 py-2 rounded-md border-none text-black dark:text-white z-10"
            >
                {{ value }}
            </button>
        </div>

        <!-- 滑动指示器 -->
        <span
            class="absolute bottom-0 h-full bg-blue-500 rounded transition-all duration-300 ease-in-out"
            :style="{
                width: indicatorWidth + 'px',
                transform: `translateX(${indicatorX}px)`,
            }"
        ></span>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick, watch, defineExpose } from 'vue';

const props = defineProps({
    data: {
        type: Array as () => string[],
        default: () => [],
    },
    modelValue: {
        type: Number,
        default: 0,
    },
});
const active = ref(props.modelValue);
const container = ref<HTMLElement | null>(null);
const indicatorX = ref(0);
const indicatorWidth = ref(0);
let btns: HTMLElement[] = [];

const emit = defineEmits<{
    (e: 'update:modelValue', value: number): void;
}>();

watch(
    () => props.modelValue,
    (val) => {
        active.value = val;
    },
);

function updateIndicator() {
    const el = btns[active.value];
    if (!el || !container.value) return;

    const elRect = el.getBoundingClientRect();
    const containerRect = container.value.getBoundingClientRect();

    indicatorX.value = elRect.left - containerRect.left;
    indicatorWidth.value = elRect.width;
}

function setActive(i: number) {
    active.value = i;
    emit('update:modelValue', i);
    nextTick(updateIndicator);
}

onMounted(() => {
    if (container.value) {
        btns = Array.from(container.value.querySelectorAll('button'));
        nextTick(() =>
            requestIdleCallback(() => requestAnimationFrame(updateIndicator)),
        );
    }
});

// ✅ 关键：暴露 active 给父组件访问
defineExpose({
    active,
});
</script>
