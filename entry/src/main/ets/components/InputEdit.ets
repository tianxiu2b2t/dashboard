@Component
export struct InputEdit {
  // Props
  @Prop modelValue: string = ''
  @Prop input_name: string = ''
  @Prop type: string = 'text'
  @Prop placeholder: string = 'Enter something'
  @Prop wrapperClass: string = ''
  @Prop inputClass: string = ''
  @Prop labelClass: string = ''
  @Prop inputWrapperClass: string = ''
  @Prop mode: string = 'input' // 'input' | 'textarea'

  // Local state
  @State isFocus: boolean = false
  @State effect: boolean = false
  @State textAreaHeight: number = 40

  // Emit events
  @Emit('update:modelValue') updateModelValue: (value: string) => void

  aboutToAppear() {
    this.effect = !!this.modelValue
    if (this.mode === 'textarea') {
      this.adjustHeight()
    }
  }

  aboutToUpdate() {
    this.effect = this.isFocus || !!this.modelValue
    if (this.mode === 'textarea') {
      this.adjustHeight()
    }
  }

  // Handle input events
  handleInput(value: string) {
    this.updateModelValue(value)
    if (this.mode === 'textarea') {
      this.adjustHeight()
    }
  }

  // Adjust textarea height
  adjustHeight() {
    // 在 ArkTS 中，我们需要通过计算文本行数来调整高度
    // 这里使用简单的行数估算
    const lineCount = (this.modelValue.match(/\n/g) || []).length + 1
    this.textAreaHeight = Math.max(40, lineCount * 24) // 每行大约24px高度
  }

  // Focus input
  focusInput() {
    // 在 ArkTS 中，我们通过状态管理来触发焦点
    this.isFocus = true
  }

  // Handle focus
  handleFocus() {
    this.isFocus = true
  }

  // Handle blur
  handleBlur() {
    this.isFocus = false
  }

  build() {
    Column() {
      // Main wrapper
      Column() {
        // Label
        Text(this.placeholder)
          .fontSize(this.effect ? 12 : 14)
          .fontColor(this.getLabelColor())
          .position({ x: 0, y: this.effect ? -9 : 10 })
          .scale({ x: this.effect ? 0.75 : 1, y: this.effect ? 0.75 : 1 })
          .transformOrigin({ x: 0, y: 0 })
          .transition({ type: TransitionType.All, duration: 200, curve: Curve.EaseInOut })

        // Input wrapper
        Column() {
          if (this.mode === 'textarea') {
            // TextArea mode
            TextArea({ text: this.modelValue, placeholder: '' })
              .onChange((value: string) => {
                this.handleInput(value)
              })
              .onFocus(() => {
                this.handleFocus()
              })
              .onBlur(() => {
                this.handleBlur()
              })
              .width('100%')
              .height(this.textAreaHeight)
              .minHeight(40)
              .backgroundColor(Color.Transparent)
              .fontColor(this.getTextColor())
              .padding({ 
                left: 14, 
                right: 14, 
                top: 8.25, 
                bottom: 8.25 
              })
          } else {
            // Input mode
            TextInput({ 
              text: this.modelValue, 
              placeholder: '' 
            })
              .onChange((value: string) => {
                this.handleInput(value)
              })
              .onFocus(() => {
                this.handleFocus()
              })
              .onBlur(() => {
                this.handleBlur()
              })
              .type(this.getInputType())
              .width('100%')
              .height(40)
              .backgroundColor(Color.Transparent)
              .fontColor(this.getTextColor())
              .padding({ 
                left: 14, 
                right: 14, 
                top: 8.25, 
                bottom: 8.25 
              })
          }

          // Fieldset simulation - 在 ArkTS 中我们需要用其他方式模拟边框效果
          this.buildFieldset()
        }
        .width('100%')
        .borderRadius(this.getBorderRadius())
        .border({
          width: 1,
          color: this.getBorderColor()
        })
        .backgroundColor(this.getInputWrapperBackground())
      }
      .width('100%')
      .height('100%')
      .onClick(() => {
        this.focusInput()
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.getWrapperBackground())
  }

  @Builder buildFieldset() {
    // 在 ArkTS 中模拟 fieldset 和 legend 效果
    // 使用叠加的边框和文本来实现
    Stack() {
      if (this.effect) {
        Text(this.placeholder)
          .fontSize(12)
          .fontColor(this.getLegendColor())
          .position({ x: 14, y: -6 })
          .backgroundColor(this.getLegendBackground())
          .padding({ left: 5, right: 5 })
      }
    }
    .width('100%')
    .height('100%')
  }

  // Style helper methods
  getWrapperBackground(): ResourceColor {
    // 根据 wrapperClass 返回对应的背景色
    // 这里简化处理，实际应该根据传入的类名映射
    return Color.White
  }

  getInputWrapperBackground(): ResourceColor {
    // 根据 inputWrapperClass 返回对应的背景色
    return Color.Transparent
  }

  getBorderColor(): ResourceColor {
    return this.isFocus ? '#1890FF' : '#D9D9D9'
  }

  getBorderRadius(): number {
    return 4
  }

  getLabelColor(): ResourceColor {
    return this.isFocus ? '#1890FF' : '#666666'
  }

  getTextColor(): ResourceColor {
    return '#000000'
  }

  getLegendColor(): ResourceColor {
    return '#1890FF'
  }

  getLegendBackground(): ResourceColor {
    return Color.White
  }

  getInputType(): InputType {
    switch (this.type) {
      case 'password':
        return InputType.Password
      case 'number':
        return InputType.Number
      case 'email':
        return InputType.Email
      case 'phone':
        return InputType.PhoneNumber
      default:
        return InputType.Normal
    }
  }
}