#include "lua_qgame_auto.hpp"
#include "LuaQgameExport.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_qgame_CCHgame_tDSetPublicProperties(lua_State* tolua_S)
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

    if (argc == 5)
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDSetPublicProperties");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDSetPublicProperties");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:tDSetPublicProperties");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:tDSetPublicProperties");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "CCHgame:tDSetPublicProperties");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDSetPublicProperties'", nullptr);
            return 0;
        }
        CCHgame::tDSetPublicProperties(arg0, arg1, arg2, arg3, arg4);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDSetPublicProperties",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDSetPublicProperties'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_tDRegister(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDRegister'", nullptr);
            return 0;
        }
        CCHgame::tDRegister();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDRegister",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDRegister'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDSetAccountId(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDSetAccountId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDSetAccountId'", nullptr);
            return 0;
        }
        CCHgame::tDSetAccountId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDSetAccountId",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDSetAccountId'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDRemoveAccountId(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDRemoveAccountId'", nullptr);
            return 0;
        }
        CCHgame::tDRemoveAccountId();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDRemoveAccountId",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDRemoveAccountId'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDLoginOut(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDLoginOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDLoginOut'", nullptr);
            return 0;
        }
        CCHgame::tDLoginOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDLoginOut",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDLoginOut'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_tDLogin(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDLogin'", nullptr);
            return 0;
        }
        CCHgame::tDLogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDLogin",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDLogin'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDLevelup(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDLevelup");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDLevelup'", nullptr);
            return 0;
        }
        CCHgame::tDLevelup(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDLevelup",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDLevelup'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_tDChat(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDChat");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDChat");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDChat'", nullptr);
            return 0;
        }
        CCHgame::tDChat(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDChat",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDChat'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDCreateRole(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDCreateRole");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDCreateRole'", nullptr);
            return 0;
        }
        CCHgame::tDCreateRole(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDCreateRole",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDCreateRole'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDOrderInit(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        double arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDOrderInit");
        ok &= luaval_to_number(tolua_S, 3,&arg1, "CCHgame:tDOrderInit");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDOrderInit'", nullptr);
            return 0;
        }
        CCHgame::tDOrderInit(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDOrderInit",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDOrderInit'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDOrderFinish(lua_State* tolua_S)
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
        std::string arg0;
        std::string arg1;
        double arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDOrderFinish");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDOrderFinish");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "CCHgame:tDOrderFinish");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDOrderFinish'", nullptr);
            return 0;
        }
        CCHgame::tDOrderFinish(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDOrderFinish",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDOrderFinish'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_tDJoinGuild(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDJoinGuild");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDJoinGuild");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDJoinGuild'", nullptr);
            return 0;
        }
        CCHgame::tDJoinGuild(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDJoinGuild",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDJoinGuild'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDLeaveGuild(lua_State* tolua_S)
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
        std::string arg0;
        std::string arg1;
        std::string arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDLeaveGuild");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDLeaveGuild");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:tDLeaveGuild");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDLeaveGuild'", nullptr);
            return 0;
        }
        CCHgame::tDLeaveGuild(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDLeaveGuild",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDLeaveGuild'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDCreateGuild(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDCreateGuild");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDCreateGuild");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDCreateGuild'", nullptr);
            return 0;
        }
        CCHgame::tDCreateGuild(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDCreateGuild",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDCreateGuild'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDArenaEnter(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDArenaEnter");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDArenaEnter'", nullptr);
            return 0;
        }
        CCHgame::tDArenaEnter(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDArenaEnter",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDArenaEnter'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDArenaWin(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDArenaWin");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDArenaWin");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDArenaWin'", nullptr);
            return 0;
        }
        CCHgame::tDArenaWin(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDArenaWin",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDArenaWin'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_tDArenaLost(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDArenaLost");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDArenaLost");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDArenaLost'", nullptr);
            return 0;
        }
        CCHgame::tDArenaLost(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDArenaLost",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDArenaLost'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDAddFriend(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDAddFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDAddFriend'", nullptr);
            return 0;
        }
        CCHgame::tDAddFriend(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDAddFriend",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDAddFriend'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDDelFriend(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDDelFriend");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDDelFriend'", nullptr);
            return 0;
        }
        CCHgame::tDDelFriend(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDDelFriend",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDDelFriend'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_tDShopBuy(lua_State* tolua_S)
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
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDShopBuy");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDShopBuy");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:tDShopBuy");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:tDShopBuy");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDShopBuy'", nullptr);
            return 0;
        }
        CCHgame::tDShopBuy(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDShopBuy",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDShopBuy'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDSommon(lua_State* tolua_S)
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
        std::string arg0;
        std::string arg1;
        std::string arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDSommon");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDSommon");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:tDSommon");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDSommon'", nullptr);
            return 0;
        }
        CCHgame::tDSommon(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDSommon",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDSommon'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDSetUserProper(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDSetUserProper");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDSetUserProper");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDSetUserProper'", nullptr);
            return 0;
        }
        CCHgame::tDSetUserProper(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDSetUserProper",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDSetUserProper'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_tDAddUserProper(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:tDAddUserProper");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:tDAddUserProper");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_tDAddUserProper'", nullptr);
            return 0;
        }
        CCHgame::tDAddUserProper(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:tDAddUserProper",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_tDAddUserProper'.",&tolua_err);
#endif
    return 0;
}






