import { Component, Entry, Column, Text, Color, Builder } from '@kit/arkui';
import { ICPs } from './constants';

@Entry
@Component
export struct ICPFooter {
  private domain = window.location.hostname;

  @Builder
  build() {
    Column({ width: '100%', paddingVertical: 16, alignItems: 'center', gap: 4 }) {
      ICPs.forEach((icp) => {
        if (this.domain.includes(icp.domain)) {
          Text(`本网站备案域名：`).color(Color('#6b7280')).fontSize(12) {
            Text(icp.domain).color(Color('#374151')).fontWeight('medium')
          }
          Text(icp.icp)
            .color(Color('#3b82f6'))
            .fontSize(12)
            .onClick(() => window.open('https://beian.miit.gov.cn', '_blank'))
        }
      })
    }
  }
}
