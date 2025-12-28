// 服务详情页面
import { ServiceItemType, ServiceItemList, FeeItem as SimpleFeeItem } from '../viewmodel/ServiceProcurementData';
import CommonConstants from '../common/CommonContants'
// ServiceDetail()的入口函数
@Builder
export function ServiceDetailBuilder() {
  ServiceDetail()
}

@Component
struct ServiceDetail {
  @State serviceItem: ServiceItemType = new ServiceItemType(0, '', '', '', $r('app.media.startIcon'), 0, '', '', '', '', '');
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  aboutToAppear(): void {
    // 从导航参数中获取服务ID
    const param: Object | undefined = this.pathStack.getParamByName('ServiceDetail');
    
    if (param) {
      // 处理参数可能被包装成数组的情况
      let serviceId: number;
      if (Array.isArray(param)) {
        serviceId = param[0] as number;
      } else {
        serviceId = param as number;
      }
      
      // 从ServiceItemList中查找对应的服务项
      const foundItem = ServiceItemList.find(item => item.id === serviceId);
      
      if (foundItem) {
        // 逐个属性赋值，确保@State触发更新
        this.serviceItem.id = foundItem.id;
        this.serviceItem.serviceName = foundItem.serviceName;
        this.serviceItem.serviceOrganization = foundItem.serviceOrganization;
        this.serviceItem.serviceType = foundItem.serviceType;
        this.serviceItem.servicePhoto = foundItem.servicePhoto;
        this.serviceItem.servicePrice = foundItem.servicePrice;
        this.serviceItem.serviceUnit = foundItem.serviceUnit;
        this.serviceItem.serviceDescription = foundItem.serviceDescription;
        this.serviceItem.serviceDetails = foundItem.serviceDetails;
        this.serviceItem.serviceAppointmentNotice = foundItem.serviceAppointmentNotice;
        this.serviceItem.serviceFeeNotice = foundItem.serviceFeeNotice;
        this.serviceItem.feeBreakdown = foundItem.feeBreakdown;
      }
    }
  }

