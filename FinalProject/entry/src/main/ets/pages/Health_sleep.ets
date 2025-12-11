//睡眠页面

@Builder
  export function Health_sleepBuilder() {
  Health_sleep()
}

@Component
struct Health_sleep {
  build() {
    NavDestination(){
      Column() {
        Text('睡眠')
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
  }
}