int lua_qgame_ResourceManager_timeEnd(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_timeEnd'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 1) {
            int arg0;
            ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ResourceManager:timeEnd");

            if (!ok) { break; }
            double ret = cobj->timeEnd(arg0);
            tolua_pushnumber(tolua_S,(lua_Number)ret);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 1) {
            std::string arg0;
            ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ResourceManager:timeEnd");

            if (!ok) { break; }
            double ret = cobj->timeEnd(arg0);
            tolua_pushnumber(tolua_S,(lua_Number)ret);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "ResourceManager:timeEnd",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_timeEnd'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_StopBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_StopBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_StopBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->StopBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:StopBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_StopBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_PauseBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_PauseBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_PauseBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->PauseBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:PauseBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_PauseBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_PlayEffect(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_PlayEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ResourceManager:PlayEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_PlayEffect'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->PlayEffect(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    if (argc == 2) 
    {
        const char* arg0;
        double arg1;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ResourceManager:PlayEffect"); arg0 = arg0_tmp.c_str();

        ok &= luaval_to_number(tolua_S, 3,&arg1, "ResourceManager:PlayEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_PlayEffect'", nullptr);
            return 0;
        }
        unsigned int ret = cobj->PlayEffect(arg0, arg1);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:PlayEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_PlayEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_PauseAllEffects(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_PauseAllEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_PauseAllEffects'", nullptr);
            return 0;
        }
        cobj->PauseAllEffects();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:PauseAllEffects",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_PauseAllEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_PlayBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_PlayBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ResourceManager:PlayBackgroundMusic"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_PlayBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->PlayBackgroundMusic(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:PlayBackgroundMusic",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_PlayBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_EnableSound(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_EnableSound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_EnableSound'", nullptr);
            return 0;
        }
        cobj->EnableSound();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:EnableSound",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_EnableSound'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_showTimeLog(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_showTimeLog'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_showTimeLog'", nullptr);
            return 0;
        }
        cobj->showTimeLog();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ResourceManager:showTimeLog");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_showTimeLog'", nullptr);
            return 0;
        }
        cobj->showTimeLog(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:showTimeLog",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_showTimeLog'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_SetBackgroundMusicVolumn(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_SetBackgroundMusicVolumn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "ResourceManager:SetBackgroundMusicVolumn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_SetBackgroundMusicVolumn'", nullptr);
            return 0;
        }
        cobj->SetBackgroundMusicVolumn(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:SetBackgroundMusicVolumn",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_SetBackgroundMusicVolumn'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_init(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_init'", nullptr);
            return 0;
        }
        cobj->init();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_init'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_StopEffect(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_StopEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned int arg0;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "ResourceManager:StopEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_StopEffect'", nullptr);
            return 0;
        }
        cobj->StopEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:StopEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_StopEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_showCurTime(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_showCurTime'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_showCurTime'", nullptr);
            return 0;
        }
        cobj->showCurTime();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:showCurTime",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_showCurTime'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_TestCPPCrash(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_TestCPPCrash'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_TestCPPCrash'", nullptr);
            return 0;
        }
        cobj->TestCPPCrash();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:TestCPPCrash",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_TestCPPCrash'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_DisableSound(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_DisableSound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_DisableSound'", nullptr);
            return 0;
        }
        cobj->DisableSound();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:DisableSound",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_DisableSound'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_preloadEffect(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_preloadEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        const char* arg0;

        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "ResourceManager:preloadEffect"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_preloadEffect'", nullptr);
            return 0;
        }
        cobj->preloadEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:preloadEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_preloadEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_ResumeBackgroundMusic(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_ResumeBackgroundMusic'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_ResumeBackgroundMusic'", nullptr);
            return 0;
        }
        cobj->ResumeBackgroundMusic();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:ResumeBackgroundMusic",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_ResumeBackgroundMusic'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_ResumeAllEffects(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_ResumeAllEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_ResumeAllEffects'", nullptr);
            return 0;
        }
        cobj->ResumeAllEffects();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:ResumeAllEffects",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_ResumeAllEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_IsSoundEnable(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_IsSoundEnable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_IsSoundEnable'", nullptr);
            return 0;
        }
        bool ret = cobj->IsSoundEnable();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:IsSoundEnable",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_IsSoundEnable'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_StopAllEffects(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_StopAllEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_StopAllEffects'", nullptr);
            return 0;
        }
        cobj->StopAllEffects();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:StopAllEffects",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_StopAllEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_UpdateSoundEnable(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_UpdateSoundEnable'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_UpdateSoundEnable'", nullptr);
            return 0;
        }
        cobj->UpdateSoundEnable();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:UpdateSoundEnable",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_UpdateSoundEnable'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_SetEffectVolumn(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_SetEffectVolumn'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        unsigned int arg0;
        double arg1;

        ok &= luaval_to_uint32(tolua_S, 2,&arg0, "ResourceManager:SetEffectVolumn");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "ResourceManager:SetEffectVolumn");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_SetEffectVolumn'", nullptr);
            return 0;
        }
        cobj->SetEffectVolumn(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:SetEffectVolumn",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_SetEffectVolumn'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_timeBegin(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (ResourceManager*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_qgame_ResourceManager_timeBegin'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 1) {
            int arg0;
            ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ResourceManager:timeBegin");

            if (!ok) { break; }
            cobj->timeBegin(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 1) {
            std::string arg0;
            ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ResourceManager:timeBegin");

            if (!ok) { break; }
            cobj->timeBegin(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "ResourceManager:timeBegin",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_timeBegin'.",&tolua_err);
#endif

    return 0;
}
int lua_qgame_ResourceManager_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ResourceManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_getInstance'", nullptr);
            return 0;
        }
        ResourceManager* ret = ResourceManager::getInstance();
        object_to_luaval<ResourceManager>(tolua_S, "ResourceManager",(ResourceManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ResourceManager:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_getInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_ResourceManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    ResourceManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_ResourceManager_constructor'", nullptr);
            return 0;
        }
        cobj = new ResourceManager();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"ResourceManager");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ResourceManager:ResourceManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_ResourceManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_qgame_ResourceManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (ResourceManager)");
    return 0;
}

int lua_register_qgame_ResourceManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ResourceManager");
    tolua_cclass(tolua_S,"ResourceManager","ResourceManager","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"ResourceManager");
        tolua_function(tolua_S,"new",lua_qgame_ResourceManager_constructor);
        tolua_function(tolua_S,"timeEnd",lua_qgame_ResourceManager_timeEnd);
        tolua_function(tolua_S,"StopBackgroundMusic",lua_qgame_ResourceManager_StopBackgroundMusic);
        tolua_function(tolua_S,"PauseBackgroundMusic",lua_qgame_ResourceManager_PauseBackgroundMusic);
        tolua_function(tolua_S,"PlayEffect",lua_qgame_ResourceManager_PlayEffect);
        tolua_function(tolua_S,"PauseAllEffects",lua_qgame_ResourceManager_PauseAllEffects);
        tolua_function(tolua_S,"PlayBackgroundMusic",lua_qgame_ResourceManager_PlayBackgroundMusic);
        tolua_function(tolua_S,"EnableSound",lua_qgame_ResourceManager_EnableSound);
        tolua_function(tolua_S,"showTimeLog",lua_qgame_ResourceManager_showTimeLog);
        tolua_function(tolua_S,"SetBackgroundMusicVolumn",lua_qgame_ResourceManager_SetBackgroundMusicVolumn);
        tolua_function(tolua_S,"init",lua_qgame_ResourceManager_init);
        tolua_function(tolua_S,"StopEffect",lua_qgame_ResourceManager_StopEffect);
        tolua_function(tolua_S,"showCurTime",lua_qgame_ResourceManager_showCurTime);
        tolua_function(tolua_S,"TestCPPCrash",lua_qgame_ResourceManager_TestCPPCrash);
        tolua_function(tolua_S,"DisableSound",lua_qgame_ResourceManager_DisableSound);
        tolua_function(tolua_S,"preloadEffect",lua_qgame_ResourceManager_preloadEffect);
        tolua_function(tolua_S,"ResumeBackgroundMusic",lua_qgame_ResourceManager_ResumeBackgroundMusic);
        tolua_function(tolua_S,"ResumeAllEffects",lua_qgame_ResourceManager_ResumeAllEffects);
        tolua_function(tolua_S,"IsSoundEnable",lua_qgame_ResourceManager_IsSoundEnable);
        tolua_function(tolua_S,"StopAllEffects",lua_qgame_ResourceManager_StopAllEffects);
        tolua_function(tolua_S,"UpdateSoundEnable",lua_qgame_ResourceManager_UpdateSoundEnable);
        tolua_function(tolua_S,"SetEffectVolumn",lua_qgame_ResourceManager_SetEffectVolumn);
        tolua_function(tolua_S,"timeBegin",lua_qgame_ResourceManager_timeBegin);
        tolua_function(tolua_S,"getInstance", lua_qgame_ResourceManager_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(ResourceManager).name();
    g_luaType[typeName] = "ResourceManager";
    g_typeCast["ResourceManager"] = "ResourceManager";
    return 1;
}

int lua_qgame_CCHgame_CallRenderRender(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_CallRenderRender'", nullptr);
            return 0;
        }
        bool ret = CCHgame::CallRenderRender();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:CallRenderRender",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_CallRenderRender'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_addIntegerProperty(lua_State* tolua_S)
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

    if (argc == 2)
    {
        const char* arg0;
        int arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_addIntegerProperty"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "CCHgame:hs_addIntegerProperty");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_addIntegerProperty'", nullptr);
            return 0;
        }
        bool ret = CCHgame::hs_addIntegerProperty(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_addIntegerProperty",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_addIntegerProperty'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_isConversationActive(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_isConversationActive'", nullptr);
            return 0;
        }
        bool ret = CCHgame::hs_isConversationActive();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_isConversationActive",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_isConversationActive'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_showInbox(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_showInbox'", nullptr);
            return 0;
        }
        CCHgame::hs_showInbox();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_showInbox",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_showInbox'.",&tolua_err);
