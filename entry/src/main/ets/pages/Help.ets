import { Component, Entry, Column, Row, Text, Color, Button } from '@kit/arkui';
import { useRouter } from '@kit/arkui';

@Entry
@Component
export struct HelpPage {
  private router = useRouter();

  @Builder
  build() {
    Column({ width: '100%', maxWidth: 1024, marginHorizontal: 'auto', padding: 24, gap: 32 }) {
      // 头部导航
      Button({ text: '返回仪表板', onClick: () => this.router.push('/dashboard'), backgroundColor: Color('#3b82f6') }).margin({ bottom: 24 })

      // 页面标题
      Column({ backgroundColor: Color('#eff6ff'), darkBackgroundColor: Color('#1e3a8a'), borderRadius: 16, padding: 24, marginBottom: 32 }) {
        Text('帮助信息').fontSize(20).fontWeight('bold').color(Color('#1e3a8a')).darkColor(Color('#f3f4f6')).margin({ bottom: 8 })
        Text('华为应用市场看板使用指南与常见问题解答').fontSize(16).color(Color('#4b5563')).darkColor(Color('#9ca3af'))
      }

      // 关于本项目
      Column({ backgroundColor: Color('#ffffff'), darkBackgroundColor: Color('#111827'), borderRadius: 16, padding: 24, gap: 8 }) {
        Text('关于本项目').fontSize(18).fontWeight('semibold').color(Color('#1f2937')).darkColor(Color('#f3f4f6')).margin({ bottom: 8 })
        Text('华为应用市场看板是一个数据统计与分析工具，通过收集华为应用市场的公开数据，为开发者和用户提供应用相关的统计信息。').color(Color('#374151')).darkColor(Color('#d1d5db'))
        Text('数据来源：华为应用市场公开API，本工具不保证数据的准确性、完整性和真实性，仅供参考。').color(Color('#374151')).darkColor(Color('#d1d5db'))
      }

      // 功能说明
      Column({ backgroundColor: Color('#ffffff'), darkBackgroundColor: Color('#111827'), borderRadius: 16, padding: 24, gap: 12 }) {
        Text('主要功能').fontSize(18).fontWeight('semibold').color(Color('#1f2937')).darkColor(Color('#f3f4f6')).margin({ bottom: 8 })
        Column({ gap: 8 }) {
          Text('数据统计: 展示应用总数、元服务总数、开发者总数等关键指标的统计数据。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('排行榜: 提供下载量排名前20的应用列表，以及排除华为系应用后的下载量排名。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('应用详情: 查看应用的详细信息，包括下载量、评分、支持设备、版本信息等。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('趋势分析: 展示应用下载量的变化趋势和增量趋势图表。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('应用查询: 通过包名或App ID查询应用信息并提交到数据库。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
        }
      }

      // 常见问题
      Column({ backgroundColor: Color('#ffffff'), darkBackgroundColor: Color('#111827'), borderRadius: 16, padding: 24, gap: 12 }) {
        Text('常见问题').fontSize(18).fontWeight('semibold').color(Color('#1f2937')).darkColor(Color('#f3f4f6')).margin({ bottom: 8 })
        Column({ gap: 8 }) {
          Text('数据多久更新一次？系统会定期更新数据，通常每24小时更新一次。您也可以点击"刷新数据"按钮手动触发更新。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('为什么某些应用没有数据？可能是因为该应用未被收录，或者华为应用市场未提供该应用的公开数据。您可以通过"投稿"功能提交应用信息。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('如何查询特定应用？点击"投稿"按钮，输入应用的包名（Package Name）或App ID即可查询并提交应用信息。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
          Text('数据来源是什么？数据来源于华为应用市场的公开API，本工具仅做数据展示和分析，不修改原始数据。').color(Color('#4b5563')).darkColor(Color('#9ca3af'))
        }
      }
    }
  }
}
