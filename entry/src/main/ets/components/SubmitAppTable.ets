import { Component, Entry, Column, Row, Text, Image, Color, ScrollView } from '@kit/arkui';
import type { SubmitParseResult } from '../common/types';
import { formatNumber, formatSize } from '../common/utils';
import { useRouter } from '@kit/arkui';

@Entry
@Component
export struct SubmitAppTable {
  @Prop apps: SubmitParseResult[] = [];

  private router = useRouter();

  @Builder
  build() {
    Column({ width: '100%', borderRadius: 10, overflow: 'hidden' }) {
      // 表头
      Row({ backgroundColor: Color('#f3f4f6'), padding: 8 }) {
        ['图标','包名','应用名称','下载量','大小','列出时间','状态'].forEach(header => {
          Text(header).fontSize(12).fontWeight('medium').color(Color('#374151')).width(120)
        })
      }


      ScrollView({ flexGrow: 1 }) {
        Column({ gap: 0 }) {
          this.apps.forEach((item, index) => {
            Row({ padding: 8, hoverColor: Color('#e5e7eb'), onClick: () => this.openDetail(item.full_info?.app_id) }) {
              // 图标
              if(item.full_info?.icon_url) {
                Image({ src: item.full_info.icon_url, width: 32, height: 32, borderRadius: 4 })
              } else {
                Text('—').color(Color('#9ca3af')).italic()
              }

              // 包名
              Text(item.pkg_name).width(120).color(Color('#1f2937'))

              // 应用名称
              if(item.full_info?.name) {
                Text(item.full_info.name).width(120).color(Color('#1f2937'))
              } else if(item.exists === false) {
                Text('未找到').width(120).color(Color('#ef4444')).italic()
              } else {
                Text('加载中...').width(120).color(Color('#9ca3af')).italic()
              }

              // 下载量
              if(item.full_info?.download_count !== undefined) {
                Text(formatNumber(item.full_info.download_count)).width(120).color(Color('#1f2937'))
              } else {
                Text('—').width(120).color(Color('#9ca3af')).italic()
              }

              // 大小
              if(item.full_info?.size_bytes !== undefined) {
                Text(formatSize(item.full_info.size_bytes)).width(120).color(Color('#1f2937'))
              } else {
                Text('—').width(120).color(Color('#9ca3af')).italic()
              }

              // 列出时间
              if(item.full_info?.listed_at) {
                Text(new Date(item.full_info.listed_at).toLocaleDateString()).width(120).color(Color('#1f2937'))
              } else {
                Text('—').width(120).color(Color('#9ca3af')).italic()
              }

              // 状态
              if(item.new_app === true) {
                Text('新应用！').width(120).color(Color('#16a34a')).fontWeight('semibold')
              } else if(item.new_app === false) {
                Text('已存在').width(120).color(Color('#6b7280'))
              } else {
                Text('—').width(120).color(Color('#9ca3af')).italic()
              }
            }
          })
        }
      }
    }


  }

  private openDetail(app_id?: string) {
    if(!app_id) return;
    this.router.push(`/app/${app_id}`);
  }
}
