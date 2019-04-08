//
//  lua_binding.h

//
//  Created by zhouhouzhen on 15-7-21.
//  Copyright (c) 2015年 Umeng Inc. All rights reserved.
//
#ifndef __LUA_BINGING_H__
#define __LUA_BINGING_H__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif


/**
 * Call this function can import the lua bindings for the mobclick module and start mobclick.
 * After registering, we could call the related mobclick code conveniently in the lua.
 */

int lua_register_mobclick_module(lua_State* L);

#endif //#ifndef __LUA_BINGING_H__
