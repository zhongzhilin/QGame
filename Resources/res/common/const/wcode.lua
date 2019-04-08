require "common"

-- 错误码
WCODE = {
	OK 		= 0,

    SERVER_STATUS_MAINTANING     = -1,-- 服务器例行维护服务器状态

    ERR_NET_DISABLE         = -999993 ,     --网络连接超时；例如客户端网络不通;
    ERR_SERVER_KICKING       = -999994 ,     --维护性的重启服务器前的踢出服务
    ERR_SERVER_UPDATE       = -999995 ,     --有热更新的错误码返回
    ERR_ABNORMAL_LOGIN      = -999996 ,     --异常登录（给一个通知就好了，后台的话互顶）
    ERR_SERVER_REBOOTED     = -999997 ,     --服务器重启过了，需要重新连接error  99992
    ERR_SERVER_CLOSING      = -999998 ,     --服务器维护中
	ERR     = -999999,
	
    -- 基本错误  -10xxx
    -------------------------------------------------------
    ERR_PKG_UNPACK_PBDEC_ERR    = -11006,   --protobuf 解析失败
    ERR_PKG_UNPACK_BD_DEC_ERR   = -11007,   --解压数据失败
    ERR_NO_BUILD_SEQ            = 16,  	    --没有可用的建造升级队列
    ERR_RPC_TIMEOUT             = -11003,   --rpc超时
    ERR_RPC_CLIENT_NO_SEND      = -11004,    --rpc超时，客户端没有发出去

    SERVER_STATE_OK          = 0,    --服务器处于开启状态外网使用
    SERVER_STATE_INNER_OPEN  = 1,    --服务器处于开启状态但是外网不可见
    SERVER_STATE_CLOSED      = 2,    --服务器处于关闭状态
}
WCODE = nodefault(WCODE)
WCODE = readonly(WCODE)

-- 服务器给客户端的提示信息码
WTIPS = {
    SYSTEM_BUSY                 = 1000,     --系统繁忙
}
WTIPS = nodefault(WTIPS)
WTIPS = readonly(WTIPS)
