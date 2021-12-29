```
  __  __
 / _|/ _|_ __ ___  _ __   ___  __ _
| |_| |_| '_ ` _ \| '_ \ / _ \/ _` |
|  _|  _| | | | | | |_) |  __/ (_| |
|_| |_| |_| |_| |_| .__/ \___|\__, |
                  |_|         |___/

```

## To generate simple video assets:

See: https://www.bogotobogo.com/FFMpeg/ffmpeg_video_test_patterns_src.php

```bash
# Creates a TV test pattern
ffmpeg -f lavfi \
    -i testsrc=duration=5:size=hd720:rate=30 \
    output.mp4

# Create a SMPTE pattern (colored venitian blinds)
ffmpeg -f lavfi \
    -i smptebars=duration=5:size=hd720:rate=30 \
    output.mp4

# Create a flat color video plate
ffmpeg -f lavfi \
    -i color=c=red:duration=5:size=hd720:rate=30 \
    output.mp4
```

## To add a text overlay to a video clip we need:

- a plaintext file that contains the text we want to overlay `text-content.txt` and 
- the video source clip to append the new text to, and
- a utility script `add-text-overlay.sh` to put them all together



**`text-content.txt`** - the text to overlay

```
The quick brown
fox jumps over
the lazy dog
```
We are using an external text file because we want to control the line breaks.



**`input-clip.mp4`** - the "raw" source clip - use any of the examples generators from above

```bash
ffmpeg -f lavfi -i smptebars=duration=5:size=hd720:rate=30 "input-clip.mp4"
```



**`add-text-overlay.sh`** - the reusable utility script

 If you did not need wrapping text then replace the `textfile=$textfile` *with* `text='a simple string'`

```bash
#!/bin/bash

# uses the argument list to pass props
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
```

Then finally bring it all together using `sh`

```bash
sh add-text-overlay.sh "input-clip.mp4" "output-clip.mp4" "text-content.txt"
```

**Note**: the font `URWGothic-Demi.otf` needs to be in the same folder as the script

## Concatenate multiple videos into one

(See the ffmpeg website for more detailed examples https://trac.ffmpeg.org/wiki/Concatenate)

**Using an external file list** (recommended)
If your clips in different folder then `content-clips.txt` is the neatest way. The text file locates clips in the order they are listed. This one looks in `source/` and `content/` folders.

```bash
# content-clips.txt
file source/red.mp4
file source/green.mp4
file content/tutorial.mp4
file source/yellow.mp4

# external text file list
ffmpeg -f concat \
    -i content-clips.txt \
    -c copy \
    output.mp4
```

Alternatively you can bash expressionto generate the `"file ...\nfile ...\n"` list.  

**Using an inline expression to create the file list**

```bash
# expression creates file list
ffmpeg -f concat \
	-safe 0 \
	-i <(for f in red.mp4 green.mp4 ../content/tutorial.mp4 yellow.mp4; \
	do echo "file '$PWD/$f'"; done) \
	-c copy \
	output.mp4
```

**Note:** this example shows how to use relative paths to construct the file list.
