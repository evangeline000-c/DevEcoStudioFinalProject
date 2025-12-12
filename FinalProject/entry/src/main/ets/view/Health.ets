//健康宣教组件
import { healthDataList, heartRateData, users, type HealthData, type UserAndPart } from '../viewmodel/HealthNumData';
import { HealthCard} from './HealthCard'

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

  @State
  private selectedValue:string = "赵智晟";
  private dataArray: string[] = users;

  @State
  userAndPart: UserAndPart = {user:this.selectedValue, part:"heartRate"};

  build() {
    Column(){
      Text('健康')
      .height('60vp')
      .width('100%')
      .fontWeight(220)//字体粗细
      .fontSize('20fp')//字体大小
      .fontColor('#FFFFFF')
      .backgroundColor('#41E3BF')
      .textAlign(TextAlign.Center)

      Column(){
        Column(){
          Text('用户健康')
            .fontWeight(700)
            .fontSize('30fp')

            Divider()
            .vertical(false)
            .strokeWidth(3)
            .height(5)
            .color('#ff000000')  // 横条颜色
            .width('30vp')
        }
        .width('100%')
        .margin({left:'12vp',top:'24vp', bottom:'12vp'})
        .alignItems(HorizontalAlign.Start)

        Select(this.dataArray.map(item => ({ value: item, text: item } as SelectOption ))) {
        // 1. 设置默认选中项的文本
        Text('赵智晟')
      }
      .selected(this.dataArray.indexOf(this.selectedValue)) // 2. 设置默认选中项的索引
      
      // 3. 监听选择变化事件
      .onSelect((index: number, value: string) => {
        // 更新状态变量
        this.selectedValue = value;
        this.userAndPart.user = this.selectedValue;
        console.log(`用户选择了索引 ${index}, 值为 ${value}`);
      })
      
      // 4. 设置选择器样式（可选）
      .fontColor(Color.Black)
      .backgroundColor(Color.White)
      .width(200)
      .height(40)
      .borderRadius(8)
      .border({ width: 1, color: Color.Gray })
        
        Scroll() {
          Column() {
            // 健康卡片网格
            Grid() {
              GridItem() {
                HealthCard({ data: heartRateData }).onClick(()=>{
                  this.userAndPart.part = "heartRate";
                  this.Health_heartRate(this.userAndPart);
                });
              }
              .columnStart(0)
              .columnEnd(1)

              ForEach(healthDataList, (item: HealthData) => {
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
            .columnsGap('12vp')
            .rowsGap('12vp')
            .width('100%')
            .height('auto')
            .padding('12vp')

            Blank()
          }
          .width('100%')
          .padding({
            left: '6vp',
            right: '6vp',
            bottom: '64vp'
          })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#F1F0F0')
    }
  }
  .height('100%') 
  .width('100%') 
}
}
