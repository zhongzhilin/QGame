--------------------------------------------------
-----双向链表，可以实现队列，列表，栈，这是一个C++风格的实现

-- 双向链表的一个节点，节点包括值，前继和后继
local list_node = {}

list_node.value = nil
list_node.next = nil
list_node.prev = nil

-- 新建一个双向链表节点，该节点是不对外暴露的
function list_node:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

-- 双向链表的iterator的定义和实现，iterator是向外部暴露的
-- 每个iterator上面都保存着一个指向的list_node和属于的某个list的值
list_iterator = {}
list_iterator.node = nil
list_iterator.owner = nil

-- 从某个list中创建一个iterator
function list_iterator:new(_owner)
    local object = {}
    setmetatable(object, self)
    self.__index = self
    object.owner = _owner
    return object
end

-- 迭代到该节点指向的下个节点
function list_iterator:next(count)
    count = count or 1

    for i = 1, count do
        if self.node ~= nil then
            self.node = self.node.next
        else
            return false
        end
    end

    return self.node ~= nil
end

-- 迭代到该节点指向的前一个节点
function list_iterator:prev(count)
    count = count or 1

    for i = 1, count do
        if self.node ~= nil then
            self.node = self.node.prev
        else
            return	false
        end
    end

    return self.node ~= nil
end

-- 当前迭代器所拥有节点的值
function list_iterator:value()
    if self.node ~= nil then
        return self.node.value
    end

    return nil
end

-- 从链表中删除掉迭代器所指向的节点
function list_iterator:erase()
    if self.owner ~= nil then
        return self.owner:erase(self)
    end
end

-- 当前的迭代器是否有效
function list_iterator:valid()
    return self.owner ~= nil and self.node ~= nil
end

-- 双向链表的定义和实现，每个链表都有一个first和last节点
-- 分别指向链表的第一个节点和最后一个节点
hqlist = {}

hqlist.first = nil
hqlist.last = nil

-- 双向链表的构造函数
function hqlist:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

-- 向链表的尾端推入一个值
function hqlist:push_back(value)
    if nil == self.last or
            nil == self.first then
        self.first = list_node:new()
        self.last = self.first
        self.last.value = value
        return
    end

    local newNode = list_node:new()
    newNode.prev = self.last
    newNode.value = value
    self.last.next = newNode
    self.last = newNode
end

-- 从链表的后端推出一个值
function hqlist:pop_back()
    if nil == self.last then
        return nil
    end

    local back = self:back()

    local prevNode = self.last.prev
    if prevNode == nil then
        self.first = nil
        self.last = nil
    else
        prevNode.next = nil
        self.last = prevNode
    end

    return back
end

-- 向链表的前端推入一个值
function hqlist:push_front(value)
    if nil == self.first or
            nil == self.last then
        self.first = list_node:new()
        self.last = self.first
        self.last.value = value
        return
    end

    local newNode = list_node:new()
    newNode.value = value
    newNode.next = self.first
    self.first.prev = newNode
    self.first = newNode
end

-- 向链表的前端推出一个值
function hqlist:pop_front()
    if nil == self.first then
        return nil
    end

    local front = self:front()

    local nextNode = self.first.next
    if nextNode == nil then
        self.first = nil
        self.last = nil
    else
        nextNode.prev = nil
        self.first = nextNode
    end

    return front
end

-- 链表最前端的值
function hqlist:front()
    if self.first ~= nil then
        return self.first.value
    end

    return nil
end

-- 链表最尾端的值
function hqlist:back()
    if self.last ~= nil then
        return self.last.value
    end

    return nil
end

-- 链表是否为空，只需要判断第一个和最后一个是否都为空
function hqlist:empty()
    return nil == self.first or nil == self.last
end

-- 清空链表，只需要将第一个元素和最后一个元素置空就可以了
function hqlist:clear()
    self.first = nil
    self.last = nil
end

-- 链表最前端的值的迭代器
function hqlist:itr_begin()
    local itr = list_iterator:new(self)
    itr.node = self.first
    return itr
end

-- 指向链表最尾端的迭代器
function hqlist:itr_end()
    local itr = list_iterator:new(self)
    itr.node = self.last

    return itr
