import { Prompt } from '@kit.ArkUI';

// 验证码状态结构体
export interface CaptchaState {
  code: string;
  expireAt: number; // ms timestamp
  dailyCount: number;
  countDateKey: string; // YYYY-MM-DD
}

// 生成4位随机数字验证码
export function gen4Digit(): string {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// 获取当前日期字符串（YYYY-MM-DD）
export function dayKey(ts: number = Date.now()): string {
  const d = new Date(ts);
  const y = d.getFullYear();
  const m = (d.getMonth() + 1).toString().padStart(2, '0');
  const day = d.getDate().toString().padStart(2, '0');
  return `${y}-${m}-${day}`;
}

// 弹出验证码提示
export function showCaptchaToast(code: string): void {
  Prompt.showToast({ message: `验证码：${code}`, duration: 2000 });
}

// 请求验证码主逻辑
// maxDaily: 每日最大获取次数，默认10次
// 返回新的验证码状态
export function requestCaptchaCore(state: CaptchaState, maxDaily: number = 10): CaptchaState {
  const nowKey = dayKey();
  let dailyCount = state.dailyCount;
  let countDateKey = state.countDateKey;
  // 日期变更时重置计数
  if (countDateKey !== nowKey) {
    countDateKey = nowKey;
    dailyCount = 0;
  }
  // 超过每日上限
  if (dailyCount >= maxDaily) {
    showCaptchaToast('今日验证码请求已达上限');
    return {
      code: state.code,
      expireAt: state.expireAt,
      dailyCount: state.dailyCount,
      countDateKey: state.countDateKey,
    };
  }
  // 生成新验证码，有效期5分钟
  const code = gen4Digit();
  const expireAt = Date.now() + 5 * 60 * 1000;
  dailyCount += 1;
  showCaptchaToast(code);
  return { code, expireAt, dailyCount, countDateKey };
}

// 校验验证码是否有效
export function isCaptchaValid(input: string, state: CaptchaState): boolean {
  if (!state.code || Date.now() > state.expireAt) return false;
  return !!input && input === state.code;
}
