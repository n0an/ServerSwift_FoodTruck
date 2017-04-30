## Swift

1. Create package:
```
swift package init --type executable
```
2. Build project:
```
swift build
```
3. Build release:
```
swift build --configuration release
```
4. Clean package:
```
swift package clean
```
5. Build and compile project:
```
swift build && .build/debug/project1
```
6. Generate .xcodeproj (run in macOS!):
```
swift package generate-xcodeproj
```
