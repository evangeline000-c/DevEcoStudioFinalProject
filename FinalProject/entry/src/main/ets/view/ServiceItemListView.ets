// 服务项目列表组件
import { ServiceItemType, ServiceItemList } from '../viewmodel/ServiceProcurementData';
import ServiceItemCard from './ServiceItemCard';
import CommonConstants from '../common/CommonContants'

@Component
export default struct ServiceItemListView {
  onItemClick?: (item: ServiceItemType) => void;

  build() {
    Column() {
      List({ space: 12 }) {
        ForEach(ServiceItemList, (item: ServiceItemType) => {
          ListItem() {
            ServiceItemCard({
              serviceItem: item,
              onItemClick: (clickedItem: ServiceItemType) => {
                if (this.onItemClick) {
                  this.onItemClick(clickedItem);
                }
              }
            })
          }
        }, (item: ServiceItemType) => item.id.toString())
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.distance_12'), bottom: $r('app.float.distance_12') })
    }
    .width(CommonConstants.FULL_PARENT)
    .height(CommonConstants.FULL_PARENT)
  }
}
