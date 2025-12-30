// 入住申请填写页面
import { 
  AdmissionItemType,
  AdmissionFormType, 
  OrganizationList, 
  OrganizationInfo,
  DepartmentInfo,
  RoomInfo,
  getDepartmentsByOrganization,
  getRoomsByDepartment
} from '../viewmodel/AdmissionData';
import { PatientInfo, getPatientList } from '../viewmodel/PatientData';
import promptAction from '@ohos.promptAction';
import CommonConstants from '../common/CommonContants'

// Select组件选项类型
interface SelectOption {
  value: string;
}

// AdmissionForm()的入口函数
@Builder
export function AdmissionFormBuilder() {
  AdmissionForm()
}

@Component
struct AdmissionForm {
  @State formData: AdmissionFormType = new AdmissionFormType();
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  // 康养用户列表
  @State patientList: PatientInfo[] = [];

  aboutToAppear(): void {
    this.patientList = getPatientList();
  }

  // 机构列表
  @State organizationList: OrganizationInfo[] = OrganizationList;

  // 部门列表(根据选择的机构动态更新)
  @State departmentList: DepartmentInfo[] = [];

  // 房间列表(根据选择的部门动态更新)
  @State roomList: RoomInfo[] = [];

  // 处理机构选择
  handleOrganizationSelect(index: number): void {
    const org = this.organizationList[index];
    this.formData.organizationId = org.id;
    this.formData.organizationName = org.name;
    
    // 更新部门列表
    this.departmentList = getDepartmentsByOrganization(org.id);
    
    // 清空部门和房间选择
    this.formData.departmentId = '';
    this.formData.departmentName = '';
    this.formData.roomId = '';
    this.formData.roomName = '';
    this.roomList = [];
  }

  // 处理部门选择
  handleDepartmentSelect(index: number): void {
    const dept = this.departmentList[index];
    this.formData.departmentId = dept.id;
    this.formData.departmentName = dept.name;
    
    // 更新房间列表
    this.roomList = getRoomsByDepartment(dept.id);
    
    // 清空房间选择
    this.formData.roomId = '';
    this.formData.roomName = '';
  }

  // 提交申请
  handleSubmit(): void {
    try {
      // 验证必填字段
      if (!this.formData.patientName) {
        promptAction.showToast({ message: $r('app.string.select_patient') });
        return;
      }
      if (!this.formData.organizationName) {
        promptAction.showToast({ message: $r('app.string.select_organization') });
        return;
      }
      if (!this.formData.departmentName) {
        promptAction.showToast({ message: $r('app.string.select_department') });
        return;
      }
      if (!this.formData.roomName) {
        promptAction.showToast({ message: $r('app.string.select_room') });
        return;
      }

      // 创建新的入住申请记录
      const currentList = AppStorage.get<AdmissionItemType[]>('admissionList') || [];
      const newId = currentList.length > 0 ? Math.max(...currentList.map(item => item.id)) + 1 : 1;
      
      // 获取当前时间
      const now = new Date();
      const dateStr = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
      
      const newAdmission = new AdmissionItemType(
        newId,
        this.formData.patientId,
        this.formData.patientName,
        this.formData.organizationId,
        this.formData.organizationName,
        this.formData.departmentId,
        this.formData.departmentName,
        this.formData.roomId,
        this.formData.roomName,
        dateStr,
        '待审核',
        this.formData.remarks
      );

      // 将新申请添加到列表开头(最新的显示在前面)
      const updatedList = [newAdmission, ...currentList];
      AppStorage.setOrCreate('admissionList', updatedList);

      // 提交成功提示
      promptAction.showToast({ message: $r('app.string.apply_success') });

      // 返回到入住申请列表页面
      setTimeout(() => {
        this.pathStack.clear();
        this.pathStack.pushPathByName('MainPages', null);
        this.pathStack.pushPathByName('Admission', null);
      }, 1500);
    } catch (error) {
      console.error('提交申请失败:', error);
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
          Text($r('app.string.admission_form_title'))
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
            // 入住申请表单
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

              // 机构名称选择
              Column() {
                Text($r('app.string.organization'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                Select(this.organizationList.map((org: OrganizationInfo): SelectOption => ({ value: org.name })))
                  .selected(-1)
                  .value(this.formData.organizationName || $r('app.string.select_organization'))
                  .font({ size: $r('app.float.font_size_16') })
                  .optionFont({ size: $r('app.float.font_size_16') })
                  .onSelect((index: number) => {
                    this.handleOrganizationSelect(index);
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 部门名称选择
              Column() {
                Text($r('app.string.department'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                Select(this.departmentList.map((dept: DepartmentInfo): SelectOption => ({ value: dept.name })))
                  .selected(-1)
                  .value(this.formData.departmentName || $r('app.string.select_department'))
                  .font({ size: $r('app.float.font_size_16') })
                  .optionFont({ size: $r('app.float.font_size_16') })
                  .enabled(this.departmentList.length > 0)
                  .onSelect((index: number) => {
                    this.handleDepartmentSelect(index);
                  })
                  .width(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.FULL_PARENT)
              .margin({ bottom: $r('app.float.distance_16') })

              // 房间名称选择
              Column() {
                Text($r('app.string.room'))
                  .fontSize($r('app.float.font_size_15'))
                  .fontColor($r('app.color.font_color1'))
                  .width(CommonConstants.FULL_PARENT)
                  .margin({ bottom: $r('app.float.distance_8') })

                Select(this.roomList.map((room: RoomInfo): SelectOption => ({ value: room.name })))
                  .selected(-1)
                  .value(this.formData.roomName || $r('app.string.select_room'))
                  .font({ size: $r('app.float.font_size_16') })
                  .optionFont({ size: $r('app.float.font_size_16') })
                  .enabled(this.roomList.length > 0)
                  .onSelect((index: number) => {
                    this.formData.roomId = this.roomList[index].id;
                    this.formData.roomName = this.roomList[index].name;
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
          .padding({ left: $r('app.float.distance_12'), right: $r('app.float.distance_12'), bottom: $r('app.float.distance_12') })
        }
        .layoutWeight(1)
        .width(CommonConstants.FULL_PARENT)

        // 底部提交按钮
        Column() {
          Button($r('app.string.submit_apply'))
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
        .shadow({ radius: $r('app.float.distance_8'), color: $r('app.color.black1'), offsetX: 0, offsetY: -2 })
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
