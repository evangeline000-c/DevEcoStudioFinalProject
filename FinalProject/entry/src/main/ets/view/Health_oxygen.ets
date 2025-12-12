//血氧页面

@Component
export default struct Health_oxygen {
  build() {
    NavDestination(){
      Column() {
        Text('血氧')
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