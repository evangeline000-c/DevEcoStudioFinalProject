//健康宣教组件
import { healthDataList, heartRateData, users, type HealthData} from '../viewmodel/HealthNumData';
import { HealthCard} from './HealthCard'
import CommonConstants from '../common/CommonContants'

export interface UserAndPart {
  id: number; // 用户id
  name: string; // 用户名
  part: "heartRate" | "oxygen" | "pressure" | "sleep" | "stress" | "sugar" |"temperature"; // 指标名
}
interface SelectOption {
  // 核心属性
  value: string; // 必需：选中后返回的值
  text: string;  // 必需：显示给用户的文本

  // 可选属性
  icon?: Resource | string;
}


@Component
export default struct Health {

  private __hrTimer: number = 0;

  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  Health_heartRate(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }
  Health_oxygen(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }
  Health_pressure(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }
  Health_sleep(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }
  Health_stress(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }
  Health_sugar(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }
  Health_temperature(item: UserAndPart): void {
    this.pathStack.pushPathByName('Health_sub', item);
  }

  // 用于选择器
  @State
  private selectedValue:string = users[0].name;
  private dataArray: SelectOption[] = users.map((user)=>{
    return {text: user.name, value: user.name} as SelectOption;
  });

  // 传递给子页面的参数
  @State
  userAndPart: UserAndPart = {id: 0, name: users[0].name, part:"heartRate"};

  build() {
    Column(){
      Text($r('app.string.tab_health'))
      .height($r('app.float.height_text'))
      .width(CommonConstants.FULL_PARENT)
      .fontWeight($r('app.string.font_weight_220'))//字体粗细
      .fontSize($r('app.float.font_size'))//字体大小
      .fontColor($r('app.color.white'))
      .backgroundColor($r('app.color.green1'))
      .textAlign(TextAlign.Center)

      Column(){
        Column(){
          Text($r('app.string.user_health'))
            .fontWeight($r('app.string.font_weight_700'))
            .fontSize($r('app.float.font_size_30'))

            Divider()
            .vertical(false)
            .strokeWidth(3)
            .height($r('app.float.distance_5'))
            .color($r('app.color.black'))  // 横条颜色
            .width($r('app.float.distance_30'))
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({left:$r('app.float.distance_12'),top:$r('app.float.distance_24'), bottom:$r('app.float.distance_12')})
        .alignItems(HorizontalAlign.Start)

        Select(this.dataArray){
          Text()
          .width(CommonConstants.FULL_PARENT) // 确保 Text 占据 Select 的全部宽度
          .textAlign(TextAlign.Start) // 设置文本左对齐 (居左)
      }
      .selected(0) // 设置默认选中项的索引
      
      // 监听选择变化事件
      .onSelect((index: number, value: string) => {
        // 更新状态变量
        this.selectedValue = value;
        this.userAndPart.id = index;
        this.userAndPart.name = users[index].name;
        console.log(`用户选择了索引 ${index}, 值为 ${value}`);
      })
      
      // 设置选择器样式
      .fontColor(Color.Black)
      .backgroundColor(Color.White)
      .width(CommonConstants.NINETY_PARENT)
      .height($r('app.float.distance_40'))
      .borderRadius($r('app.float.distance_6'))
        
        Scroll() {
          Column() {
            // 健康卡片网格
            Grid() {
              GridItem() {
                HealthCard({ data: heartRateData[this.userAndPart.id] }).onClick(()=>{
                  this.userAndPart.part = "heartRate";
                  this.Health_heartRate(this.userAndPart);
                });
              }
              .columnStart(0)
              .columnEnd(1)

              ForEach(healthDataList[this.userAndPart.id], (item: HealthData) => {
                GridItem() {
                  HealthCard({ data: item }).onClick(() => {
                    if(item.label === '血氧饱和度'){
                      this.userAndPart.part = "oxygen";
                      this.Health_oxygen(this.userAndPart);
                    }
                    else if(item.label === '血压'){
                      this.userAndPart.part = "pressure";
                      this.Health_pressure(this.userAndPart);
                    }
                    else if(item.label === '睡眠'){
                      this.userAndPart.part = "sleep";
                      this.Health_sleep(this.userAndPart);
                    }
                    else if(item.label === '压力'){
                      this.userAndPart.part = "stress";
                      this.Health_stress(this.userAndPart);
                    }
                    else if(item.label === '血糖'){
                      this.userAndPart.part = "sugar";
                      this.Health_sugar(this.userAndPart);
                    }
                    else if(item.label === '体温'){
                      this.userAndPart.part = "temperature";
                      this.Health_temperature(this.userAndPart);
                    }
                })
                }
              }, (item: HealthData) => JSON.stringify(item))
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap($r('app.float.distance_12'))
            .rowsGap($r('app.float.distance_12'))
            .width(CommonConstants.FULL_PARENT)
            .height('auto')
            .padding($r('app.float.distance_12'))

            Blank()
          }
          .width(CommonConstants.FULL_PARENT)
          .padding({
            left: $r('app.float.distance_6'),
            right: $r('app.float.distance_6'),
            bottom: $r('app.float.distance_64')
          })
        }
        .width(CommonConstants.FULL_PARENT)
        .layoutWeight(1)
        .backgroundColor($r('app.color.background_gray1'))
    }
  }
  .height(CommonConstants.FULL_PARENT)
  .width(CommonConstants.FULL_PARENT)
}
}
