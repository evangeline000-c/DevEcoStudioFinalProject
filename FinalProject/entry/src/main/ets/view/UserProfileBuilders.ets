import { UserInfo, UserDataSource } from './UserModel';
import { LIST_ITEM_SPACE, NORMAL_FONT_SIZE } from './UserProfileConfig';

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
      .fontColor('#888888');
  }
  .width('100%')
  .justifyContent(FlexAlign.Center)
  .alignSelf(ItemAlign.Center)
  .padding({ top: '10vp', bottom: '10vp' });
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
  .height('90%')
  .width('100%')
  .alignSelf(ItemAlign.Center)
  .padding({ left: '3vp', top: '0vp', bottom: '12vp' })
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
          .margin({ right: '8vp' });
      }
      Text(props.user.name)
        .fontSize('18fp')
        .fontWeight(FontWeight.Medium);
      Text(props.user.gender)
        .fontSize('12fp')
        .backgroundColor(props.user.gender === '男性' ? '#40E0D0' : '#FF80AB')
        .fontColor('#FFFFFF')
        .padding({ left: '6vp', right: '6vp', top: '2vp', bottom: '2vp' })
        .borderRadius('4vp');
    }
    .width('90%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: '8vp', bottom: '8vp' });

    InfoRow('关系', props.user.relation);
    InfoRow('生日', props.user.birthday);
    InfoRow('身份证', props.user.idCard);
    InfoRow('地址', props.user.address);
    InfoRow('职业', props.user.job);
  }
  .width('100%')
  .backgroundColor('#FFFFFF')
  .borderRadius('8vp')
  .alignSelf(ItemAlign.Center);
}

// 信息行
@Builder
export function InfoRow(label: string, value?: string) {
  if (value) {
    Row() {
      Text(label).fontSize(NORMAL_FONT_SIZE).fontColor('#888888');
      Text(value).fontSize(NORMAL_FONT_SIZE).fontColor('#333333');
    }
    .width('90%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ left: '15vp', bottom: '20vp', right: '15vp' });
  }
}
