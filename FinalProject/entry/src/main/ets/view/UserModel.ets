// 用户数据类型
export interface UserInfo {
  uid?: string;
  name: string;
  gender: '男性' | '女性';
  relation: string;
  birthday?: string;
  idCard?: string;
  address?: string;
  job?: string;
}


// 加载数据源
export class UserDataSource implements IDataSource {
  private data: UserInfo[] = [];
  private listener: DataChangeListener | null = null;

  private generateUid(): string {
    return `${Date.now()}_${Math.random().toString(16).slice(2)}`;
  }

  private ensureUid(user: UserInfo): UserInfo {
    if (!user.uid) {
      user.uid = this.generateUid();
    }
    return user;
  }

  private cloneUser(user: UserInfo): UserInfo {
    const cloned: UserInfo = {
      uid: user.uid,
      name: user.name,
      gender: user.gender,
      relation: user.relation,
      birthday: user.birthday,
      idCard: user.idCard,
      address: user.address,
      job: user.job,
    };
    return cloned;
  }

  // 初始化数据
  constructor(initialData: UserInfo[] = []) {
    this.data = initialData.map(item => this.ensureUid(this.cloneUser(item)));
  }

  // 获取所有数据（用于外部取数）
  getData(index: number): UserInfo {
    return this.data[index];
  }

  // 获取全部数据快照
  getAll(): UserInfo[] {
    return [...this.data];
  }

  // 添加新数据
  addData(newData: UserInfo[]): void {
    const startIndex = this.data.length;
    this.data.push(...newData.map(item => this.ensureUid(this.cloneUser(item))));
    this.listener?.onDataAdd(startIndex);
  }

  // 插入单个用户
  insertUser(user: UserInfo): void {
    const startIndex = this.data.length;
    this.data.push(this.ensureUid(this.cloneUser(user)));
    this.listener?.onDataAdd(startIndex);
  }

  // 实现 IDataSource 接口方法
  totalCount(): number {
    return this.data.length;
  }

  getItem(): UserInfo[] {
    return this.data;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener;
  }

  unregisterDataChangeListener(): void {
    this.listener = null;
  }

  // 提供稳定ID，供列表复用识别
  getId(index: number): string {
    const item = this.data[index];
    return item?.uid ?? String(index);
  }

  // 根据索引批量删除
  removeIndices(indices: number[]): void {
    if (!indices || indices.length === 0) {
      return;
    }
    const filtered = Array.from(new Set(indices.filter(i => i >= 0 && i < this.data.length))).sort((a,b)=>a-b);
    if (filtered.length === 0) return;
    const uids = filtered.map(i => this.data[i]?.uid ?? `idx:${i}`);
    this.removeByUids(uids);
  }

  // 按 uid 批量删除
  removeByUids(uids: string[]): void {
    if (!uids || uids.length === 0) return;
    const set = new Set(uids.filter(Boolean));
    // 记录需删除的原始索引
    const toRemove: number[] = [];
    for (let i = 0; i < this.data.length; i++) {
      const uid = this.data[i]?.uid ?? '';
      if (set.has(uid)) toRemove.push(i);
    }
    if (toRemove.length === 0) return;
    toRemove.sort((a,b)=>a-b);
    // 重建数组
    const newArr: UserInfo[] = [];
    let p = 0; let r = 0;
    while (p < this.data.length) {
      if (r < toRemove.length && p === toRemove[r]) {
        p++; r++; // skip deleted
      } else {
        newArr.push(this.data[p++]);
      }
    }
    this.data = newArr;
    // 逐条删除
    if (this.listener) {
      if (this.listener.onDataDelete) {
        for (let k = 0; k < toRemove.length; k++) {
          const adjusted = toRemove[k] - k; // 前面已删除k项
          this.listener.onDataDelete(adjusted);
        }
      } else if (this.listener.onDataChange) {
        this.listener.onDataChange(0);
      }
    }
  }


}