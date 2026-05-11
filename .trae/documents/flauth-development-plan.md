# Flauth 开发计划

## 📊 项目当前状态总结

### 已完成功能
- ✅ 核心 TOTP 验证码生成（SHA1 算法，30秒周期）
- ✅ 扫码添加账户
- ✅ 手动输入添加账户
- ✅ PIN 码保护
- ✅ 指纹/面容识别解锁
- ✅ 点击显示验证码并复制
- ✅ 拖拽排序账户
- ✅ 本地备份/恢复
- ✅ WebDAV 云端同步
- ✅ 加密备份（AES-256-CBC）
- ✅ 从 Aegis 导入
- ✅ Material 3 主题，深色模式支持
- ✅ 国际化（英文/中文）
- ✅ iOS/Android/macOS/Windows/Linux 全平台支持
- ✅ CI/CD 自动化测试和构建

### 技术架构
- **框架**: Flutter 3.10+
- **状态管理**: Provider
- **安全存储**: flutter_secure_storage
- **加密**: encrypt + pointycastle
- **代码生成**: flutter_localizations

---

## 🎯 下一步开发任务

### 任务 1: 修复指纹验证弹窗的国际化问题 🔴 高优先级

**问题描述**: `AuthService.authenticate()` 中的 `localizedReason` 是硬编码的英文字符串 `'Please authenticate to access Flauth'`，需要根据用户语言环境显示本地化文本。

**当前代码位置**: [lib/services/auth_service.dart#L24-26](file:///workspace/lib/services/auth_service.dart#L24-L26)

**修复方案**:
1. 在 `app_en.arb` 和 `app_zh.arb` 中添加新键 `biometricReason`
2. 修改 `AuthService` 接受 `localizedReason` 参数
3. 在调用 `authenticate()` 时传入本地化的字符串

**涉及文件**:
- `lib/l10n/app_en.arb` - 添加 `biometricReason`
- `lib/l10n/app_zh.arb` - 添加 `biometricReason`
- `lib/services/auth_service.dart` - 修改 `authenticate()` 方法签名
- `lib/providers/auth_provider.dart` - 传递本地化字符串

---

### 任务 2: 品牌图标集成 🟢 高价值

**功能描述**: 为每个账户显示对应服务的品牌图标（GitHub、Google、Microsoft 等），提升视觉体验和可识别性。

**实现方案**:

#### 方案 A: Simple Icons + 缓存（推荐）
- 使用 `simple_icons` 包获取 SVG 图标
- 根据 `issuer` 名称映射到对应的图标 ID
- 添加本地缓存机制，避免每次都从包加载

#### 方案 B: 首字母头像
- 当找不到对应图标时，显示 issuer 首字母
- 配合颜色生成算法，确保视觉区分度

**需要修改的文件**:
- `pubspec.yaml` - 添加依赖（如使用 simple_icons）
- `lib/models/account.dart` - 可选：添加 `iconId` 字段支持手动指定
- `lib/widgets/account_tile.dart` - 集成图标显示
- `lib/services/icon_service.dart`（新建）- 图标获取服务

**图标映射示例**:
```dart
const Map<String, String> issuerIcons = {
  'Google': 'Googledrive',
  'GitHub': 'Github',
  'Microsoft': 'Microsoft',
  'Amazon': 'Amazon',
  'Cloudflare': 'Cloudflare',
  'Dropbox': 'Dropbox',
  // ...
};
```

**UI 设计**:
- 在 `AccountTile` 中，issuer 图标显示在左侧（32x32）
- 图标下方显示 issuer 名称或 account name
- 点击后可显示完整验证码

---

## 📝 实施顺序

1. **立即修复**: 指纹验证弹窗国际化（Bug 修复）
2. **后续开发**: 品牌图标集成（功能增强）

---

## ✅ 验证步骤

1. 运行 `flutter pub get` 确保依赖正常
2. 运行 `make lint` 确保代码符合规范
3. 运行 `make test` 确保测试通过
4. 运行 `flutter run` 在设备上测试

---

## 📋 详细实施清单

### 任务 1 实施清单
- [ ] 在 `app_en.arb` 添加 `"biometricReason": "Please authenticate to access Flauth"`
- [ ] 在 `app_zh.arb` 添加 `"biometricReason": "请验证身份以访问 Flauth"`
- [ ] 修改 `AuthService.authenticate()` 接受 `String localizedReason` 参数
- [ ] 修改 `auth_provider.dart` 调用 `authenticateWithBiometrics()` 时传递本地化字符串
- [ ] 运行测试验证修复

### 任务 2 实施清单
- [ ] 研究并选择图标方案（simple_icons vs 首字母头像）
- [ ] 在 `pubspec.yaml` 添加必要依赖
- [ ] 创建 `lib/services/icon_service.dart`
- [ ] 实现 issuer 到图标 ID 的映射
- [ ] 修改 `AccountTile` 显示图标
- [ ] 测试各平台显示效果
