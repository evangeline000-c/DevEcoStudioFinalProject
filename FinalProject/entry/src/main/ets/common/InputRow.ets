@Component
export struct InputRow {
  @State value: string = '';
  @State placeholder: string = '';
  @State icon: Resource | null = null;
  @State inputType: InputType = InputType.Normal;
  onChange?: (v: string) => void;

  build() {
    Row() {
      // 左侧图标
      if (this.icon) {
        Image(this.icon)
          .width(15)
          .margin({ left: '25vp' })
      }

      // 输入框
      TextInput({ placeholder: this.placeholder })
        .type(this.inputType)
        .onChange((v: string) => {
          this.value = v;
          this.onChange && this.onChange(v);
        })
        .placeholderFont({size: 14 })
        .borderRadius(20)
        .width('100%')
        .backgroundColor(Color.Transparent)
        .margin({ left: '8vp', top: '4vp' })
        .layoutWeight(1)
    }
    .width('90%')
    .alignSelf(ItemAlign.Center)
    .height('45vp')
    .margin({bottom: '15vp' })
    .backgroundColor('#e7e4e4')
    .borderRadius(20)
  }
}
