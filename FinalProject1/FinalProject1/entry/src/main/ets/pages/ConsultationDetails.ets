//问诊详情页面

import { promptAction } from '@kit.ArkUI';

// 处方药品信息接口
interface Medicine {
  name: string;
  usage: string;
  price: number;
}

// 处方信息接口
interface PrescriptionInfo {
  chiefComplaint: string; // 主诉
  medicalHistory: string; // 病史
  diagnosis: string; // 诊断
  advice: string; // 医嘱
  medicines: Medicine[]; // 药品列表
}

// 收件信息接口
interface DeliveryInfo {
  recipient: string; // 收件人
  phone: string; // 联系电话
  address: string; // 地址
  note: string; // 备注
}

//ConsultationDetail()的入口函数
@Builder
export function ConsultationDetailBuilder() {
  ConsultationDetail()
}

@Component
struct ConsultationDetail {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;
  @State orderData: ESObject = this.pathStack.getParamByName('ConsultationDetail')[0] as ESObject;

  @State currentView: string = '处方信息'; // '处方信息' 或 '收件信息'

  // 模拟处方信息
  @State prescriptionInfo: PrescriptionInfo = {
    chiefComplaint: '发热、咳嗽、乏力、咽痛、胸闷、血便等',
    medicalHistory: '无',
    diagnosis: '慢性支气管炎',
    advice: '适当',
    medicines: [
      { name: '出塞曲', usage: '', price: 12 },
      { name: '扶桑曲', usage: '', price: 12 },
      { name: '含服液', usage: '', price: 12 }
    ]
  };

  // 收件信息
  @State deliveryInfo: DeliveryInfo = {
    recipient: '',
    phone: '',
    address: '',
    note: ''
  };

