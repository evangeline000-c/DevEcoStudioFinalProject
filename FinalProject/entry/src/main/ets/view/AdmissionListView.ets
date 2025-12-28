// 入住申请列表视图组件
import { AdmissionItemType, AdmissionItemList } from '../viewmodel/AdmissionData';
import AdmissionItemCard from './AdmissionItemCard';
import CommonConstants from '../common/CommonContants'

@Component
export default struct AdmissionListView {
  @StorageLink('admissionList') admissionList: AdmissionItemType[] = AdmissionItemList;
  onApplyClick?: () => void;  // 保留以保持接口兼容
  onItemClick?: (item: AdmissionItemType) => void;

  build() {
    Column() {
      // 入住申请列表
      if (this.admissionList.length > 0) {
        List({ space: 12 }) {
          ForEach(this.admissionList, (item: AdmissionItemType) => {
            ListItem() {
              AdmissionItemCard({
                admissionItem: item,
                onItemClick: this.onItemClick
              })
            }
          }, (item: AdmissionItemType) => item.id.toString())
        }
        .width(CommonConstants.FULL_PARENT)
        .layoutWeight(1)
        .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.distance_12') })
      } else {
        // 空状态提示
        Column() {
          Text(String($r('app.string.no_admission_records')))
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.font_color'))
            .margin({ top: $r('app.float.distance_40') })
        }
        .width(CommonConstants.FULL_PARENT)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Start)
      }
    }
    .width(CommonConstants.FULL_PARENT)
    .layoutWeight(1)
  }
}
