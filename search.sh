#!/bin/bash
# File: search.sh
# Author: SeaflyDennis <seafly0616@qq.com>
# Date: 2017.06.29
# Last Modified: 2017.06.29
echo "Author: SeaflyDennis <seafly0616@qq.com>"
echo "WeChat: seafly0616"
PLAYER=""
CUR_DIR=`pwd`
FIND_DIR=$HOME
TOTAL_DIR=$HOME

function get_search_grep_list()
{
    # 在xxx.txt中寻找含有关键字的行，并逐行写入临时文件
    grep "$INPUT_STRING" $CUR_DIR/*.txt 1> ~/seafly_search.temp 2>/dev/null
    if [ $? -ne 0 ] ;
    then
        echo "Error: Can't find $INPUT_STRING"
        exit 20
    fi
    echo "~/seafly_search.temp:" ; cat ~/seafly_search.temp
}

function get_search_pure_list()
{
    # 获取精确纯文件名列表并写入临时文件
    cat ~/seafly_search.temp |\
        xargs -i -d '\n' echo {} |\
        awk -F ':' '{print $2}' |\
        xargs -i -d '\n' echo {} > $HOME/seafly_search_pure.temp
    echo "~/seafly_search_pure.temp:" ; cat ~/seafly_search_pure.temp
}

function get_search_media_list()
{
    # 判断过滤出媒体文件并将新列表写入临时文件
    cat ~/seafly_search_pure.temp |\
        awk -F '\n' '{print $1}' |\
        egrep "*.mp3|*.mp4|*.avi|*.wmv|*.flv|*.mkv|*.rmvb|*.wav|*.wma\
              |*.MP3|*.MP4|*.AVI|*.WMV|*.FLV|*.MKV|*.RMVB|*.WAV|*.WMA" > $HOME/seafly_search_media.temp
}

function get_search_pdf_list()
{
    # 判断过滤出媒体文件并将新列表写入临时文件
    cat ~/seafly_search_pure.temp |\
        awk -F '\n' '{print $1}' |\
        egrep "*.pdf|*.PDF" > $HOME/seafly_search_media.temp
}

function get_search_doc_list()
{
    # 判断过滤出媒体文件并将新列表写入临时文件
    cat ~/seafly_search_pure.temp |\
        awk -F '\n' '{print $1}' |\
        egrep "*.doc|*.DOC|*.docx|*.DOCX" > $HOME/seafly_search_media.temp
}

function get_search_ppt_list()
{
    # 判断过滤出媒体文件并将新列表写入临时文件
    cat ~/seafly_search_pure.temp |\
        awk -F '\n' '{print $1}' |\
        egrep "*.ppt|*.PPT|*.pptx|*.PPTX" > $HOME/seafly_search_media.temp
}

function get_search_xls_list()
{
    # 判断过滤出媒体文件并将新列表写入临时文件
    cat ~/seafly_search_pure.temp |\
        awk -F '\n' '{print $1}' |\
        egrep "*.xls|*.XLS|*.xlsx|*.XLSX" > $HOME/seafly_search_media.temp
}

function get_search_png_list()
{
    # 判断过滤出媒体文件并将新列表写入临时文件
    cat ~/seafly_search_pure.temp |\
        awk -F '\n' '{print $1}' |\
        egrep "*.png|*.jpg|*.jpeg|*.bmp\
              |*.PNG|*.JPG|*.JPEG|*.BMP" > $HOME/seafly_search_media.temp
}

function get_search_all_path()
{
    # 获取搜到的所有类型文件路径
    cat /dev/null > ~/seafly_search_all_path.temp
    cat ~/seafly_search_pure.temp | xargs -i -d '\n' find $FIND_DIR -name {} -print > ~/seafly_search_all_path.temp
    echo ""
    echo ""
    echo "搜索得到的总列表：        "
    cat -n ~/seafly_search_all_path.temp
}

function get_search_final_path()
{
    # 找出完整路径并写入临时文件（该位置暂时无法找到特殊字符文件名）
    cat /dev/null > ~/seafly_search_final_path.temp
    cat ~/seafly_search_media.temp | xargs -i -d '\n' find $FIND_DIR -name {} -print > ~/seafly_search_final_path.temp
    echo ""
    echo ""
    echo "最终列表："
    cat -n ~/seafly_search_final_path.temp
}

function check_player()
{
    which $PLAYER 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ] ;
    then
        echo "Error: 找不到打开该文件的软件（$PLAYER）"
        exit 50
    fi
}

function play_search_list()
{
    # 逐行读取并播放列表中的媒体文件
    cat ~/seafly_search_final_path.temp |\
        xargs -i -d '\n' $PLAYER {}
}

function clear_temp_file()
{
    # 播放完毕，删除临时文件
    rm -rf ~/seafly_file_test.temp
    rm -rf ~/seafly_search.temp
    rm -rf ~/seafly_search_bool.temp
    rm -rf ~/seafly_search_final_path.temp
    rm -rf ~/seafly_search_grep.temp
    rm -rf ~/seafly_search_media.temp
    rm -rf ~/seafly_search_pure.temp
    rm -rf ~/seafly_search_playerlist.temp
    rm -rf ~/seafly_search_all_path.temp
}


# 获取总列表
ls -R $TOTAL_DIR > $CUR_DIR/total_list.txt

# 没有指定播放器时默认使用媒体播放器
MEDIA_PLAYER="smplayer mplayer"
for PLAYER in $MEDIA_PLAYER
do
    which $PLAYER 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ] ;
    then
        break
    fi
done
which $PLAYER 2>/dev/null 1>/dev/null
if [ $? -ne 0 ] ;
then
    echo "Error: 找不到打开该文件的软件（$PLAYER）"
    exit 30
fi

# 从用户输入获取关键字
if [ $# -eq 2 ] ;
then
    case "$1" in
        "mplayer"|"/usr/bin/mplayer")
            PLAYER=mplayer
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_media_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "smplayer"|"/usr/bin/smplayer") # media
            PLAYER=smplayer
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_media_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "okular"|"/usr/bin/okular"|"PDF"|"pdf")     # PDF
            PLAYER=okular
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_pdf_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "wps"|"/usr/bin/wps"|"DOC"|"doc"|"DOCX"|"docx")           # DOC
            PLAYER=wps
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_doc_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "wpp"|"/usr/bin/wpp"|"PPT"|"ppt"|"PPTX"|"pptx")           # PPT
            PLAYER=wpp
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_ppt_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "et"|"/usr/bin/et"|"XLS"|"xls"|"XLSX"|"xlsx")             # xls   (sheet)
            PLAYER=et
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_xls_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "eog"|"/usr/bin/eog"|"PNG"|"png"|"JPG"|"jpg"|"JPEG"|"jpeg"|"BMP"|"bmp"|"IMAGE"|"image")           # Images
            PLAYER=okular
            INPUT_STRING=$2
            check_player
            get_search_grep_list
            get_search_pure_list
            get_search_png_list
            get_search_all_path
            get_search_final_path
            play_search_list
            clear_temp_file
            ;;
        "kazam|KAZAM")
            echo "一款Linux下不错的录屏软件"
            ;;
        "supertuxkart|SuperTuxKart")
            echo "一款Linux下不错的跑跑卡丁车游戏"
            ;;
        *)
            echo "Usage: media.sh [player] keyword"
            exit 10
            ;;
    esac
elif [ $# -eq 1 ] ;
then
    INPUT_STRING=$1
    check_player
    get_search_grep_list
    get_search_pure_list
    get_search_media_list
    get_search_all_path
    get_search_final_path
    play_search_list
    clear_temp_file
else
    echo "Usage: media.sh [player] keyword"
    exit 10
fi

