//压力页面
import {getBarChartOptions} from '../viewmodel/Charts';
import { McBarChart} from '@mcui/mccharts';
import {healthDataList, type HealthData} from '../viewmodel/HealthNumData';
import HealthForm from '../viewmodel/HealthForm'
import CommonConstants from '../common/CommonContants'

@Component
export default struct Health_stress {
  @Prop userId : number;
  @State data: HealthData = healthDataList[this.userId][5];

  @Builder barChart() {
    if (this.data.history && this.data.history.length > 1) {
      McBarChart({
        options: getBarChartOptions(this.data)
      })
        .width(CommonConstants.EIGHTY_PARENT)
        .height($r('app.float.health_height'))
    }
  }

  build() {
    NavDestination(){
      Column() {
        Column() {
          Column() {
            Text($r('app.string.stress'))
              .width(CommonConstants.FULL_PARENT)
              .fontSize($r('app.float.font_size_16'))
              .fontColor($r('app.color.health_font_black'))

            // 数值和单位
            Row({ space: 2 }) {
              Text(this.data.value)
                .fontSize($r('app.float.font_size'))
                .fontWeight($r('app.float.font_weight_700'))
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

          this.barChart();
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
          colors: [[0xffffff, 0.0], [0xE0FFFF, 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
        })
        .borderRadius('6')

        Column(){
          HealthForm({data:this.data.historyWithTime, part: '压力'})
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