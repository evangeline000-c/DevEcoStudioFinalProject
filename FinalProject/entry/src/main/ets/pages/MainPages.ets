//首页和健康宣教和用户档案和我的和资讯这5个在pages文件夹下共用的文件

import Home from "../view/Home"
import Health from "../view/Health"
import My from "../view/My"
import News from "../view/News"
import UserProfile from "../view/UserProfile"

//MainPage()的入口函数
@Builder
export function MainPageBuilder() {
  MainPages()
}

@Component
export struct MainPages {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder
  TabBuilder(title: ResourceStr, index: number, selectedImg: Resource) {
    Column() {
      SymbolGlyph(selectedImg)
        .fontSize('24fp')
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP),
          this.currentIndex === index ? true : false)
        .fontColor(this.currentIndex === index ? ['#0a59f7'] : ['#66000000'])
      Text(title)
        .margin({ top: '4vp' })
        .fontSize(10)
        .fontWeight(500)
        .fontColor(this.currentIndex === index ? '#0a59f7' : '#66000000')
    }
    .backgroundColor('#F1F3F5')
    .justifyContent(FlexAlign.Center)
    .height('56vp')
    .width('100%')
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }


  build(){
    NavDestination() { //不要删这个NavDestination是用来跳转的
      Column() {
        Tabs({
          barPosition: BarPosition.End,
          controller: this.tabsController
        }) {
          TabContent() {
            Home()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('首页', 0, $r('sys.symbol.house_fill')))

          TabContent() {
            Health()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('健康', 1, $r('sys.symbol.house_fill')))

          TabContent() {
            News()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('资讯', 2, $r('sys.symbol.house_fill')))

          TabContent() {
            UserProfile()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('用户档案', 3, $r('sys.symbol.house_fill')))

          TabContent() {
            My()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('我的', 4, $r('sys.symbol.house_fill')))
        }
        .margin({ bottom: '64vp' })
        .width('100%')
        .height('100%')
        .barHeight('80vp')
        .barMode(BarMode.Fixed)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor('#d821deb4')
  }
}