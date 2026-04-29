all:	vidsrc/rick.mp4 html/output.mpd
	@docker rm -f rick
	@docker rmi -f rick-nginx
	@docker build -t rick-nginx .

vidsrc/rick.mp4:
	@mkdir -p vidsrc
	@wget https://archive.org/download/Rick_Astley_Never_Gonna_Give_You_Up/Rick_Astley_Never_Gonna_Give_You_Up.mp4 -O vidsrc/rick.mp4

run:
	@docker run --name rick -d -p 8080:80 rick-nginx

clean:
	@rm -f vidsrc/rick.mp4
	@rm -f html/*.m4s
	@rm -f html/*.mpd
	@docker rm -f rick
	@docker rmi -f rick-nginx

html/output.mpd:
	@cd html; ffmpeg -i ../vidsrc/rick.mp4 \
	  -c:v libx264 -b:v 800k -preset veryfast -profile:v main -level 4.0 \
	  -pix_fmt yuv420p -c:a aac -b:a 96k \
	  -f dash -dash_segment_type mp4 -seg_duration 4 \
	  -adaptation_sets "id=0,streams=v id=1,streams=a" \
	  output.mpd
	
