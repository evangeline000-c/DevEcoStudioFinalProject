//问诊订单详情页面
import CommonConstants from '../common/CommonContants'
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
      promptAction.showToast({ message: $r('app.string.input_recipient'), duration: 2000 });
      return;
    }
    if (!this.deliveryInfo.phone) {
      promptAction.showToast({ message: $r('app.string.input_contact_phone'), duration: 2000 });
      return;
    }
    if (!this.validatePhone(this.deliveryInfo.phone)) {
      promptAction.showToast({ message: $r('app.string.input_valid_phone'), duration: 2000 });
      return;
    }

    promptAction.showToast({ message: $r('app.string.pay_success'), duration: 2000 });
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
          .fontSize($r('app.float.font_size_16'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color1'))
        Blank()
        Text(this.isPaymentView ? $r('app.string.unpaid') : (this.orderData.status as string))
          .fontSize($r('app.float.font_size_12'))
          .fontColor(this.isPaymentView ? $r('app.color.green1') : this.getStatusColor(this.orderData.status as string))
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.layout_4'), bottom: $r('app.float.bottom_4')})
          .border({
            width: 1,
            color: this.isPaymentView ? $r('app.color.green1') : this.getStatusColor(this.orderData.status as string),
            radius: $r('app.float.layout_4')
          })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_12') })

      Row() {
        Text($r('app.string.doctor_name'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(this.orderData.doctorName as string)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      Row() {
        Text($r('app.string.consultation_time'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(this.orderData.consultationTime as string)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      Row() {
        Text($r('app.string.amount'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
        Blank()
        Text(`¥ ${this.orderData.amount}`)
          .fontSize($r('app.float.font_size_16'))
          .fontColor($r('app.color.font_red2'))
          .fontWeight(FontWeight.Bold)
      }
      .width(CommonConstants.FULL_PARENT)
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
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
          .height($r('app.float.distance_16'))
          .color($r('app.color.green1'))
          .margin({ right: $r('app.float.distance_8') })
        Text($r('app.string.prescription_info'))
          .fontSize($r('app.float.font_size_16'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_16') })

      // 主诉
      Row() {
        Text($r('app.string.chief_complaint'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
          .width($r('app.float.width_60'))
        Text(this.prescriptionInfo.chiefComplaint)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 病史
      Row() {
        Text($r('app.string.medical_history'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
          .width($r('app.float.width_60'))
        Text(this.prescriptionInfo.medicalHistory)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 过敏史
      Row() {
        Text($r('app.string.allergy_history'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
          .width($r('app.float.width_60'))
        Text(this.prescriptionInfo.allergyHistory)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 诊断
      Row() {
        Text($r('app.string.diagnosis'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
          .width($r('app.float.width_60'))
        Text(this.prescriptionInfo.diagnosis)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_8') })

      // 用药天数
      Row() {
        Text($r('app.string.medication_days'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color'))
          .width($r('app.float.distance_80'))
        Text(this.prescriptionInfo.medicationDays || '-')
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width(CommonConstants.FULL_PARENT)
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
    .margin({ top: $r('app.float.distance_12') })
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
          .height($r('app.float.distance_16'))
          .color($r('app.color.green1'))
          .margin({ right: $r('app.float.distance_8') })
        Text($r('app.string.medicine_info'))
          .fontSize($r('app.float.font_size_16'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_16') })

      ForEach(this.medicines, (medicine: Medicine) => {
        Column() {
          // 药品名称
          Row() {
            Text(`# ${medicine.index}.`)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(medicine.name)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 类型
          Row() {
            Text($r('app.string.medicine_type'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(medicine.type)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 规格
          Row() {
            Text($r('app.string.medicine_spec'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(medicine.spec)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 剂量
          Row() {
            Text($r('app.string.medicine_dosage'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(`${medicine.dosage}`)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 频次
          Row() {
            Text($r('app.string.medicine_frequency'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(`${medicine.frequency}`)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 数量
          Row() {
            Text($r('app.string.medicine_quantity'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(`${medicine.quantity}`)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 单价
          Row() {
            Text($r('app.string.medicine_unit_price'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(`${medicine.unitPrice}`)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 总价
          Row() {
            Text($r('app.string.medicine_total_price'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(`${medicine.totalPrice}`)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
          .margin({ bottom: $r('app.float.distance_8') })

          // 用法
          Row() {
            Text($r('app.string.medicine_usage'))
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color'))
            Blank()
            Text(medicine.usage)
              .fontSize($r('app.float.font_size_14'))
              .fontColor($r('app.color.font_color1'))
          }
          .width(CommonConstants.FULL_PARENT)
        }
      })
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
    .margin({ top: $r('app.float.distance_12') })
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
          .height($r('app.float.distance_16'))
          .color($r('app.color.green1'))
          .margin({ right: $r('app.float.distance_8') })
        Text($r('app.string.delivery_info'))
          .fontSize($r('app.float.font_size_16'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color1'))
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_16') })

      // 收件人
      Row() {
        Row() {
          Text($r('app.string.recipient'))
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.font_color1'))
          Text('*')
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.red'))
        }
        .width($r('app.float.distance_80'))

        TextInput({ placeholder: $r('app.string.input_recipient') })
          .layoutWeight(1)
          .fontSize($r('app.float.font_size_14'))
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .onChange((value: string) => {
            this.deliveryInfo.recipient = value;
          })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_16') })

      // 手机号码
      Row() {
        Row() {
          Text($r('app.string.phone'))
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.font_color1'))
          Text('*')
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.red'))
        }
        .width($r('app.float.distance_80'))

        TextInput({ placeholder: $r('app.string.input_contact_phone') })
          .layoutWeight(1)
          .fontSize($r('app.float.font_size_14'))
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .type(InputType.Number)
          .maxLength(11)
          .onChange((value: string) => {
            this.deliveryInfo.phone = value;
          })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_16') })

      // 地址
      Row() {
        Text($r('app.string.address'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .width($r('app.float.distance_80'))
        TextInput({ placeholder: $r('app.string.input_address') })
          .layoutWeight(1)
          .fontSize($r('app.float.font_size_14'))
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .onChange((value: string) => {
            this.deliveryInfo.address = value;
          })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_16') })

      // 备注
      Row() {
        Text($r('app.string.remarks'))
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .width($r('app.float.distance_80'))
        TextInput({ placeholder: $r('app.string.input_remarks') })
          .layoutWeight(1)
          .fontSize($r('app.float.font_size_14'))
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.End)
          .onChange((value: string) => {
            this.deliveryInfo.note = value;
          })
      }
      .width(CommonConstants.FULL_PARENT)
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
    .margin({ top: $r('app.float.distance_12') })
  }

  build() {
    NavDestination() {
      Column() {
        // 标题栏
        Row() {
          Image($r('app.media.ic_back'))
            .width($r('app.float.distance_24'))
            .height($r('app.float.distance_24'))
            .margin({ left: $r('app.float.distance_16') })
            .onClick(() => {
              if (this.isPaymentView) {
                this.isPaymentView = false;
              } else {
                this.pathStack.pop();
              }
            })
          Text(this.isPaymentView ? $r('app.string.consultation_pay_title') : $r('app.string.consultation_detail_title'))
            .fontSize($r('app.float.font_size_18'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
          Blank().width($r('app.float.distance_40'))
        }
        .width(CommonConstants.FULL_PARENT)
        .height($r('app.float.distance_50'))
        .backgroundColor($r('app.color.green1'))

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
          .width(CommonConstants.FULL_PARENT)
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.distance_12'), bottom: $r('app.float.distance_80') })
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .width(CommonConstants.FULL_PARENT)
        .align(Alignment.Top)

        // 底部按钮
        if (this.orderData.status !== '已支付') {
          Column() {
            Button(this.isPaymentView ? $r('app.string.pay') : $r('app.string.go_pay'))
              .width(CommonConstants.NINETY_PARENT)
              .height($r('app.float.distance_50'))
              .fontSize($r('app.float.font_size_16'))
              .fontColor(Color.White)
              .backgroundColor($r('app.color.green1'))
              .borderRadius($r('app.float.layout_25'))
              .onClick(() => {
                if (this.isPaymentView) {
                  this.handlePayment();
                } else {
                  this.isPaymentView = true;
                }
              })
          }
          .width(CommonConstants.FULL_PARENT)
          .padding({ top: $r('app.float.distance_12'), bottom: $r('app.float.distance_12')})
          .backgroundColor(Color.White)
        }
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .backgroundColor($r('app.color.gray5'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_green'))
  }
}
