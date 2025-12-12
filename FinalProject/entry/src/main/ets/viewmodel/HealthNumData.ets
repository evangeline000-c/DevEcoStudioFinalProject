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

export interface UserAndPart {
  user: string; // 用户名
  part: "heartRate" | "oxygen" | "pressure" | "sleep" | "stress" | "sugar" |"temperature"; // 指标名
}

export const heartRateData: HealthData = {
  label: '心率',
  value: '72',
  unit: 'bpm',
  type: 'line',
  history: [88,63,93,78]
};

export const healthDataList: HealthData[] = [
  {
    label: '血氧饱和度',
    value: '98',
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
    history: [30, 32, 28, 25, 32]
  }
];

export const users: string[] = ["赵智晟", "王国栋"];