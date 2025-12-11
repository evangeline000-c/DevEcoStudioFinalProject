//血压页面

@Builder
  export function Health_pressureBuilder() {
  Health_pressure()
}

@Component
struct Health_pressure {
  build() {
    NavDestination(){
      Column() {
        Text('血压')
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