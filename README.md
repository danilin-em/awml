# Awesome WM

![Screenshot Main](./doc/screenshot-main.png)

## Development

### Debug

```sh

Xephyr -ac -nolisten tcp -br -noreset -screen 1600x850 :1

awesome -k -c ./rc.lua

DISPLAY=:1.0 awesome -c ./rc.lua

```
