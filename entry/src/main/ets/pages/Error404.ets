import router from "@ohos.router";

@Entry
@Component
export struct NotFoundPage {

  @Builder
  build() {
    Column() {

      // 顶部说明
      Column() {
        Text('华为应用市场看板 数据收集自 appgallery API\n不保证来源的准确性、完整性和真实性，仅供参考')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827')
      }
      .width('100%')
      .padding(16)
      .borderRadius(16)
      .backgroundColor('#ffffff')

      // 中央 404 内容
      Column() {
        Text('404')
          .fontSize(72)
          .fontWeight(FontWeight.Bold)
          .fontColor('#d1d5db')
          .margin({ bottom: 16 })

        Text('页面未找到')
          .fontSize(28)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827')
          .margin({ bottom: 8 })

        Text('抱歉，您访问的页面不存在。可能路径有误，或者页面已被移除。')
          .fontSize(16)
          .fontColor('#6b7280')
          .width(300)
          .margin({ bottom: 24 })
          .textAlign(TextAlign.Center)

        Button('返回仪表板')
          .backgroundColor('#2563eb')
          .fontColor('#ffffff')
          .borderRadius(8)
          .padding({ top: 12, bottom: 12, left: 24, right: 24 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Dashboard'
            })
          })
      }
      .padding({ top: 48 })
      .flexGrow(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

    }
    .width('100%')
    .padding(16)
    .flexGrow(1)
  }
}
