

struct Array {
    data : int[3];
}
Array.__for = function(iter,bodycallback)
    return quote
        var it = &iter
        for i = 0,3 do
            [bodycallback(`&it.data[i])]
        end
    end
end

terra foo()
    var a = Array{ array(1,2,3) }
    for i in a do
        @i = @i + 1
    end
    return a.data[0] + a.data[1] + a.data[2]
end

terra foo2()
    var a = Array{ array(1,2,3) }
    var s = 0
    for i : &int in a do
        s = s + @i
    end
    return s
end

assert(foo() == 9)

assert(foo2() == 6)
