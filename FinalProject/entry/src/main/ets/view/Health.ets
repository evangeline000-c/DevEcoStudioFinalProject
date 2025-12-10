//健康宣教组件

import { HealthCard, type HealthData } from './HealthCard'

@Component
export default struct Health {
  @State heartRateData: HealthData = {
    icon: $r('sys.symbol.heart_fill'),
    label: '心率',
    value: '72',
    unit: 'bpm',
    type: 'line',
    history: [88,63,93,78]
  };

  @State healthDataList: HealthData[] = [
    {
      icon: $r('sys.symbol.leaf_fill'),
      label: '血氧饱和度',
      value: '98',
      unit: '%',
      type: 'bar',
      history: [96, 97, 91, 94, 97]
    },
    {
      icon: $r('sys.symbol.thermometer_fill'),
      label: '体温',
      value: '36.5',
      unit: '°C',
    },
    {
      icon: $r('sys.symbol.drop_fill'),
      label: '血压',
      value: '120/80',
      unit: 'mmHg',
    },
    {
      icon: $r('sys.symbol.checkmark_circle_fill'),
      label: '血糖',
      value: '5.2',
      unit: 'mmol/L',
      history: [5.0, 5.1, 5.2, 5.3, 5.2]
    },
    {
      icon: $r('sys.symbol.clock_fill'),
      label: '睡眠',
      value: '7.5',
      unit: '小时',
    },
    {
      icon: $r('sys.symbol.moon_fill'),
      label: '压力',
      value: '32',
      unit: '%',
      type: 'bar',
      history: [30, 32, 28, 25, 32]
    }
  ];

  private __hrTimer: number = 0;

  build() {
    Scroll() {
      Column() {
        Text('用户健康')
          .width('100%')
          .margin({
            top: '48vp',
            bottom: '24vp'
          })
          .fontWeight(700)
          .fontSize('26fp')

        // 健康卡片网格
        Grid() {
          GridItem() {
            HealthCard({ data: this.heartRateData })
          }
          .columnStart(0)
          .columnEnd(1)

          ForEach(this.healthDataList, (item: HealthData) => {
            GridItem() {
              HealthCard({ data: item })
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
    .backgroundColor('#F1F3F5')
  }
}
