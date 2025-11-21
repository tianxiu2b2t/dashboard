// composables/useExpiringStorage.ts
import { ref, watch } from 'vue';

interface ExpiringStorageOptions {
    ttlMs?: number; // 如果不传，则不设置过期
    keyPrefix?: string; // 可选：自定义前缀
}

export function useExpiringStorage<T>(
    key: string,
    options: ExpiringStorageOptions = {},
) {
    const data = ref<T | undefined>(undefined);
    const { ttlMs, keyPrefix } = options;
    const hasTTL = typeof ttlMs === 'number' && ttlMs > 0;
    const prefix = hasTTL ? (keyPrefix ?? 'expiring') : '';
    const storageKey = prefix ? `${prefix}-${key}` : key;

    function load() {
        const raw = localStorage.getItem(storageKey);
        if (!raw) return;

        try {
            const parsed = JSON.parse(raw);
            if (ttlMs && parsed.expires && Date.now() > parsed.expires) {
                localStorage.removeItem(storageKey);
                data.value = null;
            } else {
                data.value = parsed.value ?? parsed;
            }
        } catch {
            localStorage.removeItem(storageKey);
            data.value = null;
        }
    }

    function save(value: T) {
        const item = ttlMs ? { value, expires: Date.now() + ttlMs } : value;
        localStorage.setItem(storageKey, JSON.stringify(item));
        data.value = value;
    }

    function clear() {
        localStorage.removeItem(storageKey);
        data.value = null;
    }

    load();

    watch(data, () => {
        if (data.value !== undefined) {
            save(data.value);
        }
    });

    return {
        data,
        save,
        clear,
        reload: load,
    };
}

export type ExpiringStorage<T> = ReturnType<typeof useExpiringStorage<T>>;
