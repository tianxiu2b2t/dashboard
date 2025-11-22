import { ICPs } from '../common/constants';
import router from '@ohos.router';
import { ICPInfo } from '../common/types';

@Entry
@Component
export struct ICPFooter {
  private domain: string = 'txit.top';

  @Builder
  build() {
    Column() {
      ForEach(ICPs, (icp: ICPInfo) => { // 为 icp 参数添加明确类型
        if (this.domain.includes(icp.domain)) {
          // 本网站备案域名：
          Row() {
            Text('本网站备案域名：')
              .fontColor('#6B7280') // 使用 HEX 字符串而不是数字
              .fontSize(12)

            Text(icp.domain)
              .fontColor('#374151') // 使用 HEX 字符串而不是数字
              .fontWeight(FontWeight.Medium)
              .margin({ left: 4 })
          }

          // ICP 号
          Text(icp.icp)
            .fontColor('#3B82F6') // 使用 HEX 字符串而不是数字
            .fontSize(12)
            .onClick(() => {
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