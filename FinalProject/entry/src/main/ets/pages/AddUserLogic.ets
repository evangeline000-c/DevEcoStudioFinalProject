import { UserInfo } from '../view/UserModel';
import { SelectOption } from './AddUserFormFields';

// 关系选项常量
export const relationOptions: SelectOption[] = [
  { value: '本人' },
  { value: '父母' },
  { value: '子女' },
  { value: '未成年子女' },
  { value: '配偶' },
  { value: '其他' }
];

// 日期格式化：YYYY-MM-DD
export function formatDateFromDate(date: Date): string {
  const y = date.getFullYear();
  const m = date.getMonth() + 1;
  const d = date.getDate();
  const mm = m < 10 ? `0${m}` : `${m}`;
  const dd = d < 10 ? `0${d}` : `${d}`;
  return `${y}-${mm}-${dd}`;
}

// 字符串转 Date
export function parseDate(raw?: string): Date {
  if (raw) {
    const parts = raw.split('-');
    if (parts.length === 3) {
      const y = Number(parts[0]);
      const m = Number(parts[1]) - 1;
      const d = Number(parts[2]);
      const parsed = new Date(y, m, d);
      if (!Number.isNaN(parsed.getTime())) {
        return parsed;
      }
    }
  }
  return new Date();
}

// 校验表单，返回错误文案；通过则返回空字符串
export function validateForm(formData: Partial<UserInfo>): string {
  const nameOk = !!formData.name && formData.name.trim().length > 0;
  const relationOk = !!formData.relation;
  const genderOk = !!formData.gender;
  const birthdayOk = !!formData.birthday;
  const idOk = !!formData.idCard && formData.idCard.trim().length > 0;

  if (!nameOk || !relationOk || !genderOk || !birthdayOk || !idOk) {
    return '请完整填写带星号的必填项';
  }
  const id = formData.idCard!.trim();
  const idReg = /^(\d{15}|\d{17}[\dXx])$/;
  if (!idReg.test(id)) {
    return '身份证号格式不正确';
  }
  return '';
}

// 复制 formData 并设置生日，避免使用展开或受限标准库
export function withBirthday(formData: Partial<UserInfo>, birthday: string): Partial<UserInfo> {
  const next: Partial<UserInfo> = {
    name: formData.name,
    gender: formData.gender,
    relation: formData.relation,
    birthday: birthday,
    idCard: formData.idCard,
    address: formData.address,
    job: formData.job
  };
  return next;
}
