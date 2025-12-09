//封装主页面所需要的所有数据源
import ItemData from './ItemData';

export class MainViewModel{
  //轮播图数据源配置
  getSwiperImages(): Array<Resource>{
    let swiperImages:Resource[]=[
      $r('app.media.home1'),
      $r('app.media.home2'),
      $r('app.media.home3')
    ];
    return swiperImages;
  }

  //宫格导航数据源配置
  getFirstGridData():Array<ItemData>{
    let FirstGridData:ItemData[]=[
      new ItemData(0,'问诊记录',$r('app.media.home4')),
      new ItemData(1,'服务订单',$r('app.media.home5')),
      new ItemData(2,'服务采购',$r('app.media.home6')),
      new ItemData(3,'入住申请',$r('app.media.home7'))
    ]
    return FirstGridData;
  }
}

export default new MainViewModel();

//健康宣教的数据(包括详情页)
export class HealthResourcesItemType {
  ResourceName: string;
  ResourcePhoto: Resource;
  ResourceVideo: Resource;
  ResourcePoster:Resource;
  ResourceIntroduction:string;


  constructor(ResourceName: string, ResourcePhoto: Resource,ResourceVideo:Resource,ResourcePoster:Resource,ResourceIntroduction:string) {
    this.ResourceName = ResourceName;
    this.ResourcePhoto = ResourcePhoto;
    this.ResourceVideo=ResourceVideo;
    this.ResourcePoster=ResourcePoster;
    this.ResourceIntroduction=ResourceIntroduction;
  }
}

export const HealthResourcesList: HealthResourcesItemType[] = [
  new HealthResourcesItemType('高血压',$r('app.media.health_resource1'),$rawfile('health_video1.mp4'),$r('app.media.health_video_poster1'),
    '高血压的典型症状包括头痛、疲倦或不安、心律失常、心悸耳鸣等。然而，许多高血压患者可能在没有任何症状的情况下已出现其他并发症，如脑卒中、视物模糊、意识丧失、失忆等，所以高血压被称为“无声的杀手”。对于高血压患者，改善生活方式和药物治疗是最常用的治疗方式。'),
  new HealthResourcesItemType('骨质增生',$r('app.media.health_resource4'),$rawfile('health_video4.mp4'),$r('app.media.health_video_poster4'),
    '骨质增生是关节或骨骼边缘因长期磨损、退化或修复反应形成的骨性突起，俗称“骨刺”，常见于中老年人群的颈椎、腰椎、膝关节等部位。它是人体为稳定关节、减少异常摩擦产生的代偿性增生，可能无症状，也可能引发疼痛、活动受限等问题。'),
  new HealthResourcesItemType('老年痴呆', $r('app.media.health_resource3'),$rawfile('health_video3.mp4'),$r('app.media.health_video_poster3'),
    '老年痴呆症是一种以进行性认知功能减退为核心的神经系统退行性疾病，主要表现为记忆衰退、思维障碍、行为改变，严重影响日常生活能力，其中阿尔茨海默病占比最高（60%-80%）。目前尚无根治手段，但早期干预可延缓病程。'),
  new HealthResourcesItemType('帕金森', $r('app.media.health_resource2'),$rawfile('health_video2.mp4'),$r('app.media.health_video_poster2'),
  '帕金森氏疾病（又称震颤麻痹）是中枢神经系统变性疾病，核心病理改变为中脑黑质多巴胺能神经元死亡导致多巴胺分泌不足，临床表现为运动迟缓、静止性震颤、肌强直等运动症状及嗅觉减退、便秘等非运动症状。')
]

