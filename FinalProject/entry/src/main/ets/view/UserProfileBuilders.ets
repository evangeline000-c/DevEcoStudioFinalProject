import { UserInfo, UserDataSource } from './UserModel';
import { LIST_ITEM_SPACE, NORMAL_FONT_SIZE } from './UserProfileConfig';
import CommonConstants from '../common/CommonContants'

interface UserListProps {
  dataSource: UserDataSource;
  selecting: boolean;
  selected: Set<string>;
  onItemTouch: (event?: TouchEvent) => void;
  onCheckboxChange: (uid: string, checked: boolean) => void;
  onReachEnd?: () => void;
}

interface UserItemProps {
  user: UserInfo;
  selecting: boolean;
  selected: Set<string>;
  onCheckboxChange: (uid: string, checked: boolean) => void;
}

// 下拉刷新组件
@Builder
export function RefreshComponent(refreshText: string) {
  Column() {
    Text(refreshText)
      .fontSize(NORMAL_FONT_SIZE)
      .fontColor($r('app.color.font_gray1'));
  }
  .width(CommonConstants.FULL_PARENT)
  .justifyContent(FlexAlign.Center)
  .alignSelf(ItemAlign.Center)
  .padding({ top: $r('app.float.distance_10'), bottom: $r('app.float.distance_10') });
}

// 用户列表
@Builder
export function UserList(props: UserListProps) {
  List({ space: LIST_ITEM_SPACE }) {
    LazyForEach(props.dataSource, (user: UserInfo, index?: number) => {
      ListItem() {
        UserItem({
          user,
          selecting: props.selecting,
          selected: props.selected,
          onCheckboxChange: props.onCheckboxChange
        });
      }
      .onTouch((event?: TouchEvent) => {
        props.onItemTouch(event);
      });
    }, (user: UserInfo) => user.uid ?? '');
  }
  .scrollBar(BarState.Off)
  .height(CommonConstants.NINETY_PARENT)
  .width(CommonConstants.NINETY_PARENT)
  .alignSelf(ItemAlign.Center)
  .padding({ left: $r('app.float.distance_3'), top: $r('app.float.distance_0'), bottom: $r('app.float.distance_12') })
  .onReachEnd(() => {
    props.onReachEnd?.();
  });
}

// 单个用户项
@Builder
export function UserItem(props: UserItemProps) {
  Column() {
    Row() {
      if (props.selecting) {
        Checkbox()
          .select(props.selected.has(props.user.uid ?? ''))
          .onChange((checked: boolean) => {
            props.onCheckboxChange(props.user.uid ?? '', checked);
          })
          .margin({ right: $r('app.float.distance_8') });
      }
      Text(props.user.name)
        .fontSize($r('app.float.font_size_18'))
        .fontWeight(FontWeight.Medium);
      Text(props.user.gender)
        .fontSize($r('app.float.font_size_12'))
        .backgroundColor(props.user.gender === '男性' ? $r('app.color.background_green1') : $r('app.color.pick'))
        .fontColor($r('app.color.white'))
        .padding({ left: $r('app.float.distance_6'), right: $r('app.float.distance_6'), top: $r('app.float.distance_2'), bottom: $r('app.float.distance_2') })
        .borderRadius($r('app.float.layout_4'));
    }
    .width(CommonConstants.NINETY_PARENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: $r('app.float.distance_8'), bottom: $r('app.float.distance_8') });

    InfoRow($r('app.string.relation'), props.user.relation);
    InfoRow($r('app.string.birthday'), props.user.birthday);
    InfoRow($r('app.string.id_card'), props.user.idCard);
    InfoRow($r('app.string.address'), props.user.address);
    InfoRow($r('app.string.job'), props.user.job);
  }
  .width(CommonConstants.FULL_PARENT)
  .backgroundColor($r('app.color.white'))
  .borderRadius($r('app.float.distance_8'))
  .alignSelf(ItemAlign.Center);
}

// 信息行
@Builder
export function InfoRow(label: Resource|string, value?: string) {
  if (value) {
    Row() {
      Text(label).fontSize(NORMAL_FONT_SIZE).fontColor($r('app.color.font_gray1'));
      Text(value).fontSize(NORMAL_FONT_SIZE).fontColor($r('app.color.font_color1'));
    }
    .width(CommonConstants.NINETY_PARENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ left: $r('app.float.layout_15'), bottom: $r('app.float.distance_20'), right: $r('app.float.layout_15') });
  }
}
