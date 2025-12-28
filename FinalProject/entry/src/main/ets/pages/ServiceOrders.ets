//服务订单列表页面

//服务订单数据接口
import { ServiceOrder } from '../viewmodel/ServiceProcurementData';
import { getCaregiverById } from '../viewmodel/CaregiverData';
import CommonConstants from '../common/CommonContants'

//ServiceOrders()的入口函数
@Builder
export function ServiceOrdersBuilder() {
  ServiceOrders()
}

@Component
struct ServiceOrders {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  // 模拟服务订单数据
  // 模拟服务订单数据
  @StorageLink('serviceOrderList') serviceOrders: ServiceOrder[] = [];

  aboutToAppear() {
    // 只在列表为空时显示演示数据
    if (this.serviceOrders.length === 0) {
      this.serviceOrders = [
        {
          id: 1,
          serviceType: '检查',
          carePersonName: '王国栋',
          serviceNumber: 'kh_1710237333469',
          caregiverId: 'cg_001',
          caregiverName: '李静',
          appointmentTime: '2024-09-12 - 11:00-12:00',
          servicePrice: 36,
          status: '已支付'
        }
      ];
    }
  }

  // 跳转到服务订单详情页
  navigateToDetail(order: ServiceOrder): void {
    this.pathStack.pushPathByName('ServiceOrderDetail', order);
  }

  // 获取状态颜色
  getStatusColor(status: string): string {
    if (status === '待服务') return '21deb4';
    if (status === '待评价') return '#FF9800';
    if (status === '已支付') return '21deb4';
    return '#999999';
  }

  // 服务订单卡片组件
  @Builder
  OrderCard(order: ServiceOrder) {
    Column() {
      // 服务类型和状态
      Row() {
        Text(order.serviceType)
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

      // 被看护人
      Row() {
        Text($r('app.string.care_person'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(order.carePersonName)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 服务单号
      Row() {
        Text($r('app.string.service_number'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(order.serviceNumber)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 看护人员
      Row() {
        Text($r('app.string.caregiver'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(order.caregiverName || '-')
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 预约时间
      Row() {
        Text($r('app.string.appointment_time'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(order.appointmentTime)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 服务价格
      Row() {
        Text($r('app.string.service_price'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(`¥ ${order.servicePrice}`)
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
          Text($r('app.string.service_order_list_title'))
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
        if (this.serviceOrders.length > 0) {
          Scroll() {
            Column() {
              ForEach(this.serviceOrders, (order: ServiceOrder) => {
                this.OrderCard(order)
              })
            }
            .width(CommonConstants.FULL_PARENT)
            .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.distance_12') })
            .alignItems(HorizontalAlign.Center)
          }
          .layoutWeight(1)
          .width(CommonConstants.FULL_PARENT)
          .align(Alignment.Top)
        } else {
          Column() {
            Text($r('app.string.no_service_orders'))
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
