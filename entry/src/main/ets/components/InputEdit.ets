import { Component, Entry, Prop, Column, TextField, Text, Color, ref, onMounted, nextTick } from '@kit/arkui';

@Entry
@Component
export struct InputEdit {
  @Prop modelValue: string = '';
  @Prop input_name: string = '';
  @Prop type: string = 'text';
  @Prop placeholder: string = 'Enter something';
  @Prop wrapperClass: string = '';
  @Prop inputClass: string = '';
  @Prop labelClass: string = '';
  @Prop inputWrapperClass: string = '';
  @Prop mode: 'input' | 'textarea' = 'input';

  private isFocus = ref(false);
  private effect = ref(!!this.modelValue);
  private inputRef: any = null;

  @Builder
  build() {
    Column({ width: '100%' }) {
      TextField({
        value: this.modelValue,
        placeholder: this.placeholder,
        name: this.input_name,
        type: this.mode === 'input' ? this.type : undefined,
        multiLine: this.mode === 'textarea',
        ref: (v) => (this.inputRef = v),
        onFocus: () => { this.isFocus.value = true; this.applyEffect(); },
        onBlur: () => { this.isFocus.value = false; this.applyEffect(); },
        onChange: (v) => this.handleInput(v),
        height: this.mode === 'input' ? 40 : undefined,
        backgroundColor: Color('transparent'),
      })
    }
  }

  private applyEffect() {
    this.effect.value = this.isFocus.value || !!this.modelValue;
  }

  private handleInput(value: string) {
    this.modelValue = value;
    this.applyEffect();
    if (this.mode === 'textarea') {
      nextTick(() => this.adjustHeight());
    }
  }

  private adjustHeight() {
    if (this.mode !== 'textarea' || !this.inputRef) return;
    this.inputRef.height = this.inputRef.contentHeight + 8;
  }

  onMounted(() => {
  if (this.mode === 'textarea') nextTick(() => this.adjustHeight());
});
}
