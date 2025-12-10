//健康信息卡片组件
import { McLineChart, McBarChart, Options } from '@mcui/mccharts';

export interface HealthData {
  icon: Resource; // 图标
  label: string; // 标签（如：心率、血氧等）
  value: string; // 数值
  unit: string; // 单位
  type?: 'line' | 'bar' | 'gauge' | 'simple'; // 卡片类型（默认简单卡片）
  history?: number[]; // 可选：历史数据（用于图表）
}

@Component
export struct HealthCard {
  @Prop data: HealthData;

  // 获取折线图配置
  private getLineChartOptions(): Options {
    return new Options({
      grid:{
        left:5,
        right:5,
        top:5,
        bottom:5,
      },
      title: {
        show: false
      },
      xAxis: {
        data: this.data.history?.map((_, i) => String(i)) || [],
        axisTick: { 
        show: false, 
        },
        axisLine: { 
        show: false,
        },
        splitLine: { // 坐标轴中的分隔线。
          show: false,
        },
        axisLabel:{
          fontSize:0,
        },
        boundaryGap: false,
      },
      yAxis:{
        axisTick: { 
          show: false, 
        },
        axisLine: { 
          show: false,
        },
        splitLine: { // 坐标轴中的分隔线。
          show: false
        },
        axisLabel:{
          fontSize:0,
        },
        min: 60,
        max: 100,
        boundaryGap: false,
      },
      series: [{
        name: this.data.label,
        data: this.data.history || [],
        smooth: true,
        lineStyle:{
          color:'#ff0000'
        },
        areaStyle:{
          show: true,
          gradient:['rgba(255, 0, 0,0.6)','#ffffff']
        },
      }],
      legend:{
        show:false,
      }
    });
  }

  // 获取柱状图配置
  private getBarChartOptions(): Options {
    return new Options({
      grid:{
        left:5,
        right:5,
        top:5,
        bottom:5,
      },
      title: {
        show: false
      },
      xAxis: {
        data: this.data.history?.slice(-4).map((_, i) => String(i)) || [],
        axisTick: { 
        show: false, 
        },
        axisLine: { 
        show: false,
        },
        splitLine: { // 坐标轴中的分隔线。
          show: false,
        },
        axisLabel:{
          fontSize:0,
        },
        boundaryGap: false,
      },
      yAxis: {
        axisTick: { 
          show: false, 
        },
        axisLine: { 
          show: false,
        },
        splitLine: { // 坐标轴中的分隔线。
          show: false
        },
        axisLabel:{
          fontSize:0,
        },
        boundaryGap: false,
      },
      series: [{
        name: this.data.label,
        data: this.data.history?.slice(-4) || [],
        barStyle:{
          width: 5,
          color: '#3DC875',
        },
      }],
      dataZoom:{
        show: true,
      },
      legend:{
        show:false,
      }
    });
  }

  // 绘制折线图（用于心率等）
  @Builder lineChart() {
    if (this.data.history && this.data.history.length > 1) {
      McLineChart({
        options: this.getLineChartOptions()
      })
      .width('90%')
      .height('100vp')
    }
  }

  // 绘制柱状图（用于血氧等数据）
  @Builder barChart() {
    if (this.data.history && this.data.history.length > 0) {
      McBarChart({
        options: this.getBarChartOptions()
      })
      .width('90%')
      .height('100vp')
    }
  }

  // 绘制仪表盘（用于血压等范围数据）
  @Builder gaugeChart() {
    Row() {
      Column() {
        Circle()
          .width('40vp')
          .height('40vp')
          .fill('#f0f0f0')
          .stroke('#ffffff')
          .strokeWidth(3)
      }
      .width('90%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100vp')
    .justifyContent(FlexAlign.Center)
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
        } else if (this.data.type === 'gauge') {
          this.gaugeChart();
        } else {
          Blank().width('100%').height('100vp')
        }
      }
      .width('100%')
    }
    .width('100%')
    .shadow({
      radius: 4,
      color: '#0000000f',
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
