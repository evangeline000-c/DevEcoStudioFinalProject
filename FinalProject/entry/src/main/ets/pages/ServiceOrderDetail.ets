//服务订单详情页面
import { getCaregiverById, CaregiverInfo } from '../viewmodel/CaregiverData';

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
    if (status === '待服务') return '#21deb4';
    if (status === '待评价') return '#FF9800';
    if (status === '已支付') return '#21deb4';
    return '#999999';
  }

  // Tab切换组件
  @Builder
  TabBar() {
    Row() {
      ForEach(['服务介绍', '看护信息', '服务记录', '康复评估'], (tab: string, index: number) => {
        Text(tab)
          .fontSize('14fp')
          .fontColor(this.currentTab === index ? '#21deb4' : '#666666')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .padding({ top: '12vp', bottom: '12vp' })
          .border({
            width: { bottom: this.currentTab === index ? 2 : 0 },
            color: '#21deb4'
          })
          .onClick(() => {
            this.currentTab = index;
          })
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
  }

  // 订单基本信息卡片
  @Builder
  OrderInfoCard() {
    Column() {
      Row() {
        Text(this.orderData.serviceType as string)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Blank()
        Text(this.orderData.status as string)
          .fontSize('12fp')
          .fontColor(this.getStatusColor(this.orderData.status as string))
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({
            width: 1,
            color: this.getStatusColor(this.orderData.status as string),
            radius: '4vp'
          })
      }
      .width('100%')
      .margin({ bottom: '12vp' })

      this.InfoRow('被看护人', this.orderData.carePersonName as string)
      this.InfoRow('服务单号', this.orderData.serviceNumber as string)
      this.InfoRow('预约时间', this.orderData.appointmentTime as string)
      this.InfoRow('联系电话', '18862492805')
      this.InfoRow('联系地址', '上海')
      this.InfoRow('服务机构', '中山大学展示中心')
      this.InfoRow('服务类型', '')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
  }

  // 信息行组件
  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize('14fp')
        .fontColor('#999999')
      Blank()
      Text(value || '-')
        .fontSize('14fp')
        .fontColor('#333333')
    }
    .width('100%')
    .margin({ bottom: '8vp' })
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
            .height('16vp')
            .color('#21deb4')
            .margin({ right: '8vp' })
          Text('服务介绍')
            .fontSize('14fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .margin({ bottom: '8vp' })

        Text(this.serviceIntro)
          .fontSize('14fp')
          .fontColor('#333333')
          .lineHeight(22)
          .width('100%')
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
      .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
      .margin({ top: '12vp' })

      // 预约须知
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height('16vp')
            .color('#21deb4')
            .margin({ right: '8vp' })
          Text('预约须知')
            .fontSize('14fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .margin({ bottom: '8vp' })

        Text(this.appointmentNotice)
          .fontSize('14fp')
          .fontColor('#333333')
          .width('100%')
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
      .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
      .margin({ top: '12vp' })

      // 费用须知
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height('16vp')
            .color('#21deb4')
            .margin({ right: '8vp' })
          Text('费用须知')
            .fontSize('14fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .margin({ bottom: '8vp' })

        Text(this.feeNotice)
          .fontSize('14fp')
          .fontColor('#333333')
          .width('100%')
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
      .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
      .margin({ top: '12vp' })

      // 费用
      Column() {
        Row() {
          Divider()
            .vertical(true)
            .strokeWidth(3)
            .height('16vp')
            .color('#21deb4')
            .margin({ right: '8vp' })
          Text('费用')
            .fontSize('14fp')
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
        }
        .width('100%')
        .margin({ bottom: '12vp' })

        this.FeeRow('出诊费', this.feeInfo.consultationFee)
        this.FeeRow('技术费', this.feeInfo.techFee)
        this.FeeRow('耗材费', this.feeInfo.materialFee)

        Row() {
          Text('总金额')
            .fontSize('14fp')
            .fontColor('#333333')
          Blank()
          Text(`¥${this.feeInfo.totalAmount}`)
            .fontSize('18fp')
            .fontColor('#FF6B00')
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .margin({ top: '8vp' })
      }
      .width('100%')
      .padding('16vp')
      .backgroundColor(Color.White)
      .borderRadius('8vp')
      .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
      .margin({ top: '12vp' })
    }
    .width('100%')
  }

  // 费用行组件
  @Builder
  FeeRow(label: string, amount: number) {
    Row() {
      Text(label)
        .fontSize('14fp')
        .fontColor('#999999')
      Text(' ------------------------------------ ')
        .fontSize('12fp')
        .fontColor('#E8E8E8')
        .layoutWeight(1)
      Text(`¥ ${amount}`)
        .fontSize('14fp')
        .fontColor('#333333')
    }
    .width('100%')
    .margin({ bottom: '8vp' })
  }

  // 看护信息视图
  @Builder
  CaregiverInfoView() {
    Column() {
      Text(this.caregiverInfo?.name || '未分配')
        .fontSize('16fp')
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .margin({ bottom: '16vp' })

      this.InfoRow('职称', this.caregiverInfo?.title || '-')
      this.InfoRow('联系电话', this.caregiverInfo?.phone || '-')
      this.InfoRow('所属机构', this.caregiverInfo?.organization || '-')
      this.InfoRow('专业领域', this.caregiverInfo?.specialties.join('、') || '-')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
  }

  // 服务记录视图
  @Builder
  ServiceRecordView() {
    Column() {
      Text('未上传服务记录')
        .fontSize('14fp')
        .fontColor('#999999')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding('40vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
    .justifyContent(FlexAlign.Center)
  }

  // 康复评估视图
  @Builder
  AssessmentView() {
    Column() {
      ForEach(this.assessmentQuestions, (item: AssessmentQuestion) => {
        Column() {
          Text(item.question)
            .fontSize('14fp')
            .fontColor('#333333')
            .width('100%')
            .margin({ bottom: '8vp' })
          Text(item.answer || '-')
            .fontSize('14fp')
            .fontColor('#666666')
            .width('100%')
            .padding({ left: '12vp' })
        }
        .width('100%')
        .margin({ bottom: '16vp' })
      })
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
    .border({ width: 1, color: '#E8E8E8', radius: '8vp' })
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
              this.pathStack.pop();
            })
          Text('服务订单详情')
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
          .width('100%')
          .padding({ left: '12vp', right: '12vp', top: '12vp', bottom: '20vp' })
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .width('100%')
        .align(Alignment.Top)
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
