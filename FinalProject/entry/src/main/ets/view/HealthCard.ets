//健康信息卡片组件
import { McLineChart, McBarChart,  McPieChart,Options } from '@mcui/mccharts';
import {type HealthData } from '../viewmodel/HealthNumData';
import {getLineChartOptions, getBarChartOptions, getPieChartOptions} from '../viewmodel/Charts'

@Component
export struct HealthCard {
  @Prop data: HealthData;

  // 绘制折线图
  @Builder lineChart() {
    if (this.data.history && this.data.history.length > 1) {
      McLineChart({
        options: getLineChartOptions(this.data)
      })
      .width('90%')
      .height('100vp')
    }
  }

  // 绘制柱状图
  @Builder barChart() {
    if (this.data.history && this.data.history.length > 0) {
      McBarChart({
        options: getBarChartOptions(this.data)
      })
      .width('90%')
      .height('100vp')
    }
  }

  // 绘制饼图
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
    Column() {
      // 上半部分 - 信息区域
      Column() {
        // 标签
        Text(this.data.label)
          .width('100%')
          .fontSize('16fp')
          .fontColor('#99000000')
          .margin({ bottom: '4vp' })

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
      .width('100%')
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
                .width('100vp')
                .height('100vp')
            } else if (this.data.label === '血糖') {
              Image($r('app.media.sugar_icon'))
                .width('100vp')
                .height('100vp')
            } else if (this.data.label === '血压') {
              Image($r('app.media.pressure_icon'))
                .width('100vp')
                .height('100vp')
            } else {
              Blank().width('100%').height('100vp')
            }
        }
      }
      .width('100%')
    }
    .width('100%')
    .shadow({
      radius: 4,
      color: '#000000bc',
      offsetX: 0,
      offsetY: 2
    })
    .linearGradient({
      direction: GradientDirection.Bottom, // 渐变方向
      repeating: true, // 渐变颜色是否重复
      colors: [[0xffffff, 0.0], [(this.data.label === '压力' ? 0xE0FFFF : (this.data.label === '血氧饱和度' || this.data.label === '睡眠' ? 0xF0FFF0: 0xFFF0F5)), 1.0]] // 数组末尾元素占比小于1时满足重复着色效果
    })
    .borderRadius(12)
    .clip(true)
  }
}
