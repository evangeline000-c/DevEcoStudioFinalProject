import { AuthUser, verifyAccountPassword, findByPhone, setCurrentUser } from '../view/UserStore';
import { CaptchaState, requestCaptchaCore } from '../common/captcha';
import { InputRow } from '../common/InputRow';
import { validatePasswordLogin, validatePhoneLogin, checkPhoneCaptcha } from '../common/authLogin';
import { LoginFormState, newLoginFormState, newCaptchaState } from '../common/authState';

@Entry
@Component
struct Login {
  pathStack: NavPathStack = new NavPathStack(); 
  ForgetPassword(result: boolean): void {
    this.pathStack.pushPathByName('ForgetPassword', null);
  }
  Register(result: boolean): void {
    this.pathStack.pushPathByName('Register', null);
  }
  @State form: LoginFormState = newLoginFormState();
  @State captchaState: CaptchaState = newCaptchaState();
  // 错误提示
  @State errorMsg: string = '';

  aboutToAppear() {
    AppStorage.setOrCreate("pathStack", this.pathStack); 
  }

  // 登录主逻辑：根据模式校验并决定是否跳转
  login(result: boolean): void {
    this.errorMsg = '';
    if (this.form.mode === 'password') {
      const err = validatePasswordLogin(this.form.account, this.form.password);
      if (err) { this.errorMsg = err; return; }
      const authed = verifyAccountPassword(this.form.account, this.form.password);
      if (!authed) {
        this.errorMsg = '账号或密码错误';
        return;
      }
      setCurrentUser(authed);
    } else {
      const err = validatePhoneLogin(this.form.phone, this.form.code);
      if (err) { this.errorMsg = err; return; }
      const captchaErr = checkPhoneCaptcha(this.form.code, this.captchaState);
      if (captchaErr) { this.errorMsg = captchaErr; return; }
      const found = findByPhone(this.form.phone.trim());
      if (found) {
        setCurrentUser(found);
      } else {
        setCurrentUser({ account: '', phone: this.form.phone.trim(), password: '' });
      }
    }
    this.pathStack.pushPathByName('MainPages', this.pathStack);
  }

  // 生成并显示验证码（4位数字），5分钟有效，每日最多10次
  private requestCaptcha(): void {
    this.errorMsg = '';
    const next = requestCaptchaCore(this.captchaState, 10);
    this.captchaState = {
      code: next.code,
      expireAt: next.expireAt,
      dailyCount: next.dailyCount,
      countDateKey: next.countDateKey,
    };
  }

  build() {
    Navigation(this.pathStack) { 
      Column() {
        Text('登录')
          .height('60vp')
          .width('100%')
          .fontWeight(220)
          .fontSize('20fp')
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)

        Column() {
          Text('互联网机构 家属端')
            .fontColor('#1F2328')
            .fontSize('24fp')
            .fontWeight(FontWeight.Bold)
            .margin({ top: '80vp', bottom: '50vp'})
            .textAlign(TextAlign.Start)
            .width('90%');

          // 登录模式切换标签
          Row() {
            Text('密码登录')
              .fontColor(this.form.mode === 'password' ? '#1F2328' : '#9CA3AF')
              .fontSize('16fp')
              .onClick(() => {
                this.form.mode = 'password';
              })
              .margin({ right: '24vp' });
            Text('手机号登录')
              .fontColor(this.form.mode === 'phone' ? '#1F2328' : '#9CA3AF')
              .fontSize('16fp')
              .onClick(() => {
                this.form.mode = 'phone';
              });
          }
          .width('90%')
          .alignItems(VerticalAlign.Center)
          .margin({ bottom: '10vp' })

          // 分隔线
          Row() {
            Row() {
              if (this.form.mode === 'password') {
                Row().width('100%').height('2vp').backgroundColor('#00C8A2');
              }
            }
            .width('25%')
            .margin({left: '5vp'})
            .alignItems(VerticalAlign.Center)

            Row() {
              if (this.form.mode === 'phone') {
                Row().width('100%').height('2vp').backgroundColor('#00C8A2');
              }
            }
            .width('25%')
            .alignItems(VerticalAlign.Center);
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({left: '5vp', bottom: '30vp' })

          // 表单区域
          if (this.form.mode === 'password') {
            // 账号
            InputRow({
              placeholder: '请输入账号',
              icon: $r('app.media.human'),
              onChange: (v: string) => {
                this.form.account = v;
              }
            })
              .margin({ bottom: '12vp' })

            // 密码
            InputRow({
              placeholder: '请输入密码',
              icon: $r('app.media.lock'),
              inputType: InputType.Password,
              onChange: (v: string) => {
                this.form.password = v;
              }
            })
              .margin({ bottom: '12vp' })
          } else {
            // 手机号
            InputRow({
              placeholder: '请输入手机号',
              icon: $r('app.media.human'),
              inputType: InputType.Number,
              onChange: (v: string) => {
                this.form.phone = v;
              }
            })
              .margin({ bottom: '12vp' })

            // 验证码 + 获取验证码
            Row() {
              InputRow({
                placeholder: '请输入验证码',
                icon: $r('app.media.phone'),
                inputType: InputType.Number,
                onChange: (v: string) => {
                  this.form.code = v;
                }
              })
                .layoutWeight(1)
              Text('获取验证码')
                .fontColor('#00C8A2')
                .fontSize('15fp')
                .onClick(() => this.requestCaptcha())
                .margin({ left: '12vp' });
            }
            .width('90%')
            .alignSelf(ItemAlign.Center)
            .margin({ bottom: '12vp' })
          }
          // 错误提示
          if (this.errorMsg) {
            Text(this.errorMsg)
              .fontColor('#D92D20')
              .fontSize('14fp')
              .alignSelf(ItemAlign.Center)
              .margin({ bottom: '12vp' });
          }

          // 登录按钮
          Button('登录')
            .width('90%')
            .height('40vp')
            .fontSize('16fp')
            .backgroundColor('#d821deb4')
            .onClick(() => {
              this.login(true);
            })
            .margin({bottom: '20vp'})

          Row() {
            Text('还没有账号? ')
              .fontColor('#1F2328')
              .fontSize('14fp');
            Text('立即注册')
              .fontColor('#00C8A2')
              .fontSize('14fp')
              .margin({ right: '24vp' })
              .onClick(() => {
                this.Register(true)
              });
            Blank();
            Text('忘记密码?')
              .fontColor('#00C8A2')
              .fontSize('14fp')
              .onClick(() => {
                this.ForgetPassword(true)
              });
          }
          .width('90%')
          .alignSelf(ItemAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: '16vp' })
        }
        .backgroundColor('#fff1f0f0')
        .width('100%')
        .height('150%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('200%')
      .backgroundColor(Color.Transparent)
    }
    .backgroundColor('#d821deb4')
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}