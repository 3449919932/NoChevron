# NoChevron 1.0-2 — 独立「去拉手」插件（Theos 工程）

独立插件，隐藏控制中心顶部的「拉手」(chevron)，不改动 ControlCenter18 的任何文件。

## 原理
注入 SpringBoard，hook 私有类 `CCUIHeaderPocketView` 的
`-layoutSubviews` / `-didMoveToWindow`，在 hook 链执行完后把
`_headerChevronView` 设为 `hidden=YES`、`alpha=0`。

## 信息
- 包标识：`com.dafeiyu.nochevron`
- 架构：`iphoneos-arm64`（rootless）
- 依赖：`mobilesubstrate`、`firmware (>= 16.0)`、`firmware (<< 18.0)`
- 注入范围：仅 `com.apple.springboard`
- 无安装/卸载脚本

## 构建
```bash
export THEOS="$HOME/theos"
make clean && make package FINALPACKAGE=1
# → packages/com.dafeiyu.nochevron_1.0-2_iphoneos-arm64.deb
