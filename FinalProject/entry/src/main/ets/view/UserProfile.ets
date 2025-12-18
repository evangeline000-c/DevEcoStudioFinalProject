import { UserInfo, UserDataSource } from './UserModel';
import { MAX_OFFSET_Y, REFRESH_TIME, NORMAL_FONT_SIZE, TOTAL_MAX_DATA, INIT_USER_DATA, addNewUserToList } from './UserProfileConfig';
import { RefreshComponent, UserList } from './UserProfileBuilders';


@Component
export default struct UserProfile {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;
  // 数据源
  private dataSource = new UserDataSource(INIT_USER_DATA);
  @State refreshStatus: boolean = false;
  @State refreshText: string = '下拉刷新';
  @State currentOffsetY: number = 0;
  private timer: number | null = null;
  private bottomTimer: number | null = null;
  @State selected: Set<string> = new Set<string>();
  @State selecting: boolean = false;
  @State isEnd: boolean = false;
  @State bottomReached: boolean = false;
  private startTouchOffsetY: number = 0;
  private endTouchOffsetY: number = 0;
  private scroller: Scroller = new Scroller();

  // 跳转添加用户页面
  private AddUser(result: boolean): void {
    AppStorage.setOrCreate('userDataSource', this.dataSource);
    this.pathStack.pushPathByName('AddUser', null);
  }


  build() {
    Column() {
      Row() {
        Text('康养用户列表')
          .fontWeight(FontWeight.Bold)
          .fontSize('20fp')
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)
        Row() {
          Text(this.selecting ? '确认删除' : '删除用户')
            .fontSize('16fp')
            .fontColor('#FFFFFF')
            .margin({ right: '16vp' })
            .onClick(() => {
              if (!this.selecting) {
                this.selected.clear();
                this.selecting = true;
                return;
              }
              const ids = Array.from(this.selected.values());
              if (ids.length === 0) {
                this.selecting = false;
                return;
              }
              this.dataSource.removeByUids(ids);
              this.selected.clear();
              this.selecting = false;
            });
          Text('添加用户')
            .fontColor('#FFFFFF')
            .onClick(() => {
              this.AddUser(true);
            });
        }
        .margin({ left: '20vp' })
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('50%')
      }
      .height('50vp').justifyContent(FlexAlign.Start)
      .margin({ top: '0vp', bottom: '0vp' })

      Scroll(this.scroller) {
        Column() {
          if (this.refreshStatus) {
            RefreshComponent(this.refreshText);
          }

          // 用户列表
          UserList({
            dataSource: this.dataSource,
            selecting: this.selecting,
            selected: this.selected,
            onItemTouch: (event?: TouchEvent) => {
              this.handleListItemTouch(event);
            },
            onCheckboxChange: (uid: string, checked: boolean) => {
              if (!uid) {
                return;
              }
              if (checked) this.selected.add(uid); else this.selected.delete(uid);
            },
            onReachEnd: () => {
              // 到底时显示提示并在短时间后自动隐藏
              this.bottomReached = true;
              if (this.bottomTimer) {
                clearTimeout(this.bottomTimer);
              }
              this.bottomTimer = setTimeout(() => {
                this.bottomReached = false;
              }, 1200);
            }
          });
          Text('已经到底了')
            .fontSize(NORMAL_FONT_SIZE)
            .fontColor('#888888')
            .visibility(this.bottomReached ? Visibility.Visible : Visibility.Hidden)
            .margin({ top: '10vp', bottom: '10vp' });
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .height('630vp')
      .scrollSnap({
        snapAlign: ScrollSnapAlign.START,
        snapPagination: 400,
        enableSnapToStart: true,
        enableSnapToEnd: true
      })
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
      .onTouch((event?: TouchEvent) => {
        this.putDownRefresh(event);
      });
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      colors: [
        ['#21deb4', 0],
        ['#1121deb4', 0.2],
        ['#F1F3F5', 0.3]
      ]
    })

  }

  // 将添加的新用户同步到列表
  private addNewUserToList(newUser: UserInfo): void {
    addNewUserToList(newUser, this.dataSource, (flag: boolean) => {
      this.isEnd = flag;
    });
  }

  // 下拉刷新触摸事件处理
  private putDownRefresh(event?: TouchEvent): void {
    if (event === undefined) {
      return;
    }
    this.refreshText = this.refreshStatus ? '刷新中...' : '下拉刷新';

    switch (event.type) {
      case TouchType.Down:
        this.currentOffsetY = event.touches[0].y;
        break;
      case TouchType.Move:
        const offsetY = event.touches[0].y - this.currentOffsetY;
        this.refreshStatus = offsetY > MAX_OFFSET_Y;
        break;
      case TouchType.Cancel:
        break;
      case TouchType.Up:
        if (this.timer) {
          clearTimeout(this.timer);
        }
        this.timer = setTimeout(() => {
          this.refreshStatus = false;
          this.refreshText = '下拉刷新';
        }, REFRESH_TIME);
        break;
      default:
        break;
    }
  }

  // 列表项触摸事件处理
  private handleListItemTouch(event?: TouchEvent): void {
    if (event === undefined) {
      return;
    }
    switch (event.type) {
      case TouchType.Down:
        this.startTouchOffsetY = event.touches[0].y;
        break;
      case TouchType.Up:
        this.endTouchOffsetY = event.touches[0].y;
        break;
      case TouchType.Move:
        this.endTouchOffsetY = event.touches[0].y;
        break;
    }
  }
}