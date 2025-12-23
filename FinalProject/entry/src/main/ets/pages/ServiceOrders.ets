//服务订单列表页面

//服务订单数据接口
interface ServiceOrder {
  id: number;
  serviceType: string;       // 服务类型（检查）
  carePersonName: string;    // 被看护人
  serviceNumber: string;     // 服务单号
  nursingName: string;       // 看护名称
  appointmentTime: string;   // 预约时间
  servicePrice: number;      // 服务价格
  status: string;            // '待服务', '待评价', '已完成'
}

//ServiceOrders()的入口函数
@Builder
export function ServiceOrdersBuilder() {
  ServiceOrders()
}

@Component
struct ServiceOrders {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  // 模拟服务订单数据
  @State serviceOrders: ServiceOrder[] = [
    {
      id: 1,
      serviceType: '检查',
      carePersonName: '王国栋',
      serviceNumber: 'kh_1710237333469',
      nursingName: '王国栋',
      appointmentTime: '2024-09-12 - 11:00-12:00',
      servicePrice: 10,
      status: '已支付'
    },
    {
      id: 2,
      serviceType: '检查',
      carePersonName: '赵智晟',
      serviceNumber: 'kh_1710237333469',
      nursingName: '王国栋',
      appointmentTime: '2024-09-12 - 11:00-12:00',
      servicePrice: 10,
      status: '待服务'
    },
    {
      id: 3,
      serviceType: '检查',
      carePersonName: '赵智晟',
      serviceNumber: 'kh_1709027125728',
      nursingName: '陈婷',
      appointmentTime: '2024-02-28 - 17:44',
      servicePrice: 30,
      status: '待服务'
    }
  ];

  // 跳转到服务订单详情页
  navigateToDetail(order: ServiceOrder): void {
    this.pathStack.pushPathByName('ServiceOrderDetail', order);
  }

  // 获取状态颜色
  getStatusColor(status: string): string {
    if (status === '待服务') return '#00CEB8';
    if (status === '待评价') return '#FF9800';
    if (status === '已支付') return '#00CEB8';
    return '#999999';
  }

  // 服务订单卡片组件
  @Builder
  OrderCard(order: ServiceOrder) {
    Column() {
      // 服务类型和状态
      Row() {
        Text(order.serviceType)
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

      // 被看护人
      Row() {
        Text('被看护人')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(order.carePersonName)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 服务单号
      Row() {
        Text('服务单号')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(order.serviceNumber)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 看护名称
      Row() {
        Text('看护名称')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(order.nursingName)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 预约时间
      Row() {
        Text('预约时间')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(order.appointmentTime)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 服务价格
      Row() {
        Text('服务价格')
          .fontSize('14fp')
          .fontColor('#999999')
        Blank()
        Text(`¥ ${order.servicePrice}`)
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
          Text('服务订单列表')
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
        if (this.serviceOrders.length > 0) {
          Scroll() {
            Column() {
              ForEach(this.serviceOrders, (order: ServiceOrder) => {
                this.OrderCard(order)
              })
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
            Text('暂无服务订单')
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
