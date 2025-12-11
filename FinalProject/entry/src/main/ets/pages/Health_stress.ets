//压力页面

@Builder
  export function Health_stressBuilder() {
  Health_stress()
}

@Component
struct Health_stress {
  build() {
    NavDestination(){
      Column() {
        Text('压力')
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