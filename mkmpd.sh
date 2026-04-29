rm -f html/*
cp htmlsrc/* html/
cd html
ffmpeg -i ../vidsrc/rick.mp4 \
  -c:v libx264 -preset veryfast -profile:v main -level 4.0 \
  -pix_fmt yuv420p -c:a aac -b:a 128k \
  -f dash -dash_segment_type mp4 -seg_duration 4 \
  -adaptation_sets "id=0,streams=v id=1,streams=a" \
  output.mpd
