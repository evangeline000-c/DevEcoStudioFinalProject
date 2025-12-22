//服务订单详情页面

// 药品信息接口
interface MedicineItem {
  name: string;
  price: number;
}

// 看护信息接口
interface CaregiverInfo {
  name: string;
  phone: string;
  organization: string;
  roomNumber: string;
}

// 服务记录接口
interface ServiceRecord {
  date: string;
  content: string;
}

// 服务介绍接口
interface ServiceIntro {
  serviceItems: string; // 服务介绍
  prescriptions: string; // 诊后医嘱
  medicationPlan: string; // 用药计划
  usage: string; // 使用
  medicines: MedicineItem[];
  totalPrice: number;
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

  @State currentTab: number = 0; // 0:服务介绍, 1:看护信息, 2:服务记录, 3:服务评估

  // 模拟服务介绍数据
  @State serviceIntro: ServiceIntro = {
    serviceItems: '检查、心血管、血液检查、心理、四肢、血液检查、心理、血压、血脂、心电图、冠心、血压',
    prescriptions: '测量',
    medicationPlan: '测量',
    usage: '由医嘱',
    medicines: [
      { name: '出塞曲', price: 12 } as MedicineItem,
      { name: '扶桑曲', price: 12 } as MedicineItem,
      { name: '含服液', price: 12 } as MedicineItem
    ],
    totalPrice: 36
  };

  // 模拟看护信息
  @State caregiverInfo: CaregiverInfo = {
    name: '王国栋',
    phone: '13620240001',
    organization: '中山大学附属医院',
    roomNumber: '25'
  };

  // 模拟服务记录
  @State serviceRecords: ServiceRecord[] = [];

  // 模拟服务评估数据
  @State assessmentQuestions: AssessmentQuestion[] = [
    { question: '1. 有无心血管病病?', answer: '无' },
    { question: '2. 有无心脏病既往病史?', answer: '无' },
    { question: '3. 有无糖尿病?', answer: '无' },
    { question: '4. 有无感染?', answer: '无' },
    { question: '5. 身高 (cm)', answer: '170' },
    { question: '6. 体重 (kg)', answer: '70' },
    { question: '7. 血压水平 (左臂mmHg / 收缩压mmHg)', answer: '80-110' },
    { question: '8. 血脂水平 (TC / HDL-C / LDL-C)', answer: '10/10/10' },
    { question: '9. 体弱或虚弱吗?', answer: '无' },
    { question: '10. 身体活动受限吗', answer: '' }
  ];

  // 订单信息卡片
  @Builder
  OrderInfoCard() {
    Column() {
      Row() {
        Text(this.orderData.serviceName as string)
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(this.orderData.status as string)
          .fontSize('14fp')
          .fontColor(this.orderData.status === '待服务' ? '#4CAF50' : this.orderData.status === '待评价' ? '#FF9800' : '#999999')
          .padding({ left: '12vp', right: '12vp', top: '4vp', bottom: '4vp' })
          .border({
            width: 1,
            color: this.orderData.status === '待服务' ? '#4CAF50' : this.orderData.status === '待评价' ? '#FF9800' : '#999999',
            radius: 4
          })
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务名人')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.servicePersonName as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务单号')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.serviceNumber as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务名称')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.serviceName as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('预约时间')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.appointmentTime as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('联系电话')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text('18862492805')
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务地点')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text('上海')
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('服务价格')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(`¥ ${this.orderData.servicePrice}`)
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

  // 服务介绍视图
  @Builder
  ServiceIntroView() {
    Column() {
      this.OrderInfoCard()

      Column() {
        Text('服务介绍')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '12vp' })

        Text(this.serviceIntro.serviceItems)
          .fontSize('14fp')
          .fontColor('#333333')
          .lineHeight(22)
          .width('100%')
          .margin({ bottom: '16vp' })

        Divider()
          .margin({ bottom: '12vp' })

        Text('诊后医嘱')
          .fontSize('14fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '8vp' })
        Text(this.serviceIntro.prescriptions)
          .fontSize('14fp')
          .fontColor('#333333')
          .width('100%')
          .margin({ bottom: '16vp' })

        Divider()
          .margin({ bottom: '12vp' })

        Text('用药计划')
          .fontSize('14fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '8vp' })
        Text(this.serviceIntro.medicationPlan)
          .fontSize('14fp')
          .fontColor('#333333')
          .width('100%')
          .margin({ bottom: '16vp' })

        Divider()
          .margin({ bottom: '12vp' })

        Text('使用')
          .fontSize('14fp')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: '8vp' })
        Text(this.serviceIntro.usage)
          .fontSize('14fp')
          .fontColor('#333333')
          .width('100%')
          .margin({ bottom: '16vp' })

        Divider()
          .margin({ bottom: '12vp' })

        ForEach(this.serviceIntro.medicines, (medicine: MedicineItem, index: number) => {
          Row() {
            Text(medicine.name)
              .fontSize('14fp')
              .fontColor('#333333')
            Blank()
            Text(`¥ ${medicine.price}`)
              .fontSize('14fp')
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: '8vp' })
        })

        Divider()
          .margin({ top: '8vp', bottom: '12vp' })

        Row() {
          Text('合金额')
            .fontSize('14fp')
            .fontColor('#666666')
          Blank()
          Text(`¥ ${this.serviceIntro.totalPrice}`)
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
      .margin({ top: '12vp' })
    }
    .width('100%')
  }

  // 看护信息视图
  @Builder
  CaregiverInfoView() {
    Column() {
      Text(this.caregiverInfo.name)
        .fontSize('16fp')
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .margin({ bottom: '12vp' })

      Row() {
        Text('服务名称')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.orderData.serviceName as string)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('看护电话')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.caregiverInfo.phone)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('机构名称')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.caregiverInfo.organization)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
      .margin({ bottom: '8vp' })

      Row() {
        Text('房门号码')
          .fontSize('14fp')
          .fontColor('#666666')
        Blank()
        Text(this.caregiverInfo.roomNumber)
          .fontSize('14fp')
          .fontColor('#333333')
      }
      .width('100%')
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
  }

