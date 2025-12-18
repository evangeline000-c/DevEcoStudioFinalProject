import{ NavItem, UserHeader} from './MyComponents'
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
        Text('我的')
          .height('60vp')
          .width('100%')
          .fontWeight(220)
          .fontSize('20fp')
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)

        UserHeader({
          bgImage: 'app.media.background_My',
          avatar: 'app.media.human',
          userName: this.userName && this.userName.length > 0 ? this.userName : '未登录',
          userPhone: this.userPhone && this.userPhone.length > 0 ? this.userPhone : ''
        });

        NavItem({
          icon: 'app.media.record',
          text: '问诊记录'
        })
        .onClick(() => {
          this.Consultation(true);
        })

        NavItem({
          icon: 'app.media.service',
          text: '服务订单'
        })
        .onClick(() => {
          this.ServiceOrders(true);
        })

        NavItem({
          icon: 'app.media.bed',
          text: '入住申请'
        })
        .onClick(() => {
          this.Admission(true);
        })

        NavItem({
          icon: 'app.media.out',
          text: '退出登陆'
        })
        .onClick(() => {
          this.pathStack.clear()
        })
      }
      .width('150%')
      .height('100%')
      .linearGradient({
        colors: [
          ['#21deb4',0],
          ['#1121deb4',0.3],
          ['#F1F3F5',0.7]
        ]
      })
    }
  }
}