C = terralib.includecstring [[
	#include <stdio.h>
	#include <stdlib.h>
]]
local arraytypes = {}
function Array(T)
	local struct ArrayImpl {
		data : &T;
		N : int;
	}
	function ArrayImpl:__typename()
	    return "Array("..tostring(T)..")"
	end
	arraytypes[ArrayImpl] = true
	terra ArrayImpl:init(N : int)
		self.data = [&T](C.malloc(N*sizeof(T)))
		self.N = N
	end
	terra ArrayImpl:free()
		C.free(self.data)
	end
	ArrayImpl.__apply = macro(function(self,idx)
		return `self.data[idx]
	end)
	function ArrayImpl:__methodmissing(methodname,...)
		local args = terralib.newlist {...}
		local i = symbol(int)
		local promotedargs = args:map(function(a)
			if arraytypes[a:gettype()] then
				return `a(i)
			else
				return a
			end
		end)
		return quote
			var selfv = self
			var r : ArrayImpl
			r:init(selfv.N)
			for [i] = 0,r.N do
				r.data[i] = selfv.data[i]:[methodname](promotedargs)
			end
		in
			r
		end
	end
	return ArrayImpl
end

struct Complex {
	real : float;
	imag : float;
}

terra Complex:add(c : Complex)
	return Complex { self.real + c.real, self.imag + c.imag }
end

ComplexArray = Array(Complex)
N = 10
terra testit()
	var ca : ComplexArray
	ca:init(N)
	for i = 0,N do
		ca(i) = Complex { i, i + 1 }
	end
	var ra = ca:add(ca)
	return ra
end
local r = testit()
assert(r.N == N)
for i = 0,N-1 do
	assert(r.data[i].real == 2*i)
	assert(r.data[i].imag == 2*(i+1))
end
assert(tostring(Array(int)) == "Array(int32)")
