import { Prompt } from '@kit.ArkUI';
import { updatePasswordByPhone, setCurrentUser } from '../view/UserStore';
import { CaptchaState, requestCaptchaCore } from '../viewmodel/captcha';
import { validateReset } from '../viewmodel/authLogin';
import { ResetFormState, newResetFormState, newCaptchaState } from '../viewmodel/authState';
import { InputRow } from '../viewmodel/InputRow';
import CommonConstants from '../common/CommonContants'

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
  @State errorMsg: Resource|string = '';

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
      Prompt.showToast({ message: String($r('app.string.password_reset_success')) });
      // 返回到应用入口（登录页作为入口时用 clear 更稳妥）
      this.pathStack.clear();
    } else {
      this.errorMsg = $r('app.string.phone_not_found');
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button() {
            Image($r('app.media.arrow_login'))
              .width($r('app.float.distance_30'))
              .height($r('app.float.distance_30'))
          }.backgroundColor(Color.Transparent)
          .margin({ left: $r('app.float.distance_5') })
          .onClick(() => {
            this.pathStack.clear()
          })

          Text($r('app.string.forget_password'))
            .fontWeight($r('app.float.font_weight_220'))
            .fontSize($r('app.float.font_size'))
            .fontColor($r('app.color.white'))
            .margin({ left: $r('app.float.distance_110') })
            .textAlign(TextAlign.Center)
        }
        .height($r('app.float.height_text'))
        .width(CommonConstants.FULL_PARENT)

        Column() {
          Text($r('app.string.forget_password'))
            .fontColor($r('app.color.font_black'))
            .fontSize($r('app.float.font_size_24'))
            .fontWeight(FontWeight.Bold)
            .margin({ top: $r('app.float.distance_80'), bottom: $r('app.float.distance_40')})
            .textAlign(TextAlign.Start)
            .width(CommonConstants.NINETY_PARENT);

          InputRow({
            placeholder: $r('app.string.input_phone'),
            icon: $r('app.media.human'),
            inputType: InputType.Number,
            onChange: (v: string) => {
              this.form.phone = v
            }
          })
            .margin({ bottom: $r('app.float.distance_12') })

          Row() {
            InputRow({
              placeholder: $r('app.string.input_captcha'),
              icon: $r('app.media.phone'),
              inputType: InputType.Number,
              onChange: (v: string) => {
                this.form.code = v
              }
            }).layoutWeight(1)

            Text($r('app.string.get_captcha'))
              .fontColor($r('app.color.green'))
              .fontSize($r('app.float.font_size_15'))
              .onClick(() => this.requestCaptcha())
              .margin({ left: $r('app.float.distance_12') });
          }.width(CommonConstants.NINETY_PARENT).alignSelf(ItemAlign.Center).margin({ bottom: $r('app.float.distance_12')})

          InputRow({
            placeholder: $r('app.string.input_password'),
            icon: $r('app.media.lock'),
            inputType: InputType.Password,
            onChange: (v: string) => {
              this.form.password = v
            }
          })
            .margin({ bottom: $r('app.float.distance_12') })

          InputRow({
            placeholder: $r('app.string.input_confirm_password'),
            icon: $r('app.media.lock'),
            inputType: InputType.Password,
            onChange: (v: string) => {
              this.form.confirmPwd = v
            }
          })
            .margin({ bottom: $r('app.float.distance_20') })

          if (this.errorMsg) {
            Text(String(this.errorMsg))
              .fontColor($r('app.color.login_red'))
              .fontSize($r('app.float.font_size_14'))
              .alignSelf(ItemAlign.Center)
              .margin({ bottom: $r('app.float.distance_12') });
          }

          Button($r('app.string.confirm'))
            .width(CommonConstants.NINETY_PARENT)
            .height($r('app.float.distance_40'))
            .fontSize($r('app.float.font_size_16'))
            .backgroundColor($r('app.color.green'))
            .onClick(() => {
              this.submit()
            })
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
  }
}
