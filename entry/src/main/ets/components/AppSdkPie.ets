import { Component, Entry, Prop, Column, Row, Text, WebView, Color } from '@kit/arkui';
import type { SdkPie } from '../types';
import { formatSDKVersion } from '../utils';

@Entry
@Component
export struct AppSdkPie {
@Prop value: SdkPie[] = [];
@Prop title: string = '评分分布';

private chartWebView: WebView | null = null;

@Builder
build() {
Column({
width: '100%',
height: '100%',
borderRadius: 20,
padding: 16,
backgroundColor: Color('transparent')
}) {
// 标题栏
Row({ height: 50, borderBottomWidth: 1, borderBottomColor: Color('#d8b4fe'), alignment: 'center' }) {
Text(this.title).fontSize(16).fontWeight('medium').color(Color('#7c3aed'))
}

```
  // 图表区域
  WebView({
    flexGrow: 1,
    onLoad: (view) => { this.renderChart(view) }
  }).ref((v) => (this.chartWebView = v))
}
```

}

private renderChart(view: WebView) {
if (!view) return;
const legendDatas = this.value.map(item => formatSDKVersion(item[0]));
const option = {
backgroundColor: 'transparent',
tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
legend: { data: legendDatas },
series: [{
name: '评分分布',
type: 'pie',
radius: '48%',
center: ['50%', '30%'],
label: { formatter: '{b}: {c} ({d}%)' },
data: this.value.map(item => ({ value: item[1], name: formatSDKVersion(item[0]) }))
}]
};

```
const chartScript = `
  if (!window.chart) {
    const chartDom = document.getElementById('chart');
    window.chart = echarts.init(chartDom);
  }
  window.chart.setOption(${JSON.stringify(option)});
`;
view.evaluateJavaScript(chartScript, (res, err) => {
  if(err) console.error(err);
});
```

}
}
