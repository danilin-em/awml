all:

Xephyr:
	Xephyr -ac -nolisten tcp -br -noreset -screen 1600x884 :1
syntax:
	awesome -k -c rc.lua
rundev: syntax
	DISPLAY=:1.0 awesome -c rc.lua
