//健康宣教组件
import { healthDataList, heartRateData, type HealthData } from '../viewmodel/HealthNumData';
import { HealthCard} from './HealthCard'

@Component
export default struct Health {

  private __hrTimer: number = 0;

  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  Health_heartRate(result: boolean): void {
    this.pathStack.pushPathByName('Health_heartRate', null);
  }
  Health_oxygen(result: boolean): void {
    this.pathStack.pushPathByName('Health_oxygen', null);
  }
  Health_pressure(result: boolean): void {
    this.pathStack.pushPathByName('Health_pressure', null);
  }
  Health_sleep(result: boolean): void {
    this.pathStack.pushPathByName('Health_sleep', null);
  }
  Health_stress(result: boolean): void {
    this.pathStack.pushPathByName('Health_stress', null);
  }
  Health_sugar(result: boolean): void {
    this.pathStack.pushPathByName('Health_sugar', null);
  }
  Health_temperature(result: boolean): void {
    this.pathStack.pushPathByName('Health_temperature', null);
  }

  build() {
    NavDestination(){
    Scroll() {
      Column() {
        Text('用户健康')
          .width('100%')
          .margin({
            top: '48vp',
            bottom: '24vp'
          })
          .fontWeight(700)
          .fontSize('30fp')

        // 健康卡片网格
        Grid() {
          GridItem() {
            HealthCard({ data: heartRateData }).onClick(()=>{
              this.Health_heartRate(true);
            });
          }
          .columnStart(0)
          .columnEnd(1)

          ForEach(healthDataList, (item: HealthData) => {
            GridItem() {
              HealthCard({ data: item }).onClick(() => {
                if(item.label === '血氧饱和度'){
                  this.Health_oxygen(true);
                }
                else if(item.label === '血压'){
                  this.Health_pressure(true);
                }
                else if(item.label === '睡眠'){
                  this.Health_sleep(true);
                }
                else if(item.label === '压力'){
                  this.Health_stress(true);
                }
                else if(item.label === '血糖'){
                  this.Health_sugar(true);
                }
                else if(item.label === '体温'){
                  this.Health_temperature(true);
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
        .padding('0vp')

        Blank()
      }
      .width('100%')
      .padding({
        left: '12vp',
        right: '12vp',
        bottom: '12vp'
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('##F1F0F0')
  }
  }
}
