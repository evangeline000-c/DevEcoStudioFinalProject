//压力页面
import {getBarChartOptions} from '../viewmodel/Charts';
import { McBarChart} from '@mcui/mccharts';
import {healthDataList, type HealthData} from '../viewmodel/HealthNumData';
import HealthForm from '../viewmodel/HealthForm'

@Component
export default struct Health_stress {
  @Prop userId : number;
  @State data: HealthData = healthDataList[this.userId][5];

  @Builder barChart() {
    if (this.data.history && this.data.history.length > 1) {
      McBarChart({
        options: getBarChartOptions(this.data)
      })
        .width('80%')
        .height('100vp')
    }
  }

  build() {
    NavDestination(){
      Column() {
        Column() {
          Column() {
            Text("压力")
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

          this.barChart();
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
          colors: [[0xffffff, 0.0], [0xE0FFFF, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
        })
        .borderRadius('6')

        Column(){
          HealthForm({data:this.data.historyWithTime, part: '压力'})
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