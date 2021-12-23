# 修改默认IP(Modify default IP)
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 修改NTP服务器(Modify default NTP server for campus_internet)
echo 'Modify default NTP server...'
sed -i 's/ntp.aliyun.com/ntp1.aliyun.com/g' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/time1.cloud.tencent.com/g' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/stdtime.gov.hk/g' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/pool.ntp.org/g' package/base-files/files/bin/config_generate

#取消原主题luci-theme-bootstrap为默认主题
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

rm -rf package/lean/luci-theme-argon

# 这个修改可以
# Modify default theme
# echo 'Modify default theme...'
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 版本号里显示一个自己的名字（ababwnq build $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
#sed -i "s/OpenWrt /ababwnq build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/OpenWrt /passenger/g" package/lean/default-settings/files/zzz-default-settings

#设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

#加入定时清理内存
sed -i "28a\echo \'*/60 * * * * sh /etc/memclean.sh\' > /etc/crontabs/root" package/lean/default-settings/files/zzz-default-settings
#赋予定时清理内存脚本权限
sed -i '56a\chmod 1777 /etc/memclean.sh' package/lean/default-settings/files/zzz-default-settings
sed -i '57a\chmod 1777 /sbin/shutdown' package/lean/default-settings/files/zzz-default-settings

# Replace openwrt.org in diagnostics with www.baidu.com
echo 'Replace openwrt.org in diagnostics.htm with www.baidu.com...'
sed -i "/exit 0/d" package/lean/default-settings/files/zzz-default-settings
cat <<EOF >>package/lean/default-settings/files/zzz-default-settings
uci set luci.diag.ping=www.baidu.com
uci set luci.diag.route=www.baidu.com
uci set luci.diag.dns=www.baidu.com
uci commit luci
exit 0
EOF
