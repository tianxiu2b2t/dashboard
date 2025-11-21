import { Component, Entry, Column, Row, Text, Button, Color } from '@kit/arkui';
import { useRouter } from '@kit/arkui';

@Entry
@Component
export struct NotFoundPage {
  private router = useRouter();

  @Builder
  build() {
    Column({ width: '100%', gap: 16, padding: 16, flexGrow: 1 }) {
      // 顶部说明
      Column({ width: '100%', borderRadius: 16, padding: 16, backgroundColor: Color('#ffffff'), shadow: '0 1px 3px rgba(0,0,0,0.1)' }) {
        Text('华为应用市场看板 数据收集自 appgallery API\n不保证来源的准确性、完整性和真实性，仅供参考')
          .fontSize(18)
          .fontWeight('semibold')
          .color(Color('#111827'))
      }

      ```
  // 404 内容
  Column({ flexGrow: 1, justifyContent: 'center', alignItems: 'center', gap: 16 }) {
    Text('404')
      .fontSize(72)
      .fontWeight('bold')
      .color(Color('#d1d5db')) // 类似 gray-200

    Text('页面未找到')
      .fontSize(28)
      .fontWeight('semibold')
      .color(Color('#111827'))

    Text('抱歉，您访问的页面不存在。可能路径有误，或者页面已被移除。')
      .fontSize(16)
      .color(Color('#6b7280')) // gray-500
      .width(300)
      .textAlign('center')

    Button({
      text: '返回仪表板',
      backgroundColor: Color('#2563eb'),
      color: Color('#ffffff'),
      borderRadius: 8,
      padding: { horizontal: 24, vertical: 12 },
      onClick: () => this.router.push('/dashboard')
    })
  }
}
```

    }
  }
