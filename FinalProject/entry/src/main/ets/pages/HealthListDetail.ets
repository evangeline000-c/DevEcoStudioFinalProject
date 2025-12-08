//健康资讯详情界面
//HealthListDetail()的入口函数

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

  @State videoSrc: Resource = $rawfile('health_video1.mp4');
  @State previewUri: Resource = $r('app.media.health_video_poster1');
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;
  @State isAutoPlay: boolean = false;
  @State showControls: boolean = true;
  @State isShortcutKeyEnabled: boolean = false;
  @State showFirstFrame: boolean = false;
  controller: VideoController = new VideoController();
  @State health_title:string='老年痴呆';
  @State health_introduction: string = "老年痴呆症是一种以进行性认知功能减退为核心的神经系统退行性疾病，主要表现为记忆衰退、思维障碍、行为改变，" +
    "严重影响日常生活能力，其中阿尔茨海默病占比最高（60%-80%）。目前尚无根治手段，但早期干预可延缓病程。";





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


  }
}