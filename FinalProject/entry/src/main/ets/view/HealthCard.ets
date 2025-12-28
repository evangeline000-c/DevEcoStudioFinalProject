//健康信息卡片组件
import { McLineChart, McBarChart,  McPieChart,Options } from '@mcui/mccharts';
import {type HealthData } from '../viewmodel/HealthNumData';
import {getLineChartOptions, getBarChartOptions, getPieChartOptions} from '../viewmodel/Charts'
import CommonConstants from '../common/CommonContants'

@Component
export struct HealthCard {
  @Prop data: HealthData;

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

  // 绘制柱状图
  @Builder barChart() {
    if (this.data.history && this.data.history.length > 0) {
      McBarChart({
        options: getBarChartOptions(this.data)
      })
      .width(CommonConstants.NINETY_PARENT)
      .height($r('app.float.health_height'))
    }
  }

  // 绘制饼图
  @Builder pieChart() {
    if (this.data.sleepData && this.data.sleepData.length > 0) {
      McPieChart({
        options: getPieChartOptions(this.data)
      })
      .width(CommonConstants.NINETY_PARENT)
      .height($r('app.float.health_height'))
    }
  }

  build() {
    Column() {
      // 上半部分 - 信息区域
      Column() {
        // 标签
        Text(this.data.label)
          .width(CommonConstants.FULL_PARENT)
          .fontSize($r('app.float.font_size_16'))
          .fontColor($r('app.color.health_font_black'))
          .margin({ bottom: $r('app.float.bottom_4') })

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
      .width(CommonConstants.FULL_PARENT)
      .padding('12vp 0 12vp 12vp')

      // 下半部分 - 图表区域
      Column() {
        if (this.data.type === 'line') {
          this.lineChart();
        } else if (this.data.type === 'bar') {
          this.barChart();
        } else if (this.data.type === 'pie') {
          this.pieChart();
        } else {
            if (this.data.label === '体温') {
              Image($r('app.media.temp_icon'))
                .width($r('app.float.health_height'))
                .height($r('app.float.health_height'))
            } else if (this.data.label === '血糖') {
              Image($r('app.media.sugar_icon'))
                .width($r('app.float.health_height'))
                .height($r('app.float.health_height'))
            } else if (this.data.label === '血压') {
              Image($r('app.media.pressure_icon'))
                .width($r('app.float.health_height'))
                .height($r('app.float.health_height'))
            } else {
              Blank().width(CommonConstants.FULL_PARENT).height($r('app.float.health_height'))
            }
        }
      }
      .width(CommonConstants.FULL_PARENT)
    }
    .width(CommonConstants.FULL_PARENT)
    .shadow({
      radius: 4,
      color: $r('app.color.black3'),
      offsetX: 0,
      offsetY: 2
    })
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      repeating: true, // 渐变颜色是否重复
      colors: [[0xffffff, 0.0], [(this.data.label === '压力' ? 0xE0FFFF : (this.data.label === '血氧饱和度' || this.data.label === '睡眠' ? 0xF0FFF0: 0xFFF0F5)), 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .borderRadius($r('app.float.distance_12'))
    .clip(true)
  }
}
