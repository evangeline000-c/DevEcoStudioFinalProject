// 导航项组件
@Component
export struct NavItem {
  @Prop icon: string ;
  @Prop text: string ;

  build() {
    Column() {
      Row() {
        // 左侧图标
        Image($r(this.icon))
          .height(20)
          .margin({ right: 12 })

        // 中间文字
        Text(this.text)
          .fontSize(16)
          .fontColor('#333')
          .layoutWeight(1) 
          .textAlign(TextAlign.Start)

        // 右侧箭头
        Image($r('app.media.arrow_My'))
          .height(20)
          .margin({ left: 8 })
      }
      .padding(12)
      .width('60%')
      .height(40)
      .margin({ top: 15 })
      .borderRadius(5)
      .backgroundColor('#FFFFFF')
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
        .width(80)
        .height(80)
        .borderRadius(40)
        .objectFit(ImageFit.Cover)
        .margin({ bottom: 12 });

      // 用户名
      Text(this.userName)
        .fontSize(20)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 12 });

      // 用户电话
      Text(this.userPhone)
        .fontSize(14)
        .fontColor('#FFFFFF')
    }
    //.alignItems(ItemAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(200)
    .backgroundImage($r(this.bgImage))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .margin({ bottom: 20 })
    .backgroundColor('#40E0D0')
  }
}