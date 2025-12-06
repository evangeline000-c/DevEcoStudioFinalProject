//首页组件
import ItemData from '../viewmodel/ItemData';
import MainViewModel from '../viewmodel/MainViewModel';

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

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#d821deb4')
    }.width('100%')

  }
}