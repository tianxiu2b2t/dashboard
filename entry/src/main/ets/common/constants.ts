import ky from 'ky';
import { ref } from 'vue';
import { type BaseAPIResponse, type ICP } from './types';
import { BASE_API } from './dynmaticAPI';
import { useExpiringStorage } from '../common/useExpiringStorage';
import { ICPInfo } from '../common/types';

export const got = ky.extend({
    prefixUrl: window.location.origin + BASE_API + '/',
    hooks: {
        afterResponse: [
            async (_, __, response) => {
                if (!response.type.includes('application/json')) {
                    return;
                }
                const data = (await response.json()) as BaseAPIResponse;
                // 获取最后一个时间的
                const beforeTimestamp = responseTimestamp.value;
                if (data.timestamp && beforeTimestamp) {
                    responseTimestamp.value = new Date(
                        Math.max(+beforeTimestamp, +new Date(data.timestamp)),
                    );
                } else {
                    responseTimestamp.value = data.timestamp
                        ? new Date(data.timestamp)
                        : null;
                }
            },
        ],
    },
});

export const responseTimestamp = ref<Date | null>();
export const darkMode = ref(false);

(() => {
    const observer = new MutationObserver(() => {
        darkMode.value = document.documentElement.classList.contains('dark');
        localStorage.setItem('darkMode', darkMode.value.toString());
    });
    observer.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ['class'],
    });
    darkMode.value = document.documentElement.classList.contains('dark');
    localStorage.setItem('darkMode', darkMode.value.toString());
})();
export const defaultAppListParams = {
    page_size: 20,
    // 其他默认参数...
};
export const ICPs: ICPInfo[] = [
    {
        domain: 'txit.top',
        icp: '你的ICP备案号'
    },
    // 其他备案信息...
];

export const savedUsername = useExpiringStorage<string>('username');
export const savedSwitched = useExpiringStorage<number>('submit_switched');
