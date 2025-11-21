import { Component, Entry, Column, Row, Text, ProgressCircle, Color } from '@kit/arkui';

@Entry
@Component
export struct Loading {
@Builder
build() {
Column({ width: '100%', height: 300, justifyContent: 'center', alignItems: 'center' }) {
Column({ alignItems: 'center' }) {
ProgressCircle({
size: 40,
strokeWidth: 2,
progress: 100,
color: Color('#3b82f6'),
trackColor: Color('transparent'),
indeterminate: true
}).margin({ bottom: 8 })
Text('加载中...').color(Color('#6b7280'))
}
}
}
}
