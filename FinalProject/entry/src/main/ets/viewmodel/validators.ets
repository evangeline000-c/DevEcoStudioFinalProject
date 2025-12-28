// 校验手机号是否为中国大陆11位手机号
export function isValidPhone(phone: string): boolean {
  return /^1\d{10}$/.test(phone);
}

// 校验密码：至少8位，包含数字、小写和大写字母
export function isValidPassword(pwd: string): boolean {
  return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$/.test(pwd);
}

// 校验字符串非空
export function isNonEmpty(text: string): boolean {
  return !!text && text.trim().length > 0;
}
