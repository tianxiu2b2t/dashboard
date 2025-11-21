<template>
    <div
        class="bg-gradient-to-r from-purple-50 to-fuchsia-50 dark:from-purple-950 dark:to-fuchsia-950 rounded-xl shadow-md border border-purple-100 dark:border-purple-900"
        style="height: 100%"
    >
        <div
            class="p-4 border-b border-purple-100 dark:border-purple-900 flex items-center justify-between"
        >
            <div>
                <h5
                    class="text-lg font-semibold text-purple-800 dark:text-purple-200 mb-0"
                >
                    应用下载增长对比
                </h5>
                <p class="text-sm font-semibold">
                    应用对比日期 {{ fromDate || '未知' }} -
                    {{ toDate || '未知' }}
                </p>
            </div>
            <div class="flex gap-2">
                <select
                    v-model="priorDays"
                    class="text-sm border rounded px-2 py-1 bg-purple dark:bg-purple-800 dark:text-white"
                >
                    <option value="1">最近 1 天</option>
                    <option value="7">最近 7 天</option>
                    <option value="30">最近 30 天</option>
                </select>
                <select
                    v-model="sortedBy"
                    class="text-sm border rounded px-2 py-1 bg-purple dark:bg-purple-800 dark:text-white"
                >
                    <option value="increment">下载增长量</option>
                    <option value="prior">增长前下载量</option>
                    <option value="current">增长后下载量</option>
                </select>
            </div>
        </div>
        <div class="overflow-x-auto">
            <div
                class="p-2 chart-container"
                id="DownloadIncreaseCompareChart"
                :key="`${darkMode}`"
                :style="isVertical ? verticalStyles : styles"
            >
                <VChart
                    :option="growthChartOptions"
                    :theme="darkMode ? 'dark' : 'light'"
                    autoresize
                    ref="chartRef"
                />
            </div>
        </div>
        <div class="flex justify-end items-center gap-2 px-4 pb-2 mt-4">
            <button
                class="px-3 py-1 rounded border text-sm bg-purple-100 dark:bg-purple-900"
                :disabled="page === 0"
                @click="page--"
            >
                上一页
            </button>
            <span
                class="text-sm font-medium text-purple-700 dark:text-purple-300"
            >
                第 {{ page + 1 }} 页 / 共 {{ totalPages }} 页
            </span>
            <input
                type="number"
                v-model.number="inputPage"
                min="1"
                :max="totalPages"
                class="w-16 px-2 py-1 border rounded text-sm bg-purple-50 dark:bg-purple-900 dark:text-white"
            />
            <button
                class="px-3 py-1 rounded border text-sm bg-purple-100 dark:bg-purple-900"
                :disabled="inputPage < 1 || inputPage > totalPages"
                @click="page = inputPage - 1"
            >
                跳转
            </button>
            <button
                class="px-3 py-1 rounded border text-sm bg-purple-100 dark:bg-purple-900"
                :disabled="page + 1 >= totalPages"
                @click="page++"
            >
                下一页
            </button>
        </div>
    </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, onMounted, ref, watch, computed } from 'vue';
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { BarChart } from 'echarts/charts';
import {
    GridComponent,
    TooltipComponent,
    LegendComponent,
    DataZoomComponent,
} from 'echarts/components';
import { darkMode } from '../constants';
import type {
    RankingsDownloadIncrease,
    RankingsDownloadIncreaseType,
} from '../types';
import { formatNumber } from '../utils';
import { fetchIconUrl, fetchRankingDownloadIncrease } from '../api';
import { useRouter } from 'vue-router';

use([
    CanvasRenderer,
    BarChart,
    GridComponent,
    TooltipComponent,
    LegendComponent,
    DataZoomComponent,
]);

const VChart = defineAsyncComponent(() => import('vue-echarts'));
const downloadIncreaseData = ref<RankingsDownloadIncrease[]>([]);
const growthChartOptions = ref({});
const sortedBy = ref<RankingsDownloadIncreaseType>('increment');
const priorDays = ref(1);
const sortKeys: Record<RankingsDownloadIncreaseType, string> = {
    increment: 'download_increment',
    prior: 'prior_download_count',
    current: 'current_download_count',
};
const styles = ref({
    'min-width': '1800px',
    height: '384px',
});
const verticalStyles = ref({
    width: '100%',
    height: '1227px',
});
const fromDate = ref<string | undefined>();
const toDate = ref<string | undefined>();
const isVertical = ref(false);
const observer = new ResizeObserver(() => setVertical());
const chartRef = ref();
const router = useRouter();

