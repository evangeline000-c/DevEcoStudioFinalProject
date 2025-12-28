//首页和健康宣教和用户档案和我的和资讯这5个在pages文件夹下共用的文件
import CommonConstants from '../common/CommonContants'
import Home from "../view/Home"
import Health from "../view/Health"
import My from "../view/My"
import News from "../view/News"
import UserProfile from "../view/UserProfile"
import { UserDataSource } from "../view/UserModel"
import { INIT_USER_DATA } from "../view/UserProfileConfig"

//MainPage()的入口函数
@Builder
export function MainPageBuilder() {
  MainPages()
}

@Component
export struct MainPages {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  aboutToAppear(): void {
    // 全局初始化 UserDataSource
    if (!AppStorage.get<UserDataSource>('userDataSource')) {
      const ds = new UserDataSource(INIT_USER_DATA);
      AppStorage.setOrCreate('userDataSource', ds);
    }
  }

  @Builder
  TabBuilder(title: ResourceStr, index: number, selectedImg: Resource) {
    Column() {
      SymbolGlyph(selectedImg)
        .fontSize($r('app.float.font_size_25'))
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.UP),
          this.currentIndex === index ? true : false)
        .fontColor(this.currentIndex === index ? [$r('app.color.main_green')] : [$r('app.color.health_font_black2')])
      Text(title)
        .margin({ top: $r('app.float.layout_4') })
        .fontSize($r('app.float.font_size_15'))
        .fontWeight($r('app.float.font_weight_500'))
        .fontColor(this.currentIndex === index ? $r('app.color.main_green') : $r('app.color.health_font_black2'))
    }
    .backgroundColor($r('app.color.white'))
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.distance_50'))
    .width(CommonConstants.FULL_PARENT)
    //.margin({bottom:$r('app.float.distance_5')})
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
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.tab_home'), 0, $r('sys.symbol.house_fill')))
          .width(CommonConstants.FULL_PARENT)

          TabContent() {
            Health()
          }
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.tab_health'), 1, $r('sys.symbol.waveform_path_ecg_heart_fill')))

          TabContent() {
            News()
          }
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.tab_news'), 2, $r('sys.symbol.bookmark')))

          TabContent() {
            UserProfile()
          }
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.tab_user_profile'), 3, $r('sys.symbol.doc_plaintext_2')))

          TabContent() {
            My()
          }
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.tab_my'), 4, $r('sys.symbol.person_crop_circle_fill')))
        }
        .width(CommonConstants.FULL_PARENT)
        .height(CommonConstants.FULL_PARENT)
        .barHeight($r('app.float.height_68'))
        .barMode(BarMode.Fixed)
        .onChange((index: number) => { 
          this.currentIndex = index;
        })
      }
      .width(CommonConstants.FULL_PARENT)
      .height($r('app.float.height_800'))
      .backgroundColor($r('app.color.white'))
    }
    .height(CommonConstants.FULL_PARENT)
    .width(CommonConstants.FULL_PARENT)
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_green'))//整个页面最底部的颜色包括手机显示电量的地方
  }
}