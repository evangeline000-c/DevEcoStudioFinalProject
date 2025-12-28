//服务采购页面
import { ServiceItemType, IServiceItemData } from '../viewmodel/ServiceProcurementData';
import ServiceItemListView from '../view/ServiceItemListView';
import CommonConstants from '../common/CommonContants'

//ServiceProcurement()的入口函数
@Builder
export function ServiceProcurementBuilder() {
  ServiceProcurement()
}

@Component
struct ServiceProcurement {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  // 处理服务项目点击事件
  handleItemClick(item: ServiceItemType): void {
    // 只传递服务ID，目标页面根据ID从ServiceItemList查找完整数据
    this.pathStack.pushPathByName('ServiceDetail', item.id);
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
          Text($r('app.string.service_procurement_title'))
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

        // 服务项目列表
        ServiceItemListView({
          onItemClick: (item: ServiceItemType) => {
            this.handleItemClick(item);
          }
        })
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