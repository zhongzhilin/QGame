#include "lua_NotifyHelper_auto.hpp"

#include "NotifyHelper.h"

#include "tolua_fix.h"

#include "LuaBasicConversions.h"





int lua_NotifyHelper_NotifyHelper_init(lua_State* tolua_S)

{

    int argc = 0;

    NotifyHelper* cobj = nullptr;

    bool ok  = true;



#if COCOS2D_DEBUG >= 1

    tolua_Error tolua_err;

#endif





#if COCOS2D_DEBUG >= 1

    if (!tolua_isusertype(tolua_S,1,"NotifyHelper",0,&tolua_err)) goto tolua_lerror;

#endif



    cobj = (NotifyHelper*)tolua_tousertype(tolua_S,1,0);



#if COCOS2D_DEBUG >= 1

    if (!cobj) 

    {

        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NotifyHelper_NotifyHelper_init'", nullptr);

        return 0;

    }

#endif



    argc = lua_gettop(tolua_S)-1;

    if (argc == 0) 

    {

        if(!ok)

        {

            tolua_error(tolua_S,"invalid arguments in function 'lua_NotifyHelper_NotifyHelper_init'", nullptr);

            return 0;

        }

        bool ret = cobj->init();

        tolua_pushboolean(tolua_S,(bool)ret);

        return 1;

    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NotifyHelper:init",argc, 0);

    return 0;



#if COCOS2D_DEBUG >= 1

    tolua_lerror:

    tolua_error(tolua_S,"#ferror in function 'lua_NotifyHelper_NotifyHelper_init'.",&tolua_err);

#endif



    return 0;

}

int lua_NotifyHelper_NotifyHelper_cleanOnlyNotification(lua_State* tolua_S)

{

    int argc = 0;

    bool ok  = true;



#if COCOS2D_DEBUG >= 1

    tolua_Error tolua_err;

#endif



#if COCOS2D_DEBUG >= 1

    if (!tolua_isusertable(tolua_S,1,"NotifyHelper",0,&tolua_err)) goto tolua_lerror;

#endif



    argc = lua_gettop(tolua_S) - 1;



    if (argc == 1)

    {

        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NotifyHelper:cleanOnlyNotification");

        if(!ok)

        {

            tolua_error(tolua_S,"invalid arguments in function 'lua_NotifyHelper_NotifyHelper_cleanOnlyNotification'", nullptr);

            return 0;

        }

        bool ret = NotifyHelper::cleanOnlyNotification(arg0);

        tolua_pushboolean(tolua_S,(bool)ret);

        return 1;

    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NotifyHelper:cleanOnlyNotification",argc, 1);

    return 0;

#if COCOS2D_DEBUG >= 1

    tolua_lerror:

    tolua_error(tolua_S,"#ferror in function 'lua_NotifyHelper_NotifyHelper_cleanOnlyNotification'.",&tolua_err);

#endif

    return 0;

}

int lua_NotifyHelper_NotifyHelper_create(lua_State* tolua_S)

{

    int argc = 0;

    bool ok  = true;



#if COCOS2D_DEBUG >= 1

    tolua_Error tolua_err;

#endif



#if COCOS2D_DEBUG >= 1

    if (!tolua_isusertable(tolua_S,1,"NotifyHelper",0,&tolua_err)) goto tolua_lerror;

#endif



    argc = lua_gettop(tolua_S) - 1;



    if (argc == 0)

    {

        if(!ok)

        {

            tolua_error(tolua_S,"invalid arguments in function 'lua_NotifyHelper_NotifyHelper_create'", nullptr);

            return 0;

        }

        NotifyHelper* ret = NotifyHelper::create();

        object_to_luaval<NotifyHelper>(tolua_S, "NotifyHelper",(NotifyHelper*)ret);

        return 1;

    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NotifyHelper:create",argc, 0);

    return 0;

#if COCOS2D_DEBUG >= 1

    tolua_lerror:

    tolua_error(tolua_S,"#ferror in function 'lua_NotifyHelper_NotifyHelper_create'.",&tolua_err);

#endif

    return 0;

}

int lua_NotifyHelper_NotifyHelper_addNotification(lua_State* tolua_S)

{

    int argc = 0;

    bool ok  = true;



#if COCOS2D_DEBUG >= 1

    tolua_Error tolua_err;

#endif



#if COCOS2D_DEBUG >= 1

    if (!tolua_isusertable(tolua_S,1,"NotifyHelper",0,&tolua_err)) goto tolua_lerror;

#endif



    argc = lua_gettop(tolua_S) - 1;



    if (argc == 5)

    {

        int arg0;

        int arg1;

        std::string arg2;

        std::string arg3;

        std::string arg4;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NotifyHelper:addNotification");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "NotifyHelper:addNotification");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "NotifyHelper:addNotification");

        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "NotifyHelper:addNotification");

        ok &= luaval_to_std_string(tolua_S, 6,&arg4, "NotifyHelper:addNotification");

        if(!ok)

        {

            tolua_error(tolua_S,"invalid arguments in function 'lua_NotifyHelper_NotifyHelper_addNotification'", nullptr);

            return 0;

        }

        bool ret = NotifyHelper::addNotification(arg0, arg1, arg2, arg3, arg4);

        tolua_pushboolean(tolua_S,(bool)ret);

        return 1;

    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NotifyHelper:addNotification",argc, 5);

    return 0;

#if COCOS2D_DEBUG >= 1

    tolua_lerror:

    tolua_error(tolua_S,"#ferror in function 'lua_NotifyHelper_NotifyHelper_addNotification'.",&tolua_err);

#endif

    return 0;

}

int lua_NotifyHelper_NotifyHelper_cleanAllNotification(lua_State* tolua_S)

{

    int argc = 0;

    bool ok  = true;



#if COCOS2D_DEBUG >= 1

    tolua_Error tolua_err;

#endif



#if COCOS2D_DEBUG >= 1

    if (!tolua_isusertable(tolua_S,1,"NotifyHelper",0,&tolua_err)) goto tolua_lerror;

#endif



    argc = lua_gettop(tolua_S) - 1;



    if (argc == 0)

    {

        if(!ok)

        {

            tolua_error(tolua_S,"invalid arguments in function 'lua_NotifyHelper_NotifyHelper_cleanAllNotification'", nullptr);

            return 0;

        }

        bool ret = NotifyHelper::cleanAllNotification();

        tolua_pushboolean(tolua_S,(bool)ret);

        return 1;

    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NotifyHelper:cleanAllNotification",argc, 0);

    return 0;

#if COCOS2D_DEBUG >= 1

    tolua_lerror:

    tolua_error(tolua_S,"#ferror in function 'lua_NotifyHelper_NotifyHelper_cleanAllNotification'.",&tolua_err);

#endif

    return 0;

}

int lua_NotifyHelper_NotifyHelper_constructor(lua_State* tolua_S)

{

    int argc = 0;

    NotifyHelper* cobj = nullptr;

    bool ok  = true;



#if COCOS2D_DEBUG >= 1

    tolua_Error tolua_err;

#endif







    argc = lua_gettop(tolua_S)-1;

    if (argc == 0) 

    {

        if(!ok)

        {

            tolua_error(tolua_S,"invalid arguments in function 'lua_NotifyHelper_NotifyHelper_constructor'", nullptr);

            return 0;

        }

        cobj = new NotifyHelper();

        cobj->autorelease();

        int ID =  (int)cobj->_ID ;

        int* luaID =  &cobj->_luaID ;

        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"NotifyHelper");

        return 1;

    }

    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NotifyHelper:NotifyHelper",argc, 0);

    return 0;



#if COCOS2D_DEBUG >= 1

    tolua_error(tolua_S,"#ferror in function 'lua_NotifyHelper_NotifyHelper_constructor'.",&tolua_err);

#endif



    return 0;

}



static int lua_NotifyHelper_NotifyHelper_finalize(lua_State* tolua_S)

{

    printf("luabindings: finalizing LUA object (NotifyHelper)");

    return 0;

}



int lua_register_NotifyHelper_NotifyHelper(lua_State* tolua_S)

{

    tolua_usertype(tolua_S,"NotifyHelper");

    tolua_cclass(tolua_S,"NotifyHelper","NotifyHelper","cc.Ref",nullptr);



    tolua_beginmodule(tolua_S,"NotifyHelper");

        tolua_function(tolua_S,"new",lua_NotifyHelper_NotifyHelper_constructor);

        tolua_function(tolua_S,"init",lua_NotifyHelper_NotifyHelper_init);

        tolua_function(tolua_S,"cleanOnlyNotification", lua_NotifyHelper_NotifyHelper_cleanOnlyNotification);

        tolua_function(tolua_S,"create", lua_NotifyHelper_NotifyHelper_create);

        tolua_function(tolua_S,"addNotification", lua_NotifyHelper_NotifyHelper_addNotification);

        tolua_function(tolua_S,"cleanAllNotification", lua_NotifyHelper_NotifyHelper_cleanAllNotification);

    tolua_endmodule(tolua_S);

    std::string typeName = typeid(NotifyHelper).name();

    g_luaType[typeName] = "NotifyHelper";

    g_typeCast["NotifyHelper"] = "NotifyHelper";

    return 1;

}

TOLUA_API int register_all_NotifyHelper(lua_State* tolua_S)

{

	tolua_open(tolua_S);

	

	tolua_module(tolua_S,nullptr,0);

	tolua_beginmodule(tolua_S,nullptr);



	lua_register_NotifyHelper_NotifyHelper(tolua_S);



	tolua_endmodule(tolua_S);

	return 1;

}



