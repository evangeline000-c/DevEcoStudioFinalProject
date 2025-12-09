//资讯组件
import HealthResourceList from '../viewmodel/HealthListcomponent';
import PutDownRefresh from '../viewmodel/PutDownRefreshLayout';

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
      Text('健康资讯列表')
        .height('60vp')
        .width('100%')
        .fontWeight(220)//字体粗细
        .fontSize('20fp')//字体大小
        .backgroundColor('#0021deb4')
        .fontColor('#FFFFFF')
        .textAlign(TextAlign.Center)

      //纵向列表
      Column(){
        //"健康宣教"标题
        Row() {
          Column(){
            Text("健康资讯")
              .fontSize(30)
              .fontWeight(700)


            Divider()
              .vertical(false)
              .strokeWidth(3)
              .height(5)
              .color('#ff000000')  // 横条颜色
              .width('30vp')

          }
          .width('40%')
          .margin({left:'12vp',top:'5vp'})
          .alignItems(HorizontalAlign.Start)

          Row(){
            Image($r('app.media.news_photo'))
              .width('130vp')
              .objectFit(ImageFit.Contain)

          }.margin({left:'65vp'})
          //.backgroundColor('#00FFFFFFF')


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
        }//.margin({top:'3vp'})
        .layoutWeight(1)
        .onTouch((event?: TouchEvent) => {
          this.putDownRefresh(event);
        })


      }.backgroundColor('#fff1f0f0')
      .width('100%')
      //.height('500vp')
      .layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#d821deb4')
  }
}