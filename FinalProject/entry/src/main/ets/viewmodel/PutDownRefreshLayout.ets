@Component
export default struct PutDownRefresh {
  @Link refreshText: Resource;

  build() {
    Row() {
      Image($r('app.media.refreshing'))
        .width($r('app.float.distance_40'))
        .height($r('app.float.distance_40'))
      Text(this.refreshText).fontSize($r('app.float.font_size_15'))
    }
    .justifyContent(FlexAlign.Center)
    .width('94%')
    .height('20%')
  }
}