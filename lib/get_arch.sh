# ==============================================================================
# 如有BUG 请提交Issues
# https://github.com/slackwarecn/slacklib32/issues
#
#             Copyright (C) 2014-2015 秦凡东
#             Copyright (C) 2015 The Slackware Linux CN Community
# ==============================================================================

# ==============================================================================
# get_arch
# 获得机器的架构，结果存入$arch_file
# ==============================================================================
function get_arch () {
  local arch
  local use_dialog
  local work_directory
  local arch_file
  local title='slacklib32'

  use_dialog=$1
  shift
  work_directory=$1
  arch_file=$work_directory/arch
  shift
  arch=$(uname -m)

  if ! echo $arch | grep -P '64' >/dev/null 2>&1; then
    msgbox='当前系统不是64 位系统。'

    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 10 50
    else
      echo "$msgbox"
    fi

    exit 1
  else
    echo "$arch" > "$arch_file"
  fi
}

