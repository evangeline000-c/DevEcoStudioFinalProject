// 导航项组件
import CommonConstants from '../common/CommonContants'
@Component
export struct NavItem {
  @Prop icon: string ;
  @Prop text: Resource|string ;

  build() {
    Column() {
      Row() {
        // 左侧图标
        Image($r(this.icon))
          .height($r('app.float.distance_20'))
          .margin({ right: $r('app.float.distance_12') })

        // 中间文字
        Text(this.text)
          .fontSize($r('app.float.font_size_15'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1) 
          .textAlign(TextAlign.Start)

        // 右侧箭头
        Image($r('app.media.arrow_My'))
          .height($r('app.float.distance_20'))
          .margin({ left: $r('app.float.distance_8') })
      }
      .padding($r('app.float.distance_12'))
      .width(CommonConstants.NINETY_PARENT)
      .height($r('app.float.distance_50'))
      .margin({ top: 15 })
      .borderRadius($r('app.float.distance_5'))
      .backgroundColor($r('app.color.white'))
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
  }
}

// 顶部用户信息
@Component
export struct UserHeader {
  @Prop bgImage: string ;
  @Prop avatar: string ;
  @Prop userName: string ;
  @Prop userPhone: string ;

  build() {
    Column() {
      // 头像
      Image($r(this.avatar))
        .width($r('app.float.distance_80'))
        .height($r('app.float.distance_80'))
        .borderRadius($r('app.float.distance_40'))
        .objectFit(ImageFit.Cover)
        .margin({ bottom: $r('app.float.distance_12') });

      // 用户名
      Text(this.userName)
        .fontSize($r('app.float.font_size_20'))
        .fontColor($r('app.color.white'))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: $r('app.float.distance_12') });

      // 用户电话
      Text(this.userPhone)
        .fontSize($r('app.float.font_size_14'))
        .fontColor($r('app.color.white'))
    }
    //.alignItems(ItemAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width(CommonConstants.FULL_PARENT)
    .height($r('app.float.height_200'))
    .backgroundImage($r(this.bgImage))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .margin({ bottom: $r('app.float.distance_20') })
    .backgroundColor($r('app.color.main_green'))
  }
}