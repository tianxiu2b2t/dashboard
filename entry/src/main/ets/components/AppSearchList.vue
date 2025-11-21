<template>
    <section
        class="bg-gradient-to-r from-amber-50 to-yellow-50 dark:from-amber-950 dark:to-yellow-950 rounded-xl shadow-md border border-amber-100 dark:border-amber-900 mb-6 transition-all duration-300 hover:shadow-lg"
    >
        <div class="p-6">
            <!-- 搜索区域 -->
            <header
                class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4"
            >
                <h5
                    class="text-lg font-semibold text-amber-800 dark:text-amber-200"
                >
                    应用列表
                </h5>
                <div
                    class="flex flex-col sm:flex-row items-start sm:items-center gap-2 w-full sm:w-auto"
                >
                    <InputEdit
                        v-model="searchContent"
                        placeholder="搜索应用"
                        mode="input"
                        wrapperClass="max-w-[180px]"
                        inputClass="text-sm px-3 py-2 leading-[1.5] bg-amber-50 dark:bg-amber-950 placeholder-amber-400 dark:placeholder-amber-600 text-black dark:text-white"
                        labelClass="text-gray-500 dark:text-gray-300"
                        inputWrapperClass="flex-1 min-w-0 border border-amber-200 dark:border-amber-800 rounded-md shadow-sm focus-within:ring-1 focus-within:ring-amber-500 focus-within:border-amber-500"
                    />
                    <select
                        v-model="searchKey"
                        class="px-3 py-2 border border-amber-200 dark:border-amber-800 rounded-md shadow-sm focus:outline-none focus:ring-1 focus:ring-amber-500 focus:border-amber-500 dark:focus:ring-amber-500 dark:focus:border-amber-500 text-sm bg-amber-50 dark:bg-amber-950 text-amber-700 dark:text-amber-300"
                    >
                        <option value="name">应用名称</option>
                        <option value="pkg_name">包名</option>
                        <option value="description">应用描述</option>
                        <option value="app_id">应用 ID</option>
                        <option value="developer_name">开发者名称</option>
                        <option value="dev_en_name">开发者英文名称</option>
                        <option value="supplier">供应商</option>
                        <option value="kind_name">类型名</option>
                        <option value="tag_name">标签名</option>
                        <option value="kind_type_name">应用分类</option>
                    </select>
                    <label
                        class="relative inline-flex items-center cursor-pointer"
                    >
                        <input
                            type="checkbox"
                            v-model="excludeHuawei"
                            class="sr-only peer"
                        />
                        <span
                            class="ml-1 text-sm font-medium text-amber-700 dark:text-amber-300"
                            >排除华为应用</span
                        >
                        <div
                            class="ml-2 relative w-11 h-6 bg-gray-200 dark:bg-gray-800 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-amber-300 dark:peer-focus:ring-amber-700 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white dark:after:bg-white after:border-gray-300 dark:after:border-gray-700 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-600 dark:peer-checked:bg-amber-400"
                        ></div>
                    </label>
                    <label
                        class="relative inline-flex items-center cursor-pointer"
                    >
                        <input
                            type="checkbox"
                            v-model="excludeAtomic"
                            class="sr-only peer"
                        />
                        <span
                            class="ml-1 text-sm font-medium text-amber-700 dark:text-amber-300"
                            >排除元服务</span
                        >
                        <div
                            class="ml-2 relative w-11 h-6 bg-gray-200 dark:bg-gray-800 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-amber-300 dark:peer-focus:ring-amber-700 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white dark:after:bg-white after:border-gray-300 dark:after:border-gray-700 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-600 dark:peer-checked:bg-amber-400"
                        ></div>
                    </label>
                    <label
                        class="relative inline-flex items-center cursor-pointer"
                    >
                        <input
                            type="checkbox"
                            v-model="exactMatch"
                            class="sr-only peer"
                        />
                        <span
                            class="ml-1 text-sm font-medium text-amber-700 dark:text-amber-300"
                            >精确匹配</span
                        >
                        <div
                            class="ml-2 relative w-11 h-6 bg-gray-200 dark:bg-gray-800 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-amber-300 dark:peer-focus:ring-amber-700 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white dark:after:bg-white after:border-gray-300 dark:after:border-gray-700 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-600 dark:peer-checked:bg-amber-400"
                        ></div>
                    </label>
                    <button
                        @click="handleSearch"
                        class="px-4 py-2 bg-gradient-to-r dark:bg-gradient-to-r from-amber-500 to-yellow-500 dark:from-amber-500 dark:to-yellow-500 text-white text-sm font-medium rounded-xl hover:from-amber-600 hover:to-yellow-600 dark:hover:from-amber-400 dark:hover:to-yellow-400 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:ring-offset-2 transition-all duration-300 transform hover:scale-105 hover:shadow-md"
                    >
                        搜索
                    </button>
                    <button
                        @click="resetSearch"
                        class="px-4 py-2 bg-gradient-to-r from-gray-500 to-gray-600 dark:from-gray-500 dark:to-gray-400 text-white text-sm font-medium rounded-xl hover:from-gray-600 hover:to-gray-700 dark:hover:from-gray-400 dark:hover:to-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 transition-all duration-300 transform hover:scale-105 hover:shadow-md"
                        title="清除所有搜索条件"
                    >
                        重置搜索
                    </button>
                </div>
            </header>

            <!-- 表格区域 -->
            <div class="overflow-x-auto">
                <table
                    class="min-w-full divide-y divide-amber-200"
                    style="min-width: 1780px; width: 100%"
                >
                    <thead
                        class="bg-gradient-to-r from-amber-100 to-yellow-100 dark:from-amber-900 dark:to-yellow-900"
                    >
                        <tr>
                            <th
                                class="px-4 py-3 w-[60px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider"
                            >
                                序号
                            </th>
                            <th
                                class="px-4 py-3 w-[180px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider"
                            >
                                应用名称
                            </th>
                            <th
                                class="px-4 py-3 w-[220px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider"
                            >
                                开发者
                            </th>
                            <th
                                class="px-4 py-3 w-[180px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider"
                            >
                                分类
                            </th>
                            <th
                                class="px-4 py-3 w-[140px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider"
                            >
                                评分
                            </th>
                            <th
                                class="px-4 py-3 w-[120px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider cursor-pointer hover:bg-amber-200 dark:hover:bg-amber-800"
                                @click="sortBy('total_star_rating_count')"
                            >
                                评分数量
                                <span
                                    class="ml-1 font-bold text-amber-400 dark:text-amber-600"
                                    >{{
                                        sortKey === 'total_star_rating_count'
                                            ? sortDesc
                                                ? '↓'
                                                : '↑'
                                            : '↕'
                                    }}</span
                                >
                            </th>
                            <th
                                class="px-4 py-3 w-[120px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider cursor-pointer hover:bg-amber-200 dark:hover:bg-amber-800"
                                @click="sortBy('download_count')"
                            >
                                下载量
                                <span
                                    class="ml-1 font-bold text-amber-400 dark:text-amber-600"
                                    >{{
                                        sortKey === 'download_count'
                                            ? sortDesc
                                                ? '↓'
                                                : '↑'
                                            : '↕'
                                    }}</span
                                >
                            </th>
                            <th
                                class="px-4 py-3 w-[120px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider cursor-pointer hover:bg-amber-200 dark:hover:bg-amber-800"
                                @click="sortBy('size_bytes')"
                            >
                                大小
                                <span
                                    class="ml-1 font-bold text-amber-400 dark:text-amber-600"
                                    >{{
                                        sortKey === 'size_bytes'
                                            ? sortDesc
                                                ? '↓'
                                                : '↑'
                                            : '↕'
                                    }}</span
                                >
                            </th>
                            <th
                                class="px-4 py-3 w-[160px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider cursor-pointer hover:bg-amber-200 dark:hover:bg-amber-800"
                                @click="sortBy('metrics_created_at')"
                            >
                                上次数据更新
                                <span
                                    class="ml-1 font-bold text-amber-400 dark:text-amber-600"
                                    >{{
                                        sortKey === 'metrics_created_at'
                                            ? sortDesc
                                                ? '↓'
                                                : '↑'
                                            : '↕'
                                    }}</span
                                >
                            </th>
                            <th
                                class="px-4 py-3 w-[140px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider cursor-pointer hover:bg-amber-200 dark:hover:bg-amber-800"
                                @click="sortBy('created_at')"
                            >
                                应用爬取时间
                                <span
                                    class="ml-1 font-bold text-amber-400 dark:text-amber-600"
                                    >{{
                                        sortKey === 'created_at'
                                            ? sortDesc
                                                ? '↓'
                                                : '↑'
                                            : '↕'
                                    }}</span
                                >
                            </th>
                            <th
                                class="px-4 py-3 w-[160px] text-left text-xs font-medium text-amber-700 dark:text-amber-300 uppercase tracking-wider cursor-pointer hover:bg-amber-200 dark:hover:bg-amber-800"
                                @click="sortBy('listed_at')"
                            >
                                应用上架时间
                                <span
                                    class="ml-1 font-bold text-amber-400 dark:text-amber-600"
                                    >{{
                                        sortKey === 'listed_at'
                                            ? sortDesc
                                                ? '↓'
                                                : '↑'
                                            : '↕'
                                    }}</span
                                >
                            </th>
                        </tr>
                    </thead>
                    <tbody
                        class="bg-gradient-to-r from-amber-50 to-yellow-50 dark:from-amber-950 dark:to-yellow-950 divide-y divide-amber-100 dark:divide-amber-900"
                    >
                        <tr v-if="loading">
                            <td
                                colspan="11"
                                class="text-center py-6 text-amber-600 dark:text-amber-400 text-sm"
                            >
                                加载中...
                            </td>
                        </tr>
                        <tr v-else-if="apps.length === 0">
                            <td
                                colspan="11"
                                class="text-center py-6 text-amber-600 dark:text-amber-400 text-sm"
                            >
                                暂无数据
                            </td>
                        </tr>
                        <tr
                            v-for="(app, index) in apps"
                            :key="app.app_id"
                            class="hover:bg-gray-50 dark:hover:bg-gray-950 cursor-pointer transition-colors"
                            @click="goToAppDetail(app.app_id)"
                        >
                            <td
                                class="px-4 py-3 text-sm text-gray-900 dark:text-gray-100"
                            >
                                {{ index + 1 + (currentPage - 1) * pageSize }}
                            </td>
                            <td class="px-4 py-3 flex items-center">
                                <img
                                    :src="app.icon_url"
                                    class="w-6 h-6 mr-2"
                                    alt="icon"
                                />
                                <span
                                    class="font-medium text-gray-900 dark:text-gray-100"
                                    >{{ app.name }}</span
                                >
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-500 dark:text-gray-300"
                                @click.stop="
                                    filteredByDeveloper(app.developer_name)
                                "
                                v-if="!!app.developer_name"
                            >
                                <span
                                    class="developer-name inline-flex items-center px-3 py-1 cursor-pointer border border-blue-200 dark:border-blue-800 rounded-lg bg-blue-50 hover:bg-blue-100 hover:border-blue-400 hover:text-blue-700 dark:bg-blue-950 dark:hover:bg-blue-900 dark:hover:border-blue-600 dark:hover:text-blue-300 transition-all duration-200 shadow-sm hover:shadow-md text-blue-600 dark:text-blue-400"
                                    title="点击以搜索该开发者开发的app"
                                >
                                    {{ app.developer_name }}
                                </span>
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-500 dark:text-gray-300"
                                v-if="!app.developer_name"
                            >
                                —
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-blue-800 dark:text-blue-200"
                            >
                                <span
                                    class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full bg-blue-100 dark:bg-blue-900"
                                    >{{ app.kind_type_name }}-{{
                                        app.kind_name
                                    }}-{{ app.tag_name }}</span
                                >
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-900 dark:text-gray-100 flex items-center gap-1"
                            >
                                <span
                                    v-for="i in Math.floor(
                                        +new Number(app.average_rating || 0),
                                    )"
                                    :key="i"
                                >
                                    ★
                                </span>
                                <span
                                    v-for="i in 5 -
                                    Math.floor(
                                        +new Number(app.average_rating || 0),
                                    )"
                                    :key="i"
                                >
                                    ☆
                                </span>
                                <span>
                                    {{
                                        +new Number(app.average_rating || 0)
                                    }}</span
                                >
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-900 dark:text-gray-100"
                            >
                                {{
                                    formatNumber(
                                        app.total_star_rating_count || 0,
                                    )
                                }}
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-900 dark:text-gray-100"
                            >
                                {{ formatNumber(app.download_count) }}
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-500 dark:text-gray-300"
                            >
                                {{ formatSize(app.size_bytes || 0) }}
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-500 dark:text-gray-300"
                            >
                                {{ formatDate(app.metrics_created_at) }}
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-500 dark:text-gray-300"
                            >
                                {{ formatDate(app.created_at) }}
                            </td>
                            <td
                                class="px-4 py-3 text-sm text-gray-500 dark:text-gray-300"
                            >
                                {{ formatDate(app.listed_at) }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- 分页区域 -->
            <nav
                v-if="totalPages > 1 && !loading"
                aria-label="Page navigation"
                class="mt-6"
            >
                <ul
                    class="flex flex-wrap justify-center items-center space-x-2"
                >
                    <!-- 首页 -->
                    <li v-if="currentPage > 1">
                        <button
                            @click="goToPage(1)"
                            class="px-3 py-2 text-sm rounded-md bg-blue-50 text-blue-700 hover:bg-blue-100 dark:bg-blue-950 dark:text-blue-300 dark:hover:bg-blue-900"
                        >
                            首页
                        </button>
                    </li>

                    <!-- 上一页 -->
                    <li>
                        <button
                            @click="goToPage(currentPage - 1)"
                            :disabled="currentPage === 1"
                            class="px-3 py-2 text-sm rounded-md bg-blue-50 text-blue-700 hover:bg-blue-100 dark:bg-blue-950 dark:text-blue-300 dark:hover:bg-blue-900"
                        >
                            上一页
                        </button>
                    </li>

                    <!-- 中间页码 -->
                    <li v-for="page in visiblePages" :key="page">
                        <button
                            @click="goToPage(page)"
                            :class="
                                page === currentPage
                                    ? 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200 font-bold'
                                    : 'bg-blue-50 text-blue-700 hover:bg-blue-100 dark:bg-blue-950 dark:text-blue-300 dark:hover:bg-blue-900'
                            "
                            class="px-3 py-2 text-sm rounded-md"
                        >
                            {{ page }}
                        </button>
                    </li>

                    <!-- 下一页 -->
                    <li>
                        <button
                            @click="goToPage(currentPage + 1)"
                            :disabled="currentPage === totalPages"
                            class="px-3 py-2 text-sm rounded-md bg-blue-50 text-blue-700 hover:bg-blue-100 dark:bg-blue-950 dark:text-blue-300 dark:hover:bg-blue-900"
                        >
                            下一页
                        </button>
                    </li>

                    <!-- 尾页 -->
                    <li v-if="currentPage < totalPages">
                        <button
                            @click="goToPage(totalPages)"
                            class="px-3 py-2 text-sm rounded-md bg-blue-50 text-blue-700 hover:bg-blue-100 dark:bg-blue-950 dark:text-blue-300 dark:hover:bg-blue-900"
                        >
                            尾页
                        </button>
                    </li>

                    <!-- 跳转页 -->
                    <li class="flex items-center space-x-1">
                        <input
                            v-model="jumpPage"
                            type="number"
                            min="1"
                            :max="totalPages"
                            class="px-2 py-2 text-sm border-blue-300 bg-blue-50 text-blue-900 dark:border-blue-700 dark:bg-blue-950 dark:text-blue-100 rounded-md w-16 text-center"
                        />
                        <button
                            @click="jumpToPage"
                            class="px-3 py-2 text-sm font-medium rounded-md bg-blue-500 dark:bg-blue-800 text-white border-blue-500 hover:bg-blue-600 dark:hover:bg-blue-400"
                        >
                            跳转
                        </button>
                    </li>
                </ul>
            </nav>
        </div>
    </section>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { type AppListParams, type AppListSortType } from '../types';
import { fetchAppList } from '../api';
import { formatNumber, formatSize, formatDate } from '../utils';
import { useRouter } from 'vue-router';
import {
    searchText,
    searchKey,
    exactMatch,
    sortKey,
    sortDesc,
    currentPage,
    pageSize,
    totalCount,
    apps,
    loaded,
    excludeAtomic,
    excludeHuawei,
    resetSearchParams,
} from '../searchParams';
import { debounce } from 'vue-debounce';
import InputEdit from './InputEdit.vue';

const searchContent = ref<string>(searchText.value);
watch(searchContent, (newVal) => {
    searchText.value = newVal;
});

// 数据状态
const loading = ref(false);

const visiblePages = computed(() => {
    const pages: number[] = [];
    const total = totalPages.value;
    const current = currentPage.value;
    const range = 5;

    const start = Math.max(1, current - range);
    const end = Math.min(total, current + range);

    for (let i = start; i <= end; i++) {
        pages.push(i);
    }
    return pages;
});

const router = useRouter();

const jumpPage = ref<number | null>(null);
const debounceInstance = ref<ReturnType<typeof debounce> | null>(null);

function goToAppDetail(appId: string) {
    router.push(`/app/${appId}`);
}

function jumpToPage() {
    if (
        jumpPage.value &&
        jumpPage.value >= 1 &&
        jumpPage.value <= totalPages.value
    ) {
        goToPage(jumpPage.value);
        jumpPage.value = null;
    }
}

function resetSearch() {
    resetSearchParams();
    loadApps();
}

function getCurrentParams(): AppListParams {
    return {
        page: currentPage.value,
        page_size: pageSize.value,
        sort: sortKey.value,
        desc: sortDesc.value,
        search_key: searchText.value ? searchKey.value : undefined,
        search_value: searchText.value || undefined,
        search_exact: searchText.value ? exactMatch.value : undefined,
        exclude_huawei: excludeHuawei.value || undefined,
        exclude_atomic: excludeAtomic.value || undefined,
    };
}

async function debounceLoadApps() {
    apps.value = [];
    loading.value = true;
    const params: AppListParams = getCurrentParams();

    try {
        const result = await fetchAppList(params);
        apps.value = result.data;
        totalCount.value = result.total_count;
    } finally {
        loading.value = false;
    }
    loaded.value = true;
}

// 加载数据
async function loadApps() {
    if (!debounceInstance.value) {
        debounceInstance.value = debounce(debounceLoadApps, 500);
    }
    debounceInstance.value();
}

function filteredByDeveloper(input?: string) {
    if (!input) return;
    searchKey.value = 'developer_name';
    searchText.value = input;
    handleSearch();
}

// 排序点击
function sortBy(key: AppListSortType) {
    if (sortKey.value === key) {
        sortDesc.value = !sortDesc.value;
    } else {
        sortKey.value = key;
        sortDesc.value = true;
    }
    currentPage.value = 1;
    loadApps();
}

// 搜索点击
function handleSearch() {
    currentPage.value = 1;
    loadApps();
}

// 分页跳转
function goToPage(page: number) {
    if (page >= 1 && page <= totalPages.value) {
        currentPage.value = page;
        loadApps();
    }
}

// 总页数
const totalPages = computed(() => {
    return Math.max(1, Math.ceil(totalCount.value / pageSize.value));
});

watch([excludeAtomic, excludeHuawei], loadApps);

// 初始化加载
onMounted(() => {
    if (loaded.value) return;
    loadApps();
});
</script>
