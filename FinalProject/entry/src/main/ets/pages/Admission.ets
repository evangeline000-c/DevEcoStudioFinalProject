//入住申请页面
import { AdmissionItemType, AdmissionItemList } from '../viewmodel/AdmissionData';
import AdmissionListView from '../view/AdmissionListView';
import { UserDataSource } from '../view/UserModel';

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
            .width('24vp')
            .height('24vp')
            .margin({ left: '16vp' })
            .onClick(() => {
              this.pathStack.pop();
            })
          Text('入住申请')
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
          Button('申请入住')
            .width('100%')
            .height('48vp')
            .fontSize('18fp')
            .fontWeight(600)
            .backgroundColor('#21deb4')
            .borderRadius('24vp')
            .onClick(() => {
              this.handleApplyClick();
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
