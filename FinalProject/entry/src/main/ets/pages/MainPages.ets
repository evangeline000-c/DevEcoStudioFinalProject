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
        .fontSize('25fp')
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP),
          this.currentIndex === index ? true : false)
        .fontColor(this.currentIndex === index ? ['#d821deb4'] : ['#66000000'])
      Text(title)
        .margin({ top: '4vp' })
        .fontSize(15)
        .fontWeight(500)
        .fontColor(this.currentIndex === index ? '#d821deb4' : '#66000000')
    }
    .backgroundColor('#FFFFFF')
    .justifyContent(FlexAlign.Center)
    .height('50vp')
    .width('100%')
    //.margin({bottom:'5vp'})
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
          }
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('首页', 0, $r('sys.symbol.house_fill')))
          .width('100%')

          TabContent() {
            Health()
          }
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('健康', 1, $r('sys.symbol.waveform_path_ecg_heart_fill')))

          TabContent() {
            News()
          }
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('资讯', 2, $r('sys.symbol.bookmark')))

          TabContent() {
            UserProfile()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('用户档案', 3, $r('sys.symbol.doc_plaintext_2')))

          TabContent() {
            My()
          }.padding({ left: '12vp', right: '12vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('我的', 4, $r('sys.symbol.person_crop_circle_fill')))
        }
        .width('100%')
        .height('100%')
        .barHeight('68vp')
        .barMode(BarMode.Fixed)
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .width('100%')
      .height('800vp')
      .backgroundColor('#FFFFFF')
    }
    .height('100%')
    .width('100%')
    .hideTitleBar(true)
    .backgroundColor('#d821deb4')//整个页面最底部的颜色包括手机显示电量的地方
  }
}