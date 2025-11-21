import { Component, Entry, Column, Row, Text, Button, Color, ref, onMounted, watch } from '@kit/arkui';
import { useRouter } from '@kit/arkui';
import AppCountInfo from '../components/AppCountInfo';
import AppTotalStarChart from '../components/AppTotalStarChart';
import AppSdkPie from '../components/AppSdkPie';
import AppDownloadChart from '../components/AppDownloadChart';
import AppSearchList from '../components/AppSearchList';
import AppDownloadIncreaseCompare from '../components/AppDownloadIncreaseCompare';
import AppSyncProgress from '../components/AppSyncProgress';
import { fetchMinSdkPie, fetchTargetSdkPie, marketInfo as fetchMarketInfo, starCharts, topDownloadHuawei, topDownloadWithoutHuawei } from '../api';
import { formatCountTimeWithUnit } from '../common/utils';
import type { AppInfo, MarketInfo, RatingInfo, SdkPie } from '../common/types';
import { responseTimestamp } from '../common/constants';

@Entry
@Component
export struct DashboardPage {
  private router = useRouter();
  private lastUpdated = ref<string>('');
  private nextRefreshTime = ref<number>(0);
  private refreshTask: any;
  private refreshing = ref(false);

  private marketInfo = ref<MarketInfo>({ app_count: { apps: 0, atomic_services: 0, total: 0 }, developer_count: 0, crate_version: '0.0.0', page_size_max: 0, sync_status: { is_syncing_all: false, total_failed: 0, total_inserted: 0, total_processed: 0, total_skipped: 0, elapsed_time: { secs: 0, nanos: 0 }, estimated_total_time: { secs: 0, nanos: 0 }, progress: [0, 0] }, user_agent: '' });
  private topDownload = ref<AppInfo[]>([]);
  private topDownloadOutHuawei = ref<AppInfo[]>([]);
  private minSdk = ref<SdkPie[]>([]);
  private targetSdk = ref<SdkPie[]>([]);
  private stars = ref<RatingInfo>({ star_1: 0, star_2: 0, star_3: 0, star_4: 0, star_5: 0 });
  private isLargeScreen = ref(window.innerWidth >= 1520);
  private downloadIncreaseRef: any;

  @Builder
  build() {
    Column({ width: '100%' }) {
      // 顶部信息卡片
      Column({ marginBottom: 24 }) {
        Text(`华为应用市场看板 数据收集自 appgallery api 不保证来源的准确性、完整性和真实性 仅供参考`)
          .fontSize(20).fontWeight('semibold').color(Color('#1e40af')).margin({ bottom: 8 })
        Text(`API 版本 ${this.marketInfo.value.crate_version}`).fontSize(16).fontWeight('semibold').color(Color('#1e40af')).margin({ bottom: 12 })
        Row({ gap: 8, wrap: 'wrap' }) {
          Button({ text: this.refreshing.value ? '刷新中...' : '刷新数据', onClick: () => this.refreshData(), backgroundColor: Color('#06b6d4') })
          Button({ text: '帮助信息', onClick: () => this.router.push('/help'), backgroundColor: Color('#10b981') })
          Button({ text: '问题反馈&交流', onClick: () => this.router.push('/contact'), backgroundColor: Color('#8b5cf6') })
          Button({ text: '投稿', onClick: () => this.router.push('/submit'), backgroundColor: Color('#f97316') })
          Button({ text: '查看更新日志', onClick: () => this.router.push('/changelog'), backgroundColor: Color('#ef4444') })
          Button({ text: '打开 v1 站', onClick: () => window.open('http://shenjack.top:10003/dashboard'), backgroundColor: Color('#0ea5e9') })
          Button({ text: '切换主题', onClick: () => document.documentElement.classList.toggle('dark'), backgroundColor: Color('#6b7280') })
        }
        Text(this.nextRefreshTime.value < 0 ? `距离下次刷新时间: ${formatCountTimeWithUnit(this.nextRefreshTime.value)}` : '正在刷新').fontSize(14).color(Color('#6b7280')).margin({ top: 8 })
      }

      // 同步进度
      Column({ marginBottom: 24 }) {
        AppSyncProgress({})
      }

      // 总览信息
      AppCountInfo({ value: this.marketInfo.value })

      // 评分与 SDK 分布
      Row({ gap: 16, wrap: 'wrap', minHeight: 384 }) {
        AppTotalStarChart({ value: this.stars.value })
        AppSdkPie({ title: '应用目标 sdk 分布', value: this.targetSdk.value })
        AppSdkPie({ title: '应用最小 sdk 分布', value: this.minSdk.value })
      }

      // 下载榜
      AppDownloadChart({ title: '总下载榜', value: this.topDownload.value, yAxisMin: true })
      AppDownloadChart({ title: '非华为应用/内置应用下载榜', value: this.topDownloadOutHuawei.value, yAxisMin: true })

      // 下载增量对比
      AppDownloadIncreaseCompare({ ref: (r) => this.downloadIncreaseRef = r })

      // 搜索列表
      AppSearchList({ total_apps: this.marketInfo.value.app_count.total })
    }
  }

  private async refreshMarketInfo() { this.marketInfo.value = await fetchMarketInfo(); }
  private async refreshTopDownloadApp() { this.topDownload.value = await topDownloadHuawei(); this.topDownloadOutHuawei.value = await topDownloadWithoutHuawei(); }
  private async refreshStarCharts() { this.stars.value = await starCharts(); }
  private async refreshSdkPie() { [this.minSdk.value, this.targetSdk.value] = await Promise.all([fetchMinSdkPie(), fetchTargetSdkPie()]); }

  private async refreshData() {
    if (this.refreshing.value) return;
    this.refreshing.value = true;
    clearInterval(this.refreshTask);
    this.nextRefreshTime.value = 0;
    try {
      await Promise.all([this.refreshMarketInfo(), this.refreshTopDownloadApp(), this.refreshStarCharts(), this.refreshSdkPie(), this.downloadIncreaseRef?.refreshData()]);
    } catch (e) { console.error(e) }
    this.nextRefreshTime.value = 4000;
    this.refreshTask = setInterval(async () => { this.nextRefreshTime.value -= 1; if (this.nextRefreshTime.value <= 0) { await this.refreshData() } }, 1000);
    this.refreshing.value = false;
  }

  onMounted(() => {
  this.refreshData();
  window.addEventListener('resize', () => this.isLargeScreen.value = window.innerWidth >= 1520);
});
}
