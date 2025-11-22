import { Loading } from '../components/Loading';
import { fetchChangelog } from '../common/api';

@Entry
@Component
export struct ChangelogPage {
  private changelog = ref<string>("");

  @Builder
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
      if (!this.changelog.value) {
        Loading();
      } else {
        ScrollView() {
          Text(this.changelog.value)
            .fontSize(16)
            .fontColor(Color.Black)
            .lineHeight(22);
        }
      }
    }
    .width('100%')
    .padding(16)
  }

  onMounted(async () => {
  this.changelog.value = await fetchChangelog();
});
}
