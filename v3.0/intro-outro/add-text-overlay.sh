# renders overlay on video clip
#

input=$1
output=$2
content=$3

ffmpeg -i $input -vf \
    "drawtext=fontfile=URWGothic-Demi.otf
    :textfile=$content
    :fontcolor=white
    :fontsize=140
    :x=20
    :y=20" \
    -y $output
