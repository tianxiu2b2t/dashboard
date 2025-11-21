import { Component, Entry, Column, Row, Text, Button, Color } from '@kit/arkui';

@Entry
@Component
export struct ContactPage {
  @Builder
  build() {
    Column({ width: '100%', maxWidth: 1024, padding: 16 }) {
      // 返回按钮
      Button({
        text: '返回仪表板',
        onClick: () => window.location.href = '/dashboard',
        backgroundColor: Color('transparent'),
        color: Color('#3b82f6'),
        borderRadius: 6,
      }).margin({ bottom: 16 })

      // 页面标题
      Column({
        backgroundColor: Color('#f5f3ff'),
        padding: 16,
        borderRadius: 16,
        marginBottom: 32,
      }) {
        Text('问题反馈 & 交流').fontSize(24).fontWeight('bold').color(Color('#6b21a8'))
        Text('如有任何问题、建议或合作意向，请通过以下方式联系我们')
          .fontSize(14).color(Color('#4b5563')).margin({ top: 4 })
      }

      // 联系方式卡片
      Column({
        backgroundColor: Color('#ffffff'),
        borderRadius: 16,
        padding: 16,
        marginBottom: 32,
        shadow: 'md',
      }) {
        Text('联系方式').fontSize(20).fontWeight('semibold').color(Color('#111827'))

        // 联系人
        const contacts = [
          { name: 'shenjack (主要负责人)', email: '3695888@qq.com', iconColor: '#8b5cf6' },
          { name: 'tianxiu2b2t (v2站网页负责人)', email: 'administrator@ttb-network.top', iconColor: '#8b5cf6' },
        ];
        contacts.forEach(contact => {
          Row({ marginTop: 16, gap: 8 }) {
            Column({ width: 24, height: 24, backgroundColor: Color(contact.iconColor), borderRadius: 4 }) {}
            Column() {
              Text(contact.name).fontWeight('medium').color(Color('#111827'))
              Text(contact.email).fontSize(14).color(Color('#4b5563'))
            }
          }
        });

        // QQ 群
        Row({ marginTop: 16, gap: 8 }) {
          Column({ width: 24, height: 24, backgroundColor: Color('#3b82f6'), borderRadius: 4 }) {}
          Column() {
            Text('QQ群').fontWeight('medium').color(Color('#111827'))
            Text('757273833').fontSize(14).color(Color('#4b5563'))
          }
        }
      }
    }
  }
}
