import { UserInfo, UserDataSource } from '../view/UserModel';
import { Prompt } from '@kit.ArkUI';
import { TextInputField, RelationSelectField, GenderField } from './AddUserFormFields';
import { DatePickerModal } from './AddUserDatePickerModal';
import { relationOptions, formatDateFromDate, parseDate, validateForm, withBirthday } from './AddUserLogic';

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
  @State errorMsg: string = '';
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
      this.errorMsg = validationMsg;
      Prompt.showToast({ message: this.errorMsg });
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
        Text('添加康养用户')
          .height('60vp')
          .width('100%')
          .fontWeight(220)//字体粗细
          .fontSize('20fp')//字体大小
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)
      }.margin({bottom: '150vp'})
      Stack() {
        Column() {
        // 表单
          Column() {
            TextInputField('用户名称', true, '请输入用户名称', (v: string) => { this.formData.name = v; });

            RelationSelectField(
              relationOptions,
              this.relationIndex,
              this.formData.relation ?? '',
              (index: number, text: string) => {
                this.relationIndex = index;
                this.formData.relation = text;
              },
              '请选择关系'
            );

            GenderField(this.formData.gender as '男性' | '女性' | undefined, (g: '男性' | '女性') => {
              this.formData.gender = g;
            });

            // 出生日期，点击后展示 DatePicker
            Row() {
              Row() {
                Text('出生日期').fontSize(16).fontColor('#1F2328').margin({ left: 2 });
                Text('*').fontSize(16).fontColor('#FF5252').margin({ left: 4 });
              }
              .margin({ left: 10 })
              .alignItems(VerticalAlign.Center);

              Blank();

              Row() {
                Text(this.formData.birthday ?? '请选择日期')
                  .fontColor( '#1F2328' )
                  .fontSize(15)
               Image($r('app.media.arrow_add'))
                 .height(50)
              }
              .width('50%')
              .height('38vp')
              .backgroundColor('#FFFFFF')
              .borderRadius(6)
              .padding({ left: 10, right: 10 })
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
            .margin({ top: 10, bottom: 18 })
            .width('100%');

            TextInputField('身份证号', true, '请输入身份证号', (v: string) => { this.formData.idCard = v; });
            TextInputField('地址', false, '请输入地址', (v: string) => { this.formData.address = v; });
            TextInputField('职业', false, '请输入职业', (v: string) => { this.formData.job = v; });

            // 错误提示信息
            if (this.errorMsg) {
              Text(this.errorMsg)
                .fontSize(14)
                .fontColor('#D92D20')
                .margin({ top: 8 });
            }
          }
          .width('90%')
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .padding({ top: 10, bottom: 20 })
          // 提交按钮
        Button(this.submitting ? '提交中...' : '添加')
          .width('90%')
          .backgroundColor('#d821deb4')
          .fontColor('#FFFFFF')
          .borderRadius(22.5)
          .margin({ top: 20 })
          .onClick(() => this.handleSubmit());
        }
        .width('100%')
        .height('130%')
        .linearGradient({
          colors: [
            ['#21deb4',0],
            ['#1121deb4',0.2],
            ['#F1F3F5',0.3]
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
    }.backgroundColor('#d821deb4')
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}