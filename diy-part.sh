#!/bin/bash
# diy-part.sh - 自定义编译前的操作（添加插件、汉化等）

# 切换到 OpenWRT 源码目录（GitHub Actions 中默认克隆到 ./openwrt）
cd openwrt || exit

# ============== 1. 添加 PassWall 和 QModem 插件 ==============
# 方式1：通过 feeds 添加（推荐）
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default
echo "src-git qmodem https://github.com/FUjr/QModem.git" >> feeds.conf.default

# 方式2：手动克隆到 package 目录（备用，若 feeds 失效）
# mkdir -p package/custom
# git clone https://github.com/Openwrt-Passwall/openwrt-passwall.git package/custom/passwall
# git clone https://github.com/FUjr/QModem.git package/custom/qmodem

# ============== 2. 更新 feeds 并安装插件 ==============
./scripts/feeds update -a
./scripts/feeds install -a

# ============== 3. 配置中文汉化（确保系统语言包启用） ==============
# 向配置文件中追加中文语言包（也可在 make menuconfig 中手动选）
echo "CONFIG_LUCI_LANG_zh_CN=y" >> .config

# 可选：设置默认语言为中文
sed -i 's/luci.main.lang=auto/luci.main.lang=zh_cn/g' package/lean/default-settings/files/zzz-default-settings