const pageSize = ref(20);
const page = ref(0);
const inputPage = ref(1);
const totalPages = computed(() =>
    Math.ceil(downloadIncreaseData.value.length / pageSize.value),
);
watch(page, () => {
    inputPage.value = page.value + 1;
});

function setVertical() {
    isVertical.value = window.innerHeight > window.innerWidth;
}

async function refreshData() {
    const resp = await fetchRankingDownloadIncrease({
        days: priorDays.value,
    });
    downloadIncreaseData.value = resp.data;
    page.value = 0;
}

watch(chartRef, () => {
    chartRef.value?.chart.on('click', (params: any) => {
        router.push(`/app/${params.data.app_id}`);
    });
});

onMounted(() => {
    observer.observe(document.documentElement);
    setVertical();
    refreshData();
});

watch(priorDays, refreshData);

watch(
    [downloadIncreaseData, sortedBy, isVertical, darkMode, page],
    async () => {
        fromDate.value = downloadIncreaseData.value[0]?.prior_period_date;
        toDate.value =
            downloadIncreaseData.value[
                downloadIncreaseData.value.length - 1
            ]?.current_period_date;

        const sortedKey = sortKeys[
            sortedBy.value
        ] as keyof RankingsDownloadIncrease;
        const sortedData = downloadIncreaseData.value.sort(
            (a, b) => (b[sortedKey] as number) - (a[sortedKey] as number),
        );
        const pagedData = sortedData.slice(
            page.value * pageSize.value,
            (page.value + 1) * pageSize.value,
        );
        const data = isVertical.value ? pagedData.reverse() : pagedData;
        const max = Math.max(...data.map((item) => item[sortedKey] as number));

        let xAxis = {
            type: 'category',
            data: data.map((item) => item.name),
            axisLabel: {
                rotate: 30,
                color: darkMode.value ? '#ddd' : '#333',
            },
        };
        let yAxis = {
            type: 'value',
            axisLabel: { color: darkMode.value ? '#ddd' : '#333' },
            max: isVertical.value ? max * 1.4 : undefined,
        };

        const icons: Record<string, string> = {};
        await Promise.all(
            data.map((item) =>
                fetchIconUrl({
                    app_id: item.app_id,
                    pkg_name: undefined,
                }).then((res) => (icons[item.app_id] = res)),
            ),
        );

        growthChartOptions.value = {
            backgroundColor: 'transparent',
            tooltip: {
                trigger: 'axis',
                axisPointer: { type: 'shadow' },
            },
            grid: {
                left: '4%',
                right: isVertical.value ? '4%' : '2%',
                top: isVertical.value ? '2%' : '8%',
                bottom: '5%',
            },
            xAxis: isVertical.value ? yAxis : xAxis,
            yAxis: isVertical.value ? xAxis : yAxis,
            dataZoom: {
                type: 'slider',
                show: true,
                ...(isVertical.value
                    ? { yAxisIndex: [0], xAxisIndex: [] }
                    : { xAxisIndex: [0], yAxisIndex: [] }),
                maxSpan: (20 / data.length) * 100,
                minSpan: (2 / data.length) * 100,
                start: isVertical.value ? 100 - (20 / data.length) * 100 : 0,
                end: isVertical.value ? 100 : (20 / data.length) * 100,
            },
            series: [
                {
                    name: '下载量',
                    type: 'bar',
                    data: data.map((item) => ({
                        value: item[sortedKey] as number,
                        app_id: item.app_id,
                    })),
                    itemStyle: {
                        color: '#6366f1',
                    },
                    label: {
                        show: true,
                        position: isVertical.value ? 'right' : 'top',
                        formatter: (params: any) =>
                            `{icon${params.dataIndex}|}${isVertical.value ? '' : '\n'}{value${params.dataIndex}|${formatNumber(params.value)}}`,
                        rich: Object.fromEntries(
                            data.map((item, index) => [
                                `icon${index}`,
                                {
                                    height: 24,
                                    width: 24,
                                    backgroundColor: {
                                        image: icons[item.app_id],
                                    },
                                },
                            ]),
                        ),
                    },
                },
            ],
        };
    },
);

defineExpose({
    refreshData,
});
</script>
