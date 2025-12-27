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
        promptAction.showToast({ message: '请选择康养用户' });
        return;
      }
      if (!this.formData.organizationName) {
        promptAction.showToast({ message: '请选择机构名称' });
        return;
      }
      if (!this.formData.departmentName) {
        promptAction.showToast({ message: '请选择部门名称' });
        return;
      }
      if (!this.formData.roomName) {
        promptAction.showToast({ message: '请选择房间名称' });
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
      promptAction.showToast({ message: '申请成功!' });

      // 返回到入住申请列表页面
      setTimeout(() => {
        this.pathStack.clear();
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
            .width('24vp')
            .height('24vp')
            .margin({ left: '16vp' })
            .onClick(() => {
              this.pathStack.pop();
            })
          Text('入住申请填写')
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
            // 入住申请表单
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

              // 机构名称选择
              Column() {
                Text('机构名称')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                Select(this.organizationList.map((org: OrganizationInfo): SelectOption => ({ value: org.name })))
                  .selected(-1)
                  .value(this.formData.organizationName || '请选择机构名称')
                  .font({ size: '16fp' })
                  .optionFont({ size: '16fp' })
                  .onSelect((index: number) => {
                    this.handleOrganizationSelect(index);
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 部门名称选择
              Column() {
                Text('部门名称')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                Select(this.departmentList.map((dept: DepartmentInfo): SelectOption => ({ value: dept.name })))
                  .selected(-1)
                  .value(this.formData.departmentName || '请选择部门名称')
                  .font({ size: '16fp' })
                  .optionFont({ size: '16fp' })
                  .enabled(this.departmentList.length > 0)
                  .onSelect((index: number) => {
                    this.handleDepartmentSelect(index);
                  })
                  .width('100%')
              }
              .width('100%')
              .margin({ bottom: '16vp' })

              // 房间名称选择
              Column() {
                Text('房间名称')
                  .fontSize('15fp')
                  .fontColor('#333333')
                  .width('100%')
                  .margin({ bottom: '8vp' })

                Select(this.roomList.map((room: RoomInfo): SelectOption => ({ value: room.name })))
                  .selected(-1)
                  .value(this.formData.roomName || '请选择房间名称')
                  .font({ size: '16fp' })
                  .optionFont({ size: '16fp' })
                  .enabled(this.roomList.length > 0)
                  .onSelect((index: number) => {
                    this.formData.roomId = this.roomList[index].id;
                    this.formData.roomName = this.roomList[index].name;
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

                TextArea({ placeholder: '请输入备注(选填)' })
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
          Button('提交申请')
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
