import { Prompt } from '@kit.ArkUI';
import { updatePasswordByPhone, setCurrentUser } from '../view/UserStore';
import { CaptchaState, requestCaptchaCore } from '../common/captcha';
import { validateReset } from '../common/authLogin';
import { ResetFormState, newResetFormState, newCaptchaState } from '../common/authState';
import { InputRow } from '../common/InputRow';

@Builder
export function ForgetPasswordBuilder() {
  ForgetPassword()
}

@Entry
@Component
export default struct ForgetPassword {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;
  @State form: ResetFormState = newResetFormState();
  @State captchaState: CaptchaState = newCaptchaState();
  @State errorMsg: string = '';

  private requestCaptcha(): void {
    this.errorMsg = '';
    const next = requestCaptchaCore(this.captchaState, 10);
    this.captchaState = { code: next.code, expireAt: next.expireAt, dailyCount: next.dailyCount, countDateKey: next.countDateKey };
  }

  private validate(): boolean {
    const err = validateReset(
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
    const updated = updatePasswordByPhone(this.form.phone.trim(), this.form.password.trim());
    if (updated) {
      setCurrentUser(updated);
      Prompt.showToast({ message: '密码已重置，请用新密码登录' });
      // 返回到应用入口（登录页作为入口时用 clear 更稳妥）
      this.pathStack.clear();
    } else {
      this.errorMsg = '未找到该手机号对应的账号';
    }
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

          Text('忘记密码')
            .fontWeight(220)
            .fontSize('20fp')
            .fontColor('#FFFFFF')
            .margin({ left: '110vp' })
            .textAlign(TextAlign.Center)
        }
        .height('60vp')
        .width('100%')

        Column() {
          Text('忘记密码')
            .fontColor('#1F2328')
            .fontSize('24fp')
            .fontWeight(FontWeight.Bold)
            .margin({ top: '80vp', bottom: '40vp'})
            .textAlign(TextAlign.Start)
            .width('90%');

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
            }).layoutWeight(1)

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

          Button('确定')
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
