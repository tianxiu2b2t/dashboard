import {
    useExpiringStorage,
    type ExpiringStorage,
} from '../common/useExpiringStorage';
import { got } from '../common/constants';
import {
    defaultAppListParams,
    defaultRankingsDownloadIncreaseParams,
    type AppDetailInfo,
    type AppIconResponse,
    type appIdOrPkgName,
    type AppInfo,
    type AppListInfo,
    type AppListParams,
    type BaseAPIResponse,
    type CommentInfo,
    type MarketInfo,
    type RankingsDownloadIncrease,
    type RankingsDownloadIncreaseParams,
    type RatingInfo,
    type SdkPie,
    type SubmitAppBody,
    type SubmitParseResult,
    type SubmitSubstanceResponse,
} from './types';
// import type {
//     APIResponse,
//     AppDetail,
//     AppDetailMetric,
//     AppIconResponse,
//     AppList,
//     AppListParams,
//     MarkgetInfo,
//     RankingsDownloadIncrease,
//     RankingsDownloadIncreaseParams,
//     SdkPie,
//     StarCharts,
//     TopDownloadApp,
//     TopDownloadParams,
// } from './types';
// import {
//     defaultAppListParams,
//     defaultRankingsDownloadIncreaseParams,
// } from './types';

const iconUrlsCache = new Map<string, ExpiringStorage<string>>();
const appIdPkgMappings =
    useExpiringStorage<Record<string, string>>('appIdPkgMappings');
const iconUrlCacheTTL = 1000 * 60 * 60 * 24 * 1;

export async function marketInfo() {
    const data = (await (
        await got.get('market_info')
    ).json()) as BaseAPIResponse;
    return data.data as MarketInfo;
}

export async function topDownloadHuawei() {
    return (
        await fetchAppList({
            page_size: 30,
            desc: true,
        })
    ).data;
}

export async function topDownloadWithoutHuawei() {
    return (
        await fetchAppList({
            page_size: 30,
            desc: true,
            exclude_huawei: true,
            exclude_atomic: true,
        })
    ).data;
}

export async function starCharts() {
    const data = (await (
        await got.get('charts/rating')
    ).json()) as BaseAPIResponse;
    return data.data as RatingInfo;
}

export async function fetchAppList(params?: AppListParams) {
    const merged = {
        ...defaultAppListParams,
        ...(params || {}),
    };
    // pop merged page
    const page = merged.page || 1;
    delete merged.page;
    const resp = await got.get(`apps/list/${page}`, {
        searchParams: merged,
    });
    const data = ((await resp.json()) as BaseAPIResponse).data as AppListInfo;
    data.data.forEach((app) => {
        setIconUrl(app.app_id, app.pkg_name, app.icon_url);
    });
    return data;
}

export async function fetchAppDetail(appId: string) {
    const data = (
        (await (
            await got.get(`apps/app_id/${appId}`)
        ).json()) as BaseAPIResponse
    ).data as AppDetailInfo;
    setIconUrl(appId, data.full_info.pkg_name, data.full_info.icon_url);
    return data;
}

export async function fetchAppMetric(appPackage: string) {
    const data = (await (
        await got.get(`apps/metrics/${appPackage}`)
    ).json()) as BaseAPIResponse;
    return data.data as AppInfo[];
}

export async function fetchMinSdkPie() {
    const data = (await (
        await got.get(`charts/min_sdk`)
    ).json()) as BaseAPIResponse;
    return data.data as SdkPie[];
}

export async function fetchTargetSdkPie() {
    const data = (await (
        await got.get(`charts/target_sdk`)
    ).json()) as BaseAPIResponse;
    return data.data as SdkPie[];
}

export async function fetchRankingDownloadIncrease(
    params?: RankingsDownloadIncreaseParams,
) {
    const data = (await (
        await got.get(`rankings/download_increase`, {
            searchParams: {
                ...defaultRankingsDownloadIncreaseParams,
                ...params,
            },
        })
    ).json()) as BaseAPIResponse<RankingsDownloadIncrease[]>;
    return data;
}

