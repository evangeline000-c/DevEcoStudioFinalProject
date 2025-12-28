import CommonConstants from '../common/CommonContants'
export interface SelectOption {
  value: string;
}

// 文本输入行
@Builder
export function TextInputField(label: Resource|string, required: boolean, placeholder: Resource|string, onChange: (value: string) => void) {
  Row() {
    Row() {
      Text(label)
        .fontSize($r('app.float.font_size_15'))
        .fontColor($r('app.color.font_black'))
        .margin({ left: $r('app.float.distance_2') });
      if (required) {
        Text('*')
          .fontSize($r('app.float.font_size_15'))
          .fontColor($r('app.color.font_red1'))
          .margin({ left: $r('app.float.layout_4') });
      }
    }
    .margin({ left: $r('app.float.distance_10') })
    .alignItems(VerticalAlign.Center);

    Blank();

    TextInput({ placeholder })
      .backgroundColor($r('app.color.white'))
      .placeholderColor($r('app.color.font_black'))
      .placeholderFont({size: $r('app.float.layout_15')})
      .onChange(onChange)
      .padding({ left: $r('app.float.distance_10') })
      .height($r('app.float.height_38'))
      .width(CommonConstants.HALF_PARENT);
  }
  .alignItems(VerticalAlign.Center)
  .backgroundColor(Color.Transparent)
  .justifyContent(FlexAlign.SpaceBetween)
  .margin({ top: $r('app.float.distance_10'), bottom: $r('app.float.distance_10') })
  .width(CommonConstants.FULL_PARENT);
}

// 关系选择行
@Builder
export function RelationSelectField(options: SelectOption[], selectedIndex: number, value: string, onSelect: (idx: number, text: string) => void, placeholder: Resource|string = '请选择关系') {
  Row() {
    Row() {
      Text($r('app.string.relation'))
        .fontSize($r('app.float.font_size_15'))
        .fontColor($r('app.color.font_black'))
        .margin({ left: $r('app.float.distance_2') });
      Text('*')
        .fontSize($r('app.float.font_size_15'))
        .fontColor($r('app.color.font_red1'))
        .margin({ left: $r('app.float.layout_4') });
    }
    .margin({ left: $r('app.float.distance_10') })
    .alignItems(VerticalAlign.Center);
    Blank();
    Row() {
      Select(options)
        .selected(selectedIndex)
        .font({ size: $r('app.float.font_size_15') })
        .fontColor( $r('app.color.font_black') )
        .value(value && value.length > 0? value : placeholder)
        .optionWidth($r('app.float.height_200'))
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.float.radius_19'))
        .padding({ left: $r('app.float.distance_5'), right: $r('app.float.distance_12') })
        .onSelect((idx: number, text?: string) => {
          if (text) {
            onSelect(idx, text)
          }
        });
    }
    .backgroundColor(Color.Transparent)
    .alignItems(VerticalAlign.Center)
    .width(CommonConstants.PARENT_FIFTY_ONE)
    .height($r('app.float.height_38'));
  }
  .alignItems(VerticalAlign.Center)
  .backgroundColor($r('app.color.white'))
  .margin({ top: $r('app.float.distance_10'), bottom: $r('app.float.distance_18') })
  .width(CommonConstants.FULL_PARENT);
}

// 性别单选行
@Builder
export function GenderField(current: '男性' | '女性' | undefined, onChange: (gender: '男性' | '女性') => void) {
  Row() {
    Row() {
      Text($r('app.string.gender'))
        .fontSize($r('app.float.font_size_15'))
        .fontColor($r('app.color.font_black'))
        .margin({ left: $r('app.float.distance_2') });
      Text('*')
        .fontSize($r('app.float.font_size_15'))
        .fontColor($r('app.color.font_red1'))
        .margin({ left: $r('app.float.layout_4') });
    }
    .margin({ left: $r('app.float.distance_10') })
    .alignItems(VerticalAlign.Center);

    Blank();

    Row() {
      Row() {
        Radio({ value: '男性', group: 'radioGroup' })
          .checked(current === '男性')
          .onChange(() => onChange('男性'));
        Text($r('app.string.male')).margin({ left: $r('app.float.distance_8') });
      }
      .alignItems(VerticalAlign.Center);

      Row() {
        Radio({ value: '女性', group: 'radioGroup' })
          .checked(current === '女性')
          .onChange(() => onChange('女性'));
        Text($r('app.string.female')).margin({ left: $r('app.float.distance_8') });
      }
      .alignItems(VerticalAlign.Center)
      .margin({ left: $r('app.float.distance_20') });
    }
    .width(CommonConstants.HALF_PARENT)
    .alignItems(VerticalAlign.Center);
  }
  .alignItems(VerticalAlign.Center)
  .backgroundColor(Color.Transparent)
  .margin({ top: $r('app.float.distance_10'), bottom: $r('app.float.distance_18') })
  .width(CommonConstants.FULL_PARENT);
}

