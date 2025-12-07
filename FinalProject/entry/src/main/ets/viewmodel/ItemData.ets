export default class ItemData {
  //序号
  id: number;
  //文字
  title: ResourceStr;
  //图片
  img: Resource;
  //其他信息
  others?: ResourceStr;

  constructor(id: number, title: ResourceStr, img: Resource, others?: ResourceStr) {
    this.id = id;
    this.title = title;
    this.img = img;
    this.others = others;
  }
}


//健康宣教的数据
export class HealthResourcesItemType {
  ResourceName: string;
  ResourcePhoto: Resource;


  constructor(ResourceName: string, ResourcePhoto: Resource) {
    this.ResourceName = ResourceName;
    this.ResourcePhoto = ResourcePhoto;

  }
}

export const HealthResourcesList: HealthResourcesItemType[] = [
  new HealthResourcesItemType('高血压',$r('app.media.health_resource1')),
  new HealthResourcesItemType('骨质增生',$r('app.media.health_resource4')),
  new HealthResourcesItemType('老年痴呆', $r('app.media.health_resource3')),
  new HealthResourcesItemType('帕金森', $r('app.media.health_resource2'))
]