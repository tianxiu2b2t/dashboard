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

  build() {
    Column() {
      Column() {
        // 标题区域
        Column() {
          Text('应用投稿')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ea580c')
            .margin({ bottom: 8 })

          Text('提交应用信息到数据库，帮助我们完善应用市场看板')
            .fontColor('#374151')
            .fontSize(14)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)

        // 用户信息卡片
        Column() {
          InputEdit({
            modelValue: this.username,
            placeholder: '用户名（可选）',
            mode: 'input'
          })

          InputEdit({
            modelValue: this.note,
            placeholder: '备注信息',
            mode: 'textarea'
          })
        }
        .backgroundColor('#ffffff')
        .borderRadius(16)
        .padding(24)
        .width('100%')
        .margin({ top: 16 })

        // 内容区卡片
        Column() {
          // 切换栏
          SwitchBar({
            data: ['应用', '专题'],
            modelValue: this.switched
          })

          // 应用分支
          if (this.switched === 0) {
            Column() {
              InputEdit({
                modelValue: this.mixedUrlPkg,
                placeholder: '应用详情页链接 / 包名',
                mode: 'textarea'
              })

              if (this.results.length > 0) {
                Column() {
                  Text('解析结果')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1f2937')
                    .margin({ bottom: 8 })

                  Text(`进度：${this.progress} / ${this.progressTotal}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#6b7280')

                  SubmitAppTable({ apps: this.results })
                }
                .width('100%')
                .margin({ top: 16 })
              }
            }
          }

          // 专题分支
          if (this.switched === 1) {
            Column() {
              InputEdit({
                modelValue: this.mixedSubstance,
                placeholder: '主题链接 / ID',
                mode: 'textarea'
              })

              if (this.substanceResults.length > 0) {
                Column() {
                  Text('解析结果')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#1f2937')
                    .margin({ bottom: 8 })

                  ForEach(this.substanceResults, (item: SubmitSubstanceResult, index?: number) => {
                    Column() {
                      Text(`ID: ${item.id}`)
                        .fontWeight(FontWeight.Medium)
                        .fontColor('#111827')

                      Text(item.get_data ? '已获取数据' : '未获取')
                        .fontColor(item.get_data ? '#16a34a' : '#dc2626')
                        .fontSize(14)

                      if (item.data) {
                        Column() {
                          Text(`标题：${item.data.data.title}`)
                            .fontSize(14)
                          Text(`副标题：${item.data.data.sub_title}`)
                            .fontSize(14)
                          Text(`专题：${item.data.data.substance}`)
                            .fontSize(14)
                        }
                        .margin({ top: 8 })
                      }

                      if (item.apps && item.apps.length > 0) {
                        SubmitAppTable({ apps: item.apps })
                          .margin({ top: 8 })
                      }
                    }
                    .backgroundColor('#f9fafb')
                    .borderRadius(12)
                    .padding(16)
                    .width('100%')
                    .margin({ bottom: 12 })
                  })
                }
                .width('100%')
                .margin({ top: 16 })
              }
            }
          }
        }
        .backgroundColor('#ffffff')
        .borderRadius(16)
        .padding(24)
        .width('100%')
        .margin({ top: 16 })
      }
      .width('100%')
      .constraintSize({ maxWidth: 1280 }) // 使用 constraintSize 替代 maxWidth
      .margin({ left: 24, right: 24 })
      .padding(24)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f8fafc')
  }
}