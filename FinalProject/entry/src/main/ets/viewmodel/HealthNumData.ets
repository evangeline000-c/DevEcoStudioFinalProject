export interface SleepItem {
  value: number; // 数值，例如 2.5 小时
  name: string; // 名称，例如 "深度睡眠"
}

export interface historyItem {
  value: number; // 数值
  time: string; // 记录时间
}

export interface HealthData {
  label: string; // 标签（如：心率、血氧等）
  value: string; // 数值
  unit: string; // 单位
  type?: "line" | "bar" | "pie" | "simple"; //可选：图表类型
  history?: number[]; // 可选：历史数据（用于图表）
  historyWithTime?: historyItem[]; // 可选：带时间的历史数据
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
    history: [88, 75, 95, 72],
    historyWithTime: [
      { value: 88, time: '2025-12-12 21:05:00' }, 
      { value: 75, time: '2025-12-12 15:30:00' },
      { value: 95, time: '2025-12-11 23:15:00' },
      { value: 72, time: '2025-12-11 08:45:00' }, 
    ],
  },
  {
    label: '心率',
    value: '62',
    unit: 'bpm',
    type: 'line',
    history: [62, 80, 70, 85],
    historyWithTime: [
      { value: 62, time: '2025-12-12 22:15:00' },
      { value: 80, time: '2025-12-12 12:30:00' },
      { value: 70, time: '2025-12-11 20:15:00' },
      { value: 60, time: '2025-12-11 06:45:00' },
    ],
  },   
];

export const healthDataList: Array<HealthData[]> = [
  [
    {
      label: '血氧饱和度',
      value: '96',
      unit: '%',
      type: 'bar',
      history: [96, 97, 91, 94],
      historyWithTime: [
        { value: 96, time: '2025-12-12 18:00:00' },
        { value: 97, time: '2025-12-11 18:00:00' },
        { value: 91, time: '2025-12-10 18:00:00' },
        { value: 94, time: '2025-12-09 18:00:00' },
      ],
    },
    {
      label: '体温',
      value: '36.5',
      unit: '°C',
      history: [36.5, 36.6, 37.3, 36.4], 
      historyWithTime: [
        { value: 36.5, time: '2025-12-12 09:30:00' },
        { value: 36.6, time: '2025-12-11 09:30:00' },
        { value: 37.3, time: '2025-12-10 09:30:00' },
        { value: 36.4, time: '2025-12-09 09:30:00' },
      ],
    },
    {
      label: '血压',
      value: '120/80',
      unit: 'mmHg',
      history: [120, 80, 122, 78, 118, 85, 125, 80],
      historyWithTime: [
        { value: 120, time: '2025-12-12 10:00:00 (收)' },
        { value: 80, time: '2025-12-12 10:00:00 (舒)' },
        { value: 122, time: '2025-12-11 10:00:00 (收)' },
        { value: 78, time: '2025-12-11 10:00:00 (舒)' },
        { value: 118, time: '2025-12-10 10:00:00 (收)' },
        { value: 85, time: '2025-12-10 10:00:00 (舒)' },
        { value: 125, time: '2025-12-09 10:00:00 (收)' },
        { value: 80, time: '2025-12-09 10:00:00 (舒)' },
      ],
    },
    {
      label: '血糖',
      value: '5.2',
      unit: 'mmol/L',
      history: [5.2, 6.3, 7.5, 5.1],
      historyWithTime: [
        { value: 5.2, time: '2025-12-12 08:30:00' }, 
        { value: 6.3, time: '2025-12-11 18:30:00' },
        { value: 7.5, time: '2025-12-11 12:30:00' },
        { value: 5.1, time: '2025-12-11 08:30:00' }, 
      ],
    },
    {
      label: '睡眠',
      value: '7.5',
      sleepData:[{value:2.5, name:'深度'},{value:5, name:'浅度'}],
      unit: '小时',
      type: 'pie',
      historyWithTime: [
        { value: 7.5, time: '2025-12-12 8:05:00' }, 
      ],
    },
    {
      label: '压力',
      value: '32',
      unit: '%',
      type: 'bar',
      history: [32, 30, 28, 25], 
      historyWithTime: [
        { value: 32, time: '2025-12-12 17:00:00' },
        { value: 30, time: '2025-12-11 17:00:00' },
        { value: 28, time: '2025-12-10 17:00:00' },
        { value: 25, time: '2025-12-09 17:00:00' },
      ],
    }
  ],
  [
    {
      label: '血氧饱和度',
      value: '93',
      unit: '%',
      type: 'bar',
      history: [93, 99, 92, 95], 
      historyWithTime: [
        { value: 93, time: '2025-12-12 18:00:00' },
        { value: 99, time: '2025-12-11 18:00:00' },
        { value: 92, time: '2025-12-10 18:00:00' },
        { value: 95, time: '2025-12-09 18:00:00' },
      ],
    },
    {
      label: '体温',
      value: '36.7',
      unit: '°C',
      history: [36.7, 36.5, 36.8, 36.6], 
      historyWithTime: [
        { value: 36.7, time: '2025-12-12 09:30:00' },
        { value: 36.5, time: '2025-12-11 09:30:00' },
        { value: 36.8, time: '2025-12-10 09:30:00' },
        { value: 36.6, time: '2025-12-09 09:30:00' },
      ],
    },
    {
      label: '血压',
      value: '115/75',
      unit: 'mmHg',
      history: [115, 75, 110, 70, 120, 80, 118, 77],
      historyWithTime: [
        { value: 115, time: '2025-12-12 10:00:00 (收)' },
        { value: 75, time: '2025-12-12 10:00:00 (舒)' },
        { value: 110, time: '2025-12-11 10:00:00 (收)' },
        { value: 70, time: '2025-12-11 10:00:00 (舒)' },
        { value: 120, time: '2025-12-10 10:00:00 (收)' },
        { value: 80, time: '2025-12-10 10:00:00 (舒)' },
        { value: 118, time: '2025-12-09 10:00:00 (收)' },
        { value: 77, time: '2025-12-09 10:00:00 (舒)' },
      ],
    },
    {
      label: '血糖',
      value: '5.1',
      unit: 'mmol/L',
      history: [5.1, 6.0, 8.0, 4.9],
      historyWithTime: [
        { value: 5.1, time: '2025-12-12 08:30:00' },
        { value: 6.0, time: '2025-12-11 18:30:00' },
        { value: 8.0, time: '2025-12-11 12:30:00' },
        { value: 4.9, time: '2025-12-11 08:30:00' },
      ],
    },
    {
      label: '睡眠',
      value: '9.5',
      sleepData:[{value:3.5, name:'深度'},{value:6, name:'浅度'}],
      unit: '小时',
      type: 'pie',
      historyWithTime: [
        { value: 9.5, time: '2025-12-12 8:05:00' }, 
      ],
    },
    {
      label: '压力',
      value: '25',
      unit: '%',
      type: 'bar',
      history: [25, 28, 30, 26],
      historyWithTime: [
        { value: 25, time: '2025-12-12 17:00:00' },
        { value: 28, time: '2025-12-11 17:00:00' },
        { value: 30, time: '2025-12-10 17:00:00' },
        { value: 26, time: '2025-12-09 17:00:00' },
      ],
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