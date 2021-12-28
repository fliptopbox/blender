ffmpeg -f concat \
    -i content-clips.txt \
    -c copy render/output.mp4
