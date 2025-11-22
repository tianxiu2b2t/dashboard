import { ICPs } from '../common/constants';
import router from '@ohos.router';

@Entry
@Component
export struct ICPFooter {
  private domain: string = 'txit.top';

  @Builder
  build() {
    Column() {
      ForEach(ICPs, (icp) => {
        if (this.domain.includes(icp.domain)) {

          // 本网站备案域名：
          Row() {
            Text('本网站备案域名：')
              .fontColor(0xFF6B7280)
              .fontSize(12)

            Text(icp.domain)
              .fontColor(0xFF374151)
              .fontWeight(FontWeight.Medium)
              .margin({ left: 4 })
          }

          // ICP 号
          Text(icp.icp)
            .fontColor(0xFF3B82F6)
            .fontSize(12)
            .onClick(() => {
              // HarmonyOS 无 window.open，必须用 WebView 或 router
              router.pushUrl({
                url: 'pages/ExternalWeb',
                params: { link: 'https://beian.miit.gov.cn' }
              })
            })
        }
      })
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
  }

}
