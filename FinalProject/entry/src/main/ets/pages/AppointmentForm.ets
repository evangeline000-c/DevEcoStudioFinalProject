// 预约信息填写页面
import { ServiceItemType, AppointmentFormType, ServiceItemList, ServiceOrder } from '../viewmodel/ServiceProcurementData';
import ServiceItemCard from '../view/ServiceItemCard';
import { PatientInfo, getPatientList } from '../viewmodel/PatientData';
import { CaregiverInfo, getCaregiverList } from '../viewmodel/CaregiverData';
import promptAction from '@ohos.promptAction';

// Select组件选项类型
interface SelectOption {
  value: string;
}

// AppointmentForm()的入口函数
@Builder
export function AppointmentFormBuilder() {
  AppointmentForm()
}

@Component
struct AppointmentForm {
  @State serviceItem: ServiceItemType = new ServiceItemType(0, '', '', '', $r('app.media.startIcon'), 0, '', '', '', '', '');
  @State formData: AppointmentFormType = new AppointmentFormType();
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  // 康养用户列表 (使用 getPatientList 初始化或在 aboutToAppear 更新)
  @State patientList: PatientInfo[] = [];


  // 看护人员列表
  @State caregiverList: CaregiverInfo[] = [];

  // 模拟的预约时间列表
  @State timeSlotList: string[] = [
    '上午 08:00-10:00',
    '上午 10:00-12:00',
    '下午 14:00-16:00',
    '下午 16:00-18:00'
  ];

  aboutToAppear(): void {
    // 获取康养用户列表
    this.patientList = getPatientList();
    // 获取看护人员列表
    this.caregiverList = getCaregiverList();

    // 从导航参数中获取服务ID
    const param: Object | undefined = this.pathStack.getParamByName('AppointmentForm');
    
    if (param) {
      // 处理参数可能被包装成数组的情况
      let serviceId: number;
      if (Array.isArray(param)) {
        serviceId = param[0] as number;
      } else {
        serviceId = param as number;
      }
      
      // 从ServiceItemList中查找对应的服务项
      const foundItem = ServiceItemList.find(item => item.id === serviceId);
      
      if (foundItem) {
        // 逐个属性赋值，确保@State触发更新
        this.serviceItem.id = foundItem.id;
        this.serviceItem.serviceName = foundItem.serviceName;
        this.serviceItem.serviceOrganization = foundItem.serviceOrganization;
        this.serviceItem.serviceType = foundItem.serviceType;
        this.serviceItem.servicePhoto = foundItem.servicePhoto;
        this.serviceItem.servicePrice = foundItem.servicePrice;
        this.serviceItem.serviceUnit = foundItem.serviceUnit;
        this.serviceItem.serviceDescription = foundItem.serviceDescription;
        this.serviceItem.serviceDetails = foundItem.serviceDetails;
        this.serviceItem.serviceAppointmentNotice = foundItem.serviceAppointmentNotice;
        this.serviceItem.serviceFeeNotice = foundItem.serviceFeeNotice;
        
        this.formData.serviceId = foundItem.id;
        this.formData.serviceName = foundItem.serviceName;
      }
    }
  }

  // 验证手机号码格式
  validatePhone(phone: string): boolean {
    const phoneRegex = /^1[3-9]\d{9}$/;
    return phoneRegex.test(phone);
  }

