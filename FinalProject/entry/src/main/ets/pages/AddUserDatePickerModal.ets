import { formatDateFromDate } from './AddUserLogic';

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
      Text('选择出生日期')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 12 });
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
        Button('取消')
          .height('36vp')
          .margin({ right: 12, top: 12 })
          .backgroundColor('#d821deb4')
          .fontColor('#FFFFFF')
          .onClick(() => onCancel());
        Button('确定')
          .height('36vp')
          .backgroundColor('#d821deb4')
          .fontColor('#FFFFFF')
          .margin({ top: 12 })
          .onClick(() => onConfirm());
      }
      .justifyContent(FlexAlign.End)
      .width('100%');
    }
    .width('86%')
    .backgroundColor('#FFFFFF')
    .padding({ left: 18, right: 18, top: 18, bottom: 12 })
    .borderRadius(12);
  }
  .width('100%')
  .height('100%')
  .backgroundColor(Color.Transparent)
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center);
}
