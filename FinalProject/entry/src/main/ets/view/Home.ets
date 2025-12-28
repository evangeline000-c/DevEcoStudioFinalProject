//首页组件
import ItemData from '../viewmodel/ItemData';
import MainViewModel from '../viewmodel/MainViewModel';
import HealthResourceList from '../viewmodel/HealthListcomponent';
import PutDownRefresh from '../viewmodel/PutDownRefreshLayout';
import CommonConstants from '../common/CommonContants'

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
        Text($r('app.string.tab_home'))
          .height($r('app.float.height_text'))
          .width(CommonConstants.FULL_PARENT)
          .fontWeight($r('app.float.font_weight_220'))//字体粗细
          .fontSize($r('app.float.font_size'))//字体大小
          .backgroundColor($r('app.color.green1'))
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)

        //轮播图
        Swiper() {
          ForEach(MainViewModel.getSwiperImages(), (img: Resource) => {
            Image(img)
              .width(CommonConstants.FULL_PARENT)
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
                  .width($r('app.float.distance_65'))
                  .height($r('app.float.distance_65'))
                  .margin({top:$r('app.float.distance_10')})
                Text(item.title)
                  .fontSize($r('app.float.font_size_18'))
                  .margin({top:$r('app.float.distance_10')})
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
        .width(CommonConstants.PARENT_NINETY_SEVEN)
        .backgroundColor($r('app.color.white'))
        .height($r('app.float.distance_120'))
        .margin({top:$r('app.float.distance_8')})
        .borderRadius($r('app.float.distance_10'))

        //纵向列表
        Column(){
          //"健康宣教"标题
          Row() {
            Divider()
              .vertical(true)
              .strokeWidth(4)          // 竖条宽度
              .height($r('app.float.distance_20'))        // 竖条高度（根据文字调整）
              .color($r('app.color.main_green'))  // 竖条颜色
              .margin({ left: $r('app.float.distance_8') ,right:$r('app.float.distance_8')})

            Text($r('app.string.health_education'))
              .fontSize($r('app.float.font_size_18'))
          }.margin({top:$r('app.float.distance_12')})
          .width(CommonConstants.FULL_PARENT)

          Scroll(){
            Column(){
              if (this.refreshStatus) {
                PutDownRefresh({ refreshText: $refreshText })
              }
                HealthResourceList()
               Text($r('app.string.end_of_list')).fontSize($r('app.float.distance_12')).fontColor(Color.Gray)
            }
          }.margin({top:$r('app.float.distance_12')})
          .layoutWeight(1)
          .onTouch((event?: TouchEvent) => {
            this.putDownRefresh(event);
          })


        }.backgroundColor($r('app.color.gray'))
         .margin({top:$r('app.float.distance_8')})
         .width(CommonConstants.FULL_PARENT)
         .height($r('app.float.height_318'))



      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      .backgroundColor($r('app.color.black2'))
    }.width(CommonConstants.FULL_PARENT)

  }
}