//健康资讯list数据处理
import { HealthResourcesList, HealthResourcesItemType } from './MainViewModel';

/**
 * 创建一个重复放大后的列表，用于初始化懒加载数据
 */
const createListRange = (): HealthResourcesItemType[] => {
  let result = new Array<HealthResourcesItemType>();
  for (let i = 0; i < 1; i++) {
    result = result.concat(HealthResourcesList);
  }
  return result;
}


/**
 * 懒加载基础类
 */
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): HealthResourcesItemType | undefined {
    return undefined;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const position = this.listeners.indexOf(listener);
    if (position >= 0) {
      this.listeners.splice(position, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    })
  }
}

export class ListDataSource extends BasicDataSource {
  private listData = createListRange();

  public totalCount(): number {
    return this.listData.length;
  }

  public getData(index: number): HealthResourcesItemType {
    return this.listData[index];
  }

  public pushData(): void {
    if (this.listData.length < 20) { //20是列表加载的最大数量
      this.listData = this.listData.concat(HealthResourcesList);
      this.notifyDataAdd(this.listData.length - 1);
    }
  }
}