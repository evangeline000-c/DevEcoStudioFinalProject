//问诊订单详情页面

import { promptAction } from '@kit.ArkUI';

// 处方药品信息接口
interface Medicine {
  index: number;
  name: string;
  type: string;      // 类型
  spec: string;      // 规格
  dosage: number;    // 剂量
  frequency: number; // 频次
  quantity: number;  // 数量
  unitPrice: number; // 单价
  totalPrice: number;// 总价
  usage: string;     // 用法
}

// 处方信息接口
interface PrescriptionInfo {
  chiefComplaint: string; // 主诉
  medicalHistory: string; // 病史
  allergyHistory: string; // 过敏史
  diagnosis: string;      // 诊断
  medicationDays: string; // 用药天数
}

// 收件信息接口
interface DeliveryInfo {
  recipient: string; // 收件人
  phone: string;     // 联系电话
  address: string;   // 地址
  note: string;      // 备注
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
  @State isPaymentView: boolean = false;

  // 模拟处方信息
  @State prescriptionInfo: PrescriptionInfo = {
    chiefComplaint: '发热、胸闷、乏力、咳嗽。',
    medicalHistory: '无',
    allergyHistory: '海鲜过敏',
    diagnosis: '发烧',
    medicationDays: ''
  };

  // 模拟药品列表
  @State medicines: Medicine[] = [
    {
      index: 1,
      name: '999感冒灵',
      type: '中成药',
      spec: '9包',
      dosage: 1,
      frequency: 1,
      quantity: 1,
      unitPrice: 10,
      totalPrice: 10,
      usage: '热水冲服'
    }
  ];

  // 收件信息
  @State deliveryInfo: DeliveryInfo = {
    recipient: '',
    phone: '',
    address: '',
    note: ''
  };

  // 计算总金额
  getTotalAmount(): number {
    let total = 0;
    this.medicines.forEach((medicine: Medicine) => {
      total += medicine.totalPrice;
    });
    return total;
  }

  // 验证手机号码
  validatePhone(phone: string): boolean {
    const phoneReg = /^1[3-9]\d{9}$/;
    return phoneReg.test(phone);
  }

  // 支付
  handlePayment(): void {
    if (!this.deliveryInfo.recipient) {
      promptAction.showToast({ message: '请输入收件人姓名', duration: 2000 });
      return;
    }
    if (!this.deliveryInfo.phone) {
      promptAction.showToast({ message: '请输入联系电话', duration: 2000 });
      return;
    }
    if (!this.validatePhone(this.deliveryInfo.phone)) {
      promptAction.showToast({ message: '请输入正确的11位手机号码', duration: 2000 });
      return;
    }

    promptAction.showToast({ message: '支付成功', duration: 2000 });
    setTimeout(() => {
      this.pathStack.pop();
    }, 1000);
  }

  // 获取状态颜色
  getStatusColor(status: string): string {
    if (status === '已支付') return '#21deb4';
    if (status === '申请退款') return '#FF9800';
    if (status === '未支付') return '#21deb4';
    return '#21deb4';
  }

