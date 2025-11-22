import router from "@ohos.router";

@Entry
@Component
export struct NotFoundPage {

  @Builder
  build() {
    Column() {

      // 头部导航
      Button('返回仪表板')
        .backgroundColor('#FF3B82F6')
        .fontColor('#FFFFFFFF')
        .borderRadius(8)
        .margin({ bottom: 24 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Dashboard' })
        })


      // 页面标题
      Column() {
        Text('帮助信息')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF1E3A8A')
          .margin({ bottom: 8 })

        Text('华为应用市场看板使用指南与常见问题解答')
          .fontSize(16)
          .fontColor('#FF4B5563')
      }
      .backgroundColor('#FFEFF6FF')
      .borderRadius(16)
      .padding(24)
      .margin({ bottom: 32 })


      // 关于本项目
      Column() {
        Text('关于本项目')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FF1F2937')
          .margin({ bottom: 8 })

        Text('华为应用市场看板是一个数据统计与分析工具，通过收集华为应用市场的公开数据，为开发者和用户提供应用相关的统计信息。')
          .fontColor('#FF374151')

        Text('数据来源：华为应用市场公开API，本工具不保证数据的准确性、完整性和真实性，仅供参考。')
          .fontColor('#FF374151')
      }
      .backgroundColor('#FFFFFFFF')
      .borderRadius(16)
      .padding(24)
      .margin({ bottom: 32 })


      // 功能说明
      Column() {
        Text('主要功能')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FF1F2937')
          .margin({ bottom: 8 })

        Column() {
          Text('数据统计: 展示应用总数、元服务总数、开发者总数等关键指标的统计数据。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('排行榜: 提供下载量排名前20的应用列表，以及排除华为系应用后的下载量排名。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('应用详情: 查看应用的详细信息，包括下载量、评分、支持设备、版本信息等。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('趋势分析: 展示应用下载量的变化趋势和增量趋势图表。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('应用查询: 通过包名或App ID查询应用信息并提交到数据库。')
            .fontColor('#FF4B5563')
        }
      }
      .backgroundColor('#FFFFFFFF')
      .borderRadius(16)
      .padding(24)
      .margin({ bottom: 32 })


      // 常见问题
      Column() {
        Text('常见问题')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FF1F2937')
          .margin({ bottom: 8 })

        Column() {
          Text('数据多久更新一次？系统会定期更新数据，通常每24小时更新一次。您也可以点击"刷新数据"按钮手动触发更新。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('为什么某些应用没有数据？可能是因为该应用未被收录，或者华为应用市场未提供该应用的公开数据。您可以通过"投稿"功能提交应用信息。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('如何查询特定应用？点击"投稿"按钮，输入应用的包名（Package Name）或App ID即可查询并提交应用信息。')
            .fontColor('#FF4B5563')
            .margin({ bottom: 8 })

          Text('数据来源是什么？数据来源于华为应用市场的公开API，本工具仅做数据展示和分析，不修改原始数据。')
            .fontColor('#FF4B5563')
        }
      }
      .backgroundColor('#FFFFFFFF')
      .borderRadius(16)
      .padding(24)
    }
    .width('100%')
    .padding(24)
  }

}
