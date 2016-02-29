# ==============================================================================
# 如有BUG 请提交Issues
# https://github.com/slackwarecn/slacklib32/issues
#
#             Copyright (C) 2014-2015 秦凡东
#             Copyright (C) 2016 The Slackware Linux CN Community
# ==============================================================================

# ==============================================================================
# check_environment
# 检查脚本依赖环境是否满足，结果直接用return 语句返回
# ==============================================================================
function check_environment {
  local use_dialog
  local title='slacklib32'

  use_dialog=$1
  shift

  # 无root 权限则退出
  if [[ 0 -ne $UID ]]; then
    msgbox='请使用root 权限运行脚本。'

    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 5 50
    else
      echo "$msgbox"
    fi

    return 0
  fi

  # 不是Slackware Linux 则退出
  if [[ ! -r /etc/slackware-version ]]; then
    msgbox=$(
      cat <<EOM
您的系统似乎不是Slackware。
如果的确是Slackware，请尝试重新安装aaa_base 软件包。
EOM
    )

    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 10 50
    else
      echo "$msgbox"
    fi

    return 0
  fi

  # 无lftp 指令则退出
  if ! type lftp >/dev/null 2>&1; then
    msgbox='lftp 指令未发现，请先安装lftp。'

    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 5 50
    else
      echo "$msgbox"
    fi

    return 0
  fi

  return 1
}

