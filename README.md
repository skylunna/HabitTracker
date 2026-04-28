#  Habit Tracker

基于 SwiftUI + SwiftData 开发的个人习惯追踪器。支持每日打卡、连续天数统计与数据可视化，适合作为 iOS 17+ 架构实践项目。

##  技术栈
- **UI**: SwiftUI + iOS 17 `@Observable`
- **数据**: SwiftData（本地持久化）
- **架构**: MVVM + 响应式状态管理
- **工具**: Xcode 15+, Swift 5.9+, Swift Charts（待集成）

##  运行要求
- macOS 14.0+ / Xcode 15.0+
- iOS 17.0+ 模拟器或真机

##  快速启动
1. 克隆仓库：`git clone https://github.com/你的用户名/HabitTracker.git`
2. 打开 `HabitTracker.xcodeproj`
3. `Cmd + R` 运行至模拟器

## 功能路线图
- [x] 项目初始化 & SwiftData 容器配置
- [x] 核心数据模型 `Habit`
- [ ] 习惯列表展示 & 空状态
- [ ] 添加/编辑习惯表单
- [ ] 每日打卡 & 连续天数计算
- [ ] 图表统计（Swift Charts）
- [ ] 深色模式 & 无障碍适配

## 许可证
MIT License