#endif
    return 0;
}

int lua_qgame_CCHgame_setPasteBoard(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:setPasteBoard"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_setPasteBoard'", nullptr);
            return 0;
        }
        CCHgame::setPasteBoard(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:setPasteBoard",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_setPasteBoard'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_isRectIntersectRect(lua_State* tolua_S)
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
        cocos2d::Rect arg0;
        cocos2d::Point arg1;
        double arg2;
        ok &= luaval_to_rect(tolua_S, 2, &arg0, "CCHgame:isRectIntersectRect");
        ok &= luaval_to_point(tolua_S, 3, &arg1, "CCHgame:isRectIntersectRect");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "CCHgame:isRectIntersectRect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_isRectIntersectRect'", nullptr);
            return 0;
        }
        bool ret = CCHgame::isRectIntersectRect(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:isRectIntersectRect",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_isRectIntersectRect'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_callCustomerService(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_callCustomerService'", nullptr);
            return 0;
        }
        CCHgame::callCustomerService();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:callCustomerService",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_callCustomerService'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_AdLevelAchieved(lua_State* tolua_S)
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

    if (argc == 2)
    {
        int arg0;
        int arg1;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CCHgame:AdLevelAchieved");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "CCHgame:AdLevelAchieved");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_AdLevelAchieved'", nullptr);
            return 0;
        }
        CCHgame::AdLevelAchieved(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:AdLevelAchieved",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_AdLevelAchieved'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logSpentCreditsEvent(lua_State* tolua_S)
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
        std::string arg0;
        std::string arg1;
        double arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:logSpentCreditsEvent");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:logSpentCreditsEvent");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "CCHgame:logSpentCreditsEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logSpentCreditsEvent'", nullptr);
            return 0;
        }
        CCHgame::logSpentCreditsEvent(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logSpentCreditsEvent",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logSpentCreditsEvent'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_downloadFile(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:downloadFile");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:downloadFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_downloadFile'", nullptr);
            return 0;
        }
        CCHgame::downloadFile(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:downloadFile",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_downloadFile'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_showFAQSection(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 2)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_showFAQSection"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            cocos2d::ValueMap arg1;
            ok &= luaval_to_ccvaluemap(tolua_S, 3, &arg1, "CCHgame:hs_showFAQSection");
            if (!ok) { break; }
            CCHgame::hs_showFAQSection(arg0, arg1);
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 1)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_showFAQSection"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            CCHgame::hs_showFAQSection(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "CCHgame:hs_showFAQSection",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_showFAQSection'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_setWaterShader(lua_State* tolua_S)
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

    if (argc == 2)
    {
        cocos2d::Sprite* arg0;
        std::string arg1;
        ok &= luaval_to_object<cocos2d::Sprite>(tolua_S, 2, "cc.Sprite",&arg0, "CCHgame:setWaterShader");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:setWaterShader");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_setWaterShader'", nullptr);
            return 0;
        }
        CCHgame::setWaterShader(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:setWaterShader",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_setWaterShader'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_setLineShader(lua_State* tolua_S)
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
        cocos2d::Sprite* arg0;
        ok &= luaval_to_object<cocos2d::Sprite>(tolua_S, 2, "cc.Sprite",&arg0, "CCHgame:setLineShader");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_setLineShader'", nullptr);
            return 0;
        }
        CCHgame::setLineShader(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:setLineShader",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_setLineShader'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_addDateProperty(lua_State* tolua_S)
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

    if (argc == 2)
    {
        const char* arg0;
        double arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_addDateProperty"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_number(tolua_S, 3,&arg1, "CCHgame:hs_addDateProperty");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_addDateProperty'", nullptr);
            return 0;
        }
        bool ret = CCHgame::hs_addDateProperty(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_addDateProperty",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_addDateProperty'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_addBooleanProperty(lua_State* tolua_S)
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

    if (argc == 2)
    {
        const char* arg0;
        bool arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_addBooleanProperty"); arg0 = arg0_tmp.c_str();
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "CCHgame:hs_addBooleanProperty");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_addBooleanProperty'", nullptr);
            return 0;
        }
        bool ret = CCHgame::hs_addBooleanProperty(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_addBooleanProperty",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_addBooleanProperty'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_updateRoleInfoWith(lua_State* tolua_S)
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

    if (argc == 18)
    {
        int arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        std::string arg5;
        std::string arg6;
        std::string arg7;
        std::string arg8;
        std::string arg9;
        std::string arg10;
        std::string arg11;
        std::string arg12;
        std::string arg13;
        std::string arg14;
        std::string arg15;
        std::string arg16;
        std::string arg17;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 8,&arg6, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 9,&arg7, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 10,&arg8, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 11,&arg9, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 12,&arg10, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 13,&arg11, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 14,&arg12, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 15,&arg13, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 16,&arg14, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 17,&arg15, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 18,&arg16, "CCHgame:updateRoleInfoWith");
        ok &= luaval_to_std_string(tolua_S, 19,&arg17, "CCHgame:updateRoleInfoWith");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_updateRoleInfoWith'", nullptr);
            return 0;
        }
        CCHgame::updateRoleInfoWith(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:updateRoleInfoWith",argc, 18);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_updateRoleInfoWith'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_leaveBreadCrumb(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_leaveBreadCrumb"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_leaveBreadCrumb'", nullptr);
            return 0;
        }
        CCHgame::hs_leaveBreadCrumb(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_leaveBreadCrumb",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_leaveBreadCrumb'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_addStringProperty(lua_State* tolua_S)
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

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_addStringProperty"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CCHgame:hs_addStringProperty"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_addStringProperty'", nullptr);
            return 0;
        }
        bool ret = CCHgame::hs_addStringProperty(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_addStringProperty",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_addStringProperty'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_loginQuick(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_loginQuick'", nullptr);
            return 0;
        }
        CCHgame::loginQuick();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:loginQuick",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_loginQuick'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_getDeviceInfo(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_getDeviceInfo'", nullptr);
            return 0;
        }
        std::string ret = CCHgame::getDeviceInfo();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:getDeviceInfo",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_getDeviceInfo'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_getCountOfUnreadMessages(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_getCountOfUnreadMessages'", nullptr);
            return 0;
        }
        int ret = CCHgame::hs_getCountOfUnreadMessages();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_getCountOfUnreadMessages",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_getCountOfUnreadMessages'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logOutQuick(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logOutQuick'", nullptr);
            return 0;
        }
        CCHgame::logOutQuick();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logOutQuick",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logOutQuick'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_GetFileData(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:GetFileData"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_GetFileData'", nullptr);
            return 0;
        }
        std::string ret = CCHgame::GetFileData(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:GetFileData",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_GetFileData'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_pay(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:pay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_pay'", nullptr);
            return 0;
        }
        CCHgame::pay(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:pay",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_pay'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logCreateGroupEvent(lua_State* tolua_S)
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
        std::string arg0;
        std::string arg1;
        std::string arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:logCreateGroupEvent");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:logCreateGroupEvent");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:logCreateGroupEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logCreateGroupEvent'", nullptr);
            return 0;
        }
        CCHgame::logCreateGroupEvent(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logCreateGroupEvent",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logCreateGroupEvent'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_showFAQs(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 1)
        {
            cocos2d::ValueMap arg0;
            ok &= luaval_to_ccvaluemap(tolua_S, 2, &arg0, "CCHgame:hs_showFAQs");
            if (!ok) { break; }
            CCHgame::hs_showFAQs(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            CCHgame::hs_showFAQs();
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "CCHgame:hs_showFAQs",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_showFAQs'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_AdUpdateRoleInfo(lua_State* tolua_S)
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

    if (argc == 9)
    {
        int arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        std::string arg5;
        std::string arg6;
        std::string arg7;
        std::string arg8;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 8,&arg6, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 9,&arg7, "CCHgame:AdUpdateRoleInfo");
        ok &= luaval_to_std_string(tolua_S, 10,&arg8, "CCHgame:AdUpdateRoleInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_AdUpdateRoleInfo'", nullptr);
            return 0;
        }
        CCHgame::AdUpdateRoleInfo(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:AdUpdateRoleInfo",argc, 9);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_AdUpdateRoleInfo'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logJoinGroupEvent(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:logJoinGroupEvent");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:logJoinGroupEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logJoinGroupEvent'", nullptr);
            return 0;
        }
        CCHgame::logJoinGroupEvent(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logJoinGroupEvent",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logJoinGroupEvent'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_callFacebookShare(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_callFacebookShare'", nullptr);
            return 0;
        }
        CCHgame::callFacebookShare();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:callFacebookShare",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_callFacebookShare'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_logout(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_logout'", nullptr);
            return 0;
        }
        CCHgame::hs_logout();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_logout",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_logout'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_allExit(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_allExit'", nullptr);
            return 0;
        }
        CCHgame::allExit();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:allExit",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_allExit'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_FaceBookShare(lua_State* tolua_S)
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

    if (argc == 5)
    {
        std::string arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:FaceBookShare");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:FaceBookShare");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:FaceBookShare");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:FaceBookShare");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "CCHgame:FaceBookShare");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_FaceBookShare'", nullptr);
            return 0;
        }
        CCHgame::FaceBookShare(arg0, arg1, arg2, arg3, arg4);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:FaceBookShare",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_FaceBookShare'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logOut(lua_State* tolua_S)
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
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CCHgame:logOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logOut'", nullptr);
            return 0;
        }
        bool ret = CCHgame::logOut(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logOut",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logOut'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_login(lua_State* tolua_S)
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
        const char* arg0;
        const char* arg1;
        const char* arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_login"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CCHgame:hs_login"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CCHgame:hs_login"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_login'", nullptr);
            return 0;
        }
        CCHgame::hs_login(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_login",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_login'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_getFps(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_getFps'", nullptr);
            return 0;
        }
        double ret = CCHgame::getFps();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:getFps",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_getFps'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_AdRegisterSuccess(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:AdRegisterSuccess");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:AdRegisterSuccess");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_AdRegisterSuccess'", nullptr);
            return 0;
        }
        CCHgame::AdRegisterSuccess(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:AdRegisterSuccess",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_AdRegisterSuccess'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_showCustomService(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:showCustomService");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:showCustomService");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_showCustomService'", nullptr);
            return 0;
        }
        CCHgame::showCustomService(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:showCustomService",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_showCustomService'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_payQuick(lua_State* tolua_S)
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

    if (argc == 14)
    {
        double arg0;
        int arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        std::string arg5;
        std::string arg6;
        std::string arg7;
        std::string arg8;
        std::string arg9;
        std::string arg10;
        std::string arg11;
        std::string arg12;
        std::string arg13;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "CCHgame:payQuick");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 7,&arg5, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 8,&arg6, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 9,&arg7, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 10,&arg8, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 11,&arg9, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 12,&arg10, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 13,&arg11, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 14,&arg12, "CCHgame:payQuick");
        ok &= luaval_to_std_string(tolua_S, 15,&arg13, "CCHgame:payQuick");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_payQuick'", nullptr);
            return 0;
        }
        CCHgame::payQuick(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:payQuick",argc, 14);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_payQuick'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_clearBreadCrumbs(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_clearBreadCrumbs'", nullptr);
            return 0;
        }
        CCHgame::hs_clearBreadCrumbs();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_clearBreadCrumbs",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_clearBreadCrumbs'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_unzipfile(lua_State* tolua_S)
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
        const char* arg0;
        const char* arg1;
        const char* arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:unzipfile"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CCHgame:unzipfile"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "CCHgame:unzipfile"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_unzipfile'", nullptr);
            return 0;
        }
        bool ret = CCHgame::unzipfile(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:unzipfile",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_unzipfile'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_getXGToken(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_getXGToken'", nullptr);
            return 0;
        }
        const char* ret = CCHgame::getXGToken();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:getXGToken",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_getXGToken'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logAchievedLevelEvent(lua_State* tolua_S)
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
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:logAchievedLevelEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logAchievedLevelEvent'", nullptr);
            return 0;
        }
        CCHgame::logAchievedLevelEvent(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logAchievedLevelEvent",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logAchievedLevelEvent'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_startApp(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_startApp'", nullptr);
            return 0;
        }
        CCHgame::startApp();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:startApp",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_startApp'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_IsRelease(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_IsRelease'", nullptr);
            return 0;
        }
        int ret = CCHgame::IsRelease();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:IsRelease",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_IsRelease'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_setNoTouchMoveTableView(lua_State* tolua_S)
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

    if (argc == 2)
    {
        cocos2d::extension::TableView* arg0;
        bool arg1;
        ok &= luaval_to_object<cocos2d::extension::TableView>(tolua_S, 2, "cc.TableView",&arg0, "CCHgame:setNoTouchMoveTableView");
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "CCHgame:setNoTouchMoveTableView");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_setNoTouchMoveTableView'", nullptr);
            return 0;
        }
        CCHgame::setNoTouchMoveTableView(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:setNoTouchMoveTableView",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_setNoTouchMoveTableView'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_AdPaySuccess(lua_State* tolua_S)
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

    if (argc == 5)
    {
        double arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        std::string arg4;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "CCHgame:AdPaySuccess");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:AdPaySuccess");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CCHgame:AdPaySuccess");
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "CCHgame:AdPaySuccess");
        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "CCHgame:AdPaySuccess");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_AdPaySuccess'", nullptr);
            return 0;
        }
        CCHgame::AdPaySuccess(arg0, arg1, arg2, arg3, arg4);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:AdPaySuccess",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_AdPaySuccess'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_getQuickChannelType(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_getQuickChannelType'", nullptr);
            return 0;
        }
        int ret = CCHgame::getQuickChannelType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:getQuickChannelType",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_getQuickChannelType'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_UnScheduleAll(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_UnScheduleAll'", nullptr);
            return 0;
        }
        CCHgame::UnScheduleAll();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:UnScheduleAll",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_UnScheduleAll'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_AdLoginSuccess(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:AdLoginSuccess");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:AdLoginSuccess");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_AdLoginSuccess'", nullptr);
            return 0;
        }
        CCHgame::AdLoginSuccess(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:AdLoginSuccess",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_AdLoginSuccess'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_addProperties(lua_State* tolua_S)
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
        cocos2d::ValueMap arg0;
        ok &= luaval_to_ccvaluemap(tolua_S, 2, &arg0, "CCHgame:hs_addProperties");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_addProperties'", nullptr);
            return 0;
        }
        CCHgame::hs_addProperties(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_addProperties",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_addProperties'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_get_lan(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_get_lan'", nullptr);
            return 0;
        }
        const char* ret = CCHgame::get_lan();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:get_lan",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_get_lan'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_isNodeBeTouch(lua_State* tolua_S)
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
        cocos2d::Node* arg0;
        cocos2d::Rect arg1;
        cocos2d::Point arg2;
        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "CCHgame:isNodeBeTouch");
        ok &= luaval_to_rect(tolua_S, 3, &arg1, "CCHgame:isNodeBeTouch");
        ok &= luaval_to_point(tolua_S, 4, &arg2, "CCHgame:isNodeBeTouch");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_isNodeBeTouch'", nullptr);
            return 0;
        }
        bool ret = CCHgame::isNodeBeTouch(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:isNodeBeTouch",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_isNodeBeTouch'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_logCompletedTutorialEvent(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        bool arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:logCompletedTutorialEvent");
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "CCHgame:logCompletedTutorialEvent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_logCompletedTutorialEvent'", nullptr);
            return 0;
        }
        CCHgame::logCompletedTutorialEvent(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:logCompletedTutorialEvent",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_logCompletedTutorialEvent'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_setNameAndEmail(lua_State* tolua_S)
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

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_setNameAndEmail"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CCHgame:hs_setNameAndEmail"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_setNameAndEmail'", nullptr);
            return 0;
        }
        CCHgame::hs_setNameAndEmail(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_setNameAndEmail",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_setNameAndEmail'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_setUserIdentifier(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_setUserIdentifier"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_setUserIdentifier'", nullptr);
            return 0;
        }
        CCHgame::hs_setUserIdentifier(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_setUserIdentifier",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_setUserIdentifier'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_GetLuaDeviceRoot(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_GetLuaDeviceRoot'", nullptr);
            return 0;
        }
        const char* ret = CCHgame::GetLuaDeviceRoot();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:GetLuaDeviceRoot",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_GetLuaDeviceRoot'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_setSDKLanguage(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_setSDKLanguage"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_setSDKLanguage'", nullptr);
            return 0;
        }
        bool ret = CCHgame::hs_setSDKLanguage(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_setSDKLanguage",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_setSDKLanguage'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_RestartGame(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_RestartGame'", nullptr);
            return 0;
        }
        CCHgame::RestartGame();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:RestartGame",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_RestartGame'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_AdTorialCompletion(lua_State* tolua_S)
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

    if (argc == 2)
    {
        int arg0;
        std::string arg1;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CCHgame:AdTorialCompletion");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:AdTorialCompletion");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_AdTorialCompletion'", nullptr);
            return 0;
        }
        CCHgame::AdTorialCompletion(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:AdTorialCompletion",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_AdTorialCompletion'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_isRectContainsPoint(lua_State* tolua_S)
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

    if (argc == 2)
    {
        cocos2d::Rect arg0;
        cocos2d::Point arg1;
        ok &= luaval_to_rect(tolua_S, 2, &arg0, "CCHgame:isRectContainsPoint");
        ok &= luaval_to_point(tolua_S, 3, &arg1, "CCHgame:isRectContainsPoint");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_isRectContainsPoint'", nullptr);
            return 0;
        }
        bool ret = CCHgame::isRectContainsPoint(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:isRectContainsPoint",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_isRectContainsPoint'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_showSingleFAQ(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 2)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_showSingleFAQ"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            cocos2d::ValueMap arg1;
            ok &= luaval_to_ccvaluemap(tolua_S, 3, &arg1, "CCHgame:hs_showSingleFAQ");
            if (!ok) { break; }
            CCHgame::hs_showSingleFAQ(arg0, arg1);
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 1)
        {
            const char* arg0;
            std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_showSingleFAQ"); arg0 = arg0_tmp.c_str();
            if (!ok) { break; }
            CCHgame::hs_showSingleFAQ(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "CCHgame:hs_showSingleFAQ",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_showSingleFAQ'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_registerDeviceToken(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_registerDeviceToken"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_registerDeviceToken'", nullptr);
            return 0;
        }
        CCHgame::hs_registerDeviceToken(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_registerDeviceToken",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_registerDeviceToken'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_showAlertToRateApp(lua_State* tolua_S)
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
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CCHgame:hs_showAlertToRateApp"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_hs_showAlertToRateApp'", nullptr);
            return 0;
        }
        CCHgame::hs_showAlertToRateApp(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:hs_showAlertToRateApp",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_showAlertToRateApp'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_downloadWarData(lua_State* tolua_S)
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

    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CCHgame:downloadWarData");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:downloadWarData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_downloadWarData'", nullptr);
            return 0;
        }
        CCHgame::downloadWarData(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:downloadWarData",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_downloadWarData'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_sendTouch(lua_State* tolua_S)
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
        cocos2d::Point arg0;
        ok &= luaval_to_point(tolua_S, 2, &arg0, "CCHgame:sendTouch");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_sendTouch'", nullptr);
            return 0;
        }
        CCHgame::sendTouch(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:sendTouch",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_sendTouch'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_hs_showConversation(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CCHgame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S)-1;

    do 
    {
        if (argc == 1)
        {
            cocos2d::ValueMap arg0;
            ok &= luaval_to_ccvaluemap(tolua_S, 2, &arg0, "CCHgame:hs_showConversation");
            if (!ok) { break; }
            CCHgame::hs_showConversation(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    do 
    {
        if (argc == 0)
        {
            CCHgame::hs_showConversation();
            lua_settop(tolua_S, 1);
            return 1;
        }
    } while (0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d", "CCHgame:hs_showConversation",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_hs_showConversation'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_FaceBookPurchase(lua_State* tolua_S)
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

    if (argc == 2)
    {
        double arg0;
        std::string arg1;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "CCHgame:FaceBookPurchase");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:FaceBookPurchase");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_FaceBookPurchase'", nullptr);
            return 0;
        }
        CCHgame::FaceBookPurchase(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:FaceBookPurchase",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_FaceBookPurchase'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_getPasteBoardStr(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_getPasteBoardStr'", nullptr);
            return 0;
        }
        const char* ret = CCHgame::getPasteBoardStr();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:getPasteBoardStr",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_getPasteBoardStr'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_login(lua_State* tolua_S)
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
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CCHgame:login");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_login'", nullptr);
            return 0;
        }
        bool ret = CCHgame::login(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:login",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_login'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_callUserCenter(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_callUserCenter'", nullptr);
            return 0;
        }
        CCHgame::callUserCenter();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:callUserCenter",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_callUserCenter'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_umengPaySuccess(lua_State* tolua_S)
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

    if (argc == 5)
    {
        double arg0;
        std::string arg1;
        int arg2;
        double arg3;
        int arg4;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "CCHgame:umengPaySuccess");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "CCHgame:umengPaySuccess");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CCHgame:umengPaySuccess");
        ok &= luaval_to_number(tolua_S, 5,&arg3, "CCHgame:umengPaySuccess");
        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "CCHgame:umengPaySuccess");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_umengPaySuccess'", nullptr);
            return 0;
        }
        CCHgame::umengPaySuccess(arg0, arg1, arg2, arg3, arg4);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:umengPaySuccess",argc, 5);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_umengPaySuccess'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_setNoTouchMove(lua_State* tolua_S)
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

    if (argc == 2)
    {
        cocos2d::ui::ScrollView* arg0;
        bool arg1;
        ok &= luaval_to_object<cocos2d::ui::ScrollView>(tolua_S, 2, "ccui.ScrollView",&arg0, "CCHgame:setNoTouchMove");
        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "CCHgame:setNoTouchMove");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_setNoTouchMove'", nullptr);
            return 0;
        }
        CCHgame::setNoTouchMove(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CCHgame:setNoTouchMove",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_setNoTouchMove'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_CCHgame_constructor(lua_State* tolua_S)
{
    int argc = 0;
    CCHgame* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_CCHgame_constructor'", nullptr);
            return 0;
        }
        cobj = new CCHgame();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"CCHgame");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "CCHgame:CCHgame",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_CCHgame_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_qgame_CCHgame_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CCHgame)");
    return 0;
}

