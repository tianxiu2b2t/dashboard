<template>
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
        <div
            class="bg-gradient-to-r dark:bg-gradient-to-r from-rose-50 dark:from-rose-950 to-pink-50 dark:to-pink-950 rounded-xl shadow-md border border-rose-100 dark:border-rose-900 p-6 text-center transition-all duration-300 hover:shadow-lg hover:translate-y-[-5px]"
        >
            <div class="py-3">
                <h5
                    class="text-rose-600 dark:text-rose-400 text-sm font-medium"
                >
                    已爬取总数
                </h5>
                <h3
                    class="text-2xl font-bold text-rose-800 dark:text-rose-200 transition-all duration-500 hover:text-rose-600 dark:hover:text-rose-400"
                >
                    {{ prop.value?.app_count.total || 0 }}
                </h3>
            </div>
        </div>
        <div
            class="bg-gradient-to-r dark:bg-gradient-to-r from-orange-50 to-amber-50 dark:from-orange-950 dark:to-amber-950 rounded-xl shadow-md border border-orange-100 dark:border-orange-900 p-6 text-center transition-all duration-300 hover:shadow-lg hover:translate-y-[-5px]"
        >
            <div class="py-3">
                <h5
                    class="text-amber-600 dark:text-amber-400 text-sm font-medium"
                >
                    应用总数
                </h5>
                <h3
                    class="text-2xl font-bold text-amber-800 dark:text-amber-200 transition-all duration-500 hover:text-amber-600 dark:hover:text-amber-400"
                >
                    {{ prop.value?.app_count.apps || 0 }}
                </h3>
            </div>
        </div>
        <div
            class="bg-gradient-to-r dark:bg-gradient-to-r from-emerald-50 to-teal-50 dark:from-emerald-950 dark:to-teal-950 rounded-xl shadow-md border border-emerald-100 dark:border-emerald-900 p-6 text-center transition-all duration-300 hover:shadow-lg hover:translate-y-[-5px]"
        >
            <div class="py-3">
                <h5
                    class="text-emerald-600 dark:text-emerald-400 text-sm font-medium"
                >
                    元服务总数
                </h5>
                <h3
                    class="text-2xl font-bold text-emerald-800 dark:text-emerald-200 transition-all duration-500 hover:text-emerald-600 dark:hover:text-emerald-400"
                >
                    {{ prop.value?.app_count.atomic_services || 0 }}
                </h3>
            </div>
        </div>
        <div
            class="bg-gradient-to-r dark:bg-gradient-to-r from-indigo-50 to-violet-50 dark:from-indigo-950 dark:to-violet-950 rounded-xl shadow-md border dark:border-indigo-900 p-6 text-center transition-all duration-300 hover:shadow-lg hover:translate-y-[-5px]"
        >
            <div class="py-3">
                <h5
                    class="text-indigo-600 dark:text-indigo-600 text-sm font-medium"
                >
                    开发者总数
                </h5>
                <h3
                    class="text-2xl font-bold text-indigo-800 dark:text-indigo-200 transition-all duration-500 hover:text-indigo-600 dark:hover:text-indigo-400"
                >
                    {{ prop.value?.developer_count || 0 }}
                </h3>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import type { MarketInfo } from '../types';

const prop = defineProps({
    value: {
        type: Object as () => MarketInfo,
    },
});
</script>
