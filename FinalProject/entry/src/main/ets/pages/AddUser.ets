import { UserInfo, UserDataSource } from '../view/UserModel';
import { Prompt } from '@kit.ArkUI';
import { TextInputField, RelationSelectField, GenderField } from './AddUserFormFields';
import { DatePickerModal } from './AddUserDatePickerModal';
import { relationOptions, formatDateFromDate, parseDate, validateForm, withBirthday } from './AddUserLogic';
import CommonConstants from '../common/CommonContants'

@Builder
export function AddUserBuilder() {
  AddUser()
}

@Component
export default struct AddUser {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;
  @State formData: Partial<UserInfo> = {
    gender: '男性'
  };
  @State submitting: boolean = false;
  @State errorMsg: Resource|string = '';
  @State relationIndex: number = -1;
  @State showRelationDropdown: boolean = false;
  @State showGenderDropdown: boolean = false;
  @State showDatePicker: boolean = false;
  @State pendingBirthday: string = '';
  @State datePickerValue: Date = new Date();

  private handleSubmit() {
    if (this.submitting) return;
    const validationMsg = validateForm(this.formData);
    if (validationMsg) {
      // 资源化映射
      this.errorMsg = $r('app.string.' + validationMsg);
      Prompt.showToast({ message: String(this.errorMsg) });
      return;
    }
    this.submitting = true;

    const ds = AppStorage.get('userDataSource') as UserDataSource | undefined;
    // 若未能获取数据源，提示并返回
    if (!ds || typeof ds.insertUser !== 'function') {
      Prompt.showToast({ message: '数据源未就绪，请返回重试' });
      this.submitting = false;
      return;
    }

    const newUser = this.formData as UserInfo;
    ds.insertUser(newUser);
    Prompt.showToast({ message: '添加成功' });
    this.submitting = false;
    this.pathStack.pop();
  }

  build() {
    NavDestination() {
      Column() {
        Text($r('app.string.AddUser'))
          .height($r('app.float.height_text'))
          .width(CommonConstants.FULL_PARENT)
          .fontWeight($r('app.float.font_weight_220'))//字体粗细
          .fontSize($r('app.float.font_size'))//字体大小
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)
      }.margin({bottom: $r('app.float.bottom_150')})
      Stack() {
        Column() {
        // 表单
          Column() {

            TextInputField($r('app.string.user_name'), true, $r('app.string.input_user_name'), (v: string) => { this.formData.name = v; });

            RelationSelectField(
              relationOptions,
              this.relationIndex,
              this.formData.relation ?? '',
              (index: number, text: string) => {
                this.relationIndex = index;
                this.formData.relation = text;
              },
              $r('app.string.select_relation')
            );

            GenderField(this.formData.gender as '男性' | '女性' | undefined, (g: '男性' | '女性') => {
              this.formData.gender = g;
            });


            // 出生日期，点击后展示 DatePicker
            Row() {
              Row() {
                Text($r('app.string.birthday')).fontSize($r('app.float.font_size_16')).fontColor($r('app.color.font_black')).margin({ left: 2 });
                Text('*').fontSize($r('app.float.font_size_16')).fontColor($r('app.color.font_red1')).margin({ left: 4 });
              }
              .margin({ left: $r('app.float.distance_10') })
              .alignItems(VerticalAlign.Center);

              Blank();

              Row() {
                Text(this.formData.birthday ?? $r('app.string.select_date'))
                  .fontColor( $r('app.color.font_black') )
                  .fontSize($r('app.float.font_size_15'))
               Image($r('app.media.arrow_add'))
                 .height($r('app.float.distance_50'))
              }
              .width(CommonConstants.HALF_PARENT)
              .height($r('app.float.height_38'))
              .backgroundColor($r('app.color.white'))
              .borderRadius($r('app.float.distance_6'))
              .padding({ left: $r('app.float.distance_10'), right: $r('app.float.distance_10') })
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                // 点击弹出日期选择器
                const baseDate = parseDate(this.formData.birthday);
                this.pendingBirthday = this.formData.birthday ?? formatDateFromDate(baseDate);
                this.datePickerValue = baseDate;
                this.showDatePicker = true;
              })
            }
            .alignItems(VerticalAlign.Center)
            .backgroundColor(Color.Transparent)
            .margin({ top: $r('app.float.distance_10'), bottom: $r('app.float.distance_18') })
            .width(CommonConstants.FULL_PARENT);

            TextInputField($r('app.string.ID_number'), true, $r('app.string.input_id_number'), (v: string) => { this.formData.idCard = v; });
            TextInputField($r('app.string.address'), false, $r('app.string.input_address'), (v: string) => { this.formData.address = v; });
            TextInputField($r('app.string.job'), false, $r('app.string.input_job'), (v: string) => { this.formData.job = v; });

            // 错误提示信息
            if (this.errorMsg) {
              Text(this.errorMsg)
                .fontSize($r('app.float.font_size_14'))
                .fontColor($r('app.color.login_red'))
                .margin({ top: $r('app.float.distance_8') });
            }
          }
          .width(CommonConstants.NINETY_PARENT)
          .backgroundColor($r('app.color.white'))
          .borderRadius($r('app.float.distance_16'))
          .padding({ top: $r('app.float.distance_10'), bottom: $r('app.float.distance_20') })
          // 提交按钮
        Button(this.submitting ? '提交中...' : '添加')
          .width(CommonConstants.NINETY_PARENT)
          .backgroundColor($r('app.color.main_green'))
          .fontColor($r('app.color.white'))
          .borderRadius(22.5)
          .margin({ top: $r('app.float.distance_20') })
          .onClick(() => this.handleSubmit());
        }
        .width(CommonConstants.FULL_PARENT)
        .height('130%')
        .linearGradient({
          colors: [
            [$r('app.color.green1'),0],
            [$r('app.color.gray7'),0.2],
            [$r('app.color.background_color'),0.3]
          ]
        });

        // 日期选择弹窗
        if (this.showDatePicker) {
          DatePickerModal(
            this.datePickerValue,
            (value: Date, formatted: string) => {
              this.datePickerValue = value;
              this.pendingBirthday = formatted;
            },
            () => {
              this.showDatePicker = false;
            },
            () => {
              // 确认选择日期后赋值
              const formatted = formatDateFromDate(this.datePickerValue);
              this.formData = withBirthday(this.formData, formatted);
              this.showDatePicker = false;
            }
          );
        }
      }
    }.backgroundColor($r('app.color.main_green'))
    .width(CommonConstants.FULL_PARENT)
    .height(CommonConstants.FULL_PARENT)
    .hideTitleBar(true)
  }
}