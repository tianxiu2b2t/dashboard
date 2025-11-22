import router from '@ohos.router';
import prompt from '@ohos.prompt';
import clipboard from '@ohos.clipboard';

import { fetchAppDetail, fetchAppMetric } from '../common/api';
import { formatCountryCode, formatMainDeviceCode } from '../common/utils';

@Entry
@Component
export struct AppDetailPage {

  @State appDetailData: any = null;
  @State appMetric: any[] = [];
  @State mainDevices: string[] = [];
  @State countries: string[] = [];

  onPageShow() {
    const params = router.getParams();
    const appId = params?.appId;

    if (!appId) {
      router.replaceUrl({ url: 'pages/Dashboard' });
      return;
    }

    this.load(appId);
  }

  private async load(appId: string) {
    const detail = (await fetchAppDetail(appId)).full_info;
    this.appDetailData = detail;

    this.mainDevices = detail.main_device_codes.map(code => formatMainDeviceCode(code));

    const raw = detail.release_countries || [];
    this.countries = raw.map(v => formatCountryCode(v));

    this.appMetric = await fetchAppMetric(detail.pkg_name);
  }

  private copyUrl() {
    clipboard.setPlainText('app-detail?appId=' + this.appDetailData?.app_id);
    prompt.showToast({ message: '链接已复制' });
  }

  @Builder
  build() {
    Column() {
      if (!this.appDetailData) {
        Column() {
          Text('加载中...').fontSize(20)
        }.width('100%').height('100%').justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)

        return;
      }

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
          Text('主要设备').fontSize(18).fontWeight(FontWeight.Medium)
          Column() {
            ForEach(this.mainDevices, item => {
              Text(item).fontSize(14).margin({ top: 4 })
            })
          }.margin({ bottom: 24 })

          // 国家
          Text('发布国家/地区').fontSize(18).fontWeight(FontWeight.Medium)
          Column() {
            ForEach(this.countries, item => {
              Text(item).fontSize(14).margin({ top: 4 })
            })
          }.margin({ bottom: 24 })

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
}
