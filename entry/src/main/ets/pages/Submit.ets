import { Component, Entry, Column, Text, Color, ref, Builder } from '@kit/arkui';
import { SwitchBar } from '../components/SwitchBar';
import { InputEdit } from '../components/InputEdit';
import { SubmitAppTable } from '../components/SubmitAppTable';
import type { SubmitParseResult, SubmitSubstanceResult, CommentInfo } from '../common/types';
import { fetchAppDetail, submitApp, submitSubstance } from '../common/api';

@Entry
@Component
export struct SubmitPage {
  private switched = ref(0);
  private mixedUrlPkg = ref('');
  private mixedSubstance = ref('');
  private results = ref<SubmitParseResult[]>([]);
  private substanceResults = ref<SubmitSubstanceResult[]>([]);
  private note = ref('');
  private username = ref('');
  private progress = ref(0);
  private progressTotal = ref(0);

  private getComment(): CommentInfo {
    return { platform: 'txit', user: this.username.value || undefined, note: this.note.value || undefined };
  }

  @Builder
  build() {
    Column({ width: '100%', maxWidth: 1280, marginHorizontal: 'auto', padding: 24, gap: 24 }) {
      Text('应用投稿').fontSize(20).fontWeight('bold').color(Color('#ea580c')).darkColor(Color('#f97316')).margin({ bottom: 8 })
      Text('提交应用信息到数据库，帮助我们完善应用市场看板').color(Color('#374151')).darkColor(Color('#d1d5db'))

      Column({ backgroundColor: Color('#ffffff'), darkBackgroundColor: Color('#111827'), borderRadius: 16, padding: 24, gap: 16 }) {
        InputEdit({ modelValue: this.username, placeholder: '用户名（可选）', mode: 'input' })
        InputEdit({ modelValue: this.note, placeholder: '备注信息', mode: 'textarea' })
      }

      Column({ backgroundColor: Color('#ffffff'), darkBackgroundColor: Color('#111827'), borderRadius: 16, padding: 24, gap: 16 }) {
        SwitchBar({ data: ['应用', '专题'], modelValue: this.switched })

        if (this.switched.value === 0) {
          InputEdit({ modelValue: this.mixedUrlPkg, placeholder: '应用详情页链接 / 包名', mode: 'textarea' })

          if (this.results.value.length > 0) {
            Text('解析结果').fontSize(20).fontWeight('bold').color(Color('#1f2937')).darkColor(Color('#f3f4f6')).margin({ bottom: 8 })
            Text(`进度：${this.progress.value} / ${this.progressTotal.value}`).fontSize(14).fontWeight('bold')
            SubmitAppTable({ apps: this.results.value })
          }
        }

        if (this.switched.value === 1) {
          InputEdit({ modelValue: this.mixedSubstance, placeholder: '主题链接 / ID', mode: 'textarea' })

          if (this.substanceResults.value.length > 0) {
            Text('解析结果').fontSize(20).fontWeight('bold').color(Color('#1f2937')).darkColor(Color('#f3f4f6')).margin({ bottom: 8 })

            this.substanceResults.value.forEach((item) => {
              Column({ backgroundColor: Color('#f9fafb'), darkBackgroundColor: Color('#111827'), borderRadius: 12, padding: 16, gap: 8 }) {
                Text(`ID: ${item.id}`).fontWeight('semibold')
                Text(item.get_data ? '已获取数据' : '未获取').color(item.get_data ? Color('#16a34a') : Color('#dc2626'))

                if (item.data) {
                  Text(`标题：${item.data.data.title}`)
                  Text(`副标题：${item.data.data.sub_title}`)
                  Text(`专题：${item.data.data.substance}`)
                }

                if (item.apps?.length) {
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
