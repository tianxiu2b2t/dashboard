import { Loading } from '../components/Loading';
import { fetchChangelog } from '../common/api';

@Entry
@Component
export struct ChangelogPage {
  @State changelog: string = ''; // 使用 @State 而不是 ref
  @State isLoading: boolean = true; // 添加加载状态

  aboutToAppear() { // 使用 ArkTS 生命周期而不是 onMounted
    this.loadChangelog();
  }

  private async loadChangelog(): Promise<void> { // 明确指定返回类型
    try {
      const data = await fetchChangelog();
      this.changelog = data as string; // 确保类型正确
    } catch (error) {
      this.changelog = '加载更新日志失败';
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题区
      Column() {
        Text('更新日志')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#4f46e5');
      }
      .backgroundColor('#f5f3ff')
      .borderRadius(16)
      .padding(16)
      .margin({ bottom: 32 })

      // 内容区
      if (this.isLoading) {
        Loading(); // 显示加载组件
      } else if (this.changelog) {
        Scroll() {
          Text(this.changelog)
            .fontSize(16)
            .fontColor('#000000') // 使用字符串颜色而不是 Color.Black
            .lineHeight(22);
        }
        .layoutWeight(1) // 让 Scroll 占据剩余空间
      } else {
        Text('暂无更新日志')
          .fontSize(16)
          .fontColor('#6b7280');
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}