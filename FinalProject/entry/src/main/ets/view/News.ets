//资讯组件
import HealthResourceList from '../viewmodel/HealthListcomponent';
import PutDownRefresh from '../viewmodel/PutDownRefreshLayout';
import CommonConstants from '../common/CommonContants'

@Component
export default struct News {

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
    Column() {
      //标题部分
      Text($r('app.string.news_list_title'))
        .height($r('app.float.height_text'))
        .width(CommonConstants.FULL_PARENT)
        .fontWeight($r('app.float.font_weight_220'))//字体粗细
        .fontSize($r('app.float.font_size'))//字体大小
        .backgroundColor($r('app.color.green1'))
        .fontColor($r('app.color.white'))
        .textAlign(TextAlign.Center)

      //纵向列表
      Column(){
        //"健康宣教"标题
        Row() {
          Column(){
            Text($r('app.string.news_title'))
              .fontSize($r('app.float.font_size_30'))
              .fontWeight($r('app.float.font_weight_700'))


            Divider()
              .vertical(false)
              .strokeWidth(3)
              .height($r('app.float.distance_5'))
              .color($r('app.color.black'))  // 横条颜色
              .width($r('app.float.distance_30'))

          }
          .width(CommonConstants.FORTY_PERCENT)
          .margin({left:$r('app.float.distance_12'),top:$r('app.float.distance_5')})
          .alignItems(HorizontalAlign.Start)

          Row(){
            Image($r('app.media.news_photo'))
              .width($r('app.float.distance_130'))
              .objectFit(ImageFit.Contain)

          }.margin({left:$r('app.float.distance_65')})


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
        }//.margin({top:$r('app.float.distance_3')})
        .layoutWeight(1)
        .onTouch((event?: TouchEvent) => {
          this.putDownRefresh(event);
        })


      }.backgroundColor($r('app.color.gray'))
      .width(CommonConstants.FULL_PARENT)
      //.height('500vp')
      .layoutWeight(1)

    }
    .width(CommonConstants.FULL_PARENT)
    .height(CommonConstants.FULL_PARENT)
    .backgroundColor($r('app.color.main_green'))
  }
}