  // 提交预约
  handleSubmit(): void {
    try {
      // 验证必填字段
      if (!this.formData.patientName) {
        promptAction.showToast({ message: '请选择康养用户' });
        return;
      }
      if (!this.formData.caregiverId) {
        promptAction.showToast({ message: '请选择看护人员' });
        return;
      }
      if (!this.formData.appointmentTime) {
        promptAction.showToast({ message: '请选择预约时间' });
        return;
      }
      if (!this.formData.contactPerson) {
        promptAction.showToast({ message: '请输入联系人' });
        return;
      }
      if (!this.formData.contactPhone) {
        promptAction.showToast({ message: '请输入联系电话' });
        return;
      }
      if (!this.validatePhone(this.formData.contactPhone)) {
        promptAction.showToast({ message: '请输入正确的手机号码' });
        return;
      }
      if (!this.formData.address) {
        promptAction.showToast({ message: '请输入地址' });
        return;
      }

      // 创建订单对象
      const selectedCaregiver = this.caregiverList.find(c => c.id === this.formData.caregiverId);
      const newOrder: ServiceOrder = {
        id: Date.now(),
        serviceType: this.serviceItem.serviceType,
        carePersonName: this.formData.patientName,
        serviceNumber: `kh_${Date.now()}`,
        caregiverId: this.formData.caregiverId,
        caregiverName: selectedCaregiver?.name,
        appointmentTime: this.formData.appointmentTime,
        servicePrice: this.serviceItem.servicePrice,
        status: '待服务'
      };

      // 保存到AppStorage
      const currentList: ServiceOrder[] = AppStorage.get<ServiceOrder[]>('serviceOrderList') || [];
      AppStorage.setOrCreate('serviceOrderList', [newOrder, ...currentList]);

      // 提交成功提示
      promptAction.showToast({ message: '预约成功！' });

      // 返回到服务订单页面
      setTimeout(() => {
        this.pathStack.clear();
        this.pathStack.pushPathByName('ServiceOrders', null);
      }, 1500);
    } catch (error) {
      console.error('提交预约失败:', error);
    }
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
         Text('预约信息填写')
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

        // 滚动容器
        Scroll() {
          Column() {
            // 使用完整的服务项目卡片（与服务列表页相同）
            ServiceItemCard({ serviceItem: this.serviceItem })
              .margin({ top: '12vp' })

            // 预约信息表单
            Column() {
              // 康养用户选择
              Column() {
                Text('康养用户')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                Select(this.patientList.map((p: PatientInfo): SelectOption => ({ value: p.name })))
                  .selected(-1)
                  .value(this.formData.patientName || '请选择康养用户')
                  .font({ size: '16fp' })
                  .optionFont({ size: '16fp' })
                  .onSelect((index: number) => {
                    this.formData.patientId = this.patientList[index].id;
                    this.formData.patientName = this.patientList[index].name;
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 看护人员选择
              Column() {
                Text('看护人员')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                Select(this.caregiverList.map((c: CaregiverInfo): SelectOption => ({ 
                  value: `${c.name} - ${c.title}` 
                })))
                  .selected(-1)
                  .value(this.formData.caregiverId ? 
                    (() => {
                      const caregiver = this.caregiverList.find(c => c.id === this.formData.caregiverId);
                      return caregiver ? `${caregiver.name} - ${caregiver.title}` : '请选择看护人员';
                    })() : 
                    '请选择看护人员')
                  .font({ size: '16fp' })
                  .optionFont({ size: '16fp' })
                  .onSelect((index: number) => {
                    this.formData.caregiverId = this.caregiverList[index].id;
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 预约时间选择
              Column() {
                Text('预约时间')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                Select(this.timeSlotList.map((t: string): SelectOption => ({ value: t })))
                  .selected(-1)
                  .value(this.formData.appointmentTime || '请选择预约时间')
                  .font({ size: '16fp' })
                  .optionFont({ size: '16fp' })
                  .onSelect((index: number) => {
                    this.formData.appointmentTime = this.timeSlotList[index];
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 联系人输入
              Column() {
                Text('联系人')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                TextInput({ placeholder: '请输入联系人' })
                  .fontSize('16fp')
                  .onChange((value: string) => {
                    this.formData.contactPerson = value;
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 联系电话输入
              Column() {
                Text('联系电话')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                TextInput({ placeholder: '请输入11位手机号码' })
                  .fontSize('16fp')
                  .type(InputType.PhoneNumber)
                  .maxLength(11)
                  .onChange((value: string) => {
                    this.formData.contactPhone = value;
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 地址输入
              Column() {
                Text('地址')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                TextInput({ placeholder: '请输入地址' })
                  .fontSize('16fp')
                  .onChange((value: string) => {
                    this.formData.address = value;
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 备注输入
              Column() {
                Text('备注')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                TextArea({ placeholder: '请输入备注（选填）' })
                  .fontSize('16fp')
                  .height('80vp')
                  .onChange((value: string) => {
                    this.formData.remarks = value;
                  })
                  .width('100%')
              }
              .width('100%')
            }
            .padding('16vp')
            .width('100%')
            .backgroundColor('#FFFFFF')
            .borderRadius('12vp')
            .margin({ top: '12vp' })
          }
          .padding({ left: '12vp', right: '12vp', bottom: '12vp' })
        }
        .layoutWeight(1)
        .width('100%')

        // 底部提交按钮
        Column() {
          Button('提交预约')
            .width('100%')
            .height('48vp')
            .fontSize('18fp')
            .fontWeight(600)
            .backgroundColor('#21deb4')
            .borderRadius('24vp')
            .onClick(() => {
              this.handleSubmit();
            })
        }
        .padding('12vp')
        .width('100%')
        .backgroundColor('#FFFFFF')
        .shadow({ radius: 8, color: '#1F000000', offsetX: 0, offsetY: -2 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor('#d821deb4')
  }
}
