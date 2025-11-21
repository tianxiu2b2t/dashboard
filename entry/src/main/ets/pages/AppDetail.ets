import {
  Component,
  Entry,
  Column,
  Row,
  Text,
  Image,
  Button,
  Color,
  ref,
  onMounted,
} from '@kit/arkui';
import { useRoute, useRouter } from '@kit/arkui';
import { copy } from 'clipboard';
import VChart from 'vue-echarts';
import { use } from 'echarts/core';
import { CanvasRenderer } from 'echarts/renderers';
import { LineChart } from 'echarts/charts';
import {
  GridComponent,
  LegendComponent,
  TitleComponent,
  ToolboxComponent,
  TooltipComponent,
} from 'echarts/components';
import Loading from '../components/Loading';
import type { AppInfo, ChartIncreaseDownloadCount } from '../common/types';
import {
  fetchAppDetail,
  fetchAppMetric,
  formatDate,
  formatDatetime,
  formatMainDeviceCode,
  formatNumber,
  formatSize,
  sortByCountryCode,
  formatCountryCode,
  formatSDKVersion,
} from '../common/utils';
import { darkMode } from '../common/constants';

use([
  CanvasRenderer,
  LineChart,
  GridComponent,
  LegendComponent,
  TooltipComponent,
  TitleComponent,
  ToolboxComponent,
]);

@Entry
@Component
export struct AppDetailPage {
  private appDetailData = ref<AppInfo | null>(null);
  private appMetric = ref<AppInfo[] | null>(null);
  private mainDevices = ref<string[]>([]);
  private ref_countries = ref<string[]>([]);
  private downloadTrendOption = ref({});
  private downloadIncreaseOption = ref({});
  private selectedTrendPoints = ref<any[]>([]);
  private trendDiffInfo = ref<null | { diff: number; percent: number; hours: number }>(null);
  private selectedIncreasePoints = ref<any[]>([]);
  private increaseDiffInfo = ref<null | { diff: number; percent: number; hours: number }>(null);

  private router = useRouter();
  private route = useRoute();

  private async copyCurrentUrl() {
    copy(window.location.href);
    alert('当前链接已复制到剪贴板');
  }

  private normalizeToMidnight(dateStr: Date): Date {
    const date = new Date(dateStr);
    date.setHours(0, 0, 0, 0);
    return date;
  }

  private handleTrendClick(params: any) {
    if (params.componentType !== 'series') return;
    this.selectedTrendPoints.value.push(params);
    if (this.selectedTrendPoints.value.length === 2) {
      const [p1, p2] = this.selectedTrendPoints.value;
      const diff = p2.value[1] - p1.value[1];
      const percent = p1.value[1] !== 0 ? (diff / p1.value[1]) * 100 : 0;
      const t1 = new Date(p1.value[0]).getTime();
      const t2 = new Date(p2.value[0]).getTime();
      const hours = Math.abs(t2 - t1) / 3600000;
      this.trendDiffInfo.value = {
        diff,
        percent: Math.round(percent * 100) / 100,
        hours: Math.round(hours * 100) / 100,
      };
      (this.downloadTrendOption.value as any).series[0].markPoint = {
        data: [
          { name: '点1', coord: [p1.value[0], p1.value[1]] },
          { name: '点2', coord: [p2.value[0], p2.value[1]] },
        ],
      };
    }
  }

  private clearTrendSelection() {
    this.selectedTrendPoints.value = [];
    this.trendDiffInfo.value = null;
    (this.downloadTrendOption.value as any).series[0].markPoint = { data: [] };
  }

  private handleIncreaseClick(params: any) {
    if (params.componentType !== 'series') return;
    this.selectedIncreasePoints.value.push(params);
    if (this.selectedIncreasePoints.value.length === 2) {
      const [p1, p2] = this.selectedIncreasePoints.value;
      const diff = p2.value[1] - p1.value[1];
      const percent = p1.value[1] !== 0 ? (diff / p1.value[1]) * 100 : 0;
      const t1 = new Date(p1.value[0]).getTime();
      const t2 = new Date(p2.value[0]).getTime();
      const hours = Math.abs(t2 - t1) / 3600000;
      this.increaseDiffInfo.value = {
        diff,
        percent: Math.round(percent * 100) / 100,
        hours: Math.round(hours * 100) / 100,
      };
      (this.downloadIncreaseOption.value as any).series[0].markPoint = {
        data: [
          { name: '点1', coord: [p1.value[0], p1.value[1]] },
          { name: '点2', coord: [p2.value[0], p2.value[1]] },
        ],
      };
    }
  }

  private clearIncreaseSelection() {
    this.selectedIncreasePoints.value = [];
    this.increaseDiffInfo.value = null;
    (this.downloadIncreaseOption.value as any).series[0].markPoint = { data: [] };
  }

  onMounted(async () => {
  const appId = this.route.params.appId;
  if (!appId || typeof appId !== 'string') return this.router.push('/');
  const data = (await fetchAppDetail(appId)).full_info;
  this.appDetailData.value = data;
  this.mainDevices.value = data.main_device_codes.map((code) => formatMainDeviceCode(code));
  const countries = (data?.release_countries || []).sort(sortByCountryCode);
  this.ref_countries.value = countries.map(formatCountryCode).filter((v) => countries.indexOf(v) == -1);
  this.appMetric.value = await fetchAppMetric(data.pkg_name);

  // 数据处理与图表初始化逻辑可根据原 Vue 代码改写到这里
});
}
