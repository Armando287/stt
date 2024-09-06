@echo off

REM Obtiene el nombre del archivo sin la extensión
set filename=%~n1
REM Obtiene la extensión del archivo
set extension=%~x1

REM Genera archivos HLS para cada pista de audio
ffmpeg -i "%filename%%extension%" -vn -map 0:a:0 -c:a copy -hls_time 10 -hls_list_size 0 "%filename%_audio_0.m3u8"
ffmpeg -i "%filename%%extension%" -vn -map 0:a:1 -c:a copy -hls_time 10 -hls_list_size 0 "%filename%_audio_1.m3u8"
ffmpeg -i "%filename%%extension%" -vn -map 0:a:2 -c:a copy -hls_time 10 -hls_list_size 0 "%filename%_audio_2.m3u8"
ffmpeg -i "%filename%%extension%" -vn -map 0:a:2 -c:a copy -hls_time 10 -hls_list_size 0 "%filename%_audio_3.m3u8"
ffmpeg -i "%filename%%extension%" -vn -map 0:a:2 -c:a copy -hls_time 10 -hls_list_size 0 "%filename%_audio_4.m3u8"

REM Genera archivo HLS para el video principal
ffmpeg -i "%filename%%extension%" -c:v copy -map 0:v -hls_time 10 -hls_list_size 0 "%filename%_video.m3u8"

REM Check if any error
if %ERRORLEVEL% == 0 goto :next
echo "Se encontraron errores durante la ejecución. Salido con estado: %errorlevel%"
goto :endofscript

:next
echo "Generando lista de reproducción m3u8 general...."
REM Genera una lista de reproducción general.
(
echo #EXTM3U> master.m3u8
echo #EXT-X-VERSION:4>> master.m3u8
echo #EXT-X-INDEPENDENT-SEGMENTS>> master.m3u8
echo #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="1",LANGUAGE="1",URI=%filename%_audio_0.m3u8,DEFAULT=NO,AUTOSELECT=NO>> master.m3u8
echo #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="2",LANGUAGE="2",URI=%filename%_audio_1.m3u8,DEFAULT=YES,AUTOSELECT=YES>> master.m3u8
echo #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="3",LANGUAGE="3",URI=%filename%_audio_2.m3u8,DEFAULT=NO,AUTOSELECT=NO>> master.m3u8
echo #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="4",LANGUAGE="4",URI=%filename%_audio_2.m3u8,DEFAULT=NO,AUTOSELECT=NO>> master.m3u8

echo #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2560000,RESOLUTION=1920x1080,CODECS="mp4a.40.2,avc1.640028",FRAME-RATE=24.0,CLOSED-CAPTIONS=NONE,AUDIO="audio">> master.m3u8
echo %filename%_video.m3u8>> master.m3u8
echo #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1370000,RESOLUTION=1280x720,CODECS="mp4a.40.2,avc1.4d401f",FRAME-RATE=24.0,CLOSED-CAPTIONS=NONE,AUDIO="audio">> master.m3u8
echo %filename%_video.m3u8>> master.m3u8

)
echo "Lista de reproducción m3u8 general generada."

:endofscript
echo "Trabajo completo."

REM Brought to you by Duke Yin www.dukeyin.com
pause
