# lovehandles

A library to load another library in a thread, and call it async. You need [bitser](https://raw.githubusercontent.com/gvx/bitser/master/bitser.lua) in your lua require-path.

This can be useful for things like [luajit-request](https://github.com/LPGhatguy/luajit-request), for making async http(s)-requests in love2d.

If you want to try out the [example](example/) clone recursively, to get sub-modules:

```
git clone --recursive https://github.com/notnullgames/lovehandles.git
```

As a sidenote, [loverest](https://github.com/notnullgames/loverest) is essentially a pre-wrapped verison of this, for easier use with JSON in/out APIs. 

## caveats

There are probly a few, but this can only pass regular lua types (table, string, int, etc) as args. I may add support for registering classes, in the future, but that is not in there, now.

## basic usage

```lua
local lovehandles = require("lovehandles")

-- this sets up any other code, in that thread
local req = lovehandles([[
  local url, options = ...
  local r = require("luajit-request")
  return r.send(url, options)
]])
```

Now, you have an async function:

```lua
-- this holds a reference to the async thread
local google

function love.load()
  -- start the request, return immediately
  google = req('https://google.com')
end

function love.update(dt)
  local output, error = google()
  if output and not error then
    -- do something with text of the page
    -- if you reset google by calling req again, it will also be reset above
  end
end
```

`google` (the async handle) will return `output`/`error`, once it's finished, so you can check for that.

## using a lib in a subdir

You might want to keep your external library-code in a subdir. This is a general issue for love/lua apps, but the best way is to just modify your require-path. Let's imagine I want to keep stuff in `vendor/`, and I want to do git-submodules to track upstream changes, so things might not be in the top-dir. I have included a tiny function for that situation:

```lua
-- first one needs full path
local add_path = require('vendor.lovehandles.add_path')

add_path('vendor/lovehandles')
add_path('vendor/bitser')
add_path('vendor/luajit-request')

-- these libs will be found:
-- vendor/lovehandles/lovehandles.lua
-- vendor/bitser/bitser.lua
-- vendor/luajit-request/luajit-request/init.lua

-- now you have a loaded path, so just require stuff
local lovehandles = require("lovehandles")
```

This is pretty much how I setup [example](example/).
