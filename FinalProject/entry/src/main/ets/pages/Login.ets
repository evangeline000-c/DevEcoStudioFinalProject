import { AuthUser, verifyAccountPassword, findByPhone, setCurrentUser } from '../view/UserStore';
import { CaptchaState, requestCaptchaCore } from '../viewmodel/captcha';
import { InputRow } from '../viewmodel/InputRow';
import { validatePasswordLogin, validatePhoneLogin, checkPhoneCaptcha } from '../viewmodel/authLogin';
import { LoginFormState, newLoginFormState, newCaptchaState } from '../viewmodel/authState';
import CommonConstants from '../common/CommonContants'

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
        Text($r('app.string.login'))
          .height($r('app.float.height_text'))
          .width(CommonConstants.FULL_PARENT)
          .fontWeight($r('app.string.font_weight_220'))
          .fontSize($r('app.float.font_size'))
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)

        Column() {
          Text($r('app.string.login_subtitle'))
            .fontColor($r('app.color.font_black'))
            .fontSize($r('app.float.font_size_24'))
            .fontWeight(FontWeight.Bold)
            .margin({ top: $r('app.float.distance_80'), bottom: $r('app.float.distance_50')})
            .textAlign(TextAlign.Start)
            .width(CommonConstants.NINETY_PARENT);

          // 登录模式切换标签
          Row() {
            Text($r('app.string.password_login'))
              .fontColor(this.form.mode === 'password' ? $r('app.color.font_black') : $r('app.color.login_gray'))
              .fontSize($r('app.float.font_size_16'))
              .onClick(() => {
                this.form.mode = 'password';
              })
              .margin({ right: $r('app.float.distance_24') });
            Text($r('app.string.phone_login'))
              .fontColor(this.form.mode === 'phone' ? $r('app.color.font_black') : $r('app.color.login_gray'))
              .fontSize($r('app.float.font_size_16'))
              .onClick(() => {
                this.form.mode = 'phone';
              });
          }
          .width(CommonConstants.NINETY_PARENT)
          .alignItems(VerticalAlign.Center)
          .margin({ bottom: $r('app.float.distance_10') })

          // 分隔线
          Row() {
            Row() {
              if (this.form.mode === 'password') {
                Row().width(CommonConstants.FULL_PARENT).height($r('app.float.distance_2')).backgroundColor($r('app.color.green'));
              }
            }
            .width('25%')
            .margin({left: $r('app.float.distance_5')})
            .alignItems(VerticalAlign.Center)

            Row() {
              if (this.form.mode === 'phone') {
                Row().width(CommonConstants.FULL_PARENT).height($r('app.float.distance_2')).backgroundColor($r('app.color.green'));
              }
            }
            .width('25%')
            .alignItems(VerticalAlign.Center);
          }
          .width(CommonConstants.FULL_PARENT)
          .alignItems(VerticalAlign.Center)
          .margin({left: $r('app.float.distance_5'), bottom: $r('app.float.distance_30') })

          // 表单区域
          if (this.form.mode === 'password') {
            // 账号
            InputRow({
              placeholder: $r('app.string.input_account'),
              icon: $r('app.media.human'),
              onChange: (v: string) => {
                this.form.account = v;
              }
            })
              .margin({ bottom: $r('app.float.distance_12') })

            // 密码
            InputRow({
              placeholder: $r('app.string.input_password'),
              icon: $r('app.media.lock'),
              inputType: InputType.Password,
              onChange: (v: string) => {
                this.form.password = v;
              }
            })
              .margin({ bottom: $r('app.float.distance_12') })
          } else {
            // 手机号
            InputRow({
              placeholder: $r('app.string.input_phone'),
              icon: $r('app.media.human'),
              inputType: InputType.Number,
              onChange: (v: string) => {
                this.form.phone = v;
              }
            })
              .margin({ bottom: $r('app.float.distance_12') })

            // 验证码 + 获取验证码
            Row() {
              InputRow({
                placeholder: $r('app.string.input_captcha'),
                icon: $r('app.media.phone'),
                inputType: InputType.Number,
                onChange: (v: string) => {
                  this.form.code = v;
                }
              })
                .layoutWeight(1)
              Text($r('app.string.get_captcha'))
                .fontColor($r('app.color.green'))
                .fontSize($r('app.float.font_size_15'))
                .onClick(() => this.requestCaptcha())
                .margin({ left: $r('app.float.distance_12') });
            }
            .width(CommonConstants.NINETY_PARENT)
            .alignSelf(ItemAlign.Center)
            .margin({ bottom: $r('app.float.distance_12') })
          }
          // 错误提示
          if (this.errorMsg) {
            Text(this.errorMsg)
              .fontColor($r('app.color.login_red'))
              .fontSize($r('app.float.font_size_14'))
              .alignSelf(ItemAlign.Center)
              .margin({ bottom: $r('app.float.distance_12') });
          }

          // 登录按钮
          Button($r('app.string.login'))
            .width(CommonConstants.NINETY_PARENT)
            .height($r('app.float.distance_40'))
            .fontSize($r('app.float.font_size_16'))
            .backgroundColor($r('app.color.main_green'))
            .onClick(() => {
              this.login(true);
            })
            .margin({bottom: $r('app.float.distance_20')})

          Row() {
            Text($r('app.string.no_account'))
              .fontColor($r('app.color.font_black'))
              .fontSize($r('app.float.font_size_14'));
            Text($r('app.string.register_now'))
              .fontColor($r('app.color.green'))
              .fontSize($r('app.float.font_size_14'))
              .margin({ right: $r('app.float.distance_24') })
              .onClick(() => {
                this.Register(true)
              });
            Blank();
            Text($r('app.string.forget_password_tip'))
              .fontColor($r('app.color.green'))
              .fontSize($r('app.float.font_size_14'))
              .onClick(() => {
                this.ForgetPassword(true)
              });
          }
          .width(CommonConstants.NINETY_PARENT)
          .alignSelf(ItemAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: $r('app.float.distance_16') })
        }
        .backgroundColor($r('app.color.gray'))
        .width(CommonConstants.FULL_PARENT)
        .height(CommonConstants.FULL_PARENT_HALF)
        .layoutWeight(1)
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.DOUBLE_PARENT)
      .backgroundColor(Color.Transparent)
    }
    .backgroundColor($r('app.color.main_green'))
    .width(CommonConstants.FULL_PARENT)
    .height(CommonConstants.FULL_PARENT)
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}