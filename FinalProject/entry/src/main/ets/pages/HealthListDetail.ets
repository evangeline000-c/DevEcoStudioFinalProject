//健康资讯详情界面
//HealthListDetail()的入口函数
import { HealthResourcesItemType,HealthResourcesList } from '../viewmodel/MainViewModel';
import CommonConstants from '../common/CommonContants'

@Builder
export function HealthListDetailBuilder() {
  HealthListDetail()
}

interface DurationObject {
  duration: number;
}

interface TimeObject {
  time: number;
}

interface FullscreenObject {
  fullscreen: boolean;
}


@Component
struct HealthListDetail{
  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;//跳转页面相关 不要删

  pageParam: HealthResourcesItemType =HealthResourcesList[0]

  //@State videoSrc: Resource = $rawfile('health_video1.mp4');
  @State videoSrc: Resource = this.pageParam.ResourceVideo
  @State previewUri: Resource = this.pageParam.ResourcePoster;
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;
  @State isAutoPlay: boolean = false;
  @State showControls: boolean = true;
  @State isShortcutKeyEnabled: boolean = false;
  @State showFirstFrame: boolean = false;
  controller: VideoController = new VideoController();
  @State health_title:string=this.pageParam.ResourceName
  @State health_introduction: string = this.pageParam.ResourceIntroduction;





  build() {
    NavDestination() {
      Column() {
        //标题部分
        Row(){
          Button(){
            Image($r('app.media.arrow_health'))
              .width($r('app.float.distance_30'))
              .height($r('app.float.distance_30'))

          }.backgroundColor(Color.Transparent)
          .margin({left:$r('app.float.distance_5')})
          .onClick(()=>{
              this.pathStack.pop()
          })
          Row(){
            Text($r('app.string.health_detail_title'))
              .height($r('app.float.height_text'))
              .fontWeight($r('app.float.font_weight_220'))//字体粗细
              .fontSize($r('app.float.font_size'))//字体大小
              .backgroundColor($r('app.color.black2'))
              .fontColor($r('app.color.white'))
          }
          .margin({left:$r('app.float.health_height')})


        }.width(CommonConstants.FULL_PARENT)

        //视频
        Column(){
          Video({
            src: this.videoSrc,
            previewUri: this.previewUri, // 设置预览图。
            currentProgressRate: this.curRate, // 设置播放速度。
            controller: this.controller,
            posterOptions: { showFirstFrame: this.showFirstFrame } // 关闭首帧送显。
          }).objectFit(ImageFit.Contain)
            .width(CommonConstants.FULL_PARENT)
            .height($r('app.float.height_200'))
            .autoPlay(this.isAutoPlay)
            .controls(this.showControls)
            .enableShortcutKey(this.isShortcutKeyEnabled)
            .onStart(() => {
              console.info('onStart');
            })
            .onPause(() => {
              console.info('onPause');
            })
            .onFinish(() => {
              console.info('onFinish');
            })
            .onError(() => {
              console.info('onError');
            })
            .onStop(() => {
              console.info('onStop');
            })
            .onPrepared((e?: DurationObject) => {
              if (e != undefined) {
                console.info('onPrepared is ' + e.duration);
              }
            })
            .onSeeking((e?: TimeObject) => {
              if (e != undefined) {
                console.info('onSeeking is ' + e.time);
              }
            })
            .onSeeked((e?: TimeObject) => {
              if (e != undefined) {
                console.info('onSeeked is ' + e.time);
              }
            })
            .onUpdate((e?: TimeObject) => {
              if (e != undefined) {
                console.info('onUpdate is ' + e.time);
              }
            })
            .onFullscreenChange((e?: FullscreenObject) => {
              if (e != undefined) {
                console.info('onFullscreenChange is ' + e.fullscreen);
              }

            })

          Column(){
            Row(){
              Image($r('app.media.health_resource_detail_tip'))
                .width($r('app.float.distance_12'))
                .height($r('app.float.distance_12'))
                .margin({top:$r('app.float.distance_5')})
              Text(this.health_title)
                .fontSize($r('app.float.health_font_size'))
                .fontColor($r('app.color.black'))
                .margin({left:$r('app.float.distance_5'),top:$r('app.float.distance_5')})
            }.width(CommonConstants.PARENT_NINETY_FIVE)
            .height($r('app.float.distance_30'))
            .backgroundColor($r('app.color.gray6'))
            .margin({top:$r('app.float.distance_5')})

            Text(this.health_introduction)
              .fontColor(Color.Gray)
              .fontSize($r('app.float.layout_15'))
              .width(CommonConstants.PARENT_NINETY_FIVE)
              .margin({top:$r('app.float.distance_5'),bottom:$r('app.float.bottom_7')})


          }.width(CommonConstants.PARENT_NINETY_FIVE)
          .backgroundColor($r('app.color.gray6'))
          .borderRadius($r('app.float.distance_10'))
          .margin({top:$r('app.float.distance_12')})
        }.width(CommonConstants.FULL_PARENT)
        .backgroundColor($r('app.color.white'))
        .layoutWeight(1)
        .linearGradient({
          direction: GradientDirection.Bottom, // 渐变方向
          repeating: false, // 渐变颜色是否重复
          colors: [[$r('app.color.green3'),0.15],[$r('app.color.white'),0.85]] // 数组末尾元素占比小于1时满足重复着色效果
        })

      }
      .width(CommonConstants.FULL_PARENT)
      .height(CommonConstants.FULL_PARENT)
      //.backgroundColor($r('app.color.main_green'))


    }.hideTitleBar(true) //如果为true就没有返回的箭头
    .backgroundColor($r('app.color.green3'))
    .onReady((context:NavDestinationContext)=>{
      this.pageParam = context.pathInfo.param as HealthResourcesItemType
      this.health_title=this.pageParam.ResourceName
      this.videoSrc=this.pageParam.ResourceVideo
      this.previewUri=this.pageParam.ResourcePoster
      this.health_introduction=this.pageParam.ResourceIntroduction
    })


  }
}