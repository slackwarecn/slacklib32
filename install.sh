#!/usr/bin/env bash
# ===================================================== #
# 如有BUG 请提交Issues                                  #
# https://github.com/Arondight/slacklib32/issues        #
#                                                       #
#             Copyright (C) 2014-2015 秦凡东            #
# ===================================================== #

cwd=$(dirname $(readlink -f $0))
exec_target='/usr/local/bin/slacklib32'
exec_file="$cwd/bin/slacklib32.sh"
lib_target='/usr/local/lib'
lib_dir="$cwd/lib"
lib_files=('check_environment.sh' 'get_arch.sh' 'install_multilib.sh' 'main_window.sh')
answer=''

if [[ 0 -ne $UID ]]; then
  echo "请使用root 权限运行$0。"
  exit 1
fi

if [[ ! -e $exec_file ]]; then
  echo "未发现文件${exec_file}，请尝试重新下载项目。"
  exit 1
fi

if [[ -e $exec_target ]]; then
  read -p '发现系统内已经存在一份slacklib32，要覆盖它吗？(Y/n)' answer
  if [[ 'Y' != $answer ]]; then
    echo '确认询问未通过，slacklib32 未安装。'
    exit 1
  fi
fi

cp -f "$exec_file" "$exec_target"

i=0
while [[ $i < ${#lib_files[@]} ]]; do
  lib_files[$i]=$lib_dir/${lib_files[$i]}

  if [[ ! -e ${lib_files[$i]} ]]; then
    echo "某些脚本缺失，请尝试重新下载项目。"
    exit 1
  fi

  let ++i
done

# now answer is yes
for lib_file in ${lib_files[@]}; do
  cp -f "$lib_file" "$lib_target"
done

if [[ 0 -eq $? ]]; then
  echo "已经安装到$exec_target。"
else
  exit $?
fi