  // 跳转到预约信息填写页面
  handleAppointment(): void {
    // 只传递服务ID
    this.pathStack.pushPathByName('AppointmentForm', this.serviceItem.id);
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
          Text($r('app.string.service_detail_title'))
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

        // 滚动容器
        Scroll() {
          Column() {
            // 服务图片
            Image(this.serviceItem.servicePhoto)
              .width(CommonConstants.FULL_PARENT)
              .height($r('app.float.height_240'))
              .objectFit(ImageFit.Cover)

            // 服务信息区域
            Column() {
              // 服务名称
              Text(this.serviceItem.serviceName)
                .fontSize($r('app.float.font_size_24'))
                .fontWeight($r('app.string.font_weight_700'))
                .fontColor($r('app.color.font_color1'))
                .width(CommonConstants.FULL_PARENT)

              // 服务机构
              Row() {
                Text($r('app.string.service_organization'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color'))
                Text(this.serviceItem.serviceOrganization)
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_gray'))
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ top: $r('app.float.distance_12') })

              // 服务类型
              Row() {
                Text($r('app.string.service_type'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color'))
                Text(this.serviceItem.serviceType)
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_gray'))
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ top: $r('app.float.distance_8') })

              // 分割线
              Divider()
                .color($r('app.color.gray4'))
                .margin({ top: $r('app.float.distance_16'), bottom: $r('app.float.distance_16') })

              // 服务介绍标题
              Text($r('app.string.service_introduction'))
                .fontSize($r('app.float.font_size_18'))
                .fontWeight(600)
                .fontColor($r('app.color.font_color1'))
                .width(CommonConstants.FULL_PARENT)

              // 服务介绍内容
              Text(this.serviceItem.serviceDescription)
                .fontSize($r('app.float.font_size_15'))
                .fontColor($r('app.color.font_gray'))
                .lineHeight($r('app.float.line_height_22'))
                .width(CommonConstants.FULL_PARENT)
                .margin({ top: $r('app.float.distance_8') })

              // 分割线
              Divider()
                .color($r('app.color.gray4'))
                .margin({ top: $r('app.float.distance_16'), bottom: $r('app.float.distance_16') })

              // 预约须知标题
              Text($r('app.string.service_appointment_notice'))
                .fontSize($r('app.float.font_size_18'))
                .fontWeight(600)
                .fontColor($r('app.color.font_color1'))
                .width(CommonConstants.FULL_PARENT)

              // 预约须知内容
              Text(this.serviceItem.serviceAppointmentNotice)
                .fontSize($r('app.float.font_size_15'))
                .fontColor($r('app.color.font_gray'))
                .lineHeight($r('app.float.line_height_22'))
                .width(CommonConstants.FULL_PARENT)
                .margin({ top: $r('app.float.distance_8') })

              // 分割线
              Divider()
                .color($r('app.color.gray4'))
                .margin({ top: $r('app.float.distance_16'), bottom: $r('app.float.distance_16') })

              // 费用须知标题
              Text($r('app.string.service_fee_notice'))
                .fontSize($r('app.float.font_size_18'))
                .fontWeight(600)
                .fontColor($r('app.color.font_color1'))
                .width(CommonConstants.FULL_PARENT)

              // 费用须知内容
              Text(this.serviceItem.serviceFeeNotice)
                .fontSize($r('app.float.font_size_15'))
                .fontColor($r('app.color.font_gray'))
                .lineHeight($r('app.float.line_height_22'))
                .width(CommonConstants.FULL_PARENT)
                .margin({ top: $r('app.float.distance_8') })

              // 分割线
              Divider()
                .color($r('app.color.gray4'))
                .margin({ top: $r('app.float.distance_16'), bottom: $r('app.float.distance_16') })

              // 费用区域容器
              Column() {
                // 费用标题栏
                Row() {
                  Divider()
                    .vertical(true)
                    .strokeWidth(3)
                    .height($r('app.float.distance_16'))
                    .color($r('app.color.green1'))
                    .margin({ right: $r('app.float.distance_8') })
                  Text($r('app.string.fee'))
                    .fontSize($r('app.float.font_size_14'))
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.font_color1'))
                }
                .width(CommonConstants.FULL_PARENT)
                .margin({ bottom: $r('app.float.distance_12') })

                // 费用明细内容
                if (this.serviceItem.feeBreakdown && this.serviceItem.feeBreakdown.length > 0) {
                  ForEach(this.serviceItem.feeBreakdown, (item: SimpleFeeItem) => {
                    Row() {
                      Text(item.name)
                        .fontSize($r('app.float.font_size_14'))
                        .fontColor($r('app.color.font_color'))
                      Text(' ------------------------------------ ')
                        .fontSize($r('app.float.font_size_12'))
                        .fontColor($r('app.color.gray1'))
                        .layoutWeight(1)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Clip })
                      Text(`¥ ${item.price}`)
                        .fontSize($r('app.float.font_size_14'))
                        .fontColor($r('app.color.font_color1'))
                    }
                    .width(CommonConstants.FULL_PARENT)
                    .margin({ bottom: $r('app.float.distance_8') })
                  })
                }

                // 总金额
                Row() {
                  Text($r('app.string.total_amount'))
                    .fontSize($r('app.float.font_size_14'))
                    .fontColor($r('app.color.font_color1'))
                  Blank()
                  Text(`¥${this.serviceItem.servicePrice}`)
                    .fontSize($r('app.float.font_size_18'))
                    .fontColor($r('app.color.font_red2'))
                    .fontWeight(FontWeight.Bold)
                }
                .width(CommonConstants.FULL_PARENT)
                .margin({ top: $r('app.float.distance_8') })
              }
              .width(CommonConstants.FULL_PARENT)
              .padding($r('app.float.distance_16'))
              .backgroundColor(Color.White)
              .borderRadius($r('app.float.distance_8'))
              .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
              .margin({ top: $r('app.float.distance_12') })
            }
            .padding($r('app.float.distance_16'))
            .width(CommonConstants.FULL_PARENT)
            // .backgroundColor($r('app.color.white')) // Removed duplicated background color if needed, or keep it. Using the one from line 215 originally.
            .backgroundColor($r('app.color.white'))
          }
        }
        .layoutWeight(1)
        .width(CommonConstants.FULL_PARENT)

        // 底部预约按钮
        Column() {
          Button($r('app.string.appointment_service'))
            .width(CommonConstants.FULL_PARENT)
            .height($r('app.float.height_48'))
            .fontSize($r('app.float.font_size_18'))
            .fontWeight(600)
            .backgroundColor($r('app.color.green1'))
            .borderRadius($r('app.float.distance_24'))
            .onClick(() => {
              this.handleAppointment();
            })
        }
        .padding($r('app.float.distance_12'))
        .width(CommonConstants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .shadow({ radius: 8, color: $r('app.color.black1'), offsetX: 0, offsetY: -2 })
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .backgroundColor($r('app.color.background_color'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_green'))
  }
}
