// 康养用户数据管理
import { UserDataSource, UserInfo } from '../view/UserModel';

// 康养用户信息接口
export interface PatientInfo {
  id: string;           // 用户ID
  name: string;         // 用户姓名
  relation: string;     // 亲属关系
  gender: string;       // 性别
  age: number;          // 年龄
}

// 计算年龄的辅助函数
function calculateAge(birthday: string): number {
  if (!birthday) return 0;
  
  const birthDate = new Date(birthday);
  const today = new Date();
  
  let age = today.getFullYear() - birthDate.getFullYear();
  const m = today.getMonth() - birthDate.getMonth();
  
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  
  return age >= 0 ? age : 0;
}

// 获取康养用户列表
export function getPatientList(): PatientInfo[] {
  // 从 AppStorage 获取 UserDataSource
  const dataSource = AppStorage.get<UserDataSource>('userDataSource');
  
  if (!dataSource) {
    console.warn('PatientData: UserDataSource not found in AppStorage');
    return [];
  }
  
  const userList = dataSource.getAll();
  
  // 将 UserInfo 映射为 PatientInfo
  return userList.map((user: UserInfo): PatientInfo => {
    return {
      id: user.uid || '',
      name: user.name,
      relation: user.relation,
      gender: user.gender,
      age: calculateAge(user.birthday || '')
    } as PatientInfo;
  });
}
