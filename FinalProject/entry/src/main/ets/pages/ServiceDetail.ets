// 服务详情页面
import { ServiceItemType, ServiceItemList, FeeItem as SimpleFeeItem } from '../viewmodel/ServiceProcurementData';

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
            .width('24vp')
            .height('24vp')
            .margin({ left: '16vp' })
            .onClick(() => {
              this.pathStack.pop();
            })
          Text('服务详情')
            .fontSize('18fp')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
          Blank().width('40vp')
        }
        .width('100%')
        .height('50vp')
        .backgroundColor('#21deb4')

        // 滚动容器
        Scroll() {
          Column() {
            // 服务图片
            Image(this.serviceItem.servicePhoto)
              .width('100%')
              .height('240vp')
              .objectFit(ImageFit.Cover)

            // 服务信息区域
            Column() {
              // 服务名称
              Text(this.serviceItem.serviceName)
                .fontSize('24fp')
                .fontWeight(700)
                .fontColor('#333333')
                .width('100%')

              // 服务机构
              Row() {
                Text('服务机构：')
                  .fontSize('15fp')
                  .fontColor('#999999')
                Text(this.serviceItem.serviceOrganization)
                  .fontSize('15fp')
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ top: '12vp' })

              // 服务类型
              Row() {
                Text('服务类型：')
                  .fontSize('15fp')
                  .fontColor('#999999')
                Text(this.serviceItem.serviceType)
                  .fontSize('15fp')
                  .fontColor('#666666')
              }
              .width('100%')
              .margin({ top: '8vp' })

              // 分割线
              Divider()
                .color('#E5E5E5')
                .margin({ top: '16vp', bottom: '16vp' })

              // 服务介绍标题
              Text('服务介绍')
                .fontSize('18fp')
                .fontWeight(600)
                .fontColor('#333333')
                .width('100%')

              // 服务介绍内容
              Text(this.serviceItem.serviceDescription)
                .fontSize('15fp')
                .fontColor('#666666')
                .lineHeight('22fp')
                .width('100%')
                .margin({ top: '8vp' })

              // 分割线
              Divider()
                .color('#E5E5E5')
                .margin({ top: '16vp', bottom: '16vp' })

              // 预约须知标题
              Text('预约须知')
                .fontSize('18fp')
                .fontWeight(600)
                .fontColor('#333333')
                .width('100%')

              // 预约须知内容
              Text(this.serviceItem.serviceAppointmentNotice)
                .fontSize('15fp')
                .fontColor('#666666')
                .lineHeight('22fp')
                .width('100%')
                .margin({ top: '8vp' })

              // 分割线
              Divider()
                .color('#E5E5E5')
                .margin({ top: '16vp', bottom: '16vp' })

              // 费用须知标题
              Text('费用须知')
                .fontSize('18fp')
                .fontWeight(600)
                .fontColor('#333333')
                .width('100%')

              // 费用须知内容
              Text(this.serviceItem.serviceFeeNotice)
                .fontSize('15fp')
                .fontColor('#666666')
                .lineHeight('22fp')
                .width('100%')
                .margin({ top: '8vp' })

              // 分割线
              Divider()
                .color('#E5E5E5')
                .margin({ top: '16vp', bottom: '16vp' })

              // 费用区域容器
              Column() {
                // 费用标题栏
                Row() {
                  Divider()
                    .vertical(true)
                    .strokeWidth(3)
                    .height('16vp')
                    .color('#21deb4')
                    .margin({ right: '8vp' })
                  Text('费用')
                    .fontSize('14fp')
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#333333')
                }
                .width('100%')
                .margin({ bottom: '12vp' })

                // 费用明细内容
                if (this.serviceItem.feeBreakdown && this.serviceItem.feeBreakdown.length > 0) {
                  ForEach(this.serviceItem.feeBreakdown, (item: SimpleFeeItem) => {
                    Row() {
                      Text(item.name)
                        .fontSize('14fp')
                        .fontColor('#999999')
                      Text(' ------------------------------------ ')
                        .fontSize('12fp')
                        .fontColor('#E8E8E8')
                        .layoutWeight(1)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Clip })
                      Text(`¥ ${item.price}`)
                        .fontSize('14fp')
                        .fontColor('#333333')
                    }
                    .width('100%')
                    .margin({ bottom: '8vp' })
                  })
                }

                // 总金额
                Row() {
                  Text('总金额')
                    .fontSize('14fp')
                    .fontColor('#333333')
                  Blank()
                  Text(`¥${this.serviceItem.servicePrice}`)
                    .fontSize('18fp')
                    .fontColor('#FF6B00')
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .margin({ top: '8vp' })
              }
              .width('100%')
              .padding('16vp')
              .backgroundColor(Color.White)
              .borderRadius('8vp')
              .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
              .margin({ top: '12vp' })
            }
            .padding('16vp')
            .width('100%')
            // .backgroundColor('#FFFFFF') // Removed duplicated background color if needed, or keep it. Using the one from line 215 originally.
            .backgroundColor('#FFFFFF')
          }
        }
        .layoutWeight(1)
        .width('100%')

        // 底部预约按钮
        Column() {
          Button('预约服务')
            .width('100%')
            .height('48vp')
            .fontSize('18fp')
            .fontWeight(600)
            .backgroundColor('#21deb4')
            .borderRadius('24vp')
            .onClick(() => {
              this.handleAppointment();
            })
        }
        .padding('12vp')
        .width('100%')
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 8, color: '#1F000000', offsetX: 0, offsetY: -2 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor('#d821deb4')
  }
}
