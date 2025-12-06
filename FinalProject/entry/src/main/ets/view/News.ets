//资讯组件

@Component
export default struct News {
  build() {
    Column() {
      //标题部分
      Text('资讯')
        .height('60vp')
        .width('100%')
        .fontWeight(220)//字体粗细
        .fontSize('20fp')//字体大小
        .backgroundColor('#d821deb4')
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#d821deb4')
  }
}