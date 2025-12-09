//首页组件
import ItemData from '../viewmodel/ItemData';
import MainViewModel from '../viewmodel/MainViewModel';
import HealthResourceList from '../viewmodel/HealthListcomponent';
import PutDownRefresh from '../viewmodel/PutDownRefreshLayout';

@Component
export default struct Home {

  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;//跳转页面相关 不要删
  Consultation(result: boolean): void {
    //跳转页面相关 不要删
    this.pathStack.pushPathByName('Consultation', null);
  }
  ServiceOrders(result: boolean): void {
    //跳转页面相关 不要删
    this.pathStack.pushPathByName('ServiceOrders', null);
  }
  ServiceProcurement(result: boolean): void {
    //跳转页面相关 不要删
    this.pathStack.pushPathByName('ServiceProcurement', null);
  }
  Admission(result: boolean): void {
    //跳转页面相关 不要删
    this.pathStack.pushPathByName('Admission', null);
  }

  @State refreshStatus: boolean = false;
  @State refreshText: string = '加载中';
  private currentOffsetY: number = 0;
  private timer: number = 0;
  @State tabsIndex: number = 0;

  putDownRefresh(event?: TouchEvent): void {
    if (event === undefined) {
      return;
    }
    switch (event.type) {
      // Record the y-coordinate pressed by the finger.
      case TouchType.Down:
        this.currentOffsetY = event.touches[0].y;
        break;
      case TouchType.Move:
        // Determine whether to refresh based on the drop-down offset.
        this.refreshStatus = event.touches[0].y - this.currentOffsetY > 100;
        break;
      case TouchType.Cancel:
        break;
      case TouchType.Up:
        // Only simulation effect, no data request.
        this.timer = setTimeout(() => {
          this.refreshStatus = false;
        }, 1500);
        break;
      default:
        break;
    }
  }

  build() {
    NavDestination(){
      Column() {
        //标题部分
        Text('首页')
          .height('60vp')
          .width('100%')
          .fontWeight(220)//字体粗细
          .fontSize('20fp')//字体大小
          .backgroundColor('#d821deb4')
          .fontColor('#FFFFFF')
          .textAlign(TextAlign.Center)

        //轮播图
        Swiper() {
          ForEach(MainViewModel.getSwiperImages(), (img: Resource) => {
            Image(img)
              .width('100%')
          }, (img: Resource) => JSON.stringify(img.id))
        }.autoPlay(true)
        .indicator(
          Indicator.dot()
            .selectedColor(Color.Green)
        )

        //导航宫格
        Grid(){
          ForEach(MainViewModel.getFirstGridData(),(item:ItemData,index:number)=>{
            GridItem(){
              Column(){
                Image(item.img)
                  .width('65vp')
                  .height('65vp')
                  .margin({top:'10vp'})
                Text(item.title)
                  .fontSize('18fp')
                  .margin({top:'10vp'})
              }
              .onClick(()=>{
                if(index==0) this.Consultation(true);
                else if(index==1) this.ServiceOrders(true);
                else if(index==2) this.ServiceProcurement(true);
                else if(index==3) this.Admission(true);
              })
            }
          },(item:ItemData)=>JSON.stringify(item))
        }.columnsTemplate('1fr 1fr 1fr 1fr')
        .width('97%')
        .backgroundColor('#FFFFFF')
        .height('120vp')
        .margin({top:'8vp'})
        .borderRadius('10vp')

        //纵向列表
        Column(){
          //"健康宣教"标题
          Row() {
            Divider()
              .vertical(true)
              .strokeWidth(4)          // 竖条宽度
              .height(20)        // 竖条高度（根据文字调整）
              .color('#d821deb4')  // 竖条颜色
              .margin({ left: '8vp' ,right:'8vp'})

            Text("健康宣教")
              .fontSize(18)
          }.margin({top:'12vp'})
          .width('100%')

          Scroll(){
            Column(){
              if (this.refreshStatus) {
                PutDownRefresh({ refreshText: $refreshText })
              }
                HealthResourceList()
               Text('--到底了--').fontSize('12vp').fontColor(Color.Gray)
            }
          }.margin({top:'12vp'})
          .layoutWeight(1)
          .onTouch((event?: TouchEvent) => {
            this.putDownRefresh(event);
          })


        }.backgroundColor('#fff1f0f0')
         .margin({top:'8vp'})
         .width('100%')
         .height('318vp')



      }
      .width('100%')
      .height('100%')
      .backgroundColor('#0021deb4')
    }.width('100%')

  }
}