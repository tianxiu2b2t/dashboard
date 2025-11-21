<template>
    <table class="w-full text-left border-collapse">
        <thead>
            <tr
                class="bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 text-sm"
            >
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700 w-32"
                >
                    图标
                </th>
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700"
                >
                    包名
                </th>
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700"
                >
                    应用名称
                </th>
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700"
                >
                    下载量
                </th>
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700"
                >
                    大小
                </th>
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700"
                >
                    列出时间
                </th>
                <th
                    class="px-4 py-2 border-b border-gray-300 dark:border-gray-700"
                >
                    状态
                </th>
            </tr>
        </thead>
        <tbody>
            <tr
                v-for="(item, index) in props.apps"
                :key="index"
                class="border-b border-gray-200 dark:border-gray-700 text-sm hover:cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-800"
                v-on:click="openDetail(item.full_info?.app_id)"
            >
                <!-- 图标 -->
                <td class="px-4 py-2 text-gray-800 dark:text-gray-200">
                    <div v-if="item.full_info?.icon_url">
                        <img
                            :src="item.full_info.icon_url"
                            alt="icon"
                            class="max-w-[32px] max-h-[32px] object-contain rounded"
                        />
                    </div>
                    <span v-else class="text-gray-400 italic">—</span>
                </td>

                <!-- 包名 -->
                <td
                    class="px-4 py-2 text-gray-800 dark:text-gray-200 font-mono"
                >
                    {{ item.pkg_name }}
                </td>

                <!-- 应用名称 -->
                <td class="px-4 py-2 text-gray-800 dark:text-gray-200">
                    <span v-if="item.full_info?.name">{{
                        item.full_info.name
                    }}</span>
                    <span
                        v-else-if="item.exists === false"
                        class="text-red-500 italic"
                        >未找到</span
                    >
                    <span v-else class="text-gray-400 italic">加载中...</span>
                </td>

                <!-- 下载量 -->
                <td class="px-4 py-2 text-gray-800 dark:text-gray-200">
                    <span v-if="item.full_info?.download_count !== undefined">
                        {{ formatNumber(item.full_info.download_count) }}
                    </span>
                    <span v-else class="text-gray-400 italic">—</span>
                </td>

                <!-- 应用大小 -->
                <td class="px-4 py-2 text-gray-800 dark:text-gray-200">
                    <span v-if="item.full_info?.size_bytes !== undefined">
                        {{ formatSize(item.full_info?.size_bytes || 0) }}
                    </span>
                    <span v-else class="text-gray-400 italic">—</span>
                </td>

                <!-- 列出时间 -->
                <td class="px-4 py-2 text-gray-800 dark:text-gray-200">
                    <span v-if="item.full_info?.listed_at">
                        {{
                            new Date(
                                item.full_info.listed_at,
                            ).toLocaleDateString()
                        }}
                    </span>
                    <span v-else class="text-gray-400 italic">—</span>
                </td>

                <!-- 是否新应用 -->
                <td class="px-4 py-2 text-gray-800 dark:text-gray-200">
                    <span
                        v-if="item.new_app === true"
                        class="text-green-600 font-semibold"
                        >新应用！</span
                    >
                    <span
                        v-else-if="item.new_app === false"
                        class="text-gray-500"
                        >已存在</span
                    >
                    <span v-else class="text-gray-400 italic">—</span>
                </td>
            </tr>
        </tbody>
    </table>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import type { SubmitParseResult } from '../types';
import { formatNumber, formatSize } from '../utils';

const router = useRouter();
const props = defineProps({
    apps: {
        type: Array as () => SubmitParseResult[],
    },
});
function openDetail(app_id?: string) {
    if (!app_id) return;
    router.push(`/app/${app_id}`);
}
</script>
