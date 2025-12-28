import {type historyItem} from './HealthNumData'
import CommonConstants from '../common/CommonContants'

@Component
export default struct HealthForm{

  @Prop data: historyItem[];
  @Prop part: string;

  @Builder
  Cell(content: string, isHeader: boolean = false) {
    Text(content)
      .fontSize(isHeader ? 16 : $r('app.float.font_size_14'))
      .fontWeight(isHeader ? $r('app.float.font_weight_500') : FontWeight.Normal)
      .fontColor( Color.Black)
      .textAlign(TextAlign.Center)
      .width(CommonConstants.FULL_PARENT)
      .height($r('app.float.distance_40'))
      .padding($r('app.float.distance_5'))
      .backgroundColor(isHeader ? '#D9D9D9' : Color.White)
  }

  build(){
    List() {
    // --- 1. 表格头部 (Header) ---
    ListItem() {
      GridRow({ columns: 7 }) {
        // 数值列 (占 4 份)
        GridCol({ span: 2 }) {
          this.Cell(this.part, true)
        }
        // 时间列 (占 3 份)
        GridCol({ span: 5 }) {
          this.Cell('测量时间', true)
        }
      }
    }
    .backgroundColor(Color.Blue) // 表头背景

    // --- 2. 表格数据行 (Data Rows) ---
    ForEach(this.data, (item: historyItem) => {
      ListItem() {
        GridRow({ columns: 7 }) {
          // 数值
          GridCol({ span: 2 }) {
            this.Cell(String(item.value))
          }
          // 时间
          GridCol({ span: 5 }) {
            this.Cell(item.time)
          }
        }
      }
    })
  }
  .width(CommonConstants.FULL_PARENT)
  .divider({ strokeWidth: 1, color: '#CCCCCC' }) // List 分隔线
  }
}
