# DEPLOY

## build

```dart
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## release

```dart
flutter build appbundle --no-tree-shake-icons

flutter build apk --split-per-abi --no-tree-shake-icons
```

## null safety

[More](https://dart.cn/null-safety/migration-guide#migration-tool)

```dart
/// 检查所有依赖的迁移状态
dart pub outdated --mode=null-safety

/// 升级依赖
dart pub upgrade --null-safety

dart migrate
```
