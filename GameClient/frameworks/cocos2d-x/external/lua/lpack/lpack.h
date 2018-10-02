#ifndef LPACK_H
#define LPACK_H
//
//  lpack.h
//  cocos2d_lua_bindings
//
//  Created by sherlock on 2017/3/6.
//
//
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

TOLUA_API int luaopen_pack(lua_State *L);

#endif /* LPACK_H */