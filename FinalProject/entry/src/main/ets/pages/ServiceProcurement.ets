//服务采购页面
import { ServiceItemType, IServiceItemData } from '../viewmodel/ServiceProcurementData';
import ServiceItemListView from '../view/ServiceItemListView';

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
            .width('24vp')
            .height('24vp')
            .margin({ left: '16vp' })
            .onClick(() => {
              this.pathStack.pop();
            })
          Text('服务采购')
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

        // 服务项目列表
        ServiceItemListView({
          onItemClick: (item: ServiceItemType) => {
            this.handleItemClick(item);
          }
        })
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