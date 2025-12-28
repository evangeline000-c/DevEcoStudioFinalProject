//心率页面
import {getLineChartOptions} from '../viewmodel/Charts';
import { McLineChart, Options} from '@mcui/mccharts';
import {heartRateData, type HealthData} from '../viewmodel/HealthNumData';
import HealthForm from '../viewmodel/HealthForm'
import CommonConstants from '../common/CommonContants'

@Component
export default struct Health_heartRate {
  @Prop userId : number;
  @State data: HealthData = heartRateData[this.userId];

  // 绘制折线图
  @Builder lineChart() {
    if (this.data.history && this.data.history.length > 1) {
      McLineChart({
        options: getLineChartOptions(this.data)
      })
        .width(CommonConstants.NINETY_PARENT)
        .height($r('app.float.health_height'))
    }
  }

  build() {
    NavDestination(){
      Column() {
        Column() {
          Column() {
            Text($r('app.string.heart_rate'))
              .width(CommonConstants.FULL_PARENT)
              .fontSize($r('app.float.font_size_16'))
              .fontColor($r('app.color.health_font_black'))

            // 数值和单位
            Row({ space: 2 }) {
              Text(this.data.value)
                .fontSize($r('app.float.font_size'))
                .fontWeight($r('app.string.font_weight_700'))
                .fontColor($r('app.color.health_font_black1'))
              Text(this.data.unit)
                .fontSize($r('app.float.font_size_12'))
                .fontColor($r('app.color.health_font_black2'))
            }
            .width(CommonConstants.FULL_PARENT)
            .alignItems(VerticalAlign.Bottom)

          }
          .margin({
            top: $r('app.float.distance_12'),
            bottom: $r('app.float.distance_12'),
            left: $r('app.float.distance_12')
          })

          this.lineChart();
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({
          left: $r('app.float.distance_12'),
          right:$r('app.float.distance_12'),
          bottom: $r('app.float.distance_24')
        })
        .linearGradient({
          direction: GradientDirection.Bottom, // 渐变方向
          repeating: true, // 渐变颜色是否重复
          colors: [[0xffffff, 0.0], [0xFFF0F5, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
        })
        .borderRadius('6')

        Column(){
          HealthForm({data:this.data.historyWithTime, part: '心率'})
        }
        .borderRadius('6')
        .clip(true)
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .backgroundColor($r('app.color.background_color'))
    }
  }
}