  // 订单信息卡片
  @Builder
  OrderInfoCard() {
    Column() {
      Row() {
        Text(this.orderData.patientName as string)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Blank()
        Text(this.isPaymentView ? '未支付' : (this.orderData.status as string))
          .fontSize('12fp')
          .fontColor(this.isPaymentView ? '#21deb4' : this.getStatusColor(this.orderData.status as string))
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({
            width: 1,
            color: this.isPaymentView ? '#21deb4' : this.getStatusColor(this.orderData.status as string),
            radius: '4vp'
          })
      }
      .width('100%')
      .margin({ bottom: '12vp' })

      Row() {
        Text('医护名称')
          .fontSize('14fp')
          .fontColor('#999999')
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
          .fontColor('#999999')
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
          .fontColor('#999999')
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
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
  }

  // 处方信息卡片
  @Builder
  PrescriptionCard() {
    Column() {
      // 标题
      Row() {
        Divider()
          .vertical(true)
          .strokeWidth(3)
          .height('16vp')
          .color('#21deb4')
          .margin({ right: '8vp' })
        Text('处方信息')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '16vp' })

      // 主诉
      Row() {
        Text('主诉')
          .fontSize('14fp')
          .fontColor('#999999')
          .width('60vp')
        Text(this.prescriptionInfo.chiefComplaint)
          .fontSize('14fp')
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 病史
      Row() {
        Text('病史')
          .fontSize('14fp')
          .fontColor('#999999')
          .width('60vp')
        Text(this.prescriptionInfo.medicalHistory)
          .fontSize('14fp')
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 过敏史
      Row() {
        Text('过敏史')
          .fontSize('14fp')
          .fontColor('#999999')
          .width('60vp')
        Text(this.prescriptionInfo.allergyHistory)
          .fontSize('14fp')
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 诊断
      Row() {
        Text('诊断')
          .fontSize('14fp')
          .fontColor('#999999')
          .width('60vp')
        Text(this.prescriptionInfo.diagnosis)
          .fontSize('14fp')
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      // 用药天数
      Row() {
        Text('用药天数')
          .fontSize('14fp')
          .fontColor('#999999')
          .width('80vp')
        Text(this.prescriptionInfo.medicationDays || '-')
          .fontSize('14fp')
          .fontColor('#333333')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
    .margin({ top: '12vp' })
  }

  // 处方药信息卡片
  @Builder
  MedicineCard() {
    Column() {
      // 标题
      Row() {
        Divider()
          .vertical(true)
          .strokeWidth(3)
          .height('16vp')
          .color('#21deb4')
          .margin({ right: '8vp' })
        Text('处方药信息')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '16vp' })

      ForEach(this.medicines, (medicine: Medicine) => {
        Column() {
          // 药品名称
          Row() {
            Text(`# ${medicine.index}.`)
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(medicine.name)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 类型
          Row() {
            Text('类型')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(medicine.type)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 规格
          Row() {
            Text('规格')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(medicine.spec)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 剂量
          Row() {
            Text('剂量')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(`${medicine.dosage}`)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 频次
          Row() {
            Text('频次')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(`${medicine.frequency}`)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 数量
          Row() {
            Text('数量')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(`${medicine.quantity}`)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 单价
          Row() {
            Text('单价')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(`${medicine.unitPrice}`)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 总价
          Row() {
            Text('总价')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(`${medicine.totalPrice}`)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })

          // 用法
          Row() {
            Text('用法')
              .fontSize('14fp')
              .fontColor('#999999')
            Blank()
            Text(medicine.usage)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
        }
      })
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
    .margin({ top: '12vp' })
  }

  // 收件信息卡片
  @Builder
  DeliveryCard() {
    Column() {
      // 标题
      Row() {
        Divider()
          .vertical(true)
          .strokeWidth(3)
          .height('16vp')
          .color('#21deb4')
          .margin({ right: '8vp' })
        Text('收件信息')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '16vp' })

      // 收件人
      Row() {
        Row() {
          Text('收件人')
            .fontSize('14fp')
            .fontColor('#333333')
          Text('*')
            .fontSize('14fp')
            .fontColor('#FF0000')
        }
        .width('80vp')

        TextInput({ placeholder: '请输入收件人名称' })
          .layoutWeight(1)
          .fontSize('14fp')
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .onChange((value: string) => {
            this.deliveryInfo.recipient = value;
          })
      }
      .width('100%')
      .margin({ bottom: '16vp' })

      // 手机号码
      Row() {
        Row() {
          Text('手机号码')
            .fontSize('14fp')
            .fontColor('#333333')
          Text('*')
            .fontSize('14fp')
            .fontColor('#FF0000')
        }
        .width('80vp')

        TextInput({ placeholder: '请输入联系人手机号码' })
          .layoutWeight(1)
          .fontSize('14fp')
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .type(InputType.Number)
          .maxLength(11)
          .onChange((value: string) => {
            this.deliveryInfo.phone = value;
          })
      }
      .width('100%')
      .margin({ bottom: '16vp' })

      // 地址
      Row() {
        Text('地址')
          .fontSize('14fp')
          .fontColor('#333333')
          .width('80vp')
        TextInput({ placeholder: '请输入地址' })
          .layoutWeight(1)
          .fontSize('14fp')
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .onChange((value: string) => {
            this.deliveryInfo.address = value;
          })
      }
      .width('100%')
      .margin({ bottom: '16vp' })

      // 备注
      Row() {
        Text('备注')
          .fontSize('14fp')
          .fontColor('#333333')
          .width('80vp')
        TextInput({ placeholder: '请输入备注' })
          .layoutWeight(1)
          .fontSize('14fp')
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .onChange((value: string) => {
            this.deliveryInfo.note = value;
          })
      }
      .width('100%')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
    .margin({ top: '12vp' })
  }

  build() {
    NavDestination() {
      Column() {
        // 标题栏
        Row() {
          Image($r('app.media.ic_back'))
            .width('24vp')
            .height('24vp')
            .margin({ left: '16vp' })
            .onClick(() => {
              if (this.isPaymentView) {
                this.isPaymentView = false;
              } else {
                this.pathStack.pop();
              }
            })
          Text(this.isPaymentView ? '问诊订单支付' : '问诊订单信息')
            .fontSize('18fp')
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
          Blank().width('40vp')
        }
        .width('100%')
        .height('50vp')
        .backgroundColor('#21deb4')

        // 内容区域
        Scroll() {
          Column() {
            this.OrderInfoCard()

            if (this.isPaymentView) {
              this.DeliveryCard()
            } else {
              this.PrescriptionCard()
              this.MedicineCard()
            }
          }
          .width('100%')
          .padding({ left: '12vp', right: '12vp', top: '12vp', bottom: '80vp' })
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .width('100%')
        .align(Alignment.Top)

        // 底部按钮
        if (this.orderData.status !== '已支付') {
          Column() {
            Button(this.isPaymentView ? '支付' : '去支付')
              .width('90%')
              .height('50vp')
              .fontSize('16fp')
              .fontColor(Color.White)
              .backgroundColor('#21deb4')
              .borderRadius('25vp')
              .onClick(() => {
                if (this.isPaymentView) {
                  this.handlePayment();
                } else {
                  this.isPaymentView = true;
                }
              })
          }
          .width('100%')
          .padding({ top: '12vp', bottom: '12vp' })
          .backgroundColor(Color.White)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor('#d821deb4')
  }
}
