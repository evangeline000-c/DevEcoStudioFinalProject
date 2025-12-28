// 卡片入口页面

import Health_heartRate from "../view/Health_heartRate"
import Health_oxygen from "../view/Health_oxygen"
import Health_pressure from "../view/Health_pressure"
import Health_sleep from "../view/Health_sleep"
import Health_stress from "../view/Health_stress"
import Health_sugar from "../view/Health_sugar"
import Health_temperature from "../view/Health_temperature"
import CommonConstants from '../common/CommonContants'
import { healthDataList, heartRateData, users, type HealthData, type userData } from '../viewmodel/HealthNumData';
import {type UserAndPart} from "../view/Health"

const IndexRecord: Record<string, number> = {
  "heartRate": 0,
  "oxygen": 1,
  "temperature": 2,
  "sugar": 3,
  "pressure": 4,
  "stress": 5,
  "sleep": 6
};

@Builder
  export function Health_subBuilder() {
  Health_sub()
}

@Component
export struct Health_sub {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;//跳转页面相关 不要删
  pageParam: UserAndPart = {id:0,name:users[0].name,part:"heartRate"} as UserAndPart;

  @State currentIndex: number = 0;
  @State currentUserId: number = 0;
  @State currentUserName: string = users[0].name;
  @State tabsReady: boolean = false;
  private tabsController: TabsController = new TabsController();

  @Builder
  TabBuilder(title: ResourceStr, index: number) {
    Column() {
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


  build() {
    NavDestination(){
      Column() {
        Column(){
          Row() {
            Button() {
              Image($r('app.media.arrow_health'))
                .width($r('app.float.distance_30'))
                .height($r('app.float.distance_30'))

            }.backgroundColor($r('app.color.main_green'))
            .margin({ left: $r('app.float.distance_5') })
            .onClick(() => {
              this.pathStack.pop()
            })

            Row() {
              Text($r('app.string.health_info'))
                .height($r('app.float.height_text'))
                .fontWeight($r('app.float.font_weight_220'))//字体粗细
                .fontSize($r('app.float.font_size'))//字体大小
                .fontColor($r('app.color.white'))
                .width(CommonConstants.FULL_PARENT)
            }
            .margin({ left: $r('app.float.distance_110') })
            .width(CommonConstants.FULL_PARENT)

          }
          .width(CommonConstants.FULL_PARENT)


          Column(){
            Text(this.currentUserName)
              .fontWeight($r('app.float.font_weight_700'))
              .fontSize($r('app.float.font_size_25'))

            Divider()
              .vertical(false)
              .strokeWidth(3)
              .height($r('app.float.distance_5'))
              .color($r('app.color.black'))  // 横条颜色
              .width($r('app.float.distance_20'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({left:$r('app.float.distance_12'),top:$r('app.float.distance_12'), bottom:$r('app.float.distance_12')})
          .alignItems(HorizontalAlign.Start)
        }

        Tabs({
          barPosition: BarPosition.Start,
          controller: this.tabsController,
          index: $$this.currentIndex
        }) {
          TabContent() {
            Health_heartRate({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.heart_rate'), 0))

          TabContent() {
            Health_oxygen({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.blood_oxygen'), 1))

          TabContent() {
            Health_temperature({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.temperature'), 2))

          TabContent() {
            Health_sugar({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.sugar'), 3))

          TabContent() {
            Health_pressure({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.pressure'), 4))
          TabContent() {
            Health_stress({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.stress'), 5))
          TabContent() {
            Health_sleep({userId:this.currentUserId})
          }.padding({ top:$r('app.float.distance_8'), left: $r('app.float.distance_8'), right: $r('app.float.distance_8') })
          .backgroundColor($r('app.color.background_color'))
          .tabBar(this.TabBuilder($r('app.string.sleep'), 6))
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
      .backgroundColor($r('app.color.main_green'))
    }
    .width(CommonConstants.FULL_PARENT)
    .height(CommonConstants.FULL_PARENT)
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_green'))
    .onReady((context: NavDestinationContext)=>{
      this.pageParam = context.pathInfo.param as UserAndPart
      this.currentIndex = IndexRecord[this.pageParam.part];
      this.currentUserId = this.pageParam.id;
      this.currentUserName = this.pageParam.name;
      this.tabsReady = true;
    })
  }
}