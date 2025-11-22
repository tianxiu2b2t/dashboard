import { Component, Entry, Prop, Column, Row, Text, Picker, Button, TextField, WebView, Color } from "@kit.ArkUI";
import { formatNumber } from '../common/utils';
import type { RankingsDownloadIncrease, RankingsDownloadIncreaseType } from '../common/types';
import { fetchIconUrl, fetchRankingDownloadIncrease } from '../common/api';

@Entry
@Component
export struct AppDownloadIncreaseCompar {
  private downloadIncreaseData: RankingsDownloadIncrease[] = [];
  private growthChartWebView: WebView | null = null;

  private sortedBy: RankingsDownloadIncreaseType = 'increment';
  private priorDays: number = 1;
  private pageSize: number = 20;
  private page: number = 0;
  private inputPage: number = 1;
  private fromDate?: string;
  private toDate?: string;
  private isVertical: boolean = false;

  @Builder
  build() {
    Column({
      width: '100%',
      height: '100%',
      borderRadius: 20,
      padding: 16,
      backgroundColor: Color('transparent')
    }) {
      // 顶部标题栏和选择器
      Row({ justifyContent: 'space-between', height: 60 }) {
        Column() {
          Text('应用下载增长对比').fontSize(16).fontWeight('medium').color(Color('#6366f1'))
          Text(`应用对比日期 ${this.fromDate ?? '未知'} - ${this.toDate ?? '未知'}`).fontSize(12)
        }
        Row({ gap: 8 }) {
          Picker({ selectedValue: this.priorDays, values: [1,7,30], onChange: (v) => { this.priorDays = v } })
          Picker({ selectedValue: this.sortedBy, values: ['increment','prior','current'], onChange: (v) => { this.sortedBy = v } })
        }
      }


      // 图表区域
      WebView({ flexGrow: 1, onLoad: (view) => { this.renderChart(view) } })
        .ref((v) => (this.growthChartWebView = v))

      // 分页控件
      Row({ justifyContent: 'flex-end', gap: 8, height: 40 }) {
        Button({ text: '上一页', disabled: this.page === 0, onClick: () => { this.page-- } })
        Text(`第 ${this.page + 1} 页 / 共 ${this.totalPages()} 页`).fontSize(12)
        TextField({ value: this.inputPage.toString(), width: 60, onChange: (v) => { this.inputPage = Number(v) } })
        Button({ text: '跳转', disabled: this.inputPage < 1 || this.inputPage > this.totalPages(), onClick: () => { this.page = this.inputPage - 1 } })
        Button({ text: '下一页', disabled: this.page + 1 >= this.totalPages(), onClick: () => { this.page++ } })
      }
    }


  }

  private totalPages() {
    return Math.ceil(this.downloadIncreaseData.length / this.pageSize);
  }

  async refreshData() {
    const resp = await fetchRankingDownloadIncrease({ days: this.priorDays });
    this.downloadIncreaseData = resp.data;
    this.page = 0;
    this.inputPage = 1;
    this.updateChart();
  }

  private async updateChart() {
    if (!this.growthChartWebView) return;


    this.fromDate = this.downloadIncreaseData[0]?.prior_period_date;
    this.toDate = this.downloadIncreaseData[this.downloadIncreaseData.length-1]?.current_period_date;

    const sortKeys: Record<RankingsDownloadIncreaseType, string> = {
      increment: 'download_increment',
      prior: 'prior_download_count',
      current: 'current_download_count'
    };
    const sortedKey = sortKeys[this.sortedBy] as keyof RankingsDownloadIncrease;

    const sortedData = [...this.downloadIncreaseData].sort(
      (a, b) => (b[sortedKey] as number) - (a[sortedKey] as number)
    );
    const pagedData = sortedData.slice(this.page*this.pageSize, (this.page+1)*this.pageSize);
    const data = this.isVertical ? pagedData.reverse() : pagedData;
    const max = Math.max(...data.map(item => item[sortedKey] as number));

    const icons: Record<string,string> = {};
    await Promise.all(data.map(item => fetchIconUrl({ app_id: item.app_id }).then(res => icons[item.app_id] = res)));

    const option = {
      backgroundColor: 'transparent',
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: this.isVertical ? { type: 'value', max, axisLabel: { color: '#333' } } : { type: 'category', data: data.map(d=>d.name), axisLabel: { rotate:30, color:'#333' } },
      yAxis: this.isVertical ? { type: 'category', data: data.map(d=>d.name), axisLabel: { color:'#333' } } : { type:'value', axisLabel: { color:'#333' } },
      series: [{
        name: '下载量',
        type: 'bar',
        data: data.map(item => ({ value: item[sortedKey] as number, app_id: item.app_id })),
        itemStyle: { color: '#6366f1' }
      }]
    };

    const chartScript = `
  if (!window.chart) {
    const chartDom = document.getElementById('chart');
    window.chart = echarts.init(chartDom);
  }
  window.chart.setOption(${JSON.stringify(option)});
  window.chart.on('click', function(params){ window.location.href = '/app/' + params.data.app_id; });
`;
    this.growthChartWebView.evaluateJavaScript(chartScript, (res, err) => { if(err) console.error(err); });

  }

  onMounted() {
    this.refreshData();
    // 可根据屏幕比例设置 isVertical
    this.isVertical = window.innerHeight > window.innerWidth;
  }
}
