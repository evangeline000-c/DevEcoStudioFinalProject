// 服务项目卡片组件
import { ServiceItemType } from '../viewmodel/ServiceProcurementData';
import CommonConstants from '../common/CommonContants'

@Component
export default struct ServiceItemCard {
  @Prop serviceItem: ServiceItemType;
  onItemClick?: (item: ServiceItemType) => void;

  build() {
    Column() {
      // 顶部图片
      Image(this.serviceItem.servicePhoto)
        .width(CommonConstants.FULL_PARENT)
        .height($r('app.float.service_picture_height'))
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: $r('app.float.distance_12'), topRight: $r('app.float.distance_12') })

      // 下方信息区域
      Column() {
        // 第1行：服务名称
        Text(this.serviceItem.serviceName)
          .fontSize($r('app.float.font_size_16'))
          .fontWeight($r('app.string.font_weight_700'))
          .fontColor($r('app.color.font_color1'))
          .width(CommonConstants.FULL_PARENT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 第2行：服务机构
        Row() {
          Text($r('app.string.organization_label'))
            .fontSize($r('app.float.font_size_13'))
            .fontColor($r('app.color.font_color'))
          Text(this.serviceItem.serviceOrganization)
            .fontSize($r('app.float.font_size_13'))
            .fontColor($r('app.color.font_gray'))
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ top: $r('app.float.distance_8') })

        // 第3行：服务类型
        Row() {
          Text($r('app.string.service_type'))
            .fontSize($r('app.float.font_size_13'))
            .fontColor($r('app.color.font_color'))
          Text(this.serviceItem.serviceType)
            .fontSize($r('app.float.font_size_13'))
            .fontColor($r('app.color.font_gray'))
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ top: $r('app.float.distance_6') })

        // 第4行：服务价格
        Row() {
          Text($r('app.string.service_price'))
            .fontSize($r('app.float.font_size_13'))
            .fontColor($r('app.color.font_color'))
          Row() {
            Text($r('app.string.price_yuan_unit'))
              .fontSize($r('app.float.font_size_12'))
              .fontColor($r('app.color.font_red'))
              .fontWeight($r('app.string.font_weight_500'))
            Text(this.serviceItem.servicePrice.toString())
              .fontSize($r('app.float.font_size_18'))
              .fontColor($r('app.color.font_red'))
              .fontWeight($r('app.string.font_weight_700'))
            Text(`/${this.serviceItem.serviceUnit}`)
              .fontSize($r('app.float.font_size_12'))
              .fontColor($r('app.color.font_color'))
              .margin({ left: $r('app.float.distance_2') })
          }
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ top: $r('app.float.distance_6') })
      }
      .padding($r('app.float.distance_12'))
      .width(CommonConstants.FULL_PARENT)
      .alignItems(HorizontalAlign.Start)
    }
    .width(CommonConstants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.distance_12'))
    .shadow({ radius: $r('app.float.distance_8'), color: $r('app.color.black1'), offsetX: 0, offsetY: 2 })
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.serviceItem);
      }
    })
  }
}