  // 订单信息卡片
  @Builder
  OrderInfoCard() {
    Column() {
      Row() {
        Text(this.orderData.patientName as string)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(this.orderData.status as string)
          .fontSize('14fp')
          .fontColor(this.orderData.status === '已支付' ? '#4CAF50' : '#FF9800')
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({ width: 1, color: this.orderData.status === '已支付' ? '#4CAF50' : '#FF9800', radius: 4 })
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('医护名称')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.doctorName as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('问诊时间')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.consultationTime as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('金额')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(`¥ ${this.orderData.amount}`)
          .fontSize('16fp')
          .fontColor('#FF6B00')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
  }

  // 处方信息视图
  @Builder
  PrescriptionView() {
    Column() {
      // 处方信息
      Column() {
        Text('处方信息')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '12vp' })

        this.InfoRow('主诉', this.prescriptionInfo.chiefComplaint)
        this.InfoRow('病史', this.prescriptionInfo.medicalHistory)
        this.InfoRow('诊断', this.prescriptionInfo.diagnosis)
        this.InfoRow('医嘱', this.prescriptionInfo.advice)
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
      .margin({ bottom: '12vp' })

      // 处方药信息
      Column() {
        Text('处方药信息')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '12vp' })

        ForEach(this.prescriptionInfo.medicines, (medicine: Medicine, index: number) => {
          Column() {
            Row() {
              Text(`# ${index + 1}`)
                .fontSize('14fp')
                .fontColor('#666666')
              Blank()
              Text(medicine.name)
                .fontSize('14fp')
                .fontColor('#333333')
            }
            .width('100%')
            .margin({ bottom: '8vp' })

            Row() {
              Text('用法')
                .fontSize('14fp')
                .fontColor('#666666')
              Blank()
              Text(medicine.usage || '按医嘱')
                .fontSize('14fp')
                .fontColor('#333333')
            }
            .width('100%')
            .margin({ bottom: '8vp' })

            Row() {
              Text('剂量')
                .fontSize('14fp')
                .fontColor('#666666')
              Blank()
              Text('1')
                .fontSize('14fp')
                .fontColor('#333333')
            }
            .width('100%')
            .margin({ bottom: '8vp' })

            Row() {
              Text('频次')
                .fontSize('14fp')
                .fontColor('#666666')
              Blank()
              Text('1')
                .fontSize('14fp')
                .fontColor('#333333')
            }
            .width('100%')
            .margin({ bottom: '8vp' })

            Row() {
              Text('单价')
                .fontSize('14fp')
                .fontColor('#666666')
              Blank()
              Text('10')
                .fontSize('14fp')
                .fontColor('#333333')
            }
            .width('100%')
            .margin({ bottom: '8vp' })

            Row() {
              Text('用法')
                .fontSize('14fp')
                .fontColor('#666666')
              Blank()
              Text('热水冲服')
                .fontSize('14fp')
                .fontColor('#333333')
            }
            .width('100%')

            if (index < this.prescriptionInfo.medicines.length - 1) {
              Divider()
                .margin({ top: '12vp', bottom: '12vp' })
            }
          }
        })

        Divider()
          .margin({ top: '12vp', bottom: '12vp' })

        Row() {
          Text('合金额')
            .fontSize('14fp')
            .fontColor('#666666')
          Blank()
          Text(`¥ ${this.orderData.amount}`)
            .fontSize('16fp')
            .fontColor('#FF6B00')
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
    }
    .width('100%')
  }

  // 收件信息视图
  @Builder
  DeliveryView() {
    Column() {
      Column() {
        Text('收件信息')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '12vp' })

        // 收件人
        Row() {
          Text('收件人')
            .fontSize('14fp')
            .fontColor('#333333')
            .width('80vp')
          TextInput({ placeholder: '请输入收件人姓名' })
            .layoutWeight(1)
            .fontSize('14fp')
            .onChange((value: string) => {
              this.deliveryInfo.recipient = value;
            })
        }
        .width('100%')
        .margin({ bottom: '12vp' })
        .alignItems(VerticalAlign.Center)

        // 手机号码
        Row() {
          Text('手机号码')
            .fontSize('14fp')
            .fontColor('#333333')
            .width('80vp')
          TextInput({ placeholder: '请输入11位手机号码' })
            .layoutWeight(1)
            .fontSize('14fp')
            .type(InputType.Number)
            .maxLength(11)
            .onChange((value: string) => {
              this.deliveryInfo.phone = value;
            })
        }
        .width('100%')
        .margin({ bottom: '12vp' })
        .alignItems(VerticalAlign.Center)

        // 地址
        Row() {
          Text('地址')
            .fontSize('14fp')
            .fontColor('#333333')
            .width('80vp')
          TextInput({ placeholder: '请输入地址' })
            .layoutWeight(1)
            .fontSize('14fp')
            .onChange((value: string) => {
              this.deliveryInfo.address = value;
            })
        }
        .width('100%')
        .margin({ bottom: '12vp' })
        .alignItems(VerticalAlign.Center)

        // 备注
        Row() {
          Text('备注')
            .fontSize('14fp')
            .fontColor('#333333')
            .width('80vp')
          TextInput({ placeholder: '请输入备注' })
            .layoutWeight(1)
            .fontSize('14fp')
            .onChange((value: string) => {
              this.deliveryInfo.note = value;
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
    }
    .width('100%')
  }

  // 信息行组件
  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize('14fp')
        .fontColor('#666666')
      Blank()
      Text(value)
        .fontSize('14fp')
        .fontColor('#333333')
        .textAlign(TextAlign.End)
        .layoutWeight(1)
        .margin({ left: '12vp' })
    }
    .width('100%')
    .margin({ bottom: '8vp' })
    .alignItems(VerticalAlign.Top)
  }

  build() {
    NavDestination() {
      Column() {
        // 标题栏
        Text('问诊详情')
          .width('100%')
          .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
          .fontWeight(700)
          .fontSize('20fp')
          .backgroundColor('#00CDA5')
          .fontColor(Color.White)

        // 内容区域
        Scroll() {
          Column() {
            // 订单信息卡片
            this.OrderInfoCard()

            // 视图切换按钮
            Row() {
              Button(this.currentView === '处方信息' ? '处方信息' : '收件信息')
                .fontSize('14fp')
                .backgroundColor(this.currentView === '处方信息' ? '#00CDA5' : '#EEEEEE')
                .fontColor(this.currentView === '处方信息' ? Color.White : '#666666')
                .layoutWeight(1)
                .onClick(() => {
                  this.currentView = '处方信息';
                })

              Button(this.currentView === '收件信息' ? '收件信息' : '处方信息')
                .fontSize('14fp')
                .backgroundColor(this.currentView === '收件信息' ? '#00CDA5' : '#EEEEEE')
                .fontColor(this.currentView === '收件信息' ? Color.White : '#666666')
                .layoutWeight(1)
                .onClick(() => {
                  this.currentView = '收件信息';
                })
            }
            .width('100%')
            .margin({ top: '12vp', bottom: '12vp' })

            // 内容区域
            if (this.currentView === '处方信息') {
              this.PrescriptionView()
            } else {
              this.DeliveryView()
            }
          }
          .width('100%')
          .padding({ left: '12vp', right: '12vp', top: '12vp', bottom: '12vp' })
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .width('100%')
        .align(Alignment.Top)

        // 支付按钮（仅在收件信息视图显示）
        if (this.currentView === '收件信息' && this.orderData.status !== '已支付') {
          Button('支付')
            .width('90%')
            .height('44vp')
            .fontSize('16fp')
            .backgroundColor('#00CDA5')
            .fontColor(Color.White)
            .margin({ top: '12vp', bottom: '12vp' })
            .onClick(() => {
              // 支付逻辑
              promptAction.showToast({
                message: '支付成功',
                duration: 2000
              });
              // 延迟返回，让用户看到提示
              setTimeout(() => {
                this.pathStack.pop();
              }, 1000);
            })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .hideTitleBar(true)
  }
}
