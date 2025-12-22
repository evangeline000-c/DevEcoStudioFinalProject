//问诊记录页面

//问诊订单数据接口
interface ConsultationOrder {
  id: number;
  patientName: string;
  doctorName: string;
  consultationTime: string;
  amount: number;
  status: string; // '已支付', '申请退款', '未支付'
}

//Consultation()的入口函数
@Builder
export function ConsultationBuilder() {
  Consultation()
}

@Component
struct Consultation {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  // 模拟问诊订单数据
  @State consultationOrders: ConsultationOrder[] = [
    {
      id: 1,
      patientName: '赵智康',
      doctorName: '张主任',
      consultationTime: '2024-04-26 16:54:24',
      amount: 54,
      status: '已支付'
    },
    {
      id: 2,
      patientName: '赵智康',
      doctorName: '张主任',
      consultationTime: '2024-04-24 15:41:36',
      amount: 54,
      status: '申请退款'
    }
  ];

  // 跳转到问诊详情页
  navigateToDetail(order: ConsultationOrder): void {
    this.pathStack.pushPathByName('ConsultationDetail', order);
  }

  // 问诊订单卡片组件
  @Builder
  OrderCard(order: ConsultationOrder) {
    Column() {
      Row() {
        Text(order.patientName)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(order.status)
          .fontSize('14fp')
          .fontColor(order.status === '已支付' ? '#4CAF50' : '#FF9800')
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({ width: 1, color: order.status === '已支付' ? '#4CAF50' : '#FF9800', radius: 4 })
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('医护名称')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(order.doctorName)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('问诊时间')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(order.consultationTime)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('金额')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(`¥ ${order.amount}`)
          .fontSize('16fp')
          .fontColor('#FF6B00')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .margin({ bottom: '12vp' })
    .onClick(() => {
      this.navigateToDetail(order);
    })
  }

  build() {
    NavDestination() {
      Column() {
        // 标题
        Text('问诊记录')
          .width('100%')
          .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
          .fontWeight(700)
          .fontSize('20fp')
          .backgroundColor('#00CDA5')
          .fontColor(Color.White)

        // 订单列表
        if (this.consultationOrders.length > 0) {
          List({ space: 0 }) {
            ForEach(this.consultationOrders, (order: ConsultationOrder) => {
              ListItem() {
                this.OrderCard(order)
              }
            })
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: '12vp', right: '12vp', top: '12vp' })
        } else {
          Column() {
            Text('没有更多')
              .fontSize('14fp')
              .fontColor('#999999')
              .margin({ top: '20vp' })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .hideTitleBar(true)
  }
}