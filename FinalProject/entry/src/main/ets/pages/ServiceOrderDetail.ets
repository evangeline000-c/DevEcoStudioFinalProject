//服务订单详情页面
import { getCaregiverById, CaregiverInfo } from '../viewmodel/CaregiverData';
import CommonConstants from '../common/CommonContants'
// 费用信息接口
interface FeeInfo {
  consultationFee: number;  // 出诊费
  techFee: number;          // 技术费
  materialFee: number;      // 耗材费
  totalAmount: number;      // 总金额
}



// 评估问题接口
interface AssessmentQuestion {
  question: string;
  answer: string;
}

//ServiceOrderDetail()的入口函数
@Builder
export function ServiceOrderDetailBuilder() {
  ServiceOrderDetail()
}

@Component
struct ServiceOrderDetail {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;
  @State orderData: ESObject = this.pathStack.getParamByName('ServiceOrderDetail')[0] as ESObject;
  @State currentTab: number = 0;

  // 服务介绍内容
  @State serviceIntro: string = '检查：心率、血压、血脂检查：心率、血压、血脂检查：心率、血压、血脂检查：心率、血压、血脂检查：心率、血压、血脂';
  @State appointmentNotice: string = '测试';
  @State feeNotice: string = '测试';

  // 费用信息
  @State feeInfo: FeeInfo = {
    consultationFee: 12,
    techFee: 12,
    materialFee: 12,
    totalAmount: 36
  };

  // 看护信息(从订单数据中获取)
  @State caregiverInfo: CaregiverInfo | undefined = undefined;

  // 康复评估数据
  @State assessmentQuestions: AssessmentQuestion[] = [
    { question: '1. 有无心血管疾病?', answer: '无' },
    { question: '2. 有无心血管疾病家族史?', answer: '无' },
    { question: '3. 有无糖尿病?', answer: '无' },
    { question: '4. 有无吸烟?', answer: '无' },
    { question: '5. 身高（cm）', answer: '170' },
    { question: '6. 体重（kg）', answer: '70' },
    { question: '7. 血压水平（舒张压mmHg / 收缩压mmHg）', answer: '80-110' },
    { question: '8. 血脂水平（TC / HDL-C / LDL-C）', answer: '10/10/10' },
    { question: '9. 体育锻炼情况?', answer: '无' },
    { question: '10. 康复情况评估', answer: '' }
  ];

  aboutToAppear(): void {
    // 根据订单中的caregiverId加载看护人员信息
    if (this.orderData.caregiverId) {
      this.caregiverInfo = getCaregiverById(this.orderData.caregiverId as string);
    }
  }

  // 获取状态颜色
  getStatusColor(status: string): string {
    if (status === '待服务') return '21deb4';
    if (status === '待评价') return '#FF9800';
    if (status === '已支付') return '21deb4';
    return '#999999';
  }

