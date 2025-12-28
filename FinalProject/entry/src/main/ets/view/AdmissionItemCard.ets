// 入住申请卡片组件
import { AdmissionItemType } from '../viewmodel/AdmissionData';
import CommonConstants from '../common/CommonContants'

@Component
export default struct AdmissionItemCard {
  @Prop admissionItem: AdmissionItemType;
  onItemClick?: (item: AdmissionItemType) => void;

  // 根据审核状态返回对应的颜色
  getStatusColor(status: string): string {
    switch (status) {
      case '已通过':
        return '#52C41A';  // 绿色
      case '已拒绝':
        return '#FF4D4F';  // 红色
      case '待审核':
      default:
        return '#FA8C16';  // 橙色
    }
  }

  build() {
    Column() {
      // 第1行:康养用户姓名
      Row() {
        Text($r('app.string.patient_label'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Text(this.admissionItem.patientName)
          .fontSize($r('app.float.font_size_16'))
          .fontWeight($r('app.float.font_weight_700'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1)
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 第2行:机构名称
      Row() {
        Text($r('app.string.organization_label'))
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_color'))
        Text(this.admissionItem.organizationName)
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_gray'))
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_6') })

      // 第3行:部门名称
      Row() {
        Text($r('app.string.department_label'))
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_color'))
        Text(this.admissionItem.departmentName)
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_gray'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_6') })

      // 第4行:房间名称
      Row() {
        Text($r('app.string.room_label'))
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_color'))
        Text(this.admissionItem.roomName)
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_gray'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_6') })

      // 第5行:申请时间
      Row() {
        Text($r('app.string.application_time_label'))
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_color'))
        Text(this.admissionItem.applicationTime)
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_gray'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 第6行:审核状态
      Row() {
        Text($r('app.string.status_label'))
          .fontSize($r('app.float.font_size_13'))
          .fontColor($r('app.color.font_color'))
        Text(this.admissionItem.status)
          .fontSize($r('app.float.font_size_14'))
          .fontWeight(600)
          .fontColor(this.getStatusColor(this.admissionItem.status))
      }
      .width(CommonConstants.FULL_PARENT)
    }
    .padding($r('app.float.distance_16'))
    .width(CommonConstants.FULL_PARENT)
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.distance_12'))
    .shadow({ radius: $r('app.float.distance_8'), color: $r('app.color.black1'), offsetX: 0, offsetY: 2 })
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.admissionItem);
      }
    })
  }
}