function setIconUrl(appId: string, pkg_name: string, iconUrl: string) {
    const cached = useExpiringStorage<string>(appId, {
        ttlMs: iconUrlCacheTTL,
    });
    cached.data.value = iconUrl;
    iconUrlsCache.set(`${appId}-${pkg_name}`, cached);
    appIdPkgMappings.data.value = appIdPkgMappings.data.value || {};
    appIdPkgMappings.data.value[pkg_name] = appId;
}
function getIconUrl(appId: string): ExpiringStorage<string> {
    let cached = iconUrlsCache.get(appId);
    if (cached) {
        return cached;
    }
    cached = useExpiringStorage<string>(appId, {
        ttlMs: iconUrlCacheTTL,
    });
    iconUrlsCache.set(appId, cached);
    return cached;
}

export async function fetchIconUrl(params: appIdOrPkgName) {
    let appId: string | undefined = params.app_id;

    // 尝试从映射中获取 appId
    if (!appId && params.pkg_name && appIdPkgMappings.data.value) {
        appId = appIdPkgMappings.data.value[params.pkg_name];
    }

    // 如果仍然没有 appId，则通过 pkg_name 请求 icon
    if (appId === undefined || !appId) {
        const { data } = (await got
            .get('apps/icon', {
                searchParams: { pkg_name: params.pkg_name },
            })
            .json()) as BaseAPIResponse;

        const iconData = data as AppIconResponse;
        setIconUrl(iconData.app_id, iconData.pkg_name, iconData.icon_url);
        return iconData.icon_url;
    }

    // 尝试从缓存获取 icon
    const cachedIcon = getIconUrl(appId).data.value;
    if (cachedIcon) return cachedIcon;

    // 如果缓存没有，则通过 app_id 请求 icon
    const { data } = (await got
        .get('apps/icon', {
            searchParams: { app_id: appId },
        })
        .json()) as BaseAPIResponse;

    const iconData = data as AppIconResponse;
    setIconUrl(iconData.app_id, iconData.pkg_name, iconData.icon_url);
    return iconData.icon_url;
}

export async function submitApp(
    params: SubmitAppBody,
): Promise<AppDetailInfo | undefined> {
    const data = (await (
        await got.post('submit', {
            json: params,
        })
    ).json()) as BaseAPIResponse;
    if (!data.success) {
        return undefined;
    }
    return data.data as AppDetailInfo;
}

export async function submitSubstance(
    substance_id: string,
    comment?: CommentInfo,
): Promise<SubmitSubstanceResponse | undefined> {
    const data = (await (
        await got.post(`submit_substance/${substance_id}`, {
            json: {
                comment,
            },
        })
    ).json()) as BaseAPIResponse;
    if (!data.success) {
        return undefined;
    }
    return data.data;
}

export async function fetchAppIdFromPkg(
    pkg_name: string,
): Promise<string | undefined> {
    if (appIdPkgMappings.data.value && appIdPkgMappings.data.value[pkg_name]) {
        return appIdPkgMappings.data.value[pkg_name];
    }
    // fetch icon
    await fetchIconUrl({ pkg_name, app_id: undefined });
    return (appIdPkgMappings.data.value ?? {})[pkg_name];
}

export async function fetchAppInfoFromPkg(
    pkg_name: string,
): Promise<SubmitParseResult> {
    //
    const resp = (await (
        await got.get(`apps/pkg_name/${pkg_name}`)
    ).json()) as BaseAPIResponse;
    const data = resp.data as AppDetailInfo;
    return {
        pkg_name: data.full_info.pkg_name,
        new_app: data.new_app,
        exists: data.get_data,
        full_info: data.full_info,
    };
}

export async function fetchChangelog(): Promise<string> {
    const resp = await (await got.get('changelog')).text();
    return resp;
}
