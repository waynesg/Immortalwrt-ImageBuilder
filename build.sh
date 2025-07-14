#!/bin/sh

BASE_PACKAGES=""
BASE_PACKAGES="$BASE_PACKAGES curl"
BASE_PACKAGES="$BASE_PACKAGES -dnsmasq"
BASE_PACKAGES="$BASE_PACKAGES dnsmasq-full"
BASE_PACKAGES="$BASE_PACKAGES luci"
BASE_PACKAGES="$BASE_PACKAGES bash"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-ttyd-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES openssh-sftp-server"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-package-manager-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-compat"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-firewall-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-base-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-dockerman-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-filemanager-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-p910nd-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-openvpn-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-3cat-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-openvpn-server-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-cloudflared-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-ddns-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-diskman-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-homeproxy-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-msd_lite-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-samba4-zh-cn"
BASE_PACKAGES="$BASE_PACKAGES luci-i18n-smartdns-zh-cn"





# 下面是自定义的包 你可以用#注释掉不需要的包 也可以添加更多的包 
# 使用条件:在extra-packages下放置了相关run或者ipk
CUSTOM_PACKAGES=""
# 第三方插件 文件传输 luci-app-filetransfer
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-lib-fs"
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-lua-runtime"
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-filetransfer"
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-filetransfer-zh-cn"
# 第三方插件 argon主题 luci-theme-argon 紫色主题 3个ipk
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-theme-argon"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-argon-config-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-argon-config"

CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-airconnect"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-autoupdate"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-eqosplus"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-eqosplus"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-mosdns"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-oaf"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-onliner"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-subconverter"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-tailscale"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-wechatpush"



#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-adguardhome"
# 第三方插件 openclash 内核放在files/etc/openclash/core/clash_meta 若不勾选则不集成
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash"
# 第三方插件 luci-app-passwall 包含内部组件
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-passwall"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-passwall-zh-cn"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES geoview"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES xray-core"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES sing-box"
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES hysteria"
# 第三方插件 luci-app-ssr-plus 尤其注意要包含 shadowsocks-libev-ss-server
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-ssr-plus"
# 第三方插件 luci-app-homeproxy
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-homeproxy-zh-cn"
# CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-homeproxy"
# 第三方插件 luci-app-nikki
#CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-nikki-zh-cn"

# ✅ 校验 CUSTOM_PACKAGES 中的包是否都存在于 packages_names.txt
package_file="packages_names.txt"
for pkg in $CUSTOM_PACKAGES; do
  if ! grep -qx "$pkg" "$package_file"; then
    echo "❌ 错误：包 $pkg 不存在于 $package_file 中 请检查自定义包名是否正确!"
    exit 1
  fi
done

# 拼接
PACKAGES="$BASE_PACKAGES $CUSTOM_PACKAGES"

# 若构建openclash 则添加内核
if echo "$PACKAGES" | grep -q "luci-app-openclash"; then
    echo "✅ [构建逻辑] 已选择 luci-app-openclash，添加 openclash core"
    mkdir -p files/etc/openclash/core
    if [ -f extra-packages/temp-unpack/clash_meta ]; then
        cp extra-packages/temp-unpack/clash_meta files/etc/openclash/core/clash_meta
    else
        echo "⚠️ [警告] 缺少 clash_meta 内核,跳过复制,你应该确保extra-packages目录下有相关run文件"
    fi
else
    echo "⚪️ [构建逻辑] 未选择 luci-app-openclash"
    [ -d files/etc/openclash ] && rm -rf files/etc/openclash
fi


# # 若构建luci-app-adguardhome 则添加内核
# if echo "$PACKAGES" | grep -q "luci-app-adguardhome"; then
#     echo "✅ [构建逻辑] 已选择 luci-app-adguardhome，添加 AdGuardHome core"
#     if [ -f extra-packages/temp-unpack/AdGuardHome/AdGuardHome ]; then
#         cp extra-packages/temp-unpack/AdGuardHome/AdGuardHome files/usr/bin/AdGuardHome
#     else
#         echo "⚠️ [警告] 缺少 AdGuardHome内核,跳过复制,你应该确保extra-packages目录下有相关run文件"
#     fi
# else
#     echo "⚪️ [构建逻辑] 未选择 luci-app-adguardhome"
#     [ -f files/usr/bin/AdGuardHome ] && rm -f files/usr/bin/AdGuardHome
# fi


# 开始构建 软件包大小1024代表1GB 
# 可选参数FILES=files 代表files目录中若有文件 则覆盖openwrt的根目录 原样注入  
# 例如files/etc对应覆盖openwrt系统/etc目录中的文件 
# 例如files/mnt对应覆盖openwrt系统/mnt目录中的文件 
OUTPUT_DIR=$(pwd)/output
mkdir -p $OUTPUT_DIR
make image PROFILE=generic PACKAGES="$PACKAGES"  FILES=files ROOTFS_PARTSIZE=1024 BIN_DIR=$OUTPUT_DIR
ls -lah $OUTPUT_DIR
