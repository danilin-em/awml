all: requirements

requirements:
	git clone git@github.com:lcpz/lain.git
Xephyr:
	Xephyr -ac -nolisten tcp -br -noreset -screen 1600x884 :1
linter:
	luacheck rc.lua lib services theme
syntax:
	awesome -k -c rc.lua
rundev: syntax
	AWESOME_ROOT=$(shell pwd) DISPLAY=:1.0 awesome -c rc.lua
replace: syntax
	AWESOME_ROOT=$(shell pwd) awesome --replace -c rc.lua
