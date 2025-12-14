// 卡片入口页面

import Health_heartRate from "../view/Health_heartRate"
import Health_oxygen from "../view/Health_oxygen"
import Health_pressure from "../view/Health_pressure"
import Health_sleep from "../view/Health_sleep"
import Health_stress from "../view/Health_stress"
import Health_sugar from "../view/Health_sugar"
import Health_temperature from "../view/Health_temperature"

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


  build() {
    NavDestination(){
      Column() {
        Column(){
          Row() {
            Button() {
              Image($r('app.media.arrow_health'))
                .width(30)
                .height(30)

            }.backgroundColor('#41E3BF')
            .margin({ left: '5vp' })
            .onClick(() => {
              this.pathStack.pop()
            })

            Row() {
              Text('体征信息')
                .height('60vp')
                .fontWeight(220)//字体粗细
                .fontSize('20fp')//字体大小
                //.backgroundColor('#ffd41c1c')
                .fontColor('#FFFFFF')
                .width('100%')
            }
            .margin({ left: '110vp' })
            .width('100%')

          }
          .width('100%')


          Column(){
            Text(this.currentUserName)
              .fontWeight(700)
              .fontSize('25fp')

            Divider()
              .vertical(false)
              .strokeWidth(3)
              .height(5)
              .color('#ff000000')  // 横条颜色
              .width('20vp')
          }
          .width('100%')
          .margin({left:'12vp',top:'12vp', bottom:'12vp'})
          .alignItems(HorizontalAlign.Start)
        }

        Tabs({
          barPosition: BarPosition.Start,
          controller: this.tabsController,
          index: $$this.currentIndex
        }) {
          TabContent() {
            Health_heartRate({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('心率', 0))

          TabContent() {
            Health_oxygen({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('血氧', 1))

          TabContent() {
            Health_temperature({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('体温', 2))

          TabContent() {
            Health_sugar({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('血糖', 3))

          TabContent() {
            Health_pressure({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('血压', 4))
          TabContent() {
            Health_stress({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('压力', 5))
          TabContent() {
            Health_sleep({userId:this.currentUserId})
          }.padding({ top:'8vp', left: '8vp', right: '8vp' })
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('睡眠', 6))
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
      .backgroundColor('#41E3BF')
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor('#41E3BF')
    .onReady((context: NavDestinationContext)=>{
      this.pageParam = context.pathInfo.param as UserAndPart
      this.currentIndex = IndexRecord[this.pageParam.part];
      this.currentUserId = this.pageParam.id;
      this.currentUserName = this.pageParam.name;
      this.tabsReady = true;
    })
  }
}