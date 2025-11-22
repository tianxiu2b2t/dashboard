import router from '@ohos.router';
import prompt from '@ohos.prompt';
import pasteboard from '@ohos.pasteboard'; // 注意：应该是 pasteboard 而不是 clipboard

import { fetchAppDetail, fetchAppMetric } from '../common/api';
import { formatCountryCode, formatMainDeviceCode } from '../common/utils';

// 定义类型接口
interface AppDetailData {
  app_id: string;
  name: string;
  icon_url: string;
  main_device_codes: string[];
  release_countries: string[];
  pkg_name: string;
}

interface AppMetric {
  // 根据你的实际数据结构定义这些字段
  metric_type?: string;
  value?: number;
  // 添加其他需要的字段
}

interface RouterParams {
  appId?: string;
}

@Entry
@Component
export struct AppDetailPage {
  @State appDetailData: AppDetailData | null = null;
  @State appMetric: AppMetric[] = [];
  @State mainDevices: string[] = [];
  @State countries: string[] = [];

  onPageShow() {
    const params = router.getParams() as RouterParams;
    const appId = params?.appId;

    if (!appId) {
      router.replaceUrl({ url: 'pages/Dashboard' });
      return;
    }

    this.load(appId);
  }

  private async load(appId: string) {
    try {
      const detailResponse = await fetchAppDetail(appId);
      const detail = detailResponse.full_info as AppDetailData;
      this.appDetailData = detail;

      this.mainDevices = detail.main_device_codes.map((code: string) => formatMainDeviceCode(code));

      const raw = detail.release_countries || [];
      this.countries = raw.map((v: string) => formatCountryCode(v));

      const metricResponse = await fetchAppMetric(detail.pkg_name);
      this.appMetric = metricResponse as AppMetric[];
    } catch (error) {
      prompt.showToast({ message: '加载失败，请重试' });
    }
  }

  private copyUrl() {
    if (!this.appDetailData) {
      return;
    }

    const systemPasteboard = pasteboard.getSystemPasteboard();
    const data: pasteboard.PasteData = pasteboard.createPlainTextData('app-detail?appId=' + this.appDetailData.app_id);
    systemPasteboard.setPasteData(data);
    prompt.showToast({ message: '链接已复制' });
  }

  build() {
    Column() {
      if (!this.appDetailData) {
        // 使用条件渲染而不是 return
        Column() {
          Text('加载中...')
            .fontSize(20)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Scroll() {
          Column() {
            // 标题
            Text(this.appDetailData.name)
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            // 图标
            Row() {
              Image(this.appDetailData.icon_url)
                .width(80)
                .height(80)
                .borderRadius(16)
            }
            .margin({ bottom: 24 })

            // 主设备
            Text('主要设备')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Column() {
              ForEach(this.mainDevices, (item: string) => {
                Text(item)
                  .fontSize(14)
                  .margin({ top: 4 })
              })
            }
            .margin({ bottom: 24 })

            // 国家
            Text('发布国家/地区')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
            Column() {
              ForEach(this.countries, (item: string) => {
                Text(item)
                  .fontSize(14)
                  .margin({ top: 4 })
              })
            }
            .margin({ bottom: 24 })

            // 复制按钮
            Button('复制当前页面链接')
              .onClick(() => this.copyUrl())
              .backgroundColor('#2563eb')
              .borderRadius(8)
              .padding(12)
              .margin({ top: 16, bottom: 32 })
          }
          .padding(24)
        }
      }
    }
    .width('100%')
    .height('100%')
  }
}