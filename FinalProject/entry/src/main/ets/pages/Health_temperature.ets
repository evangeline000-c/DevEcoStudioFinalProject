//温度页面

@Builder
  export function Health_temperatureBuilder() {
  Health_temperature()
}

@Component
struct Health_temperature {
  build() {
    NavDestination(){
      Column() {
        Text('体温')
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