

struct A {}


function A:__getmethod(methodname)
	local c = methodname:sub(1,1):byte()
	return terra(a : &A)
		return c
	end
end


terra foo()
	var a : A
	return a:a() + a:b()
end

assert(foo() == ("a"):byte() + ("b"):byte())
