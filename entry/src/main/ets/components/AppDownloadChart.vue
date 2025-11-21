<template>
    <div
        :class="`bg-gradient-to-r ${bgFrom} ${bgTo} dark:${darkBgFrom} dark:${darkBgTo} rounded-xl shadow-md border ${borderColor} dark:${darkBorderColor}`"
        :style="{ height: containerHeight }"
    >
        <div
            class="p-4 border-b"
            :class="`${borderColor} dark:${darkBorderColor}`"
        >
            <h5
                class="text-lg font-semibold"
                :class="`${titleColor} dark:${darkTitleColor}`"
            >
                {{ title }}
            </h5>
        </div>
        <div class="overflow-x-auto">
            <div
                class="p-2 chart-container"
                style="min-width: 2280px; height: 292px"
                :key="`${darkMode}`"
            >
                <VChart
                    ref="chartRef"
                    :option="chartOptions"
                    :theme="darkMode ? 'dark' : 'light'"
                    autoresize
                />
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, watch } from 'vue';
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { BarChart } from 'echarts/charts';
import {
    GridComponent,
    LegendComponent,
    ToolboxComponent,
} from 'echarts/components';
import type { AppInfo } from '../types';
import { useRouter } from 'vue-router';
import { formatNumber } from '../utils';
import { darkMode } from '../constants';

use([
    CanvasRenderer,
    BarChart,
    LegendComponent,
    GridComponent,
    ToolboxComponent,
]);

const VChart = defineAsyncComponent(() => import('vue-echarts'));
const router = useRouter();
const chartOptions = ref({});
const chartRef = ref<typeof VChart>();
const props = defineProps<{
    title: string;
    value: AppInfo[];
    bgFrom: string;
    bgTo: string;
    borderColor: string;
    titleColor: string;
    darkBgFrom: string;
    darkBgTo: string;
    darkBorderColor: string;
    darkTitleColor: string;
    containerHeight?: string;
    yAxisMin?: boolean;
}>();

watch(
    () => props.value,
    (newVal) => {
        const val = newVal.sort((a, b) => b.download_count - a.download_count);
        const xAxisData = val.map((item) => item.name);
        const min = Math.min(...val.map((item) => item.download_count));
        chartOptions.value = {
            backgroundColor: 'transparent',
            xAxis: {
                data: xAxisData,
                axisLabel: { rotate: 22.5 },
            },
            grid: {
                left: '3%',
                right: '2%',
                top: '15%',
                bottom: '3%',
            },
            yAxis: {
                ...(props.yAxisMin
                    ? { min: Math.max(Math.round(min * 0.95), 0) }
                    : {}),
            },
            tooltip: {},
            series: [
                {
                    barWidth: '48px',
                    barGap: '20%',
                    name: '下载数',
                    type: 'bar',
                    label: {
                        show: true,
                        position: 'top',
                        formatter: (params: any) =>
                            `{icon${params.dataIndex}|}\n{value${params.dataIndex}|${formatNumber(params.value)}}`,
                        rich: Object.fromEntries(
                            val.map((item, index) => [
                                `icon${index}`,
                                {
                                    height: 24,
                                    width: 24,
                                    backgroundColor: {
                                        image: item.icon_url,
                                    },
                                },
                            ]),
                        ),
                    },
                    data: val.map((item) => ({
                        value: item.download_count,
                        app_id: item.app_id,
                    })),
                },
            ],
        };
    },
);

watch(chartRef, () => {
    chartRef.value?.chart.on('click', (params: any) => {
        router.push(`/app/${params.data.app_id}`);
    });
});
</script>
