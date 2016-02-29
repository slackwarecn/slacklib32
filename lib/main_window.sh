# ==============================================================================
# 如有BUG 请提交Issues
# https://github.com/slackwarecn/slacklib32/issues
#
#             Copyright (C) 2014-2015 秦凡东
#             Copyright (C) 2016 The Slackware Linux CN Community
# ==============================================================================

# ==============================================================================
# main_window
# 绘制主界面，版本号存入$version_file
# ==============================================================================
function main_window () {
  local my_version
  local result
  local use_dialog
  local result_file
  local title='slacklib32'

  use_dialog=$1
  shift
  work_directory=$1
  result_file=$work_directory/result
  version_file=$work_directory/version
  shift

  my_version=$(
    sed -n 's/slackware \([0-9]\+\.[0-9]\+\)$/\1/ip' /etc/slackware-version
  )

  while true; do
    menu='选择Multilib 的版本'
    switch_1="Slackware $my_version"
    switch_2='Slackware Current'
    switch_3='手动指定版本'
    switch_4='关于'
    switch_5='退出'
    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --default-item 1 \
            --menu "$menu" 15 50 5 \
            1 "$switch_1" \
            2 "$switch_2" \
            3 "$switch_3" \
            4 "$switch_4" \
            5 "$switch_5" \
            2>$result_file
      result=$(cat $result_file)
    else
      echo $menu
      echo 1 "$switch_1"
      echo 2 "$switch_2"
      echo 3 "$switch_3"
      echo 4 "$switch_4"
      echo 5 "$switch_5"
      while true; do
        read -p "请选择：" result
        if [[ 1 -le $result && 5 -ge $result ]]; then
          break
        fi
      done
    fi

    case $result in
      1)
        my_version=$my_version
        break
        ;;
      2)
        my_version='current'
        break
        ;;
      3)
        back_to_main_window=false
        while true; do
          inputbox='输入要指定的版本号'
          if [[ true == $use_dialog ]]; then
            dialog --title "$title" --inputbox "$inputbox" 10 50 \
              2>$result_file
            if [[ 1 == $? ]]; then
              back_to_main_window=true
              break
            fi
            my_version=$(cat $result_file)
          else
            read -p "$inputbox：" my_version
          fi

          if [[ -z $my_version ]]; then
            continue
          fi

          if [[ ! $my_version =~ ^[0-9]+\.[0-9]+$ ]]; then
            msgbox="\"$my_version\" 似乎不是一个合法的版本号。"
            if [[ true == $use_dialog ]]; then
              dialog --title "$title" --msgbox "$msgbox" 10 50
            else
              echo "$msgbox"
            fi
            continue
          fi

          if [[ true == $(awk --assign=my_version=$my_version \
                              --assign=min_version=13.0 \
                              'BEGIN { print (my_version < min_version) \
                                ? "true" : "false" }') ]]; then
            msgbox='不支持Slackware 13.0 以下的版本。'
            if [[ true == $use_dialog ]]; then
              dialog --title "$title" --msgbox "$msgbox" 10 50
            else
              echo "$msgbox"
            fi
          else
            break
          fi
        done

        if [[ true == $back_to_main_window ]]; then
          # 重新设定$my_version
          my_version=$(
            sed -n 's/slackware \([0-9]\+\.[0-9]\+\)$/\1/ip' \
                    /etc/slackware-version
          )
          continue
        fi

        break
        ;;
      4)
        msgbox=$(
          cat <<EOM
  Copyright (C) 2014-2015 秦凡东

  此程序是自由软件；您可以以自由软件基金会发布的GNU通用公共许可协议第三版或（您可以选择）更高版方式重新发布它和/或修改它。

  此程序是希望其会有用而发布，但没有任何担保；没有甚至是暗含的适宜销售或特定目的适用性方面的担保。详情参看GNU通用公共许可协议。

  您应该与此程序一道收到了一份GNU通用公共许可协议的副本；如果没有，请查看<http://www.gnu.org/licenses/>。
EOM
        )
        if [[ true == $use_dialog ]]; then
          dialog --title "$title" --msgbox "$msgbox" 20 50
        else
          echo "$msgbox"
        fi
        ;;
      5)
        exit 0
        ;;
      *)
        exit 0
        ;;
  esac
  done

  echo "$my_version" > "$version_file"
}