int lua_register_qgame_CCHgame(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CCHgame");
    tolua_cclass(tolua_S,"CCHgame","CCHgame","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"CCHgame");
        tolua_function(tolua_S,"new",lua_qgame_CCHgame_constructor);
        tolua_function(tolua_S,"CallRenderRender", lua_qgame_CCHgame_CallRenderRender);
        tolua_function(tolua_S,"hs_addIntegerProperty", lua_qgame_CCHgame_hs_addIntegerProperty);
        tolua_function(tolua_S,"hs_isConversationActive", lua_qgame_CCHgame_hs_isConversationActive);
        tolua_function(tolua_S,"hs_showInbox", lua_qgame_CCHgame_hs_showInbox);
        tolua_function(tolua_S,"setPasteBoard", lua_qgame_CCHgame_setPasteBoard);
        tolua_function(tolua_S,"isRectIntersectRect", lua_qgame_CCHgame_isRectIntersectRect);
        tolua_function(tolua_S,"callCustomerService", lua_qgame_CCHgame_callCustomerService);
        tolua_function(tolua_S,"AdLevelAchieved", lua_qgame_CCHgame_AdLevelAchieved);
        tolua_function(tolua_S,"logSpentCreditsEvent", lua_qgame_CCHgame_logSpentCreditsEvent);
        tolua_function(tolua_S,"downloadFile", lua_qgame_CCHgame_downloadFile);
        tolua_function(tolua_S,"hs_showFAQSection", lua_qgame_CCHgame_hs_showFAQSection);
        tolua_function(tolua_S,"setWaterShader", lua_qgame_CCHgame_setWaterShader);
        tolua_function(tolua_S,"setLineShader", lua_qgame_CCHgame_setLineShader);
        tolua_function(tolua_S,"hs_addDateProperty", lua_qgame_CCHgame_hs_addDateProperty);
        tolua_function(tolua_S,"hs_addBooleanProperty", lua_qgame_CCHgame_hs_addBooleanProperty);
        tolua_function(tolua_S,"updateRoleInfoWith", lua_qgame_CCHgame_updateRoleInfoWith);
        tolua_function(tolua_S,"hs_leaveBreadCrumb", lua_qgame_CCHgame_hs_leaveBreadCrumb);
        tolua_function(tolua_S,"hs_addStringProperty", lua_qgame_CCHgame_hs_addStringProperty);
        tolua_function(tolua_S,"loginQuick", lua_qgame_CCHgame_loginQuick);
        tolua_function(tolua_S,"getDeviceInfo", lua_qgame_CCHgame_getDeviceInfo);
        tolua_function(tolua_S,"hs_getCountOfUnreadMessages", lua_qgame_CCHgame_hs_getCountOfUnreadMessages);
        tolua_function(tolua_S,"logOutQuick", lua_qgame_CCHgame_logOutQuick);
        tolua_function(tolua_S,"GetFileData", lua_qgame_CCHgame_GetFileData);
        tolua_function(tolua_S,"pay", lua_qgame_CCHgame_pay);
        tolua_function(tolua_S,"logCreateGroupEvent", lua_qgame_CCHgame_logCreateGroupEvent);
        tolua_function(tolua_S,"hs_showFAQs", lua_qgame_CCHgame_hs_showFAQs);
        tolua_function(tolua_S,"AdUpdateRoleInfo", lua_qgame_CCHgame_AdUpdateRoleInfo);
        tolua_function(tolua_S,"logJoinGroupEvent", lua_qgame_CCHgame_logJoinGroupEvent);
        tolua_function(tolua_S,"callFacebookShare", lua_qgame_CCHgame_callFacebookShare);
        tolua_function(tolua_S,"hs_logout", lua_qgame_CCHgame_hs_logout);
        tolua_function(tolua_S,"allExit", lua_qgame_CCHgame_allExit);
        tolua_function(tolua_S,"FaceBookShare", lua_qgame_CCHgame_FaceBookShare);
        tolua_function(tolua_S,"logOut", lua_qgame_CCHgame_logOut);
        tolua_function(tolua_S,"hs_login", lua_qgame_CCHgame_hs_login);
        tolua_function(tolua_S,"getFps", lua_qgame_CCHgame_getFps);
        tolua_function(tolua_S,"AdRegisterSuccess", lua_qgame_CCHgame_AdRegisterSuccess);
        tolua_function(tolua_S,"showCustomService", lua_qgame_CCHgame_showCustomService);
        tolua_function(tolua_S,"payQuick", lua_qgame_CCHgame_payQuick);
        tolua_function(tolua_S,"hs_clearBreadCrumbs", lua_qgame_CCHgame_hs_clearBreadCrumbs);
        tolua_function(tolua_S,"unzipfile", lua_qgame_CCHgame_unzipfile);
        tolua_function(tolua_S,"getXGToken", lua_qgame_CCHgame_getXGToken);
        tolua_function(tolua_S,"logAchievedLevelEvent", lua_qgame_CCHgame_logAchievedLevelEvent);
        tolua_function(tolua_S,"startApp", lua_qgame_CCHgame_startApp);
        tolua_function(tolua_S,"IsRelease", lua_qgame_CCHgame_IsRelease);
        tolua_function(tolua_S,"setNoTouchMoveTableView", lua_qgame_CCHgame_setNoTouchMoveTableView);
        tolua_function(tolua_S,"AdPaySuccess", lua_qgame_CCHgame_AdPaySuccess);
        tolua_function(tolua_S,"getQuickChannelType", lua_qgame_CCHgame_getQuickChannelType);
        tolua_function(tolua_S,"UnScheduleAll", lua_qgame_CCHgame_UnScheduleAll);
        tolua_function(tolua_S,"AdLoginSuccess", lua_qgame_CCHgame_AdLoginSuccess);
        tolua_function(tolua_S,"hs_addProperties", lua_qgame_CCHgame_hs_addProperties);
        tolua_function(tolua_S,"get_lan", lua_qgame_CCHgame_get_lan);
        tolua_function(tolua_S,"isNodeBeTouch", lua_qgame_CCHgame_isNodeBeTouch);
        tolua_function(tolua_S,"logCompletedTutorialEvent", lua_qgame_CCHgame_logCompletedTutorialEvent);
        tolua_function(tolua_S,"hs_setNameAndEmail", lua_qgame_CCHgame_hs_setNameAndEmail);
        tolua_function(tolua_S,"hs_setUserIdentifier", lua_qgame_CCHgame_hs_setUserIdentifier);
        tolua_function(tolua_S,"GetLuaDeviceRoot", lua_qgame_CCHgame_GetLuaDeviceRoot);
        tolua_function(tolua_S,"hs_setSDKLanguage", lua_qgame_CCHgame_hs_setSDKLanguage);
        tolua_function(tolua_S,"RestartGame", lua_qgame_CCHgame_RestartGame);
        tolua_function(tolua_S,"AdTorialCompletion", lua_qgame_CCHgame_AdTorialCompletion);
        tolua_function(tolua_S,"isRectContainsPoint", lua_qgame_CCHgame_isRectContainsPoint);
        tolua_function(tolua_S,"hs_showSingleFAQ", lua_qgame_CCHgame_hs_showSingleFAQ);
        tolua_function(tolua_S,"hs_registerDeviceToken", lua_qgame_CCHgame_hs_registerDeviceToken);
        tolua_function(tolua_S,"hs_showAlertToRateApp", lua_qgame_CCHgame_hs_showAlertToRateApp);
        tolua_function(tolua_S,"downloadWarData", lua_qgame_CCHgame_downloadWarData);
        tolua_function(tolua_S,"sendTouch", lua_qgame_CCHgame_sendTouch);
        tolua_function(tolua_S,"hs_showConversation", lua_qgame_CCHgame_hs_showConversation);
        tolua_function(tolua_S,"FaceBookPurchase", lua_qgame_CCHgame_FaceBookPurchase);
        tolua_function(tolua_S,"getPasteBoardStr", lua_qgame_CCHgame_getPasteBoardStr);
        tolua_function(tolua_S,"login", lua_qgame_CCHgame_login);
        tolua_function(tolua_S,"callUserCenter", lua_qgame_CCHgame_callUserCenter);
        tolua_function(tolua_S,"umengPaySuccess", lua_qgame_CCHgame_umengPaySuccess);
        tolua_function(tolua_S,"setNoTouchMove", lua_qgame_CCHgame_setNoTouchMove);

        tolua_function(tolua_S,"tDSetPublicProperties", lua_qgame_CCHgame_tDSetPublicProperties);
        tolua_function(tolua_S,"tDRegister", lua_qgame_CCHgame_tDRegister);
        tolua_function(tolua_S,"tDJoinGuild", lua_qgame_CCHgame_tDJoinGuild);
        tolua_function(tolua_S,"tDSommon", lua_qgame_CCHgame_tDSommon);
        tolua_function(tolua_S,"tDArenaWin", lua_qgame_CCHgame_tDArenaWin);
        tolua_function(tolua_S,"tDDelFriend", lua_qgame_CCHgame_tDDelFriend);
        tolua_function(tolua_S,"tDLoginOut", lua_qgame_CCHgame_tDLoginOut);
        tolua_function(tolua_S,"tDArenaLost", lua_qgame_CCHgame_tDArenaLost);
        tolua_function(tolua_S,"tDLogin", lua_qgame_CCHgame_tDLogin);
        tolua_function(tolua_S,"tDSetAccountId", lua_qgame_CCHgame_tDSetAccountId);
        tolua_function(tolua_S,"tDSetUserProper", lua_qgame_CCHgame_tDSetUserProper);
        tolua_function(tolua_S,"tDOrderFinish", lua_qgame_CCHgame_tDOrderFinish);
        tolua_function(tolua_S,"tDArenaEnter", lua_qgame_CCHgame_tDArenaEnter);
        tolua_function(tolua_S,"tDShopBuy", lua_qgame_CCHgame_tDShopBuy);
        tolua_function(tolua_S,"tDCreateRole", lua_qgame_CCHgame_tDCreateRole);
        tolua_function(tolua_S,"tDAddUserProper", lua_qgame_CCHgame_tDAddUserProper);
        tolua_function(tolua_S,"tDOrderInit", lua_qgame_CCHgame_tDOrderInit);
        tolua_function(tolua_S,"tDLevelup", lua_qgame_CCHgame_tDLevelup);
        tolua_function(tolua_S,"tDChat", lua_qgame_CCHgame_tDChat);
        tolua_function(tolua_S,"tDRemoveAccountId", lua_qgame_CCHgame_tDRemoveAccountId);
        tolua_function(tolua_S,"tDCreateGuild", lua_qgame_CCHgame_tDCreateGuild);
        tolua_function(tolua_S,"tDAddFriend", lua_qgame_CCHgame_tDAddFriend);
        tolua_function(tolua_S,"tDLeaveGuild", lua_qgame_CCHgame_tDLeaveGuild);

    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CCHgame).name();
    g_luaType[typeName] = "CCHgame";
    g_typeCast["CCHgame"] = "CCHgame";
    return 1;
}

