all:

Xephyr:
	Xephyr -ac -nolisten tcp -br -noreset -screen 1600x884 :1
rundev:
	awesome -k -c rc.lua
	DISPLAY=:1.0 awesome -c rc.lua
