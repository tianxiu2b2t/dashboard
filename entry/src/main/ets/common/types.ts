export interface BaseAPIResponse<T = any> {
    success: boolean;
    data: T;
    total?: number;
    limit?: number;
    timestamp: string;
}

export interface SyncProgress {
    is_syncing_all: boolean;
    progress: [number, number];
    total_processed: number;
    total_inserted: number;
    total_skipped: number;
    total_failed: number;
    elapsed_time: {
        secs: number;
        nanos: number;
    };
    estimated_total_time: {
        secs: number;
        nanos: number;
    };
    next_sync_countdown?: {
        secs: number;
        nanos: number;
    };
}

export interface CommentInfo {
    platform?: string;
    user?: string;
    note?: string;
}

export interface MarketInfo {
    app_count: {
        apps: number;
        atomic_services: number;
        total: number;
    };
    crate_version: string;
    developer_count: number;
    page_size_max: number;
    sync_status: SyncProgress;
    user_agent: string;
}

export interface RatingInfo {
    star_1: number;
    star_2: number;
    star_3: number;
    star_4: number;
    star_5: number;
}

export interface AppInfo {
    app_id: string;
    icon_url: string;
    comment?: CommentInfo;
    created_at: string;
    description: string;
    dev_en_name: string;
    developer_name: string;
    download_count: number;
    kind_name: string;
    kind_type_name: string;
    listed_at: string;
    main_device_codes: string[];
    metrics_created_at: string;
    minsdk: number;
    name: string;
    pkg_name: string;
    release_date: number; // 这玩意是 unix timestamp
    size_bytes: number;
    updated_at: string;
    version: string;
    version_code: number;
    supplier: string;
    tag_name: string;
    target_sdk: number;
    compile_sdk_version: number;
    release_countries?: string[];

    // rating
    average_rating?: string;
    full_average_rating?: string;
    only_star_count?: number;
    star_1_rating_count?: number;
    star_2_rating_count?: number;
    star_3_rating_count?: number;
    star_4_rating_count?: number;
    star_5_rating_count?: number;
    total_star_rating_count?: number;
    rating_created_at?: string;
}

export type TopDownloadParams = {
    limit?: number;
    exclude_pattern?: string;
};

export type AppListParams = {
    page?: number;
    sort?: AppListSortType;
    desc?: boolean;
    page_size?: number;
    search_key?: string;
    search_value?: string;
    search_exact?: boolean;
    exclude_huawei?: boolean;
    exclude_atomic?: boolean;
};

export type AppListSortType =
    | 'download_count'
    | 'size_bytes'
    | 'total_star_rating_count'
    | 'metrics_created_at'
    | 'created_at'
    | 'listed_at';

export const defaultAppListParams: AppListParams = {
    page: 1,
    sort: 'download_count',
    desc: true,
    page_size: 20,
};

export interface SdkPie {
    [0]: number;
    [1]: number;
}

export interface RankingsDownloadIncreaseParams {
    days?: number;
    months?: number;
    microseconds?: number;
    limit?: number;
    page?: number;
}

export const defaultRankingsDownloadIncreaseParams: RankingsDownloadIncreaseParams =
    {
        limit: 100,
    };

export interface RankingsDownloadIncrease {
    app_id: string;
    current_download_count: number;
    current_period_date: string;
    download_increment: number;
    name: string;
    pkg_name: string;
    prior_download_count: number;
    prior_period_date: string;
}

export interface RankingsDownloadIncrease {
    app_id: string;
    current_download_count: number;
    current_period_date: string;
    download_increment: number;
    name: string;
    pkg_name: string;
    prior_download_count: number;
    prior_period_date: string;
}

export type RankingsDownloadIncreaseType = 'prior' | 'current' | 'increment';

export interface AppIconResponse {
    app_id: string;
    icon_url: string;
    name: string;
    pkg_name: string;
}

export interface AppListInfo {
    data: AppInfo[];
    page: number;
    page_size: number;
    total_count: number;
    total_pages: number;
}

export interface AppDetailInfo {
    full_info: AppInfo;
    get_data: boolean;
    new_app: boolean;
    new_info: boolean;
    new_metric: boolean;
    new_rating: boolean;
}

export type BackendDateType = string | number;

export interface ICP {
    domain: string;
    icp: string;
}
export type appIdOrPkgName =
    | {
          app_id: string;
          pkg_name: undefined;
      }
    | {
          pkg_name: string;
          app_id: undefined;
      };

export type SubmitAppBody = appIdOrPkgName & {
    comment?: CommentInfo;
};

export interface SubmitParseResult {
    pkg_name: string;
    full_info?: AppInfo;
    new_app?: boolean;
    exists?: boolean;
}

export interface SubmitSubstanceResult {
    id: string;
    get_data: boolean;
    apps?: SubmitParseResult[];
    data?: SubmitSubstanceResponse;
}

export interface SubmitSubstanceResponse {
    is_new: boolean;
    data: {
        id: string;
        name: string;
        title: string;
        sub_title: string;
        substance: string;
        data: { app_id: string }[];
    };
}

export interface ChartIncreaseDownloadCount {
    created_at: Date;
    download_count: number;
}
