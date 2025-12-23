// 入住申请相关数据模型

import { PatientInfo } from './PatientData';

// 入住申请信息类型
export class AdmissionItemType {
  id: number;                    // 申请ID
  patientId: string;             // 康养用户ID
  patientName: string;           // 康养用户姓名
  organizationId: string;        // 机构ID
  organizationName: string;      // 机构名称
  departmentId: string;          // 部门ID
  departmentName: string;        // 部门名称
  roomId: string;                // 房间ID
  roomName: string;              // 房间名称
  applicationTime: string;       // 申请时间
  status: string;                // 审核状态: '待审核' | '已通过' | '已拒绝'
  remarks: string;               // 备注

  constructor(
    id: number,
    patientId: string,
    patientName: string,
    organizationId: string,
    organizationName: string,
    departmentId: string,
    departmentName: string,
    roomId: string,
    roomName: string,
    applicationTime: string,
    status: string,
    remarks: string = ''
  ) {
    this.id = id;
    this.patientId = patientId;
    this.patientName = patientName;
    this.organizationId = organizationId;
    this.organizationName = organizationName;
    this.departmentId = departmentId;
    this.departmentName = departmentName;
    this.roomId = roomId;
    this.roomName = roomName;
    this.applicationTime = applicationTime;
    this.status = status;
    this.remarks = remarks;
  }
}

// 入住申请表单数据类型
export class AdmissionFormType {
  patientId: string;
  patientName: string;
  organizationId: string;
  organizationName: string;
  departmentId: string;
  departmentName: string;
  roomId: string;
  roomName: string;
  remarks: string;

  constructor(
    patientId: string = '',
    patientName: string = '',
    organizationId: string = '',
    organizationName: string = '',
    departmentId: string = '',
    departmentName: string = '',
    roomId: string = '',
    roomName: string = '',
    remarks: string = ''
  ) {
    this.patientId = patientId;
    this.patientName = patientName;
    this.organizationId = organizationId;
    this.organizationName = organizationName;
    this.departmentId = departmentId;
    this.departmentName = departmentName;
    this.roomId = roomId;
    this.roomName = roomName;
    this.remarks = remarks;
  }
}

// 机构信息接口
export interface OrganizationInfo {
  id: string;
  name: string;
}

// 部门信息接口
export interface DepartmentInfo {
  id: string;
  name: string;
  organizationId: string;  // 所属机构ID
}

// 房间信息接口
export interface RoomInfo {
  id: string;
  name: string;
  departmentId: string;    // 所属部门ID
}

// 模拟的服务机构列表
export const OrganizationList: OrganizationInfo[] = [
  { id: '1', name: '阳光康养中心' },
  { id: '2', name: '和谐养老院' },
  { id: '3', name: '温馨护理中心' }
];

// 模拟的部门列表
export const DepartmentList: DepartmentInfo[] = [
  { id: '1', name: '普通康养区', organizationId: '1' },
  { id: '2', name: '专业护理区', organizationId: '1' },
  { id: '3', name: '康复训练区', organizationId: '1' },
  { id: '4', name: '基础护理区', organizationId: '2' },
  { id: '5', name: '医疗护理区', organizationId: '2' },
  { id: '6', name: '综合康养区', organizationId: '3' },
  { id: '7', name: '特色理疗区', organizationId: '3' }
];

// 模拟的房间列表
export const RoomList: RoomInfo[] = [
  { id: '101', name: '101室（单人间）', departmentId: '1' },
  { id: '102', name: '102室（双人间）', departmentId: '1' },
  { id: '103', name: '103室（单人间）', departmentId: '1' },
  { id: '201', name: '201室（VIP单人间）', departmentId: '2' },
  { id: '202', name: '202室（单人间）', departmentId: '2' },
  { id: '301', name: '301室（康复训练室A）', departmentId: '3' },
  { id: '302', name: '302室（康复训练室B）', departmentId: '3' },
  { id: '401', name: '401室（双人间）', departmentId: '4' },
  { id: '402', name: '402室（三人间）', departmentId: '4' },
  { id: '501', name: '501室（医疗护理单间）', departmentId: '5' },
  { id: '502', name: '502室（医疗护理双间）', departmentId: '5' },
  { id: '601', name: '601室（舒适单间）', departmentId: '6' },
  { id: '602', name: '602室（温馨双间）', departmentId: '6' },
  { id: '701', name: '701室（理疗室A）', departmentId: '7' },
  { id: '702', name: '702室（理疗室B）', departmentId: '7' }
];

// 根据机构ID获取部门列表
export function getDepartmentsByOrganization(organizationId: string): DepartmentInfo[] {
  return DepartmentList.filter(dept => dept.organizationId === organizationId);
}

// 根据部门ID获取房间列表
export function getRoomsByDepartment(departmentId: string): RoomInfo[] {
  return RoomList.filter(room => room.departmentId === departmentId);
}

// 入住申请数据列表，初始为空，手动添加
export const AdmissionItemList: AdmissionItemType[] = [];
