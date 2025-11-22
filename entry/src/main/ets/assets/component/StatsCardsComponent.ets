// StatsCardsComponent.ets
@Component
export struct StatsCardsComponent {
  @State totalCount: number = 0
  @State appCount: number = 0
  @State atomicServiceCount: number = 0
  @State developerCount: number = 0
  @State substanceCount: number = 0

  build() {
    Grid() {
      // 已爬取总数卡片
      GridItem() {
        StatCardComponent('已爬取总数', this.totalCount.toString(), '#fdf2f8', '#be185d')
      }

      // 应用总数卡片
      GridItem() {
        StatCardComponent('应用总数', this.appCount.toString(), '#fff7ed', '#d97706')
      }

      // 元服务总数卡片
      GridItem() {
        StatCardComponent('元服务总数', this.atomicServiceCount.toString(), '#f0fdf4', '#047857')
      }

      // 开发者总数卡片
      GridItem() {
        StatCardComponent('开发者总数', this.developerCount.toString(), '#faf5ff', '#3730a3')
      }

      // 已知专题数量卡片
      GridItem() {
        StatCardComponent('已知专题数量', this.substanceCount.toString(), '#faf5ff', '#7c3aed')
      }
    }
    .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr')
    .columnsGap(16)
    .rowsGap(16)
    .margin({ bottom: 16 })
  }
}

@Component
export struct StatCardComponent {
  title: string = ''
  value: string = ''
  bgColor: string = '#ffffff'
  textColor: string = '#000000'

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.textColor)
        .margin({ bottom: 8 })

      Text(this.value)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.textColor)
    }
    .width('100%')
    .height(120)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.bgColor)
    .borderRadius(16)
    .shadow({ radius: 8, color: '#000000', offsetX: 2, offsetY: 2 })
  }
}