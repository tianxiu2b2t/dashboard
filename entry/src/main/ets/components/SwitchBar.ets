import { Component, Entry, Column, Row,
  Button, Color, ref, nextTick, defineExpose } from '@kit/arkui';

@Entry
@Component
export struct SwitchBar {
  @Prop data: string[] = [];
  @Prop modelValue: number = 0;

  private active = ref(this.modelValue);
  private indicatorX = ref(0);
  private indicatorWidth = ref(0);
  private btns: any[] = [];

  @Builder
  build() {
    Column({ width: '100%', position: 'relative' }) {
      Row({ gap: 8 }) {
        this.data.forEach((value, i) => {
          Button({
            text: value,
            borderRadius: 8,
            backgroundColor: Color('transparent'),
            color: Color('#000000'),
            onClick: () => this.setActive(i)
          })
        })
      }


      // 指示器
      Row({
        position: 'absolute',
        bottom: 0,
        height: 4,
        backgroundColor: Color('#3b82f6'),
        borderRadius: 4,
        width: this.indicatorWidth,
        transform: `translateX(${this.indicatorX}px)`,
        transition: 'all 0.3s ease-in-out'
      })
    }


  }

  private setActive(i: number) {
    this.active.value = i;
    this.updateIndicator();
  }

  private updateIndicator() {
    nextTick(() => {
      const btnEl = this.btns[this.active.value];
      if(!btnEl) return;
      this.indicatorWidth = btnEl.width;
      this.indicatorX = btnEl.x;
    });
  }

  onMounted() {
    this.btns = this.data.map((_, i) => ({ width: 80*i + 80, x: 80*i })); // 模拟按钮布局，可根据实际测量优化
    nextTick(() => this.updateIndicator());
  }

  // 暴露 active 给父组件
  defineExpose() {
    return { active: this.active };
  }
}
