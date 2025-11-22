import { Component, Entry, Prop, Column, Row, Text, WebView, Color } from '@kit/arkui';
import type { RatingInfo } from '../common/types';

@Entry
@Component
export struct AppTotalStarChart {
  @Prop value: RatingInfo = {};

  private chartWebView: WebView | null = null;

  @Builder
  build() {
    Column({ width: '100%', height: '100%', borderRadius: 20, padding: 16, backgroundColor: Color('transparent') }) {
      // 标题栏
      Row({ height: 50, borderBottomWidth: 1, borderBottomColor: Color('#d8b4fe'), alignment: 'center' }) {
        Text('总应用评分分布').fontSize(16).fontWeight('medium').color(Color('#7c3aed'))
      }


      // 图表区域
      WebView({
        flexGrow: 1,
        onLoad: (view) => { this.renderChart(view) }
      }).ref((v) => (this.chartWebView = v))
    }


  }

  private renderChart(view: WebView) {
    if (!view) return;


    const data = [
      { value: this.value.star_1, name: '无评分' },
      { value: this.value.star_2, name: '[1-2]星' },
      { value: this.value.star_3, name: '[2-3]星' },
      { value: this.value.star_4, name: '[3-4]星' },
      { value: this.value.star_5, name: '[4-5]星' },
    ];

    const option = {
      backgroundColor: 'transparent',
      tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
      legend: { data: ['无评分','[1-2]星','[2-3]星','[3-4]星','[4-5]星'] },
      series: [{
        name: '评分分布',
        type: 'pie',
        radius: '60%',
        center: ['50%', '40%'],
        label: { formatter: '{b}: {c} ({d}%)' },
        data
      }]
    };

    const chartScript = `
  if (!window.chart) {
    const chartDom = document.getElementById('chart');
    window.chart = echarts.init(chartDom);
  }
  window.chart.setOption(${JSON.stringify(option)});
`;
    view.evaluateJavaScript(chartScript, (res, err) => { if(err) console.error(err); });


  }
}