int lua_qgame_LogMore_isInShowLog(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_isInShowLog'", nullptr);
            return 0;
        }
        bool ret = LogMore::isInShowLog();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:isInShowLog",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_isInShowLog'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_logError(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "LogMore:logError"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_logError'", nullptr);
            return 0;
        }
        LogMore::logError(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:logError",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_logError'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_writeFileData(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        const char* arg0;
        const char* arg1;
        const char* arg2;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "LogMore:writeFileData"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "LogMore:writeFileData"); arg1 = arg1_tmp.c_str();
        std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "LogMore:writeFileData"); arg2 = arg2_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_writeFileData'", nullptr);
            return 0;
        }
        bool ret = LogMore::writeFileData(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:writeFileData",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_writeFileData'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_setOpenPrintLogModuleList(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::vector<std::string> arg0;
        ok &= luaval_to_std_vector_string(tolua_S, 2, &arg0, "LogMore:setOpenPrintLogModuleList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_setOpenPrintLogModuleList'", nullptr);
            return 0;
        }
        LogMore::setOpenPrintLogModuleList(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:setOpenPrintLogModuleList",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_setOpenPrintLogModuleList'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_pvpStart(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_pvpStart'", nullptr);
            return 0;
        }
        LogMore::pvpStart();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:pvpStart",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_pvpStart'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_setLogLevel(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "LogMore:setLogLevel");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_setLogLevel'", nullptr);
            return 0;
        }
        LogMore::setLogLevel(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:setLogLevel",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_setLogLevel'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_printLogInfo(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        const char* arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LogMore:printLogInfo");
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "LogMore:printLogInfo"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_printLogInfo'", nullptr);
            return 0;
        }
        LogMore::printLogInfo(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:printLogInfo",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_printLogInfo'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_writeToFile(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "LogMore:writeToFile"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_writeToFile'", nullptr);
            return 0;
        }
        bool ret = LogMore::writeToFile(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:writeToFile",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_writeToFile'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_writeAllRecordToFile(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_writeAllRecordToFile'", nullptr);
            return 0;
        }
        LogMore::writeAllRecordToFile();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:writeAllRecordToFile",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_writeAllRecordToFile'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_showErrorWindow(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_showErrorWindow'", nullptr);
            return 0;
        }
        LogMore::showErrorWindow();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:showErrorWindow",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_showErrorWindow'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_init(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_init'", nullptr);
            return 0;
        }
        LogMore::init();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:init",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_init'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_setNeedPrintLogModuleList(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::vector<std::string> arg0;
        ok &= luaval_to_std_vector_string(tolua_S, 2, &arg0, "LogMore:setNeedPrintLogModuleList");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_setNeedPrintLogModuleList'", nullptr);
            return 0;
        }
        LogMore::setNeedPrintLogModuleList(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:setNeedPrintLogModuleList",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_setNeedPrintLogModuleList'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_writeRecordToFile(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_writeRecordToFile'", nullptr);
            return 0;
        }
        bool ret = LogMore::writeRecordToFile();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:writeRecordToFile",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_writeRecordToFile'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_setIsPvp(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        bool arg0;
        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "LogMore:setIsPvp");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_setIsPvp'", nullptr);
            return 0;
        }
        LogMore::setIsPvp(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:setIsPvp",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_setIsPvp'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_insertOpenLogModule(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LogMore:insertOpenLogModule");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_insertOpenLogModule'", nullptr);
            return 0;
        }
        LogMore::insertOpenLogModule(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:insertOpenLogModule",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_insertOpenLogModule'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_pvpStop(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_pvpStop'", nullptr);
            return 0;
        }
        LogMore::pvpStop();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:pvpStop",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_pvpStop'.",&tolua_err);
