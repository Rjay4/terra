C = terralib.includecstring [[
    typedef int (*PROC)();
    PROC what() { return 0; }
]]

assert(C.what() == nil or -- for puc lua
tonumber(C.what()) == 0)