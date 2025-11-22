import { Component, Entry, Prop, Column, Row, Text, TextField, Button, Checkbox, Color, ScrollView } from "@kit.ArkUI";
import type { AppInfo, AppListParams, AppListSortType } from '../common/types';
import { fetchAppList } from '../common/api';
import { formatNumber, formatSize, formatDate } from '../common/utils';
import { useRouter } from '@kit/arkui';

@Entry
@Component
export struct AppSearchList {
  private searchContent: string = '';
  private searchKey: string = 'name';
  private exactMatch: boolean = false;
  private excludeHuawei: boolean = false;
  private excludeAtomic: boolean = false;

  private sortKey: AppListSortType = 'download_count';
  private sortDesc: boolean = true;
  private currentPage: number = 1;
  private pageSize: number = 20;
  private totalCount: number = 0;
  private apps: AppInfo[] = [];
  private loading: boolean = false;
  private jumpPage: number = 1;

  private router = useRouter();

  @Builder
  build() {
    Column({ width: '100%', borderRadius: 20, padding: 16, backgroundColor: Color('transparent'), flexGrow: 1 }) {
      // 搜索区域
      Row({ justifyContent: 'space-between', gap: 8, height: 60 }) {
        Text('应用列表').fontSize(16).fontWeight('medium').color(Color('#d97706'))


        Row({ gap: 8 }) {
          TextField({ value: this.searchContent, placeholder: '搜索应用', width: 180, onChange: (v) => { this.searchContent = v } })
          TextField({ value: this.searchKey, placeholder: '搜索字段', width: 120, onChange: (v) => { this.searchKey = v } })
          Checkbox({ value: this.excludeHuawei, label: '排除华为应用', onChange: (v) => { this.excludeHuawei = v } })
          Checkbox({ value: this.excludeAtomic, label: '排除元服务', onChange: (v) => { this.excludeAtomic = v } })
          Checkbox({ value: this.exactMatch, label: '精确匹配', onChange: (v) => { this.exactMatch = v } })
          Button({ text: '搜索', onClick: () => this.handleSearch() })
          Button({ text: '重置搜索', onClick: () => this.resetSearch() })
        }
      }

      // 表格区域
      Scroll({ flexGrow: 1 }) {
        Column({ gap: 0 }) {
          // 表头
          Row({ backgroundColor: Color('#fef3c7'), padding: 4 }) {
            ['序号','应用名称','开发者','分类','评分','评分数量','下载量','大小','上次数据更新','应用爬取时间','应用上架时间'].forEach(header => {
              Text(header).fontSize(12).fontWeight('medium').color(Color('#b45309')).width(120)
            })
          }

          // 数据行
          this.apps.forEach((app, index) => {
            Row({ padding: 4, hoverColor: Color('#fef3c7'), onClick: () => this.goToAppDetail(app.app_id) }) {
              Text((index + 1 + (this.currentPage-1)*this.pageSize).toString()).width(60)
              Text(app.name).width(180)
              Text(app.developer_name || '—').width(220)
              Text(`${app.kind_type_name}-${app.kind_name}-${app.tag_name}`).width(180)
              Text((app.average_rating || 0).toFixed(1)).width(140)
              Text(formatNumber(app.total_star_rating_count || 0)).width(120)
              Text(formatNumber(app.download_count)).width(120)
              Text(formatSize(app.size_bytes || 0)).width(120)
              Text(formatDate(app.metrics_created_at)).width(160)
              Text(formatDate(app.created_at)).width(140)
              Text(formatDate(app.listed_at)).width(160)
            }
          })

          // 加载或空数据提示
          if (this.loading) {
            Row({ justifyContent: 'center', padding: 8 }) {
              Text('加载中...').color(Color('#b45309'))
            }
          } else if (this.apps.length === 0) {
            Row({ justifyContent: 'center', padding: 8 }) {
              Text('暂无数据').color(Color('#b45309'))
            }
          }
        }
      }

      // 分页
      Row({ justifyContent: 'center', gap: 4, paddingTop: 8 }) {
        Button({ text: '首页', disabled: this.currentPage===1, onClick: () => this.goToPage(1) })
        Button({ text: '上一页', disabled: this.currentPage===1, onClick: () => this.goToPage(this.currentPage-1) })
        TextField({ value: this.jumpPage.toString(), width: 50, onChange: (v) => { this.jumpPage = Number(v) } })
        Button({ text: '跳转', onClick: () => this.jumpToPage() })
        Button({ text: '下一页', disabled: this.currentPage >= this.totalPages(), onClick: () => this.goToPage(this.currentPage+1) })
        Button({ text: '尾页', disabled: this.currentPage >= this.totalPages(), onClick: () => this.goToPage(this.totalPages()) })
      }
    }


  }

  private totalPages() {
    return Math.max(1, Math.ceil(this.totalCount/this.pageSize));
  }

  private async handleSearch() {
    this.currentPage = 1;
    await this.loadApps();
  }

  private async resetSearch() {
    this.searchContent = '';
    this.searchKey = 'name';
    this.exactMatch = false;
    this.excludeHuawei = false;
    this.excludeAtomic = false;
    this.currentPage = 1;
    await this.loadApps();
  }

  private async loadApps() {
    this.loading = true;
    const params: AppListParams = {
      page: this.currentPage,
      page_size: this.pageSize,
      sort: this.sortKey,
      desc: this.sortDesc,
      search_key: this.searchContent ? this.searchKey : undefined,
      search_value: this.searchContent || undefined,
      search_exact: this.searchContent ? this.exactMatch : undefined,
      exclude_huawei: this.excludeHuawei || undefined,
      exclude_atomic: this.excludeAtomic || undefined,
    };
    try {
      const result = await fetchAppList(params);
      this.apps = result.data;
      this.totalCount = result.total_count;
    } finally {
      this.loading = false;
    }
  }

  private goToAppDetail(appId: string) {
    this.router.push(`/app/${appId}`);
  }

  private jumpToPage() {
    if (this.jumpPage >= 1 && this.jumpPage <= this.totalPages()) {
      this.goToPage(this.jumpPage);
    }
  }

  private goToPage(page: number) {
    if (page >=1 && page <= this.totalPages()) {
      this.currentPage = page;
      this.loadApps();
    }
  }
}
