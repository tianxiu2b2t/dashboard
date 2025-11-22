import router from '@ohos.router';
import { AppCountInfo } from '../components/AppCountInfo';
import { AppTotalStarChart } from '../components/AppTotalStarChart';
import { AppSdkPie } from '../components/AppSdkPie';
import { AppDownloadChart } from '../components/AppDownloadChart';
import { AppSearchList } from '../components/AppSearchList';
import { AppDownloadIncreaseCompare } from '../components/AppDownloadIncreaseCompare';
import { AppSyncProgress } from '../components/AppSyncProgress';
import { fetchMinSdkPie, fetchTargetSdkPie, marketInfo as fetchMarketInfo, starCharts, topDownloadHuawei, topDownloadWithoutHuawei } from '../common/api';
import { formatCountTimeWithUnit } from '../common/utils';
import type { AppInfo, MarketInfo, RatingInfo, SdkPie } from '../common/types';

// 定义按钮配置接口
interface ButtonConfig {
  text: string;
  onClick: () => void;
  bg: string;
}

@Entry
@Component
export struct DashboardPage {
  @State lastUpdated: string = '';
  @State nextRefreshTime: number = 0;
  @State refreshing: boolean = false;

  @State marketInfo: MarketInfo = {
    app_count: { apps: 0, atomic_services: 0, total: 0 },
    developer_count: 0,
    crate_version: '0.0.0',
    page_size_max: 0,
    sync_status: {
      is_syncing_all: false,
      total_failed: 0,
      total_inserted: 0,
      total_processed: 0,
      total_skipped: 0,
      elapsed_time: { secs: 0, nanos: 0 },
      estimated_total_time: { secs: 0, nanos: 0 },
      progress: [0, 0]
    },
    user_agent: ''
  };

  @State topDownload: AppInfo[] = [];
  @State topDownloadOutHuawei: AppInfo[] = [];
  @State minSdk: SdkPie[] = [];
  @State targetSdk: SdkPie[] = [];
  @State stars: RatingInfo = { star_1: 0, star_2: 0, star_3: 0, star_4: 0, star_5: 0 };

  private refreshTask: number = 0;

  aboutToAppear(): void {
    this.refreshData();
  }

  aboutToDisappear(): void {
    // 清理定时器
    if (this.refreshTask) {
      clearTimeout(this.refreshTask);
    }
  }

  build() {
    Column({ space: 8 }) {
      // 顶部信息卡片
      Column({ space: 8 }) {
        Text('华为应用市场看板 数据收集自 appgallery api 不保证来源的准确性、完整性和真实性 仅供参考')
          .fontSize(20)
          .fontWeight(500)
          .fontColor('#1e40af')

        Text(`API 版本 ${this.marketInfo.crate_version}`)
          .fontSize(16)
          .fontWeight(500)
          .fontColor('#1e40af')

        // 按钮行
        Scroll() {
          Row({ space: 8 }) {
            ForEach(this.getButtonConfigs(), (btn: ButtonConfig) => {
              Button(btn.text)
                .backgroundColor(btn.bg)
                .fontColor(Color.White)
                .borderRadius(8)
                .padding(12)
                .onClick(btn.onClick)
            })
          }
          .padding(8)
        }
        .scrollable(ScrollDirection.Horizontal)

        Text(this.nextRefreshTime > 0 ?
          `距离下次刷新时间: ${formatCountTimeWithUnit(this.nextRefreshTime)}` :
          '正在刷新')
          .fontSize(14)
          .fontColor('#6b7280')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#f8fafc')
      .borderRadius(16)
      .margin({ bottom: 24 })

      // 同步进度
      AppSyncProgress({})

      // 总览信息
      AppCountInfo({ value: this.marketInfo })

      // 评分与 SDK 分布
      Row({ space: 16 }) {
        AppTotalStarChart({ value: this.stars })
        AppSdkPie({ title: '应用目标 sdk 分布', value: this.targetSdk })
        AppSdkPie({ title: '应用最小 sdk 分布', value: this.minSdk })
      }
      .width('100%')
      .margin({ bottom: 24 })

      // 下载榜
      AppDownloadChart({ title: '总下载榜', value: this.topDownload, yAxisMin: true })
      AppDownloadChart({ title: '非华为应用/内置应用下载榜', value: this.topDownloadOutHuawei, yAxisMin: true })

      // 下载增量对比
      AppDownloadIncreaseCompare({})

      // 搜索列表 - 直接使用组件，不传递任何属性
      AppSearchList()
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#ffffff')
  }

  // 获取按钮配置
  private getButtonConfigs(): ButtonConfig[] {
    const configs: ButtonConfig[] = [
      {
        text: this.refreshing ? '刷新中...' : '刷新数据',
        onClick: (): void => { this.refreshData(); },
        bg: '#06b6d4'
      },
      {
        text: '帮助信息',
        onClick: (): void => { router.pushUrl({ url: 'pages/Help' }); },
        bg: '#10b981'
      },
      {
        text: '问题反馈&交流',
        onClick: (): void => { router.pushUrl({ url: 'pages/Contact' }); },
        bg: '#8b5cf6'
      },
      {
        text: '投稿',
        onClick: (): void => { router.pushUrl({ url: 'pages/Submit' }); },
        bg: '#f97316'
      },
      {
        text: '查看更新日志',
        onClick: (): void => { router.pushUrl({ url: 'pages/Changelog' }); },
        bg: '#ef4444'
      },
      {
        text: '切换主题',
        onClick: (): void => { this.toggleTheme(); },
        bg: '#6b7280'
      },
    ];
    return configs;
  }

  private async refreshMarketInfo(): Promise<void> {
    this.marketInfo = await fetchMarketInfo();
  }

  private async refreshTopDownloadApp(): Promise<void> {
    const topDownloadData = await topDownloadHuawei();
    const topDownloadOutHuaweiData = await topDownloadWithoutHuawei();
    this.topDownload = topDownloadData;
    this.topDownloadOutHuawei = topDownloadOutHuaweiData;
  }

  private async refreshStarCharts(): Promise<void> {
    this.stars = await starCharts();
  }

  private async refreshSdkPie(): Promise<void> {
    const minSdkData = await fetchMinSdkPie();
    const targetSdkData = await fetchTargetSdkPie();
    this.minSdk = minSdkData;
    this.targetSdk = targetSdkData;
  }

  private async refreshData(): Promise<void> {
    if (this.refreshing) return;

    this.refreshing = true;

    // 清除现有定时器
    if (this.refreshTask) {
      clearTimeout(this.refreshTask);
    }

    this.nextRefreshTime = 0;

    try {
      await Promise.all([
        this.refreshMarketInfo(),
        this.refreshTopDownloadApp(),
        this.refreshStarCharts(),
        this.refreshSdkPie(),
      ]);
    } catch (e) {
      console.error('刷新数据失败:', e);
    }

    this.nextRefreshTime = 4000;

    // 设置下一次刷新
    this.refreshTask = setTimeout(() => {
      this.refreshData();
    }, this.nextRefreshTime * 1000);

    this.refreshing = false;
  }

  private toggleTheme(): void {
    // HarmonyOS 主题切换实现
    // 这里需要根据你的实际主题切换逻辑来实现
    console.log('切换主题');
  }
}