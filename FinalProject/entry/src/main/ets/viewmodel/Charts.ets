import { Options } from '@mcui/mccharts';
import {HealthData} from './HealthNumData';

interface AxisTick {
  show: boolean
}

interface AxisLine {
  show: boolean
}

interface SplitLine {
  show: boolean
}

interface AxisLabel {
  fontSize: number
}

interface YAxisItem {
  axisTick?: AxisTick
  axisLine?: AxisLine
  splitLine?: SplitLine
  axisLabel?: AxisLabel
  boundaryGap?: boolean
}

interface BarStyle {
  width: number
  color: string
}

interface SeriesItem {
  name?: string
  data: number[]
  barStyle?: BarStyle
  yAxisIndex?: number
}

// 获取折线图配置
export function getLineChartOptions(data: HealthData, part: string = "heartRate"): Options {
  let minY = 60;
  let maxY = 100;

  if(part === "sugar"){
    minY = 3;
    maxY = 10;
  }else if(part === "temperature"){
    minY = 35;
    maxY = 42;
  }

  return new Options({
    grid:{
      left:5,
      right:5,
      top:5,
      bottom:5,
    },
    title: {
      show: false
    },
    xAxis: {
      data: data.history?.map((_, i) => String(i)) || [],
      axisTick: { 
      show: false, 
      },
      axisLine: { 
      show: false,
      },
      splitLine: { // 坐标轴中的分隔线。
        show: false,
      },
      axisLabel:{
        fontSize:0,
      },
      boundaryGap: false,
    },
    yAxis:{
      axisTick: { 
        show: false, 
      },
      axisLine: { 
        show: false,
      },
      splitLine: { // 坐标轴中的分隔线。
        show: false
      },
      axisLabel:{
        fontSize:0,
      },
      min: minY,
      max: maxY,
      boundaryGap: false,
    },
    series: [{
      name: data.label,
      data: data.history || [],
      smooth: true,
      lineStyle:{
        color:'#ff0000'
      },
      areaStyle:{
        show: true,
        gradient:['rgba(255, 0, 0,0.6)','#ffffff']
      },
    }
    ],
    legend:{
      show:false,
    }
  });
}

// 获取柱状图配置
export function getBarChartOptions(data: HealthData,  twoY: boolean = false): Options {
  let secondYAxisConfig: YAxisItem[] = [];
  let secondSeries: SeriesItem[] = [];

  if (twoY) {
    secondYAxisConfig = [{
      axisTick: { show: false },
      axisLine: { show: false },
      splitLine: { show: false },
      axisLabel: { fontSize: 0 },
      boundaryGap: false,
    }];
    secondSeries = [{
      name: data.label,
      data: data.history
        ? data.history.filter((_, index) => index % 2 === 1)
        : [],
      barStyle: {
        width: 5,
        color: '#5FECCA',
      },
      yAxisIndex: 1,
    }]
  }

  return new Options({
    grid:{
      left:5,
      right:5,
      top:5,
      bottom:5,
    },
    title: {
      show: false
    },
    xAxis: {
      data: (twoY ? data.history?.map((_, i) => String(i)).filter((ele,index)=>{
        return index % 2 === 0;
      }) : data.history?.map((_, i) => String(i)) )|| [],
      axisTick: { 
      show: false, 
      },
      axisLine: { 
      show: false,
      },
      splitLine: { // 坐标轴中的分隔线。
        show: false,
      },
      axisLabel:{
        fontSize:0,
      },
      boundaryGap: false,
    },
    yAxis: [{
      axisTick: { 
        show: false, 
      },
      axisLine: { 
        show: false,
      },
      splitLine: { // 坐标轴中的分隔线。
        show: false
      },
      axisLabel:{
        fontSize:0,
      },
      boundaryGap: false,
    },
      ...secondYAxisConfig
    ],
    series: [{
      name: data.label,
      data: (twoY ? data.history?.filter((ele,index)=>{
        return index % 2 === 0;
      }) : data.history) || [],
      barStyle:{
        width: 5,
        color: data.label === '压力' ? '#5FECCA' : '#3DC875',
      },
    },
      ...secondSeries
    ],
    dataZoom:{
      show: true,
    },
    legend:{
      show:false,
    }
  });
}

// 获取饼图配置
export function getPieChartOptions(data: HealthData): Options {
  return new Options({
    series: [{
      radius: ['80%', '50%'], // 饼图外半径、内半径
      center: ['50%', '50%'], // 饼图中心位置
      data: data.sleepData,
    }],
    title: {
      show: false,
    },
    legend: {
      show: false,
    },
    grid:{
      left:5,
      right:5,
      top:5,
      bottom:5,
    },
    color:['#1BC0F2','#5BD793']
  });
}