  // Tab切换组件
  @Builder
  TabBar() {
    Row() {
      ForEach([$r('app.string.service_introduction'), $r('app.string.caregiver_info'), $r('app.string.service_record'), $r('app.string.assessment')], (tab: Resource, index: number) => {
        Text(tab)
          .fontSize($r('app.float.font_size_14'))
          .fontColor(this.currentTab === index ? $r('app.color.green1') : $r('app.color.font_gray'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .padding({ top: $r('app.float.distance_12'), bottom: $r('app.float.distance_12') })
          .border({
            width: { bottom: this.currentTab === index ? 2 : 0 },
            color: $r('app.color.green1')
          })
          .onClick(() => {
            this.currentTab = index;
          })
      })
    }
    .width(CommonConstants.FULL_PARENT)
    .backgroundColor(Color.White)
  }

  // 订单基本信息卡片
  @Builder
  OrderInfoCard() {
    Column() {
      Row() {
        Text(this.orderData.serviceType as string)
          .fontSize($r('app.float.font_size_16'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color1'))
        Blank()
        Text(this.orderData.status as string)
          .fontSize($r('app.float.font_size_12'))
          .fontColor(this.getStatusColor(this.orderData.status as string))
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.layout_4'), bottom: $r('app.float.bottom_4')})
          .border({
            width: 1,
            color: this.getStatusColor(this.orderData.status as string),
            radius: $r('app.float.layout_4')
          })
      }
      .width(CommonConstants.FULL_PARENT)
      .margin({ bottom: $r('app.float.distance_12') })

      this.InfoRow($r('app.string.care_person'), this.orderData.carePersonName as string)
      this.InfoRow($r('app.string.service_number'), this.orderData.serviceNumber as string)
      this.InfoRow($r('app.string.appointment_time'), this.orderData.appointmentTime as string)
      this.InfoRow($r('app.string.contact_phone'), '18862492805')
      this.InfoRow($r('app.string.contact_address'), '上海')
      this.InfoRow($r('app.string.service_organization'), '中山大学展示中心')
      this.InfoRow($r('app.string.service_type'), '')
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
  }

  // 信息行组件
  @Builder
  InfoRow(label: Resource|string, value: string) {
    Row() {
      Text(label)
        .fontSize($r('app.float.font_size_14'))
        .fontColor($r('app.color.font_color'))
      Blank()
      Text(value || '-')
        .fontSize($r('app.float.font_size_14'))
        .fontColor($r('app.color.font_color1'))
    }
    .width(CommonConstants.FULL_PARENT)
    .margin({ bottom: $r('app.float.distance_8') })
  }

  // 服务介绍视图
  @Builder
  ServiceIntroView() {
    Column() {
      this.OrderInfoCard()

      // 服务介绍
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height($r('app.float.distance_16'))
            .color($r('app.color.green1'))
            .margin({ right: $r('app.float.distance_8') })
          Text($r('app.string.service_introduction'))
            .fontSize($r('app.float.font_size_14'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color1'))
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ bottom: $r('app.float.distance_8') })

        Text(this.serviceIntro)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .lineHeight(22)
          .width(CommonConstants.FULL_PARENT)
      }
      .width(CommonConstants.FULL_PARENT)
      .padding($r('app.float.distance_16'))
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.distance_8'))
      .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
      .margin({ top: $r('app.float.distance_12') })

      // 预约须知
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height($r('app.float.distance_16'))
            .color($r('app.color.green1'))
            .margin({ right: $r('app.float.distance_8') })
          Text($r('app.string.service_appointment_notice'))
            .fontSize($r('app.float.font_size_14'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color1'))
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ bottom: $r('app.float.distance_8') })

        Text(this.appointmentNotice)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .width(CommonConstants.FULL_PARENT)
      }
      .width(CommonConstants.FULL_PARENT)
      .padding($r('app.float.distance_16'))
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.distance_8'))
      .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
      .margin({ top: $r('app.float.distance_12') })

      // 费用须知
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height($r('app.float.distance_16'))
            .color($r('app.color.green1'))
            .margin({ right: $r('app.float.distance_8') })
          Text($r('app.string.service_fee_notice'))
            .fontSize($r('app.float.font_size_14'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color1'))
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ bottom: $r('app.float.distance_8') })

        Text(this.feeNotice)
          .fontSize($r('app.float.font_size_14'))
          .fontColor($r('app.color.font_color1'))
          .width(CommonConstants.FULL_PARENT)
      }
      .width(CommonConstants.FULL_PARENT)
      .padding($r('app.float.distance_16'))
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.distance_8'))
      .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
      .margin({ top: $r('app.float.distance_12') })

      // 费用
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height($r('app.float.distance_16'))
            .color($r('app.color.green1'))
            .margin({ right: $r('app.float.distance_8') })
          Text($r('app.string.fee'))
            .fontSize($r('app.float.font_size_14'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_color1'))
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ bottom: $r('app.float.distance_12') })

        this.FeeRow($r('app.string.consultation_fee'), this.feeInfo.consultationFee)
        this.FeeRow($r('app.string.tech_fee'), this.feeInfo.techFee)
        this.FeeRow($r('app.string.material_fee'), this.feeInfo.materialFee)

        Row() {
          Text($r('app.string.total_amount'))
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.font_color1'))
          Blank()
          Text(`¥${this.feeInfo.totalAmount}`)
            .fontSize($r('app.float.font_size_18'))
            .fontColor($r('app.color.font_red2'))
            .fontWeight(FontWeight.Bold)
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ top: $r('app.float.distance_8') })
      }
      .width(CommonConstants.FULL_PARENT)
      .padding($r('app.float.distance_16'))
      .backgroundColor(Color.White)
      .borderRadius($r('app.float.distance_8'))
      .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
      .margin({ top: $r('app.float.distance_12') })
    }
    .width(CommonConstants.FULL_PARENT)
  }

