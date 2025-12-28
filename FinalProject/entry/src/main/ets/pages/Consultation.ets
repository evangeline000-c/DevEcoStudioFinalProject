//问诊记录列表页面
import CommonConstants from '../common/CommonContants'
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
    if (status === '已支付') return '21deb4';
    if (status === '申请退款') return '#FF9800';
    return '21deb4';
  }

  // 问诊订单卡片组件
  @Builder
  OrderCard(order: ConsultationOrder) {
    Column() {
      // 患者姓名和状态
      Row() {
        Text(order.patientName)
          .fontSize($r('app.float.font_size_16'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color1'))
        Blank()
        Text(order.status)
          .fontSize($r('app.float.font_size_12'))
          .fontColor(this.getStatusColor(order.status))
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.layout_4'), bottom: $r('app.float.bottom_4')})
          .border({ width: 1, color: this.getStatusColor(order.status), radius: $r('app.float.layout_4') })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_12') })

      // 医护名称
      Row() {
        Text($r('app.string.doctor_name'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(order.doctorName)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 问诊时间
      Row() {
        Text($r('app.string.consultation_time'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(order.consultationTime)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 金额
      Row() {
        Text($r('app.string.amount'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(`¥ ${order.amount}`)
          .fontSize($r('app.float.font_size_16'))
          .fontColor($r('app.color.font_red2'))
          .fontWeight(FontWeight.Bold)
      }
      .width(CommonConstants.FULL_PARENT)
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .margin({ bottom: $r('app.float.distance_12') })
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
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
            .width($r('app.float.distance_24'))
            .height($r('app.float.distance_24'))
            .margin({ left: $r('app.float.distance_16') })
            .onClick(() => {
              this.pathStack.pop();
            })
          Text($r('app.string.consultation_list_title'))
            .fontSize($r('app.float.font_size_18'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
          Blank().width($r('app.float.distance_40'))
        }
        .width(CommonConstants.FULL_PARENT)
        .height($r('app.float.distance_50'))
        .backgroundColor($r('app.color.green1'))

        // 订单列表
        if (this.consultationOrders.length > 0) {
          Scroll() {
            Column() {
              ForEach(this.consultationOrders, (order: ConsultationOrder) => {
                this.OrderCard(order)
              })

              // 底部提示
              Text($r('app.string.no_more'))
                .fontSize($r('app.float.font_size_14'))
                .fontColor($r('app.color.font_color'))
                .margin({ top: $r('app.float.distance_12'), bottom: $r('app.float.distance_20') })
            }
            .width(CommonConstants.FULL_PARENT)
            .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.distance_12')})
            .alignItems(HorizontalAlign.Center)
          }
          .layoutWeight(1)
          .width(CommonConstants.FULL_PARENT)
          .align(Alignment.Top)
        } else {
          Column() {
            Text($r('app.string.no_consultation'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
              .margin({ top: $r('app.float.health_height') })
          }
          .width(CommonConstants.FULL_PARENT)
          .layoutWeight(1)
        }
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .backgroundColor($r('app.color.gray5'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_green'))
  }
}
