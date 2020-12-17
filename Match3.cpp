// Match3.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#pragma comment(lib, "lua54.lib")
extern "C" {
# include "lua.h"
# include "lauxlib.h"
# include "lualib.h"
}
#include <conio.h> // надо для _getch()
#include <iostream>

int main(int argc, char* argv[])
{
    auto lvm = luaL_newstate();
    if (lvm)
    {
        luaL_openlibs(lvm);

        if (luaL_dofile(lvm, "App.lua") != LUA_OK)
        {
            std::cerr << "Lua error:" << std::endl;
            auto msg = luaL_checkstring(lvm, -1);
            if (msg)
                std::cerr << msg << std::endl;
        }
        lua_close(lvm);
    }
    return 0;
}