// 卡片入口页面

@Builder
  export function Health_subBuilder() {
  Health_sub()
}

@Component
struct Health_sub {
  build() {
    NavDestination(){
      Column() {
        Text('子页面')
          .width('100%')
          .margin({
            top: '48vp',
            bottom: '12vp'
          })
          .fontWeight(700)
          .fontSize('26fp')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#41E3BF')
  }
}