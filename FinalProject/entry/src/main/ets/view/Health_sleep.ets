//睡眠页面
import {getPieChartOptions} from '../viewmodel/Charts';
import { McPieChart} from '@mcui/mccharts';
import {healthDataList, type HealthData} from '../viewmodel/HealthNumData';
import HealthForm from '../viewmodel/HealthForm'

@Component
export default struct Health_sleep {
  @Prop userId : number;
  @State data: HealthData = healthDataList[this.userId][4];

  @Builder pieChart() {
    if (this.data.sleepData && this.data.sleepData.length > 0) {
      McPieChart({
        options: getPieChartOptions(this.data)
      })
        .width('90%')
        .height('100vp')
    }
  }

  build() {
    NavDestination(){
      Column() {
        Column() {
          Column() {
            Text("睡眠")
              .width('100%')
              .fontSize('16fp')
              .fontColor('#99000000')

            // 数值和单位
            Row({ space: 2 }) {
              Text(this.data.value)
                .fontSize('20fp')
                .fontWeight(700)
                .fontColor('#000000')
              Text(this.data.unit)
                .fontSize('12fp')
                .fontColor('#66000000')
            }
            .width('100%')
            .alignItems(VerticalAlign.Bottom)

          }
          .margin({
            top: '12vp',
            bottom: '12vp',
            left: '12vp'
          })

          this.pieChart();
        }
        .width('100%')
        .margin({
          left: '12vp',
          right:'12vp',
          bottom: '24vp'
        })
        .linearGradient({
          direction: GradientDirection.Bottom, // 渐变方向
          repeating: true, // 渐变颜色是否重复
          colors: [[0xffffff, 0.0], [0xF0FFF0, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
        })
        .borderRadius('6')

        Column(){
          HealthForm({data:this.data.historyWithTime, part: '睡眠'})
        }
        .borderRadius('6')
        .clip(true)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
  }
}