  // 费用行组件
  @Builder
  FeeRow(label: Resource|string, amount: number) {
    Row() {
      Text(label)
        .fontSize($r('app.float.font_size_14'))
        .fontColor($r('app.color.font_color'))
      Text(' ------------------------------------ ')
        .fontSize($r('app.float.font_size_12'))
        .fontColor($r('app.color.gray1'))
        .layoutWeight(1)
      Text(`¥ ${amount}`)
        .fontSize($r('app.float.font_size_14'))
        .fontColor($r('app.color.font_color1'))
    }
    .width(CommonConstants.FULL_PARENT)
    .margin({ bottom: $r('app.float.distance_8') })
  }

  // 看护信息视图
  @Builder
  CaregiverInfoView() {
    Column() {
      Text(this.caregiverInfo?.name || String($r('app.string.not_assigned')))
        .fontSize($r('app.float.font_size_16'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.font_color1'))
        .width(CommonConstants.FULL_PARENT)
        .margin({ bottom: $r('app.float.distance_16') })

      this.InfoRow($r('app.string.title'), this.caregiverInfo?.title || '-')
      this.InfoRow($r('app.string.contact_phone'), this.caregiverInfo?.phone || '-')
      this.InfoRow($r('app.string.belong_organization'), this.caregiverInfo?.organization || '-')
      this.InfoRow($r('app.string.specialties'), this.caregiverInfo?.specialties.join('、') || '-')
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
  }

  // 服务记录视图
  @Builder
  ServiceRecordView() {
    Column() {
      Text($r('app.string.no_service_record'))
        .fontSize($r('app.float.font_size_14'))
        .fontColor($r('app.color.font_color'))
        .textAlign(TextAlign.Center)
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_40'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
    .justifyContent(FlexAlign.Center)
  }

  // 康复评估视图
  @Builder
  AssessmentView() {
    Column() {
      ForEach(this.assessmentQuestions, (item: AssessmentQuestion) => {
        Column() {
          Text(item.question)
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.font_color1'))
            .width(CommonConstants.FULL_PARENT)
            .margin({ bottom: $r('app.float.distance_8') })
          Text(item.answer || '-')
            .fontSize($r('app.float.font_size_14'))
            .fontColor($r('app.color.font_gray'))
            .width(CommonConstants.FULL_PARENT)
            .padding({ left: $r('app.float.distance_12')})
        }
        .width(CommonConstants.FULL_PARENT)
        .margin({ bottom: $r('app.float.distance_16') })
      })
    }
    .width(CommonConstants.FULL_PARENT)
    .padding($r('app.float.distance_16'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.float.distance_8'))
    .border({ width: 1, color: $r('app.color.gray1'), radius: $r('app.float.distance_8') })
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
              this.pathStack.pop();
            })
          Text($r('app.string.service_order_detail_title'))
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

        // Tab切换
        this.TabBar()

        // 内容区域
        Scroll() {
          Column() {
            if (this.currentTab === 0) {
              this.ServiceIntroView()
            } else if (this.currentTab === 1) {
              this.CaregiverInfoView()
            } else if (this.currentTab === 2) {
              this.ServiceRecordView()
            } else if (this.currentTab === 3) {
              this.AssessmentView()
            }
          }
          .width(CommonConstants.FULL_PARENT)
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), top: $r('app.float.distance_12'), bottom: $r('app.float.distance_20') })
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .width(CommonConstants.FULL_PARENT)
        .align(Alignment.Top)
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
