// 预约信息填写页面
import { ServiceItemType, AppointmentFormType, ServiceItemList, ServiceOrder } from '../viewmodel/ServiceProcurementData';
import ServiceItemCard from '../view/ServiceItemCard';
import { PatientInfo, getPatientList } from '../viewmodel/PatientData';
import { CaregiverInfo, getCaregiverList } from '../viewmodel/CaregiverData';
import promptAction from '@ohos.promptAction';
import CommonConstants from '../common/CommonContants'
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
        promptAction.showToast({ message: $r('app.string.select_patient') });
        return;
      }
      if (!this.formData.caregiverId) {
        promptAction.showToast({ message: $r('app.string.select_caregiver') });
        return;
      }
      if (!this.formData.appointmentTime) {
        promptAction.showToast({ message: $r('app.string.select_appointment_time') });
        return;
      }
      if (!this.formData.contactPerson) {
        promptAction.showToast({ message: $r('app.string.input_contact_person') });
        return;
      }
      if (!this.formData.contactPhone) {
        promptAction.showToast({ message: $r('app.string.input_contact_phone') });
        return;
      }
      if (!this.validatePhone(this.formData.contactPhone)) {
        promptAction.showToast({ message: $r('app.string.input_valid_phone') });
        return;
      }
      if (!this.formData.address) {
        promptAction.showToast({ message: $r('app.string.input_address') });
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
      promptAction.showToast({ message: $r('app.string.appointment_success') });

      // 返回到服务订单页面
      setTimeout(() => {
        this.pathStack.clear();
        this.pathStack.pushPathByName('MainPages', null);
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
           .width($r('app.float.distance_24'))
           .height($r('app.float.distance_24'))
           .margin({ left: $r('app.float.distance_16') })
           .onClick(() => {
             this.pathStack.pop();
           })
         Text($r('app.string.appointment_form_title'))
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

        // 滚动容器
        Scroll() {
          Column() {
            // 使用完整的服务项目卡片（与服务列表页相同）
            ServiceItemCard({ serviceItem: this.serviceItem })
              .margin({ top: $r('app.float.distance_12') })

            // 预约信息表单
            Column() {
              // 康养用户选择
              Column() {
                Text($r('app.string.patient'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                Select(this.patientList.map((p: PatientInfo): SelectOption => ({ value: p.name })))
                  .selected(-1)
                  .value(this.formData.patientName || $r('app.string.select_patient'))
                  .font({ size: $r('app.float.font_size_16') })
                  .optionFont({ size: $r('app.float.font_size_16') })
                  .onSelect((index: number) => {
                    this.formData.patientId = this.patientList[index].id;
                    this.formData.patientName = this.patientList[index].name;
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 看护人员选择
              Column() {
                Text($r('app.string.caregiver'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                Select(this.caregiverList.map((c: CaregiverInfo): SelectOption => ({ 
                  value: `${c.name} - ${c.title}` 
                })))
                  .selected(-1)
                  .value(this.formData.caregiverId ? 
                    (() => {
                      const caregiver = this.caregiverList.find(c => c.id === this.formData.caregiverId);
                      return caregiver ? `${caregiver.name} - ${caregiver.title}` : $r('app.string.select_caregiver');
                    })() : 
                    $r('app.string.select_caregiver'))
                  .font({ size: $r('app.float.font_size_16') })
                  .optionFont({ size: $r('app.float.font_size_16') })
                  .onSelect((index: number) => {
                    this.formData.caregiverId = this.caregiverList[index].id;
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 预约时间选择
              Column() {
                Text($r('app.string.appointment_time'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                Select(this.timeSlotList.map((t: string): SelectOption => ({ value: t })))
                  .selected(-1)
                  .value(this.formData.appointmentTime || $r('app.string.select_appointment_time'))
                  .font({ size: $r('app.float.font_size_16') })
                  .optionFont({ size: $r('app.float.font_size_16') })
                  .onSelect((index: number) => {
                    this.formData.appointmentTime = this.timeSlotList[index];
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 联系人输入
              Column() {
                Text($r('app.string.contact_person'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                TextInput({ placeholder: $r('app.string.input_contact_person') })
                  .fontSize($r('app.float.font_size_16'))
                  .onChange((value: string) => {
                    this.formData.contactPerson = value;
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 联系电话输入
              Column() {
                Text($r('app.string.contact_phone'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                TextInput({ placeholder: $r('app.string.input_contact_phone') })
                  .fontSize($r('app.float.font_size_16'))
                  .type(InputType.PhoneNumber)
                  .maxLength(11)
                  .onChange((value: string) => {
                    this.formData.contactPhone = value;
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 地址输入
              Column() {
                Text($r('app.string.address'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                TextInput({ placeholder: $r('app.string.input_address') })
                  .fontSize($r('app.float.font_size_16'))
                  .onChange((value: string) => {
                    this.formData.address = value;
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 备注输入
              Column() {
                Text($r('app.string.remarks'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                TextArea({ placeholder: $r('app.string.input_remarks') })
                  .fontSize($r('app.float.font_size_16'))
                  .height($r('app.float.distance_80'))
                  .onChange((value: string) => {
                    this.formData.remarks = value;
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
            }
            .padding($r('app.float.distance_16'))
            .width(CommonConstants.FULL_PARENT)
            .backgroundColor($r('app.color.white'))
            .borderRadius($r('app.float.distance_12'))
            .margin({ top: $r('app.float.distance_12') })
          }
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), bottom: $r('app.float.distance_12')})
        }
        .layoutWeight(1)
        .width(CommonConstants.FULL_PARENT)

        // 底部提交按钮
        Column() {
          Button($r('app.string.submit_appointment'))
            .width(CommonConstants.FULL_PARENT)
            .height($r('app.float.height_48'))
            .fontSize($r('app.float.font_size_18'))
            .fontWeight(600)
            .backgroundColor($r('app.color.green1'))
            .borderRadius($r('app.float.distance_24'))
            .onClick(() => {
              this.handleSubmit();
            })
        }
        .padding($r('app.float.distance_12'))
        .width(CommonConstants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .shadow({ radius: 8, color: $r('app.color.black1'), offsetX: 0, offsetY: -2 })
      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .backgroundColor($r('app.color.background_color'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.main_green'))
  }
}
