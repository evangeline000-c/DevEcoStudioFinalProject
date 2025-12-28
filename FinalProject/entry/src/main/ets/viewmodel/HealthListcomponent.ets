//健康资讯List部分的组件

import { HealthResourcesItemType } from '../viewmodel/MainViewModel';
import { ListDataSource } from '../viewmodel/HealthListData';
import CommonConstants from '../common/CommonContants'

@Component
export default struct HealthResourceList {
  @Provide HealthResourceListData: ListDataSource = new ListDataSource();
  private startTouchOffsetY: number = 0;
  private endTouchOffsetY: number = 0;

  pathStack: NavPathStack = AppStorage.get("pathStack") as NavPathStack;//跳转页面相关 不要删
  // HealthListDetail(result: boolean): void {
  //   //跳转页面相关 不要删
  //   this.pathStack.pushPathByName('HealthListDetail', null);
  // }
  HealthListDetail(item:HealthResourcesItemType):void{
    this.pathStack.pushPathByName('HealthListDetail',item)
  }

  build() {

      Row() {
        List({ space: 16 }) {
          LazyForEach(this.HealthResourceListData, (item: HealthResourcesItemType) => {
            ListItem() {
              Button() {
                Column() {
                  Image(item?.ResourcePhoto)
                    .width(CommonConstants.FULL_PARENT)
                    .objectFit(ImageFit.Contain)
                    //.height($r('app.float.bottom_150'))
                    .borderRadius({ topLeft: $r('app.float.distance_10'), topRight: $r('app.float.distance_10') })
                    .margin({ top: $r('app.float.distance_0') })
                  Row() {
                    Row() {
                      Image($r('app.media.health_resource_title'))
                        .height($r('app.float.distance_24'))
                        .objectFit(ImageFit.Contain)

                      Text(item?.ResourceName)
                        .fontSize($r('app.float.health_font_size'))
                        .margin({ left: $r('app.float.distance_8') })
                    }.margin({ top: $r('app.float.distance_10') })
                    .alignItems(VerticalAlign.Center)
                    .width(CommonConstants.FULL_PARENT)
                  }.backgroundColor($r('app.color.gray2'))
                  .flexGrow(1)

                }.width(CommonConstants.FULL_PARENT)
                .height(CommonConstants.FULL_PARENT)
              }
              .width(CommonConstants.PARENT_NINETY_FIVE)
              .height($r('app.float.height_258'))
              .backgroundColor($r('app.color.gray3'))
              .borderRadius($r('app.float.distance_10'))
              .margin({ left: $r('app.float.distance_10') })
              .onClick(() => {
                //this.HealthListDetail(true)
                this.HealthListDetail(item)
              })

            }
            .onTouch((event?: TouchEvent) => {
              if (event === undefined) {
                return;
              }
              switch (event.type) {
                case TouchType.Down:
                  this.startTouchOffsetY = event.touches[0].y;
                  break;
                case TouchType.Up:
                  this.startTouchOffsetY = event.touches[0].y;
                  break;
                case TouchType.Move:
                  if (this.startTouchOffsetY - this.endTouchOffsetY > 0) {
                    this.HealthResourceListData.pushData();
                  }
                  break;
              }
            })
          })
        }
        .width(CommonConstants.FULL_PARENT)
      }
      .justifyContent(FlexAlign.Center)
      .width(CommonConstants.FULL_PARENT)
    }

}