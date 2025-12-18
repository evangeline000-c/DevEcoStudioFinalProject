import { Prompt } from '@kit.ArkUI';
import { AuthUser, upsertUser, setCurrentUser } from '../view/UserStore';
import { CaptchaState, requestCaptchaCore } from '../common/captcha';
import { validateRegister } from '../common/authLogin';
import { RegisterFormState, newRegisterFormState, newCaptchaState } from '../common/authState';
import { InputRow } from '../common/InputRow';

@Builder
export function RegisterBuilder() {
  Register()
}

@Entry
@Component
struct Register {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;
  @State form: RegisterFormState = newRegisterFormState();
  @State captchaState: CaptchaState = newCaptchaState();
  @State errorMsg: string = '';

  private requestCaptcha(): void {
    this.errorMsg = '';
    const next = requestCaptchaCore(this.captchaState, 10);
    this.captchaState = { code: next.code, expireAt: next.expireAt, dailyCount: next.dailyCount, countDateKey: next.countDateKey };
  }

  private validate(): boolean {
    const err = validateRegister(
      this.form.account,
      this.form.phone,
      this.form.code,
      this.form.password,
      this.form.confirmPwd,
      this.captchaState
    );
    if (err) { this.errorMsg = err; return false; }
    this.errorMsg = ''; return true;
  }

  private submit(): void {
    if (!this.validate()) { return; }
    const user: AuthUser = { account: this.form.account.trim(), phone: this.form.phone.trim(), password: this.form.password.trim() };
    upsertUser(user);
    setCurrentUser(user);
    Prompt.showToast({ message: '注册成功，请使用账号或手机号登录' });
    this.pathStack.clear();
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button() {
            Image($r('app.media.arrow_login'))
              .width(30)
              .height(30)
          }.backgroundColor(Color.Transparent)
          .margin({ left: '5vp' })
          .onClick(() => {
            this.pathStack.clear()
          })

          Text('注册')
            .fontWeight(220)//字体粗细
            .fontSize('20fp')//字体大小
            .fontColor('#FFFFFF')
            .margin({ left: '130vp' })
            .textAlign(TextAlign.Center)
        }
        .height('60vp')
        .width('100%')

        Column() {
          Text('用户注册')
            .fontColor('#1F2328')
            .fontSize('24fp')
            .fontWeight(FontWeight.Bold)
            .margin({ top: '80vp', bottom: '40vp'})
            .textAlign(TextAlign.Start)
            .width('90%');

          InputRow({
            placeholder: '请输入账号',
            icon: $r('app.media.human'),
            onChange: (v: string) => {
              this.form.account = v
            }
          })
            .margin({ bottom: '12vp' })

          InputRow({
            placeholder: '请输入手机号',
            icon: $r('app.media.human'),
            inputType: InputType.Number,
            onChange: (v: string) => {
              this.form.phone = v
            }
          })
            .margin({ bottom: '12vp' })

          Row() {
            InputRow({
              placeholder: '请输入验证码',
              icon: $r('app.media.phone'),
              inputType: InputType.Number,
              onChange: (v: string) => {
                this.form.code = v
              }
            })
              .layoutWeight(1)

            Text('获取验证码')
              .fontColor('#00C8A2')
              .fontSize('15fp')
              .onClick(() => this.requestCaptcha())
              .margin({ left: '12vp' });
          }.width('90%').alignSelf(ItemAlign.Center).margin({ bottom: '12vp' })

          InputRow({
            placeholder: '请输入密码',
            icon: $r('app.media.lock'),
            inputType: InputType.Password,
            onChange: (v: string) => {
              this.form.password = v
            }
          })
            .margin({ bottom: '12vp' })

          InputRow({
            placeholder: '请再次确认密码',
            icon: $r('app.media.lock'),
            inputType: InputType.Password,
            onChange: (v: string) => {
              this.form.confirmPwd = v
            }
          })
            .margin({ bottom: '20vp' })

          if (this.errorMsg) {
            Text(this.errorMsg)
              .fontColor('#D92D20')
              .fontSize('14fp')
              .alignSelf(ItemAlign.Center)
              .margin({ bottom: '12vp' });
          }

          Button('注册')
            .width('90%')
            .height('40vp')
            .fontSize('16fp')
            .backgroundColor('#00C8A2')
            .onClick(() => {
              this.submit()
            })
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
  }
}