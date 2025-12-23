//问诊记录列表页面

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
      patientName: '赵智晟',
      doctorName: '张玉峰',
      consultationTime: '2024-04-26 15:34:24',
      amount: 34,
      status: '已支付'
    },
    {
      id: 2,
      patientName: '赵智晟',
      doctorName: '张玉峰',
      consultationTime: '2024-04-24 15:41:36',
      amount: 34,
      status: '申请退款'
    }
  ];

  // 跳转到问诊详情页
  navigateToDetail(order: ConsultationOrder): void {
    this.pathStack.pushPathByName('ConsultationDetail', order);
  }

  // 获取状态颜色
  getStatusColor(status: string): string {
    if (status === '已支付') return '#00CEB8';
    if (status === '申请退款') return '#FF9800';
    return '#00CEB8';
  }

  // 问诊订单卡片组件
  @Builder
  OrderCard(order: ConsultationOrder) {
    Column() {
      // 患者姓名和状态
      Row() {
        Text(order.patientName)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Blank()
        Text(order.status)
          .fontSize('12fp')
          .fontColor(this.getStatusColor(order.status))
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({ width: 1, color: this.getStatusColor(order.status), radius: '4vp' })
      }
      .width('100%')
      .margin({ bottom: '12vp' })

      // 医护名称
      Row() {
        Text('医护名称')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(order.doctorName)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 问诊时间
      Row() {
        Text('问诊时间')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(order.consultationTime)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 金额
      Row() {
        Text('金额')
          .fontSize('14fp')
          .fontColor('#999999')
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
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
    .onClick(() => {
      this.navigateToDetail(order);
    })
  }

  build() {
    NavDestination() {
      Column() {
        // 标题栏
        Row() {
          Image($r('app.media.ic_back'))
            .width('24vp')
            .height('24vp')
            .margin({ left: '16vp' })
            .onClick(() => {
              this.pathStack.pop();
            })
          Text('问诊订单列表')
            .fontSize('18fp')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
          Blank().width('40vp')
        }
        .width('100%')
        .height('50vp')
        .backgroundColor('#00CEB8')

        // 订单列表
        if (this.consultationOrders.length > 0) {
          Scroll() {
            Column() {
              ForEach(this.consultationOrders, (order: ConsultationOrder) => {
                this.OrderCard(order)
              })

              // 底部提示
              Text('没有更多')
                .fontSize('14fp')
                .fontColor('#999999')
                .margin({ top: '12vp', bottom: '20vp' })
            }
            .width('100%')
            .padding({ left: '12vp', right: '12vp', top: '12vp' })
            .alignItems(HorizontalAlign.Center)
          }
          .layoutWeight(1)
          .width('100%')
          .align(Alignment.Top)
        } else {
          Column() {
            Text('暂无问诊记录')
              .fontSize('14fp')
              .fontColor('#999999')
              .margin({ top: '100vp' })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .hideTitleBar(true)
  }
}
