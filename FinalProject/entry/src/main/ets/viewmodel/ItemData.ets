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


