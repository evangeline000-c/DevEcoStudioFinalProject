import CommonConstants from '../common/CommonContants'
@Component
export struct InputRow {
  @State value: string = '';
  @State placeholder: Resource|string = '';
  @State icon: Resource | null = null;
  @State inputType: InputType = InputType.Normal;
  onChange?: (v: string) => void;

  build() {
    Row() {
      // 左侧图标
      if (this.icon) {
        Image(this.icon)
          .width($r('app.float.layout_15'))
          .margin({ left: $r('app.float.layout_25') })
      }

      // 输入框
      TextInput({ placeholder: this.placeholder })
        .type(this.inputType)
        .onChange((v: string) => {
          this.value = v;
          this.onChange && this.onChange(v);
        })
        .placeholderFont({size: $r('app.float.font_size_14') })
        .borderRadius($r('app.float.distance_20'))
        .width(CommonConstants.FULL_PARENT)
        .backgroundColor(Color.Transparent)
        .margin({ left: $r('app.float.distance_8'), top: $r('app.float.layout_4') })
        .layoutWeight(1)
    }
    .width(CommonConstants.NINETY_PARENT)
    .alignSelf(ItemAlign.Center)
    .height($r('app.float.height_45'))
    .margin({bottom: $r('app.float.layout_15') })
    .backgroundColor($r('app.color.background_gray'))
    .borderRadius($r('app.float.distance_20'))
  }
}
