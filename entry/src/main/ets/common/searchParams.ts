import { ref } from 'vue';
import {
    defaultAppListParams,
    type AppListParams,
    type AppInfo,
    type AppListSortType,
} from '../common/types';

export const searchText = ref('');
export const searchKey = ref<AppListParams['search_key']>('name');
export const exactMatch = ref(false);
export const excludeHuawei = ref(false);
export const excludeAtomic = ref(false);

// 排序相关
export const sortKey = ref<AppListSortType>('download_count');
export const sortDesc = ref<AppListParams['desc']>(true);

// 分页相关
export const currentPage = ref(1);
export const pageSize = ref(defaultAppListParams.page_size || 20);
export const totalCount = ref(0);
export const apps = ref<AppInfo[]>([]);
export const loaded = ref(false);

export function resetSearchParams() {
    searchText.value = '';
    searchKey.value = 'name';
    exactMatch.value = false;
    excludeHuawei.value = false;
    excludeAtomic.value = false;
    sortKey.value = 'download_count';
    sortDesc.value = true;
    currentPage.value = 1;
    pageSize.value = defaultAppListParams.page_size || 20;
    totalCount.value = 0;
}
