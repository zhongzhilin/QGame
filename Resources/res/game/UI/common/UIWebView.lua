-- @author wuwx
local resMgr = global.resMgr
local uiMgr = global.uiMgr
local luaCfg = global.luaCfg

local UIWebView  = class("UIWebView", function() return gdisplay.newWidget() end )

function UIWebView:ctor()
    print("----UIWebView:ctor()")
	self:CreateUI()
end

function UIWebView:onEnter()

end

function UIWebView:onExit()

end

function UIWebView:CreateUI()
	self.s_webview = ccexp.WebView:create()
	-- self.s_webview:setScalesPageToFit(true)

	self:addChild(self.s_webview)
end

function UIWebView:setSize(size)
    self.s_webview:setContentSize(size)
end

function UIWebView:loadUrl(url,isClearCache)
    self.s_webview:loadURL(url,isClearCache)
end

function UIWebView:getCurrUrl()
    return self.s_webview:getCurrUrl()
end

function UIWebView:setOnDidFinishLoading(callback)
    return self.s_webview:setOnDidFinishLoading(callback)
end

function UIWebView:setOnShouldStartLoading(callback)
    return self.s_webview:setOnShouldStartLoading(callback)
end

function UIWebView:setOnDidFailLoading(callback)
    return self.s_webview:setOnDidFailLoading(callback)
end

return UIWebView
