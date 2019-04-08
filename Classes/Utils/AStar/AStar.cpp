#include "AStar.h"
#include <cassert>
#include <cstring>
#include <algorithm>
#include <math.h>

static const int kStepValue = 10;
static const int kObliqueValue = 14;

AStar::AStar()
	: width_(0)
	, height_(0)
	, step_value_(kStepValue)
	, oblique_value_(kObliqueValue)
{
}

AStar::~AStar()
{
	clear();
}

int AStar::stepValue() const
{
	return step_value_;
}

int AStar::obliqueValue() const
{
	return oblique_value_;
}

void AStar::setStepValue(int value)
{
	step_value_ = value;
}

void AStar::setObliqueValue(int value)
{
	oblique_value_ = value;
}

void AStar::clear()
{
	size_t index = 0;
	const size_t max_size = width_ * height_;
	while (index < max_size)
	{
		delete maps_[index++];
	}
	query_ = nullptr;
	open_list_.clear();
	width_ = height_ = 0;
}

void AStar::initParam(const Param &param)
{
	width_ = param.width;
	height_ = param.height;
	query_ = param.can_reach;
	if (!maps_.empty())
	{
		memset(&maps_[0], 0, sizeof(Node *) * maps_.size());
	}
	maps_.resize(width_ * height_, nullptr);
}

bool AStar::isVlidParam(const Param &param)
{
	return (param.can_reach
			&& (param.width > 0 && param.height > 0)
			&& (param.end.x >= 0 && param.end.x < param.width)
			&& (param.end.y >= 0 && param.end.y < param.height)
			&& (param.start.x >= 0 && param.start.x < param.width)
			&& (param.start.y >= 0 && param.start.y < param.height)
			);
}

bool AStar::getNodeIndex(Node *node, size_t &index)
{
	index = 0;
	const size_t size = open_list_.size();
	while (index < size)
	{
		if (open_list_[index]->pos == node->pos)
		{
			return true;
		}
		++index;
	}
	return false;
}

void AStar::percolateUp(size_t hole)
{
	size_t parent = 0;
	while (hole > 0)
	{
		parent = (hole - 1) / 2;
		if (open_list_[hole]->f() < open_list_[parent]->f())
		{
			std::swap(open_list_[hole], open_list_[parent]);
			hole = parent;
		}
		else
		{
			return;
		}
	}
}

inline uint16_t AStar::calculGValue(Node *parent_node, const Vec2 &current_pos)
{
	uint16_t g_value = ((abs(current_pos.y + current_pos.x - parent_node->pos.y - parent_node->pos.x)) == 2 ? oblique_value_ : step_value_);
	return g_value += parent_node->g;
}

inline uint16_t AStar::calculHValue(const Vec2 &current_pos, const Vec2 &end_pos)
{
	//unsigned int h_value = abs(end_pos.y + end_pos.x - current_pos.y - current_pos.x);
	unsigned int h_value = abs(end_pos.y - current_pos.y) + abs(end_pos.x - current_pos.x);
	return h_value * step_value_;
}

inline bool AStar::hasNoodeInOpenList(const Vec2 &pos, Node *&out)
{
	out = maps_[pos.y * width_ + pos.x];
	return out ? out->state == IN_OPENLIST : false;
}

inline bool AStar::hasNodeInCloseList(const Vec2 &pos)
{
	Node *node_ptr = maps_[pos.y * width_ + pos.x];
	return node_ptr ? node_ptr->state == IN_CLOSELIST : false;
}

bool AStar::canReach(const Vec2 &pos)
{
	return (pos.x >= 0 && pos.x < width_ && pos.y >= 0 && pos.y < height_) ? query_(pos) : false;
}

bool AStar::canReach(const Vec2 &current_pos, const Vec2 &target_pos, bool corner)
{
	if (target_pos.x >= 0 && target_pos.x < width_ && target_pos.y >= 0 && target_pos.y < height_)
	{
		if (hasNodeInCloseList(target_pos))
		{
			return false;
		}

		if (abs(current_pos.y + current_pos.x - target_pos.y - target_pos.x) == 1)
		{
			return query_(target_pos);
		}
		else if (corner)
		{
			return (canReach(Vec2(current_pos.x + target_pos.x - current_pos.x, current_pos.y))
					&& canReach(Vec2(current_pos.x, current_pos.y + target_pos.y - current_pos.y)));
		}
	}
	return false;
}

