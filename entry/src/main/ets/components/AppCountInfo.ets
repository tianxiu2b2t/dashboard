import { Component, Entry, Prop, Column, Text, Shape, Color, Stack } from '@kit/arkui';

interface MarketInfo {
app_count: {
total: number;
apps: number;
atomic_services: number;
};
developer_count: number;
}

@Entry
@Component
export struct AppCountInfo {
@Prop value: MarketInfo | null;

@Builder
build() {
Column() {
Row({ justifyContent: 'space-between' }) {
this.renderCard('已爬取总数', this.value?.app_count.total ?? 0, 'rose')
this.renderCard('应用总数', this.value?.app_count.apps ?? 0, 'amber')
this.renderCard('元服务总数', this.value?.app_count.atomic_services ?? 0, 'emerald')
this.renderCard('开发者总数', this.value?.developer_count ?? 0, 'indigo')
}
}
}

renderCard(label: string, count: number, color: 'rose' | 'amber' | 'emerald' | 'indigo') {
Column({
width: 150,
height: 120,
backgroundColor: Color.Transparent,
borderRadius: 20,
padding: 16,
alignment: 'center'
}) {
// 模拟渐变和暗黑模式，可根据实际主题再优化
Stack() {
Shape({
shapeType: 'rectangle',
fillColor: Color(color + '50'),
borderColor: Color(color + '100'),
borderWidth: 1,
borderRadius: 20
})
}
Column({ alignment: 'center' }) {
Text(label)
.fontSize(14)
.color(Color(color + '600'))
Text(count.toString())
.fontSize(24)
.fontWeight('bold')
.color(Color(color + '800'))
}
}
}
}
