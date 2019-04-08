
local SOCKET_TICK_TIME = 0.1 			-- check socket data interval
local SOCKET_RECONNECT_TIME = 5			-- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3	-- socket failure timeout

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_ALREADY_CONNECTED = "already connected"
local STATUS_ALREADY_IN_PROGRESS = "Operation already in progress"
local STATUS_TIMEOUT = "timeout"

local scheduler = gscheduler
local socket = require "socket"

local SocketTCP = {}

SocketTCP.EVENT_DATA = 1
SocketTCP.EVENT_CLOSE = 2
SocketTCP.EVENT_CLOSED = 3
SocketTCP.EVENT_CONNECTED = 4
SocketTCP.EVENT_CONNECT_FAILURE = 5

SocketTCP._VERSION = socket._VERSION
SocketTCP._DEBUG = socket._DEBUG

function SocketTCP.new(__host, __port, __event, __retryConnectWhenFailure)
    local instance = {}
    instance = setmetatable(instance, {__index = SocketTCP })
    
    ------------
    instance.host = __host
    instance.port = __port
    instance.tickScheduler = nil		-- timer for data
    instance.reconnectScheduler = nil		-- timer for reconnect
    instance.connectTimeTickScheduler = nil	-- timer for connect timeout
    instance.name = 'SocketTCP'
    instance.tcp = nil
    instance.event = __event
    instance.isRetryConnect = __retryConnectWhenFailure
    instance.isConnected = false
    ------------
    
    return instance
end

function SocketTCP.getTime()
    return socket.gettime()
end

function SocketTCP:setName( __name )
    self.name = __name
    return self
end

function SocketTCP:setTickTime(__time)
    SOCKET_TICK_TIME = __time
    return self
end

function SocketTCP:setReconnTime(__time)
    SOCKET_RECONNECT_TIME = __time
    return self
end

function SocketTCP:setConnFailTime(__time)
    SOCKET_CONNECT_FAIL_TIMEOUT = __time
    return self
end

function SocketTCP:checkConnect()
    local __succ = self:_connect() 
    return __succ
end

function SocketTCP:connect(__host, __port, __retryConnectWhenFailure)
    if __host then self.host = __host end
    if __port then self.port = __port end
    if __retryConnectWhenFailure ~= nil then self.isRetryConnect = __retryConnectWhenFailure end
    assert(self.host or self.port or self.event, "Host and port and event are necessary!")

    local isIPV6_only = false
    local addrinfo, err = socket.dns.getaddrinfo(self.host)
    if addrinfo ~= nil then
        log.debug("=============> addrinfo %s", vardump(addrinfo))
        for k, v in pairs(addrinfo) do
            if v.family == "inet6" then
                isIPV6_only = true
                break
            end
        end
    end

    if isIPV6_only then
        self.tcp = socket.tcp6()
    else
        self.tcp = socket.tcp()
    end
    self.tcp:settimeout(0)
    self.isIPV6 = isIPV6_only
    
    local function __checkConnect()
        local __succ = self:_connect() 
        if __succ then
            self:_onConnected()
        end
        return __succ
    end
    
    if not __checkConnect() then
        -- check whether connection is success
        -- the connection is failure if socket isn't connected after SOCKET_CONNECT_FAIL_TIMEOUT seconds
        local __connectTimeTick = function ()
            if self.isConnected then return end
            self.waitConnect = self.waitConnect or 0
            self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
            if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
                self.waitConnect = nil
                self:close()
                self:_connectFailure()
            end
            __checkConnect()
        end
        self.connectTimeTickScheduler = scheduler.scheduleGlobal(__connectTimeTick, SOCKET_TICK_TIME)
    end
end

function SocketTCP:send(__data)
    assert(self.isConnected, self.name .. " is not connected.")
    log.debug("###############socktcp:send self.name=%s,__data=%s",self.name,__data)
    return self.tcp:send(__data)
end

function SocketTCP:recv()
    while true do
        -- if use "*l" pattern, some buffer will be discarded, why?
        local __body, __status, __partial = self.tcp:receive("*a")  -- read the package body
        if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
            self:close()
            if self.isConnected then
                self:_onDisconnect()
            else 
                self:_connectFailure(__status)
            end
            return
        end
        if  (__body and string.len(__body) == 0) or
            (__partial and string.len(__partial) == 0)
        then return end
        if __body and __partial then __body = __body .. __partial end
        --self:dispatchEvent({name=SocketTCP.EVENT_DATA, data=(__partial or __body), partial=__partial, body=__body})
        self.event(SocketTCP.EVENT_DATA, {data=(__partial or __body), partial=__partial, body=__body})
    end
end

function SocketTCP:close( ... )
    if self.tcp then 
        self.tcp:close()
    end 
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
    if self.tickScheduler then scheduler.unscheduleGlobal(self.tickScheduler) end
    --self:dispatchEvent({name=SocketTCP.EVENT_CLOSE})
    --self.event(SocketTCP.EVENT_CLOSE)
end

-- disconnect on user's own initiative.
function SocketTCP:disconnect()
    self:_disconnect()
    self.isRetryConnect = false -- initiative to disconnect, no reconnect.
end

--------------------
-- private
--------------------

--- When connect a connected socket server, it will return "already connected"
-- @see: http://lua-users.org/lists/lua-l/2009-10/msg00584.html
function SocketTCP:_connect()
    local __succ, __status = self.tcp:connect(self.host, self.port)
    return __succ == 1 or __status == STATUS_ALREADY_CONNECTED
end

function SocketTCP:_disconnect()
    self.isConnected = false
    self.tcp:shutdown()
    --self:dispatchEvent({name=SocketTCP.EVENT_CLOSED})
    print("######SocketTCP:_disconnect()")
    self.event(SocketTCP.EVENT_CLOSED)
end

function SocketTCP:_onDisconnect()
    self.isConnected = false
    --self:dispatchEvent({name=SocketTCP.EVENT_CLOSED})
    print("######SocketTCP:_onDisconnect()")
    self.event(SocketTCP.EVENT_CLOSED)
    self:_reconnect()
end

-- connecte success, cancel the connection timerout timer
function SocketTCP:_onConnected()
    self.isConnected = true
    --self:dispatchEvent({name=SocketTCP.EVENT_CONNECTED})
    self.event(SocketTCP.EVENT_CONNECTED)
    if self.connectTimeTickScheduler then scheduler.unscheduleGlobal(self.connectTimeTickScheduler) end
    
--    local __tick = function()
--        self:recv()
--    end
--    
--    -- start to read TCP data
--    self.tickScheduler = scheduler.scheduleGlobal(__tick, SOCKET_TICK_TIME)
end

function SocketTCP:_connectFailure(status)
    --self:dispatchEvent({name=SocketTCP.EVENT_CONNECT_FAILURE})
    self.event(SocketTCP.EVENT_CONNECT_FAILURE)
    self:_reconnect()
end

-- if connection is initiative, do not reconnect
function SocketTCP:_reconnect(__immediately)
    if not self.isRetryConnect then return end
    if __immediately then self:connect() return end
    if self.reconnectScheduler then scheduler.unscheduleGlobal(self.reconnectScheduler) end
    local __doReConnect = function ()
        self:connect()
    end
    log.debug("------------------:%s,%s", SOCKET_RECONNECT_TIME, SOCKET_CONNECT_FAIL_TIMEOUT)
    self.reconnectScheduler = scheduler.performWithDelayGlobal(__doReConnect, SOCKET_RECONNECT_TIME)
end

function SocketTCP:Debug()
    log.debug("soc:%s, %s", self.tcp, self.isConnected)
end

return SocketTCP
