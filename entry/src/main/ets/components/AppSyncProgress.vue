<template>
    <h3 class="text-2xm font-semibold mb-2">同步状态</h3>
    <div class="grid grid-cols-2">
        <p class="font-semibold">
            {{
                data.is_syncing_all
                    ? '正在同步中...'
                    : '距离下次同步时间: ' +
                      formatCountTimeWithUnit(nextSyncCountDown)
            }}
        </p>
        <p class="font-semibold">
            {{ data.is_syncing_all ? '本次同步用时' : '上次同步用时' }}:
            {{ formatCountTimeWithUnit(data.elapsed_time.secs) }}
        </p>
    </div>
    <div class="grid grid-cols-2 mt-2">
        <p>已插入应用数量: {{ formatNumber(data.total_inserted) }}</p>
        <p>共处理应用数量: {{ formatNumber(data.total_processed) }}</p>
        <p>已失败应用数量: {{ formatNumber(data.total_failed) }}</p>
        <p>已跳过应用数量: {{ formatNumber(data.total_skipped) }}</p>
    </div>
    <div
        class="flex items-center justify-between mt-2"
        v-if="data.is_syncing_all"
    >
        <div
            class="sync-progressbar bg-neutral-200 dark:bg-neutral-800 rounded overflow-hidden"
        >
            <div
                class="progressbar-inner bg-sky-300 dark:bg-sky-500 transition-all duration-300"
                :style="{
                    width: `${(data.progress[0] / data.progress[1]) * 100}%`,
                }"
            ></div>
        </div>
        <span class="px-2"></span>
        <p class="whitespace-nowrap">
            {{ formatNumber(data.progress[0]) }}/{{
                formatNumber(data.progress[1])
            }}
            [{{ formatCountTimeWithSpilt(data.elapsed_time.secs) }}&lt;{{
                formatCountTimeWithSpilt(
                    data.estimated_total_time.secs - data.elapsed_time.secs,
                )
            }}]
        </p>
    </div>
</template>

<script lang="ts" setup>
import { onBeforeUnmount, onMounted, ref } from 'vue';
import type { SyncProgress } from '../types';
import {
    formatCountTimeWithSpilt,
    formatCountTimeWithUnit,
    formatNumber,
} from '../utils';
import { BASE_API } from '../dynmaticAPI';

const data = ref<SyncProgress>({
    is_syncing_all: false,
    progress: [0, 0],
    total_processed: 0,
    total_failed: 0,
    total_inserted: 0,
    total_skipped: 0,
    elapsed_time: {
        secs: 0,
        nanos: 0,
    },
    estimated_total_time: {
        secs: 0,
        nanos: 0,
    },
    next_sync_countdown: {
        secs: 0,
        nanos: 0,
    },
});
const nextSyncCountDown = ref<number>(0);
const eventSource = ref<EventSource | null>(null);
const updateNextSyncCountDownTask = ref();

function startNextSyncCountDown() {
    if (updateNextSyncCountDownTask.value !== undefined) {
        clearInterval(updateNextSyncCountDownTask.value);
    }
    updateNextSyncCountDownTask.value = setInterval(() => {
        nextSyncCountDown.value -= 1;
    }, 1000);
}

onMounted(() => {
    eventSource.value = new EventSource(BASE_API + '/sync_status/stream');
    eventSource.value.addEventListener('sync_status', (event) => {
        let msg = JSON.parse(event.data) as SyncProgress;
        if (!msg.is_syncing_all) {
            nextSyncCountDown.value = msg.next_sync_countdown?.secs || 0;
            startNextSyncCountDown();
        }
        data.value = msg;
    });
});

onBeforeUnmount(() => {
    if (eventSource.value) {
        eventSource.value.close();
    }
    clearInterval(updateNextSyncCountDownTask.value);
});
</script>

<style scoped>
.sync-progressbar {
    width: 100%;
    height: 8px;
    border-radius: 10px;
    overflow: hidden;
}

.progressbar-inner {
    height: 100%;
    width: 0%;
}
</style>
