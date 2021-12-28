# renders overlay on video clip
#

input=$1
output=$2
textfile=$3

ffmpeg -i $input -vf \
    "drawtext=fontfile=URWGothic-Demi.otf
    :textfile=$textfile
    :fontcolor=white
    :fontsize=180
    :x=20
    :y=20" \
    -y $output
