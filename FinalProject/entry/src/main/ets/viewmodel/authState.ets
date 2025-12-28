import { CaptchaState } from './captcha';

// 登录表单状态
export interface LoginFormState {
  mode: 'password' | 'phone';
  account: string;
  password: string;
  phone: string;
  code: string;
}

// 注册表单状态
export interface RegisterFormState {
  account: string;
  phone: string;
  code: string;
  password: string;
  confirmPwd: string;
}

// 重置密码表单状态
export interface ResetFormState {
  phone: string;
  code: string;
  password: string;
  confirmPwd: string;
}

// 初始化登录表单状态
export function newLoginFormState(): LoginFormState {
  return { mode: 'password', account: '', password: '', phone: '', code: '' };
}

// 初始化注册表单状态
export function newRegisterFormState(): RegisterFormState {
  return { account: '', phone: '', code: '', password: '', confirmPwd: '' };
}

// 初始化重置密码表单状态
export function newResetFormState(): ResetFormState {
  return { phone: '', code: '', password: '', confirmPwd: '' };
}

// 初始化验证码状态
export function newCaptchaState(): CaptchaState {
  return { code: '', expireAt: 0, dailyCount: 0, countDateKey: '' };
}
