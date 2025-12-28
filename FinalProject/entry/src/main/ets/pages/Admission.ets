//入住申请页面
import { AdmissionItemType, AdmissionItemList } from '../viewmodel/AdmissionData';
import AdmissionListView from '../view/AdmissionListView';
import { UserDataSource } from '../view/UserModel';
import CommonConstants from '../common/CommonContants'

//Admission()的入口函数
@Builder
export function AdmissionBuilder() {
  Admission()
}

@Component
struct Admission {
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;

  aboutToAppear(): void {
    // Check if admissionList needs initialization or is empty (for demo purpose)
    let list = AppStorage.get<AdmissionItemType[]>('admissionList');
    
    if (!list || list.length === 0) {
      // 目标4.6: 添加一个已审核的入住申请演示样例，用户需存在于用户档案
      // 尝试从 UserDataSource 查找 "赵智晟"
      const userDS = AppStorage.get<UserDataSource>('userDataSource');
      let patientId = 'mock_id_001';
      let patientName = '赵智晟';
      
      if (userDS) {
         const users = userDS.getAll();
         const found = users.find(u => u.name === '赵智晟');
         if (found) {
            patientId = found.uid || 'mock_id_001';
            patientName = found.name;
         }
      }

      const demoItem = new AdmissionItemType(
        1,
        patientId,
        patientName,
        '1', '阳光康养中心',
        '1', '普通康养区',
        '101', '101室（单人间）',
        '2024-09-12 10:00', // Example time
        '已通过',
        '系统演示数据'
      );
      
      AppStorage.setOrCreate('admissionList', [demoItem]);
    }
  }

  // 处理申请入住按钮点击事件
  handleApplyClick(): void {
    this.pathStack.pushPathByName('AdmissionForm', null);
  }

  // 处理卡片点击事件 (未来可扩展查看详情功能)
  handleItemClick(item: AdmissionItemType): void {
    // 暂时不处理,未来可跳转到详情页
    console.log('点击了入住申请:', item.patientName);
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
          Text($r('app.string.admission_title'))
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

        // 入住申请列表视图（不包含按钮）
        AdmissionListView({
          onApplyClick: () => {
            this.handleApplyClick();
          },
          onItemClick: (item: AdmissionItemType) => {
            this.handleItemClick(item);
          }
        })
        
        // 底部申请入住按钮
        Column() {
          Button($r('app.string.admission_apply'))
            .width(CommonConstants.FULL_PARENT)
            .height($r('app.float.height_48'))
            .fontSize($r('app.float.font_size_18'))
            .fontWeight(600)
            .backgroundColor($r('app.color.green1'))
            .borderRadius($r('app.float.distance_24'))
            .onClick(() => {
              this.handleApplyClick();
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