end

-- 从链表中搜索某个值，找到就返回一个迭代器
function hqlist:find(v, start)
    if start == nil then
        start = self:itr_begin()
    end

    repeat
        if v == start:value() then
            return start
        end
        until start:next() == false

    return nil
end

-- 从链表中反向搜索某个值，找到就返回一个反向迭代器
function hqlist:rfind(v, start)
    if start == nil then
        start = self:itr_end()
    end

    repeat
        if v == start:value() then
            return start
        end
        until start:prev() == false

    return nil
end

-- 根据迭代器从链表中删除一个节点，同时会改变itr指向为当前值的前一个
function hqlist:erase(itr)

    if nil == itr or nil == itr.node or
            itr.owner ~= self then
        return itr
    end

    local nextItr = list_iterator:new(self)
    nextItr.node = itr.node
    nextItr:next()

    if itr.node == self.first then
        self:pop_front()
    elseif itr.node == self.last then
        self:pop_back()
    else
        local prevNode = itr.node.prev
        local nextNode = itr.node.next

        if prevNode ~= nil then
            prevNode.next = nextNode
        end

        if nextNode ~= nil then
            nextNode.prev = prevNode
        end
    end

    itr.owner = nil
    itr.node = nil

    return nextItr

end

-- 删除链表中的一个确定的值，先找到迭代器，然后再通过迭代器删除
function hqlist:erase_value(value)
    local itr = self:find(value)
    self:erase(itr)
end

-- 删除链表中所有相同的值
function hqlist:erase_all(value)
    local itr = self:find(value)
    while itr ~= nil and itr:valid() do
        itr = self:erase(itr)
        itr = self:find(value, itr)
    end
end

-- 根据迭代器向双向链表中某个位置后插入一个新的值
function hqlist:insert(itr, value)
    if nil == itr or nil == itr.node or
            itr.owner ~= self then
        return
    end

    local result_itr = list_iterator:new(self)

    if itr.node == self.last then
        self:push_back(value)
        result_itr.node = self.last
    else
        local prevNode = itr.node
        local nextNode = itr.node.next
        local newNode = list_node:new()
        newNode.value = value
        prevNode.next = newNode
        nextNode.prev = newNode
        newNode.next = nextNode
        newNode.prev = prevNode

        result_itr.node = newNode
    end

    return result_itr
end

-- 根据迭代器向双向链表中某个位置前插入一个新的值
function hqlist:insert_before(itr, value)
    if nil == itr or nil == itr.node or
            itr.owner ~= self then
        return
    end

    local result_itr = list_iterator:new(self)

    if itr.node == self.first then
        self:push_front(value)
        result_itr.node = self.first
    else
        local prevNode = itr.node.prev
        local nextNode = itr.node
        local newNode = list_node:new()
        newNode.value = value
        prevNode.next = newNode
        nextNode.prev = newNode
        newNode.next = nextNode
        newNode.prev = prevNode

        result_itr.node = newNode
    end

    return result_itr
end

-- for循环中使用到的正向迭代器函数实现
function ilist(l)

    local itr_first = list_iterator:new(l)
    itr_first.node = list_node:new()
    itr_first.node.next = l.first

    local function ilist_it(itr)

        itr:next()
        local v = itr:value()

        if v ~= nil then
            return v, itr
        else
            return nil
        end

    end

    return ilist_it, itr_first
end

-- for循环中使用到的反向迭代器函数实现
function rilist(l)

    local itr_last = list_iterator:new(l)
    itr_last.node = list_node:new()
    itr_last.node.prev = l.last

    local function rilist_it(itr)

        itr:prev()
        local v = itr:value()

        if v ~= nil then
            return v, itr
        else
            return nil
        end

    end

    return rilist_it, itr_last
end


-- 双向链表的打印函数
function hqlist:print()
    for v in ilist(self) do
        print(tostring(v))
    end
end

-- 双向链表的大小
function hqlist:size()
    local count = 0

    for v in ilist(self) do
        count = count + 1
    end

    return count
end

-- 双向链表的拷贝
function hqlist:clone()
    local newList = hqlist:new()
    for v in ilist(self) do
        newList:push_back(v)
    end
    return newList
end
