# ==============================================================================
# 如有BUG 请提交Issues
# https://github.com/slackwarecn/slacklib32/issues
#
#             Copyright (C) 2014-2015 秦凡东
#             Copyright (C) 2016 The Slackware Linux CN Community
# ==============================================================================

# ==============================================================================
# install_multilib
# 下载并安装Multilib，结果以return 语句返回
# =========================
function install_multilib () {
  local use_dialog
  local version
  local cache_directory
  local delete
  local title='slacklib32'

  use_dialog=$1
  shift
  cache_directory=$1
  shift
  version=$1
  shift

  # 下载Multilib 安装包
  lftp -c "open http://slackware.com/~alien/multilib/; mirror -c -e $version $cache_directory;"
  if [[ 0 != $? ]]; then
    msgbox=$(
      cat <<EOF
无法下载对应的Multilib 安装包，可能是因为：
1. 无法连接到网络
2. 版本号不正确
EOF
    )
    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 10 50
    else
      echo "$msgbox"
    fi

    return 1
  fi

  # 安装
  find "$cache_directory" \
    -name '*.t?z' \
    -exec /sbin/upgradepkg --reinstall --install-new {} \;

  # 清理：Slackware 的/tmp 目录默认不是tmpfs 的挂载点
  yesno="是否删除缓存的Multilib 安装包（$cache_directory）？"
  if [[ true == $use_dialog ]]; then
    dialog --title "$title" --yesno "$yesno" 5 50;
    if [[ 0 == $? ]]; then
      delete=true
    else
      delete=false
    fi
  else
    read -p "$yesno（y/n）" delete
    delete=$(echo $delete | tr '[:lower:]' '[:upper:]')
    if [[ 'Y' == $delete ]]; then
      delete=true
    else
      delete=false
    fi
  fi
  if [[ true == $delete ]]; then
    rm --verbose --recursive --force $cache_directory
  fi

  return 0
}

