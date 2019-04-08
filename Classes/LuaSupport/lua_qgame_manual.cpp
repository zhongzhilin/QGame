#include "lua_qgame_manual.hpp"
#include "LuaQgameExport.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"

#ifndef CC_SAFE_DELETE_ARRAY
#define do { if(p) { delete[] (p); (p) = nullptr; } } while(0)
#endif

int lua_qgame_CCHgame_exitQuickSdk(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int handler =  toluafix_ref_function(tolua_S,2,0);
        CCHgame::exitQuickSdk(handler);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:exitQuickSdk",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_exitQuickSdk'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_initQuickSdk(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 6)
    {

        int handler1 =  toluafix_ref_function(tolua_S,2,0);
        int handler2 =  toluafix_ref_function(tolua_S,3,0);
        int handler3 =  toluafix_ref_function(tolua_S,4,0);
        int handler4 =  toluafix_ref_function(tolua_S,5,0);
        int handler5 =  toluafix_ref_function(tolua_S,6,0);
        int handler6 =  toluafix_ref_function(tolua_S,7,0);
        CCHgame::initQuickSdk(handler1,handler2,handler3,handler4,handler5,handler6);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:initQuickSdk",argc, 6);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_initQuickSdk'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_StartDraw(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;
    if (argc == 4)
    {
        const cocos2d::Vec2* arg0;
        unsigned int arg1;
        int handler =  toluafix_ref_function(tolua_S,2,0);
        size_t size = lua_tonumber(tolua_S, 4);
        int drawTurn = lua_tonumber(tolua_S, 5);
            
        if ( size > 0 )
        {
            cocos2d::Vec2* points = new cocos2d::Vec2[size];
            if (NULL == points)
                return 0;
            
            for (int i = 0; i < size; i++)
            {
                lua_pushnumber(tolua_S,i + 1);
                lua_gettable(tolua_S,3);
#if COCOS2D_DEBUG >= 1
                if (!tolua_istable(tolua_S,-1, 0, &tolua_err))
                {
                    CC_SAFE_DELETE_ARRAY(points);
                    goto tolua_lerror;
                }
#endif
                
                if(!luaval_to_vec2(tolua_S, lua_gettop(tolua_S), &points[i], "cc.DrawNode:drawPolygon"))
                {
                    lua_pop(tolua_S, 1);
                    CC_SAFE_DELETE_ARRAY(points);
                    return 0;
                }
                lua_pop(tolua_S, 1);
            }
            
            CCHgame::StartDraw(handler, points,(int)size,drawTurn);
            CC_SAFE_DELETE_ARRAY(points);
            return 0;
        }   
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:StartDraw",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_StartDraw'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_isSpriteTouchByPix(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        unsigned int arg0;
        cocos2d::Point arg1;
        cocos2d::Sprite* arg2;
        int handler =  toluafix_ref_function(tolua_S,2,0);
        ok &= luaval_to_point(tolua_S, 3, &arg1, "CCHgame:isSpriteTouchByPix");
        ok &= luaval_to_object<cocos2d::Sprite>(tolua_S, 4, "cc.Sprite",&arg2, "CCHgame:isSpriteTouchByPix");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_isSpriteTouchByPix'", nullptr);
            return 0;
        }
        bool ret = CCHgame::isSpriteTouchByPix(handler, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:isSpriteTouchByPix",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_isSpriteTouchByPix'.",&tolua_err);
#endif
    return 0;
}

int register_qgame_CCHgame_manual(lua_State* tolua_S)
{
    lua_pushstring(tolua_S, "CCHgame");
    lua_rawget(tolua_S, LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"StartDraw");
        lua_pushcfunction(tolua_S,lua_qgame_CCHgame_StartDraw );
        lua_rawset(tolua_S,-3);

        lua_pushstring(tolua_S,"isSpriteTouchByPix");
        lua_pushcfunction(tolua_S,lua_qgame_CCHgame_isSpriteTouchByPix );
        lua_rawset(tolua_S,-3);   

        lua_pushstring(tolua_S,"initQuickSdk");
        lua_pushcfunction(tolua_S,lua_qgame_CCHgame_initQuickSdk);
        lua_rawset(tolua_S,-3); 

        lua_pushstring(tolua_S,"exitQuickSdk");
        lua_pushcfunction(tolua_S,lua_qgame_CCHgame_exitQuickSdk);
        lua_rawset(tolua_S,-3); 

    }
    lua_pop(tolua_S, 1);

	return 0;
}