void AStar::findCanReachPos(const Vec2 &current_pos, bool corner, std::vector<Vec2> &can_reach)
{
	Vec2 target_pos;
	can_reach.clear();
	int row_index = current_pos.y - 1;
	const int max_row = current_pos.y + 1;
	const int max_col = current_pos.x + 1;

	if (row_index < 0)
	{
		row_index = 0;
	}
	
	while (row_index <= max_row)
	{
		int col_index = current_pos.x - 1;

		if (col_index < 0)
		{
			col_index = 0;
		}
	
		while (col_index <= max_col)
		{
			target_pos.set(col_index, row_index);
			if (canReach(current_pos, target_pos, corner))
			{
				can_reach.push_back(target_pos);
			}
			++col_index;
		}
		++row_index;
	}
}

void AStar::handleFoundNode(Node *current_node, Node *target_node)
{
	unsigned int g_value = calculGValue(current_node, target_node->pos);
	if (g_value < target_node->g)
	{
		target_node->g = g_value;
		target_node->parent = current_node;

		size_t index = 0;
		if (getNodeIndex(target_node, index))
		{
			percolateUp(index);
		}
		else
		{
			assert(false);
		}
	}
}

void AStar::hndleNotFoundNode(Node *current_node, Node *target_node, const Vec2 &end_pos)
{
	target_node->parent = current_node;
	target_node->h = calculHValue(target_node->pos, end_pos);
	target_node->g = calculGValue(current_node, target_node->pos);

	Node *&node_ptr = maps_[target_node->pos.y * width_ + target_node->pos.x];
	node_ptr = target_node;
	node_ptr->state = IN_OPENLIST;

	open_list_.push_back(target_node);
	std::push_heap(open_list_.begin(), open_list_.end(), [](const Node *a, const Node *b)->bool
	{
		return a->f() > b->f();
	});
}

std::vector<AStar::Vec2> AStar::find(const Param &param)
{
	std::vector<Vec2> paths;
	if (!isVlidParam(param))
	{
		assert(false);
	}
	else
	{
		initParam(param);
		std::vector<Vec2> nearby_nodes;
		nearby_nodes.reserve(param.corner ? 8 : 4);

		if (CanWalkableBetween(param.start, param.end) == true)
		{
			paths.push_back(AStar::Vec2(param.end.x, param.end.y));
			goto __end__;
		}

		Node *start_node = new Node(param.start);
		open_list_.push_back(start_node);

		Node *&node_ptr = maps_[start_node->pos.y * width_ + start_node->pos.x];
		node_ptr = start_node;
		node_ptr->state = IN_OPENLIST;

		while (!open_list_.empty())
		{
			Node *current_node = *open_list_.begin();
			std::pop_heap(open_list_.begin(), open_list_.end(), [](const Node *a, const Node *b)->bool
			{
				return a->f() > b->f();
			});
			open_list_.pop_back();
			maps_[current_node->pos.y * width_ + current_node->pos.x]->state = IN_CLOSELIST;

			findCanReachPos(current_node->pos, param.corner, nearby_nodes);

			size_t index = 0;
			const size_t size = nearby_nodes.size();
			while (index < size)
			{
				Node *new_node = nullptr;
				if (hasNoodeInOpenList(nearby_nodes[index], new_node))
				{
					handleFoundNode(current_node, new_node);
				}
				else
				{
					new_node = new Node(nearby_nodes[index]);
					hndleNotFoundNode(current_node, new_node, param.end);

					if (nearby_nodes[index] == param.end)
					{
						while (new_node->parent)
						{
							paths.push_back(new_node->pos);
							new_node = new_node->parent;
						}
						std::reverse(paths.begin(), paths.end());
						goto __end__;
					}
				}
				++index;
			}
		}
	}

__end__:

	//endPos can not reach
	if (query_(param.end) == false)
	{
		int minH = 99999;
		Node* minHNode = NULL;
		for (std::vector<Node *>::iterator it1 = maps_.begin(); it1 != maps_.end(); it1++)
		{
			if (*it1 && (*it1)->state == IN_CLOSELIST && (*it1)->parent)
			{
				if (minH > (*it1)->h)
				{
					minH = (*it1)->h;
					minHNode = *it1;
				}
			}
		}
		if (minHNode)
		{
			while (minHNode->parent)
			{
				paths.push_back(minHNode->pos);
				minHNode = minHNode->parent;
			}
			std::reverse(paths.begin(), paths.end());
		}
		

	}

	clear();
	return paths;
}