  // 服务记录视图
  @Builder
  ServiceRecordView() {
    Column() {
      if (this.serviceRecords.length > 0) {
        ForEach(this.serviceRecords, (record: ServiceRecord) => {
          Column() {
            Text(record.date)
              .fontSize('14fp')
              .fontColor('#666666')
              .width('100%')
              .margin({ bottom: '8vp' })
            Text(record.content)
              .fontSize('14fp')
              .fontColor('#333333')
              .width('100%')
          }
          .width('100%')
          .padding('16vp')
          .backgroundColor(Color.White)
          .borderRadius('8vp')
          .margin({ bottom: '12vp' })
        })
      } else {
        Column() {
          Text('本土暂无记录')
            .fontSize('14fp')
            .fontColor('#999999')
            .margin({ top: '20vp' })
        }
        .width('100%')
        .padding('16vp')
        .backgroundColor(Color.White)
        .borderRadius('8vp')
      }
    }
    .width('100%')
  }

  // 服务评估视图
  @Builder
  ServiceAssessmentView() {
    Column() {
      ForEach(this.assessmentQuestions, (question: AssessmentQuestion) => {
        Column() {
          Text(question.question)
            .fontSize('14fp')
            .fontColor('#333333')
            .width('100%')
            .margin({ bottom: '8vp' })
          Text(question.answer || '-')
            .fontSize('14fp')
            .fontColor('#666666')
            .width('100%')
        }
        .width('100%')
        .margin({ bottom: '16vp' })
      })
    }
    .width('100%')
    .padding('16vp')
    .backgroundColor(Color.White)
    .borderRadius('8vp')
  }

  build() {
    NavDestination() {
      Column() {
        // 标题栏
        Text('服务订单详情')
          .width('100%')
          .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
          .fontWeight(700)
          .fontSize('20fp')
          .backgroundColor('#00CDA5')
          .fontColor(Color.White)

        // Tab切换
        Row() {
          Text('服务介绍')
            .fontSize('14fp')
            .fontColor(this.currentTab === 0 ? '#00CDA5' : '#666666')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .padding({ top: '12vp', bottom: '12vp' })
            .border({
              width: { bottom: this.currentTab === 0 ? 2 : 0 },
              color: '#00CDA5'
            })
            .onClick(() => {
              this.currentTab = 0;
            })

          Text('看护信息')
            .fontSize('14fp')
            .fontColor(this.currentTab === 1 ? '#00CDA5' : '#666666')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .padding({ top: '12vp', bottom: '12vp' })
            .border({
              width: { bottom: this.currentTab === 1 ? 2 : 0 },
              color: '#00CDA5'
            })
            .onClick(() => {
              this.currentTab = 1;
            })

          Text('服务记录')
            .fontSize('14fp')
            .fontColor(this.currentTab === 2 ? '#00CDA5' : '#666666')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .padding({ top: '12vp', bottom: '12vp' })
            .border({
              width: { bottom: this.currentTab === 2 ? 2 : 0 },
              color: '#00CDA5'
            })
            .onClick(() => {
              this.currentTab = 2;
            })

          Text('服务评估')
            .fontSize('14fp')
            .fontColor(this.currentTab === 3 ? '#00CDA5' : '#666666')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .padding({ top: '12vp', bottom: '12vp' })
            .border({
              width: { bottom: this.currentTab === 3 ? 2 : 0 },
              color: '#00CDA5'
            })
            .onClick(() => {
              this.currentTab = 3;
            })
        }
        .width('100%')
        .backgroundColor(Color.White)

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
              this.ServiceAssessmentView()
            }
          }
          .width('100%')
          .padding({ left: '12vp', right: '12vp', top: '12vp', bottom: '12vp' })
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .width('100%')
        .align(Alignment.Top)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
    .hideTitleBar(true)
  }
}
