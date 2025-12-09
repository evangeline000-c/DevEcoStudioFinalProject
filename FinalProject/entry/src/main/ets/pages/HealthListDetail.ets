//健康资讯详情界面
//HealthListDetail()的入口函数
import { HealthResourcesItemType,HealthResourcesList } from '../viewmodel/MainViewModel';

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
              .width(30)
              .height(30)

          }.backgroundColor('#00000000')
          .margin({left:'5vp'})
          .onClick(()=>{
              this.pathStack.pop()
          })
          Row(){
            Text('健康资讯详情')
              .height('60vp')
              .fontWeight(220)//字体粗细
              .fontSize('20fp')//字体大小
              .backgroundColor('#0021deb4')
              //.backgroundColor('#ffd41c1c')
              .fontColor('#FFFFFF')
          }
          .margin({left:'100vp'})


        }.width('100%')

        //视频
        Column(){
          Video({
            src: this.videoSrc,
            previewUri: this.previewUri, // 设置预览图。
            currentProgressRate: this.curRate, // 设置播放速度。
            controller: this.controller,
            posterOptions: { showFirstFrame: this.showFirstFrame } // 关闭首帧送显。
          }).objectFit(ImageFit.Contain)
            .width('100%')
            .height('200vp')
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
                .width(12)
                .height(12)
                .margin({top:'5vp'})
              Text(this.health_title)
                .fontSize('18vp')
                .fontColor('#FF000000')
                .margin({left:'5vp',top:'5vp'})
            }.width('95%')
            .height('30vp')
            .backgroundColor('#ffffffff')
            .margin({top:'5vp'})

            Text(this.health_introduction)
              .fontColor(Color.Gray)
              .fontSize('15vp')
              .width('95%')
              .margin({top:'5vp',bottom:'7vp'})


          }.width('95%')
          .backgroundColor('#ffffffff')
          .borderRadius('10vp')
          .margin({top:'12vp'})
        }.width('100%')
        .backgroundColor('#FFFFFF')
        .layoutWeight(1)
        .linearGradient({
          direction: GradientDirection.Bottom, // 渐变方向
          repeating: false, // 渐变颜色是否重复
          colors: [['#ff21deb4',0.15],['#FFFFFF',0.85]] // 数组末尾元素占比小于1时满足重复着色效果
        })

      }
      .width('100%')
      .height('100%')
      //.backgroundColor('#d821deb4')


    }.hideTitleBar(true) //如果为true就没有返回的箭头
    .backgroundColor('#ff21deb4')
    .onReady((context:NavDestinationContext)=>{
      this.pageParam = context.pathInfo.param as HealthResourcesItemType
      this.health_title=this.pageParam.ResourceName
      this.videoSrc=this.pageParam.ResourceVideo
      this.previewUri=this.pageParam.ResourcePoster
      this.health_introduction=this.pageParam.ResourceIntroduction
    })


  }
}