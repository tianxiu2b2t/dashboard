import router from '@ohos.router';

import { SwitchBar } from '../components/SwitchBar';
import { InputEdit } from '../components/InputEdit';
import { SubmitAppTable } from '../components/SubmitAppTable';

import type { SubmitParseResult, SubmitSubstanceResult, CommentInfo } from '../common/types';
import { fetchAppDetail, submitApp, submitSubstance } from '../common/api';

@Entry
@Component
export struct SubmitPage {

  @State switched: number = 0;
  @State mixedUrlPkg: string = '';
  @State mixedSubstance: string = '';
  @State results: SubmitParseResult[] = [];
  @State substanceResults: SubmitSubstanceResult[] = [];
  @State note: string = '';
  @State username: string = '';
  @State progress: number = 0;
  @State progressTotal: number = 0;

  private getComment(): CommentInfo {
    return {
      platform: 'txit',
      user: this.username || undefined,
      note: this.note || undefined
    };
  }

  @Builder
  build() {
    Column()
      .width('100%')
      .maxWidth(1280)
      .margin({ left: 'auto', right: 'auto' })
      .padding(24)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .gap(24) {

      Text('应用投稿')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color('#ea580c'))
        .darkColor(Color('#f97316'))
        .margin({ bottom: 8 })

      Text('提交应用信息到数据库，帮助我们完善应用市场看板')
        .fontColor(Color('#374151'))
        .darkColor(Color('#d1d5db'))

      // 用户信息
      Column()
        .backgroundColor(Color.White)
        .darkBackgroundColor(Color('#111827'))
        .borderRadius(16)
        .padding(24)
        .gap(16) {

        InputEdit({ modelValue: this.username, placeholder: '用户名（可选）', mode: 'input' })
        InputEdit({ modelValue: this.note, placeholder: '备注信息', mode: 'textarea' })
      }

      // 内容区
      Column()
        .backgroundColor(Color.White)
        .darkBackgroundColor(Color('#111827'))
        .borderRadius(16)
        .padding(24)
        .gap(16) {

        SwitchBar({ data: ['应用', '专题'], modelValue: this.switched })

        // ===== 应用分支 =====
        If(this.switched.value === 0) {
          InputEdit({ modelValue: this.mixedUrlPkg, placeholder: '应用详情页链接 / 包名', mode: 'textarea' })

          If(this.results.value.length > 0) {
            Column() {
              Text('解析结果')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color('#1f2937'))
                .darkColor(Color('#f3f4f6'))
                .margin({ bottom: 8 })

              Text(`进度：${this.progress.value} / ${this.progressTotal.value}`)
                .fontSize(14)
                .fontWeight(FontWeight.Bold)

              SubmitAppTable({ apps: this.results.value })
            }
          }
        }

        // ===== 专题分支 =====
        ElseIf(this.switched.value === 1) {
          InputEdit({ modelValue: this.mixedSubstance, placeholder: '主题链接 / ID', mode: 'textarea' })

          If(this.substanceResults.value.length > 0) {
            Column() {
              Text('解析结果')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color('#1f2937'))
                .darkColor(Color('#f3f4f6'))
                .margin({ bottom: 8 })

              ForEach(this.substanceResults.value, (item) => {
                Column()
                  .backgroundColor(Color('#f9fafb'))
                  .darkBackgroundColor(Color('#111827'))
                  .borderRadius(12)
                  .padding(16)
                  .gap(8) {

                  Text(`ID: ${item.id}`).fontWeight(FontWeight.Semibold)

                  Text(item.get_data ? '已获取数据' : '未获取')
                    .fontColor(item.get_data ? Color('#16a34a') : Color('#dc2626'))

                  If(item.data) {
                    Text(`标题：${item.data.data.title}`)
                    Text(`副标题：${item.data.data.sub_title}`)
                    Text(`专题：${item.data.data.substance}`)
                  }

                  If(item.apps && item.apps.length > 0) {
                    SubmitAppTable({ apps: item.apps })
                  }
                }
              })
            }
          }
        }
      }
    }
  }

}
