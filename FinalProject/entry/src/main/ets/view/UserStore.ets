// 认证用户信息结构体
export interface AuthUser {
  account: string;
  phone: string;
  password: string;
}

const USERS_KEY = 'authUsers';
const CURRENT_KEY = 'currentUser';

// 初始化默认用户数据
function seedUsers(): Array<AuthUser> {
  const defaults: Array<AuthUser> = [
    { account: 'user01', phone: '13800000000', password: 'Pass010101' },
    { account: 'user02', phone: '13900000000', password: 'Pass020202' }
  ];
  AppStorage.setOrCreate(USERS_KEY, defaults);
  return defaults;
}

// 加载所有用户
export function loadUsers(): Array<AuthUser> {
  const stored = AppStorage.get(USERS_KEY) as Array<AuthUser> | undefined;
  if (stored && Array.isArray(stored)) { return stored; }
  return seedUsers();
}

// 保存所有用户到存储
function saveUsers(users: Array<AuthUser>): void {
  AppStorage.setOrCreate(USERS_KEY, users);
}

// 根据账号查找用户
export function findByAccount(account: string): AuthUser | null {
  const users = loadUsers();
  return users.find(u => u.account === account) ?? null;
}

// 根据手机号查找用户
export function findByPhone(phone: string): AuthUser | null {
  const users = loadUsers();
  return users.find(u => u.phone === phone) ?? null;
}

// 校验账号和密码，返回用户或null
export function verifyAccountPassword(account: string, password: string): AuthUser | null {
  const u = findByAccount(account.trim());
  if (u && u.password === password.trim()) { return u; }
  return null;
}

// 新增或更新用户
export function upsertUser(user: AuthUser): void {
  const users = loadUsers();
  const idx = users.findIndex(u => u.account === user.account || u.phone === user.phone);
  if (idx >= 0) {
    users[idx] = user;
  } else {
    users.push(user);
  }
  saveUsers(users);
}

// 根据手机号重置密码
export function updatePasswordByPhone(phone: string, password: string): AuthUser | null {
  const users = loadUsers();
  const idx = users.findIndex(u => u.phone === phone);
  if (idx < 0) { return null; }
  const oldUser = users[idx];
  const updated: AuthUser = { account: oldUser.account, phone: oldUser.phone, password };
  users[idx] = updated;
  saveUsers(users);
  return updated;
}

// 设置当前登录用户
export function setCurrentUser(user: AuthUser | null): void {
  if (user) {
    AppStorage.setOrCreate(CURRENT_KEY, { account: user.account, phone: user.phone });
  } else {
    AppStorage.setOrCreate(CURRENT_KEY, null);
  }
}

// 获取当前登录用户
export function getCurrentUser(): AuthUser | null {
  const u = AppStorage.get(CURRENT_KEY) as AuthUser | null;
  if (u && typeof u === 'object') {
    const account = u.account ? u.account : '';
    const phone = u.phone ? u.phone : '';
    if (account.length > 0 || phone.length > 0) {
      return { account, phone, password: '' };
    }
  }
  return null;
}
