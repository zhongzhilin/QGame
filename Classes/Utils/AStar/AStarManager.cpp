#include "AStarManager.h"
//#include <chrono>
#include <iostream>
#include "CCLuaStack.h"
#include "CCLuaEngine.h"
extern "C"
{
#include "lualib.h"
#include "lauxlib.h"
#include "lua.h"
};

//class Duration
//{
//public:
//	Duration()
//		: start_time_(std::chrono::system_clock::now())
//	{}
//
//	void reset()
//	{
//		start_time_ = std::chrono::system_clock::now();
//	}
//
//	std::chrono::seconds::rep seconds()
//	{
//		return std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now() - start_time_).count();
//	}
//
//	std::chrono::milliseconds::rep milli_seconds()
//	{
//		return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now() - start_time_).count();
//	}
//
//	std::chrono::microseconds::rep micro_seconds()
//	{
//		return std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::system_clock::now() - start_time_).count();
//	}
//
//	std::chrono::nanoseconds::rep nano_seconds()
//	{
//		return std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now() - start_time_).count();
//	}
//
//private:
//	std::chrono::system_clock::time_point start_time_;
//};


int AStarManager::searchPath(int startX, int startY, int endX, int endY, const int mapRow, const int mapCol)
{

	// 搜索参数
	AStar::Param param;
	param.width = mapCol;
	param.height = mapRow;
	param.corner = true;
	param.start = AStar::Vec2(startX, startY);
	param.end = AStar::Vec2(endX, endY);
	param.can_reach = [&](const AStar::Vec2 &pos)->bool
	{
		return canReachFun(pos.y, pos.x);
		//return ( mapData.at(pos.y) ).at(pos.x) == 0;
	};

	if (aStar == nullptr)
	{
		aStar = new AStar();
	}
	else if (this->mapRow != mapRow || this->mapCol !=mapCol)
	{
		delete aStar;
		aStar = nullptr;
		aStar = new AStar();
	}
	this->mapRow = mapRow;
	this->mapCol = mapCol;
	// 执行搜索
	//AStar as;
	//Duration duration;
	//auto path = as.find(param);
	auto path = aStar->find(param);

	/*std::cout << (path.empty() ? "路径未找到！" : "路径已找到！") << std::endl;
	std::cout << "本次寻路耗时" << duration.milli_seconds() << "毫秒" << std::endl;
	std::cout << '\n';*/

	cocos2d::LuaStack* stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
	lua_State* L = stack->getLuaState();
	lua_newtable(L);

	uint16_t countIndex = 1;
	for (std::vector< AStar::Vec2 >::iterator it1 = path.begin(); it1 != path.end(); it1++)
	{
		lua_pushnumber(L, countIndex++);//压入key
		lua_pushnumber(L, (*it1).x);//压入vlaue
		lua_settable(L, -3);//把key,vlaue压入table中,并弹出key,value

		lua_pushnumber(L, countIndex++);//压入key
		lua_pushnumber(L, (*it1).y);//压入vlaue
		lua_settable(L, -3);//把key,vlaue压入table中,并弹出key,value
	}


	return 1;
}


