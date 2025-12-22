//服务订单页面

//服务订单数据接口
interface ServiceOrder {
  id: number;
  servicePersonName: string; // 服务名人
  serviceNumber: string; // 服务单号
  serviceName: string; // 服务名称
  appointmentTime: string; // 预约时间
  servicePrice: number; // 服务价格
  status: string; // '待服务', '待评价', '已完成'
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
      servicePersonName: '王国栋',
      serviceNumber: 'kh_J710237533469',
      serviceName: '检查',
      appointmentTime: '2024-09-12 · 11:00-12:00',
      servicePrice: 10,
      status: '待服务'
    },
    {
      id: 2,
      servicePersonName: '赵智康',
      serviceNumber: 'kh_J710237533469',
      serviceName: '检查',
      appointmentTime: '2024-09-12 · 11:00-12:00',
      servicePrice: 10,
      status: '待评价'
    },
    {
      id: 3,
      servicePersonName: '陈婷',
      serviceNumber: 'kh_J709027125728',
      serviceName: '检查',
      appointmentTime: '2024-02-28 · 17:44',
      servicePrice: 50,
      status: '待服务'
    }
  ];

  // 跳转到服务订单详情页
  navigateToDetail(order: ServiceOrder): void {
    this.pathStack.pushPathByName('ServiceOrderDetail', order);
  }

  // 服务订单卡片组件
  @Builder
  OrderCard(order: ServiceOrder) {
    Column() {
      Row() {
        Text(order.serviceName)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(order.status)
          .fontSize('14fp')
          .fontColor(order.status === '待服务' ? '#4CAF50' : order.status === '待评价' ? '#FF9800' : '#999999')
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({
            width: 1,
            color: order.status === '待服务' ? '#4CAF50' : order.status === '待评价' ? '#FF9800' : '#999999',
            radius: 4
          })
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务名人')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(order.servicePersonName)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务单号')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(order.serviceNumber)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务名称')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(order.serviceName)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('预约时间')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(order.appointmentTime)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务价格')
          .fontSize('14fp')
          .fontColor('#666666')
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
    .onClick(() => {
      this.navigateToDetail(order);
    })
  }

  build() {
    NavDestination() {
      Column() {
        // 标题
        Text('服务订单')
          .width('100%')
          .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
          .fontWeight(700)
          .fontSize('20fp')
          .backgroundColor('#00CDA5')
          .fontColor(Color.White)

        // 订单列表
        if (this.serviceOrders.length > 0) {
          List({ space: 0 }) {
            ForEach(this.serviceOrders, (order: ServiceOrder) => {
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