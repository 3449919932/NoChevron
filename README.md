# NoChevron 1.0 — 独立「去拉手」插件（Theos 工程）

目标：在**不修改 ControlCenter18** 的前提下，把控制中心顶部的「拉手」（chevron）隐藏掉。
做法：独立 dylib 注入 SpringBoard，hook 私有类 `CCUIHeaderPocketView` 的
`-layoutSubviews` / `-didMoveToWindow`，在其 hook 链跑完后把 `_headerChevronView`
设为 `hidden=YES`、`alpha=0`。

- 包标识：`com.dafeiyu.nochevron`
- 架构：`iphoneos-arm64`（rootless，`THEOS_PACKAGE_SCHEME = rootless`）
- 依赖：`mobilesubstrate`、`firmware (>= 16.0)`、`firmware (<< 18.0)`
- 注入范围：仅 `com.apple.springboard`（见 `NoChevron.plist`）
- 无安装/卸载脚本，卸载即恢复

## 构建（在电脑上，需要 Theos）

```bash
export THEOS="$HOME/theos"      # 改成你的 Theos 路径
cd NoChevron-src
make clean
make package FINALPACKAGE=1
ls packages/
# 产物：packages/com.dafeiyu.nochevron_1.0-1_iphoneos-arm64.deb
```

要求：Theos 支持 rootless（较新版本）、iOS 16 SDK、可用的 `ldid`。
如果 `make package` 报找不到 `ldid` 或 `clang`：

```bash
# WSL 下常见：检查工具是否齐全
which clang make ldid dpkg-deb
```

## 安装 / 卸载

1. 先把上一版**整合包**卸掉（`ControlCenter18_1.0-beta-fix1_iphoneos-arm64.deb`），
   把 ControlCenter18 装回**原版**（1.0-beta 或 3.0-beta 都行）。
2. 用 Sileo 打开本插件 deb 安装，respring（或 `killall -9 SpringBoard`）。
3. 锁屏下拉控制中心，顶部箭头应消失。

卸载：Sileo 里卸载 `NoChevron`，respring 即可恢复。

## 如果没生效

本插件的定位依据是反汇编结论（`_headerChevronView` 是
`CCUIHeaderPocketView` 的私有子视图、由 CC18 搬到 y=23 露出）。

- 若 `valueForKey:@"_headerChevronView"` 拿不到，会退化为按类名包含
  `chevron` 的子视图查找。
- 如果你的 CC18 版本改了视图层级（例如 3.x 重写了这块），把 CC18 的版本号和
  dylib 发我，我按同样方法重新定位（这次是独立插件，只改我们自己的 Tweak.x）。

## 构建两种架构（同一份源码）

```bash
export THEOS="$HOME/theos"

# rootless（Dopamine 等通用环境）→ 产物 *_iphoneos-arm64.deb
make clean && make package FINALPACKAGE=1

# roothide（RootHide 环境）→ 产物 *_iphoneos-arm64e.deb
make clean && make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide
```

`THEOS_PACKAGE_SCHEME` 默认 `rootless`，命令行传 `roothide` 即覆盖；
`control` 里的 `Architecture` 由 Theos 按 scheme 决定，无需手改。
