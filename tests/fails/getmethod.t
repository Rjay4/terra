if not require("fail") then return end


struct A {}

function A.__getmethod()
	error("nope!")
end

terra foo()
	var a : A
	return a:bar()
end

foo()