bool AStar::CanWalkableBetween(const Vec2 &sourceTilePos, const Vec2 &destinationTilePos)
{
	// same position do not need move
	if (sourceTilePos.x == destinationTilePos.x &&
		sourceTilePos.y == destinationTilePos.y)
	{
		return true;
	}
	// different position need check
	int32_t direction = 0;
	
	// source point & destination point are in same column
	if (sourceTilePos.x == destinationTilePos.x)
	{
		direction = (sourceTilePos.y>destinationTilePos.y) ? (-1) : 1;
		int32_t yIdx = static_cast<int32_t>(sourceTilePos.y);
		while ((static_cast<int32_t>(destinationTilePos.y) - yIdx)*direction>0)
		{
			if (false == canReach(Vec2(sourceTilePos.x, yIdx)))
			{
				return false;
			}
			yIdx += direction;
		}
		return true;
	}
	// source point & destination point are in same row
	if (sourceTilePos.y == destinationTilePos.y)
	{
		direction = (sourceTilePos.x>destinationTilePos.x) ? (-1) : 1;
		int32_t xIdx = static_cast<int32_t>(sourceTilePos.x);
		while ((static_cast<int32_t>(destinationTilePos.x) - xIdx)*direction>0)
		{
			if (false == canReach(Vec2(xIdx, sourceTilePos.y)))
			{
				return false;
			}
			xIdx += direction;
		}
		return true;
	}
	// other conditions
	assert(fabsf(sourceTilePos.x - destinationTilePos.x)>0 ||
		fabsf(sourceTilePos.y - destinationTilePos.y)>0);
	float kValue = float(sourceTilePos.y - destinationTilePos.y) / float(sourceTilePos.x - destinationTilePos.x);
	std::list<Vec2> xAxis, yAxis, allPoints;
	// calculate point by xPos firstly 
	direction = (sourceTilePos.x>destinationTilePos.x) ? (-1) : 1;
	for (uint16_t xIdx = static_cast<uint16_t>(sourceTilePos.x);
	(static_cast<uint16_t>(destinationTilePos.x) - xIdx)*direction>0; )
	{
		uint16_t xPos = xIdx + 1.0f*direction;
		uint16_t yPos = floor(kValue*(xPos - sourceTilePos.x) + sourceTilePos.y);
		xAxis.push_back(Vec2(xPos, yPos));
		xIdx += direction;
	}
	// then by yPos
	direction = (sourceTilePos.y>destinationTilePos.y) ? (-1) : 1;
	for (uint16_t yIdx = static_cast<uint16_t>(sourceTilePos.y);
	(static_cast<uint16_t>(destinationTilePos.y) - yIdx)*direction>0; )
	{
		//  y axis in tile coordinate is oppsite to cocos coordinate
		uint16_t yPos = yIdx + 1.0f*direction;
		uint16_t xPos = floor((yPos - sourceTilePos.y + kValue*sourceTilePos.x) / kValue);
		yAxis.push_back(Vec2(xPos, yPos));
		yIdx += direction;
	}
	// sort points list
	allPoints.push_back(sourceTilePos);
	std::list<Vec2>::iterator xIt = xAxis.begin(), yIt = yAxis.begin();
	while (xIt != xAxis.end() || yIt != yAxis.end())
	{
		if (xIt == xAxis.end())
		{
			allPoints.push_back(*yIt);
			++yIt;
			continue;
		}
		if (yIt == yAxis.end())
		{
			allPoints.push_back(*xIt);
			++xIt;
			continue;
		}
		if (((*xIt).y - (*yIt).y)*direction>0)
		{
			allPoints.push_back(*xIt);
			++xIt;
		}
		else
		{
			allPoints.push_back(*yIt);
			++yIt;
		}
	}
	allPoints.push_back(destinationTilePos);
	assert(allPoints.size() >= 2);
	// then check all tiles between each two points
	std::list<Vec2>::iterator it = allPoints.begin();
	while (allPoints.size() >= 2)
	{
		std::list<Vec2>::iterator nextIt = it;
		++nextIt;
		Vec2 midPoint = Vec2(0.5*((*it).x + (*nextIt).x), 0.5*((*it).y + (*nextIt).y));
		if (false == canReach(midPoint))
		{
			return false;
		}
		it = allPoints.erase(it);
	}
	return true;
}