#endif
    return 0;
}
int lua_qgame_LogMore_insertNeeLogModule(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LogMore",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LogMore:insertNeeLogModule");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_qgame_LogMore_insertNeeLogModule'", nullptr);
            return 0;
        }
        LogMore::insertNeeLogModule(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LogMore:insertNeeLogModule",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qgame_LogMore_insertNeeLogModule'.",&tolua_err);
#endif
    return 0;
}


static int lua_qgame_LogMore_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LogMore)");
    return 0;
}

int lua_register_qgame_LogMore(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LogMore");
    tolua_cclass(tolua_S,"LogMore","LogMore","",nullptr);

    tolua_beginmodule(tolua_S,"LogMore");
        tolua_function(tolua_S,"isInShowLog", lua_qgame_LogMore_isInShowLog);
        tolua_function(tolua_S,"logError", lua_qgame_LogMore_logError);
        tolua_function(tolua_S,"writeFileData", lua_qgame_LogMore_writeFileData);
        tolua_function(tolua_S,"setOpenPrintLogModuleList", lua_qgame_LogMore_setOpenPrintLogModuleList);
        tolua_function(tolua_S,"pvpStart", lua_qgame_LogMore_pvpStart);
        tolua_function(tolua_S,"setLogLevel", lua_qgame_LogMore_setLogLevel);
        tolua_function(tolua_S,"printLogInfo", lua_qgame_LogMore_printLogInfo);
        tolua_function(tolua_S,"writeToFile", lua_qgame_LogMore_writeToFile);
        tolua_function(tolua_S,"writeAllRecordToFile", lua_qgame_LogMore_writeAllRecordToFile);
        tolua_function(tolua_S,"showErrorWindow", lua_qgame_LogMore_showErrorWindow);
        tolua_function(tolua_S,"init", lua_qgame_LogMore_init);
        tolua_function(tolua_S,"setNeedPrintLogModuleList", lua_qgame_LogMore_setNeedPrintLogModuleList);
        tolua_function(tolua_S,"writeRecordToFile", lua_qgame_LogMore_writeRecordToFile);
        tolua_function(tolua_S,"setIsPvp", lua_qgame_LogMore_setIsPvp);
        tolua_function(tolua_S,"insertOpenLogModule", lua_qgame_LogMore_insertOpenLogModule);
        tolua_function(tolua_S,"pvpStop", lua_qgame_LogMore_pvpStop);
        tolua_function(tolua_S,"insertNeeLogModule", lua_qgame_LogMore_insertNeeLogModule);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LogMore).name();
    g_luaType[typeName] = "LogMore";
    g_typeCast["LogMore"] = "LogMore";
    return 1;
}
TOLUA_API int register_all_qgame(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_qgame_LogMore(tolua_S);
	lua_register_qgame_ResourceManager(tolua_S);
	lua_register_qgame_CCHgame(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

