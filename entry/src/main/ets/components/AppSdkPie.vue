<template>
    <div
        class="bg-gradient-to-r from-purple-50 to-fuchsia-50 dark:from-purple-950 dark:to-fuchsia-950 rounded-xl shadow-md border border-purple-100 dark:border-purple-900"
        style="height: 100%"
    >
        <div class="p-4 border-b border-purple-100 dark:border-purple-900">
            <h5
                class="text-lg font-semibold text-purple-800 dark:text-purple-200 mb-0"
            >
                {{ title }}
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
import type { SdkPie } from '../types';
import { formatSDKVersion } from '../utils';
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
        type: Array as () => SdkPie[],
        default: () => [],
    },
    title: {
        type: String,
        default: '评分分布',
    },
});

watch(
    () => props.value,
    (newVal) => {
        let legendDatas = newVal.map((item) => formatSDKVersion(item[0]));
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
                data: legendDatas,
            },
            series: [
                {
                    name: '评分分布',
                    type: 'pie',
                    radius: '48%',
                    center: ['50%', '30%'],
                    label: {
                        formatter: '{b}: {c} ({d}%)',
                    },
                    data: newVal.map((item) => ({
                        value: item[1],
                        name: formatSDKVersion(item[0]),
                    })),
                },
            ],
        };
    },
);
</script>
