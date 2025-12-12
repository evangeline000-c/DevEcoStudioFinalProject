export interface SleepItem {
  value: number; // 数值，例如 2.5 小时
  name: string; // 名称，例如 "深度睡眠"
}

export interface HealthData {
  label: string; // 标签（如：心率、血氧等）
  value: string; // 数值
  unit: string; // 单位
  type?: "line" | "bar" | "pie" | "simple"; //可选：图表类型
  history?: number[]; // 可选：历史数据（用于图表）
  sleepData?: SleepItem[]; // 可选：睡眠数据;
}

export interface userData {
  id: number; // 数值，用户的编号
  name: string; //名称，用户的名字
}

// 心率单独渲染，用户的 id 对应数据即为数组的索引
export const heartRateData: HealthData[] = [
  {
    label: '心率',
    value: '88',
    unit: 'bpm',
    type: 'line',
    history: [88,63,93,78]
  },
  {
    label: '心率',
    value: '62',
    unit: 'bpm',
    type: 'line',
    history: [62,70,90,63]
  },   
];

export const healthDataList: Array<HealthData[]> = [
  [
    {
      label: '血氧饱和度',
      value: '96',
      unit: '%',
      type: 'bar',
      history: [96, 97, 91, 94, 97]
    },
    {
      label: '体温',
      value: '36.5',
      unit: '°C',
    },
    {
      label: '血压',
      value: '120/80',
      unit: 'mmHg',
    },
    {
      label: '血糖',
      value: '5.2',
      unit: 'mmol/L',
      history: [5.0, 5.1, 5.2, 5.3, 5.2]
    },
    {
      label: '睡眠',
      value: '7.5',
      sleepData:[{value:2.5, name:'深度'},{value:5, name:'浅度'}],
      unit: '小时',
      type: 'pie',
    },
    {
      label: '压力',
      value: '32',
      unit: '%',
      type: 'bar',
      history: [32, 30, 28, 25, 38]
    }
  ],
  [
    {
      label: '血氧饱和度',
      value: '93',
      unit: '%',
      type: 'bar',
      history: [93, 99, 92, 95, 97]
    },
    {
      label: '体温',
      value: '36.7',
      unit: '°C',
    },
    {
      label: '血压',
      value: '115/75',
      unit: 'mmHg',
    },
    {
      label: '血糖',
      value: '5.1',
      unit: 'mmol/L',
      history: [5.1, 5.0, 5.3, 5.2, 5.2]
    },
    {
      label: '睡眠',
      value: '9.5',
      sleepData:[{value:3.5, name:'深度'},{value:6, name:'浅度'}],
      unit: '小时',
      type: 'pie',
    },
    {
      label: '压力',
      value: '25',
      unit: '%',
      type: 'bar',
      history: [25, 28, 30, 26, 33]
    }
  ],
];

export const users: userData[] = [
  {
    id: 0,
    name: "赵智晟",
  },
  {
    id: 1,
    name: "王国栋"
  }
];