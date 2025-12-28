import { formatDateFromDate } from './AddUserLogic';
import CommonConstants from '../common/CommonContants'

// 出生日期弹窗
@Builder
export function DatePickerModal(
  selectedDate: Date,
  onDateChange: (value: Date, formatted: string) => void,
  onCancel: () => void,
  onConfirm: () => void
) {
  Column() {
    Column() {
      Text($r('app.string.select_birthday'))
        .fontSize($r('app.float.font_size_18'))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: $r('app.float.distance_12') });
      DatePicker({
        start: new Date(1900, 0, 1),
        end: new Date(),
        selected: selectedDate
      })
        .onDateChange((value: Date) => {
          const formatted = formatDateFromDate(value);
          onDateChange(value, formatted);
        });

      Row() {
        Button($r('app.string.cancel'))
          .height($r('app.float.height_36'))
          .margin({ right: $r('app.float.distance_12'), top: $r('app.float.distance_12') })
          .backgroundColor($r('app.color.main_green'))
          .fontColor($r('app.color.white'))
          .onClick(() => onCancel());
        Button($r('app.string.confirm'))
          .height($r('app.float.height_36'))
          .backgroundColor($r('app.color.main_green'))
          .fontColor($r('app.color.white'))
          .margin({ top: $r('app.float.distance_12') })
          .onClick(() => onConfirm());
      }
      .justifyContent(FlexAlign.End)
      .width(CommonConstants.FULL_PARENT);
    }
    .width('86%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: $r('app.float.distance_18'), right: $r('app.float.distance_18'), top: $r('app.float.distance_18'), bottom: 12 })
    .borderRadius($r('app.float.distance_12'));
  }
  .width(CommonConstants.FULL_PARENT)
  .height(CommonConstants.FULL_PARENT)
  .backgroundColor(Color.Transparent)
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center);
}
