import { Component, Entry, Prop, Column, Row, Text, WebView, Color } from "@kit.ArkUI";
import { formatNumber } from '../common/utils';
import type { AppInfo } from '../common/types';

@Entry
@Component
export struct AppDownloadChart {
  @Prop title: string = '';
  @Prop value: AppInfo[] = [];
  @Prop bgFrom: string = 'orange-50';
  @Prop bgTo: string = 'amber-50';
  @Prop darkBgFrom: string = 'orange-950';
  @Prop darkBgTo: string = 'amber-950';
  @Prop borderColor: string = 'orange-100';
  @Prop darkBorderColor: string = 'orange-900';
  @Prop titleColor: string = 'orange-600';
  @Prop darkTitleColor: string = 'orange-400';
  @Prop containerHeight: string = '300px';
  @Prop yAxisMin: boolean = false;

  private chartWebView: WebView | null = null;

  @Builder
  build() {
    Column({
      width: '100%',
      height: this.containerHeight,
      backgroundColor: Color.Transparent,
      borderRadius: 20,
      padding: 16
    }) {
      // 标题栏
      Row({
        height: 40,
        borderBottomWidth: 1,
        borderBottomColor: Color(this.borderColor),
        alignment: 'center'
      }) {
        Text(this.title)
          .fontSize(16)
          .fontWeight('medium')
          .color(Color(this.titleColor))
      }


      // 图表区域
      WebView({
        url: '', // 可加载本地html或远程html，html中渲染ECharts
        flexGrow: 1,
        onLoad: (view) => {
          this.renderChart(view);
        }
      })
        .ref((v) => (this.chartWebView = v));
    }


  }

  private renderChart(view: WebView) {
    if (!view) return;
    // 构造 ECharts 配置 JSON
    const val = [...this.value].sort((a, b) => b.download_count - a.download_count);
    const xAxisData = val.map((item) => item.name);
    const min = Math.min(...val.map((item) => item.download_count));
    const option = {
      backgroundColor: 'transparent',
      xAxis: { data: xAxisData, axisLabel: { rotate: 22.5 } },
      grid: { left: '3%', right: '2%', top: '15%', bottom: '3%' },
      yAxis: this.yAxisMin ? { min: Math.max(Math.round(min * 0.95), 0) } : {},
      tooltip: {},
      series: [
        {
          type: 'bar',
          name: '下载数',
          barWidth: '48px',
          barGap: '20%',
          label: {
            show: true,
            position: 'top',
            formatter: (params: any) => formatNumber(params.value)
          },
          data: val.map((item) => ({ value: item.download_count, app_id: item.app_id }))
        }
      ]
    };


    // 通过 JS 注入到 WebView 渲染图表
    const chartScript = `
  if (!window.chart) {
    const chartDom = document.getElementById('chart');
    window.chart = echarts.init(chartDom);
  }
  window.chart.setOption(${JSON.stringify(option)});
  window.chart.on('click', function(params){
    window.location.href = '/app/' + params.data.app_id;
  });
`;
    view.evaluateJavaScript(chartScript, (res, err) => {
      if (err) console.error(err);
    });


  }
}
