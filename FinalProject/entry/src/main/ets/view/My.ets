import{ NavItem, UserHeader} from './MyComponents'
import CommonConstants from '../common/CommonContants'

interface CurrentUser { account?: string; phone?: string }

@Component
export default struct My {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;//跳转页面相关 不要删
  @State currentUser: CurrentUser | null = null;
  @State userName: string = '';
  @State userPhone: string = '';

  aboutToAppear() {
    const u = AppStorage.get('currentUser') as CurrentUser | null;
    this.currentUser = u;
    // 显示当前登录信息
    if (u) {
      this.userName = u.account ? u.account : '';
      this.userPhone = u.phone ? u.phone : '';
    } else {
      this.userName = '';
      this.userPhone = '';
    }
  }
  Consultation(result: boolean): void {
    this.pathStack.pushPathByName('Consultation', null);
  }
  ServiceOrders(result: boolean): void {
    this.pathStack.pushPathByName('ServiceOrders', null);
  }
  Admission(result: boolean): void {
    this.pathStack.pushPathByName('Admission', null);
  }

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.tab_my'))
          .height($r('app.float.height_text'))
          .width(CommonConstants.FULL_PARENT)
          .fontWeight($r('app.float.font_weight_220'))
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)

        UserHeader({
          bgImage: 'app.media.background_My',
          avatar: 'app.media.human',
          userName: this.userName && this.userName.length > 0 ? this.userName : '未登录',
          userPhone: this.userPhone && this.userPhone.length > 0 ? this.userPhone : ''
        });

        NavItem({
          icon: 'app.media.record',
          text: $r('app.string.consultation')
        })
        .onClick(() => {
          this.Consultation(true);
        })

        NavItem({
          icon: 'app.media.service',
          text: $r('app.string.service_order')
        })
        .onClick(() => {
          this.ServiceOrders(true);
        })

        NavItem({
          icon: 'app.media.bed',
          text: $r('app.string.admission_title')
        })
        .onClick(() => {
          this.Admission(true);
        })

        NavItem({
          icon: 'app.media.out',
          text: $r('app.string.logout')
        })
        .onClick(() => {
          this.pathStack.clear()
        })
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .linearGradient({
        colors: [
          [$r('app.color.green1'),0],
          [$r('app.color.gray7'),0.3],
          [$r('app.color.background_color'),0.7]
        ]
      })
    }
  }
}