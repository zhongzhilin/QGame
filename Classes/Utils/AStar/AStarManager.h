#ifndef __ASTAR_MANAGER_H__
#define __ASTAR_MANAGER_H__

#include <vector>
#include <functional>
#include "AStar.h"


class AStarManager
{
public:
	AStarManager(){	
		mapRow = 0;
		mapCol = 0;
	};
	~AStarManager(){};

	static AStarManager* getInstance()
	{
		static AStarManager* _AStarManager = NULL;
		if (_AStarManager == NULL)
		{
			_AStarManager = new AStarManager();
		}
		return _AStarManager;

	}

public:
	int searchPath(int startX, int startY, int endX, int endY, const int mapRow, const int mapCol);
	std::function<bool(int, int)> canReachFun = nullptr;

private:
	AStar* aStar = nullptr;
	int mapRow;
	int mapCol;
};
#endif