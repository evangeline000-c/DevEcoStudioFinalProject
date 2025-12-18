export interface SelectOption {
  value: string;
}

// 文本输入行
@Builder
export function TextInputField(label: string, required: boolean, placeholder: string, onChange: (value: string) => void) {
  Row() {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor('#1F2328')
        .margin({ left: 2 });
      if (required) {
        Text('*')
          .fontSize(16)
          .fontColor('#FF5252')
          .margin({ left: 4 });
      }
    }
    .margin({ left: 10 })
    .alignItems(VerticalAlign.Center);

    Blank();

    TextInput({ placeholder })
      .backgroundColor('#FFFFFF')
      .placeholderColor('#1F2328')
      .placeholderFont({size: '15vp'})
      .onChange(onChange)
      .padding({ left: 10 })
      .height('38vp')
      .width('50%');
  }
  .alignItems(VerticalAlign.Center)
  .backgroundColor(Color.Transparent)
  .justifyContent(FlexAlign.SpaceBetween)
  .margin({ top: 10, bottom: 10 })
  .width('100%');
}

// 关系选择行
@Builder
export function RelationSelectField(options: SelectOption[], selectedIndex: number, value: string, onSelect: (idx: number, text: string) => void, placeholder: string = '请选择关系') {
  Row() {
    Row() {
      Text('关系')
        .fontSize(16)
        .fontColor('#1F2328')
        .margin({ left: 2 });
      Text('*')
        .fontSize(16)
        .fontColor('#FF5252')
        .margin({ left: 4 });
    }
    .margin({ left: 10 })
    .alignItems(VerticalAlign.Center);
    Blank();
    Row() {
      Select(options)
        .selected(selectedIndex)
        .font({ size: 15 })
        .fontColor( '#1F2328' )
        .value(value && value.length > 0? value : placeholder)
        .optionWidth(200)
        .backgroundColor('#FFFFFF')
        .borderRadius(19)
        .padding({ left: 5, right: 12 })
        .onSelect((idx: number, text?: string) => {
          if (text) {
            onSelect(idx, text)
          }
        });
    }
    .backgroundColor(Color.Transparent)
    .alignItems(VerticalAlign.Center)
    .width('51%')
    .height('38vp');
  }
  .alignItems(VerticalAlign.Center)
  .backgroundColor('#FFFFFF')
  .margin({ top: 10, bottom: 18 })
  .width('100%');
}

// 性别单选行
@Builder
export function GenderField(current: '男性' | '女性' | undefined, onChange: (gender: '男性' | '女性') => void) {
  Row() {
    Row() {
      Text('性别')
        .fontSize(16)
        .fontColor('#1F2328')
        .margin({ left: 2 });
      Text('*')
        .fontSize(16)
        .fontColor('#FF5252')
        .margin({ left: 4 });
    }
    .margin({ left: 10 })
    .alignItems(VerticalAlign.Center);

    Blank();

    Row() {
      Row() {
        Radio({ value: '男性', group: 'radioGroup' })
          .checked(current === '男性')
          .onChange(() => onChange('男性'));
        Text('男性').margin({ left: 8 });
      }
      .alignItems(VerticalAlign.Center);

      Row() {
        Radio({ value: '女性', group: 'radioGroup' })
          .checked(current === '女性')
          .onChange(() => onChange('女性'));
        Text('女性').margin({ left: 8 });
      }
      .alignItems(VerticalAlign.Center)
      .margin({ left: 20 });
    }
    .width('50%')
    .alignItems(VerticalAlign.Center);
  }
  .alignItems(VerticalAlign.Center)
  .backgroundColor(Color.Transparent)
  .margin({ top: 10, bottom: 18 })
  .width('100%');
}

