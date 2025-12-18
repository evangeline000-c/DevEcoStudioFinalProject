import { isValidPhone, isValidPassword } from './validators';
import { CaptchaState, isCaptchaValid } from './captcha';

// 密码登录校验：账号和密码格式
export function validatePasswordLogin(account: string, password: string): string | null {
  const acc = (account || '').trim();
  const pwd = (password || '').trim();
  if (acc.length === 0) { return '请输入账号'; }
  if (pwd.length === 0) { return '请输入密码'; }
  if (!isValidPassword(pwd)) { return '密码需至少8位且含数字、大小写字母'; }
  return null;
}

// 手机号+验证码登录校验
export function validatePhoneLogin(phone: string, code: string): string | null {
  const ph = (phone || '').trim();
  const cd = (code || '').trim();
  if (!isValidPhone(ph)) { return '请输入11位手机号'; }
  if (cd.length === 0) { return '请输入验证码'; }
  if (!/^\d{4}$/.test(cd)) { return '请输入4位验证码'; }
  return null;
}

// 校验验证码是否正确和有效
export function checkPhoneCaptcha(code: string, state: CaptchaState): string | null {
  const c = (code || '').trim();
  if (!state.code) { return '请先获取验证码'; }
  if (Date.now() > state.expireAt) { return '验证码已失效，请重新获取'; }
  if (c !== state.code) { return '验证码错误'; }
  return null;
}

// 注册页面校验：账号、手机号、验证码、密码、确认密码
export function validateRegister(
  account: string,
  phone: string,
  code: string,
  password: string,
  confirmPwd: string,
  captchaState: CaptchaState
): string | null {
  const acc = (account || '').trim();
  const ph = (phone || '').trim();
  const cd = (code || '').trim();
  const pwd = (password || '').trim();
  const cf = (confirmPwd || '').trim();
  if (acc.length === 0) { return '请输入账号'; }
  if (!isValidPhone(ph)) { return '请输入11位手机号'; }
  if (cd.length === 0) { return '请输入验证码'; }
  if (!/^\d{4}$/.test(cd)) { return '请输入4位验证码'; }
  if (!captchaState.code) { return '请先获取验证码'; }
  if (Date.now() > captchaState.expireAt) { return '验证码已失效，请重新获取'; }
  if (cd !== captchaState.code) { return '验证码错误'; }
  if (!isValidPassword(pwd)) { return '密码需至少8位且含数字、大小写字母'; }
  if (pwd !== cf) { return '两次输入的密码不一致'; }
  return null;
}

// 忘记密码页面校验：手机号、验证码、密码、确认密码
export function validateReset(
  phone: string,
  code: string,
  password: string,
  confirmPwd: string,
  captchaState: CaptchaState
): string | null {
  const ph = (phone || '').trim();
  const cd = (code || '').trim();
  const pwd = (password || '').trim();
  const cf = (confirmPwd || '').trim();
  if (!isValidPhone(ph)) { return '请输入11位手机号'; }
  if (cd.length === 0) { return '请输入验证码'; }
  if (!/^\d{4}$/.test(cd)) { return '请输入4位验证码'; }
  if (!captchaState.code) { return '请先获取验证码'; }
  if (Date.now() > captchaState.expireAt) { return '验证码已失效，请重新获取'; }
  if (cd !== captchaState.code) { return '验证码错误'; }
  if (!isValidPassword(pwd)) { return '密码需至少8位且含数字、大小写字母'; }
  if (pwd !== cf) { return '两次输入的密码不一致'; }
  return null;
}
