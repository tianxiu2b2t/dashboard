<template>
    <div
        class="bg-gradient-to-r from-purple-50 to-fuchsia-50 dark:from-purple-950 dark:to-fuchsia-950 rounded-xl shadow-md border border-purple-100 dark:border-purple-900"
        style="height: 100%"
    >
        <div class="p-4 border-b border-purple-100 dark:border-purple-900">
            <h5
                class="text-lg font-semibold text-purple-800 dark:text-purple-200 mb-0"
            >
                总应用评分分布
            </h5>
        </div>
        <div
            class="p-2 chart-container"
            style="height: 356px"
            :key="`${darkMode}`"
        >
            <VChart
                :option="chartOptions"
                autoresize
                :theme="darkMode ? 'dark' : 'light'"
            />
        </div>
    </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, watch } from 'vue';
import { use } from 'echarts/core';

import { CanvasRenderer } from 'echarts/renderers';
import { PieChart } from 'echarts/charts';
import {
    GridComponent,
    LegendComponent,
    TooltipComponent,
} from 'echarts/components';
import type { RatingInfo } from '../types';
import { darkMode } from '../constants';

// 注册 ECharts 组件
use([
    CanvasRenderer,
    PieChart,
    LegendComponent,
    GridComponent,
    TooltipComponent,
]);
const VChart = defineAsyncComponent(() => import('vue-echarts'));

const chartOptions = ref({});
const props = defineProps({
    value: {
        type: Object as () => RatingInfo,
        default: () => {},
    },
});

watch(
    () => props.value,
    (newVal) => {
        chartOptions.value = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'item',
                formatter: '{b}: {c} ({d}%)',
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                top: '-8%',
                containLabel: true,
            },
            legend: {
                data: ['无评分', '[1-2]星', '[2-3]星', '[3-4]星', '[4-5]星'],
            },
            series: [
                {
                    name: '评分分布',
                    type: 'pie',
                    radius: '60%',
                    center: ['50%', '40%'],
                    label: {
                        formatter: '{b}: {c} ({d}%)',
                    },
                    data: [
                        { value: newVal.star_1, name: '无评分' },
                        { value: newVal.star_2, name: '[1-2]星' },
                        { value: newVal.star_3, name: '[2-3]星' },
                        { value: newVal.star_4, name: '[3-4]星' },
                        { value: newVal.star_5, name: '[4-5]星' },
                    ],
                },
            ],
        };
    },
);
</script>
