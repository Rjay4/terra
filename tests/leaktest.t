local leak = require "lib.leak"

function make()
  local terra a(x:int)
    return x+1
  end

  local terra b(x:int)
    return a(x)
  end

  return b(12),leak.track(b)
end
nan = 0/0
res,t=make()
assert(res == 13)
local gcd, path = leak.find(t)
if gcd then
	print(path)
   if path:match("failed to find the path to object") then
      print("I couldn't find the path, so not reporting an error but this is suspicious...")
      return
   end
   error("leaked")
end

l = leak.track(leak)
foo = 0/0
local f,p = leak.find(l)
assert(f)
assert(p == "$locals.leak")
