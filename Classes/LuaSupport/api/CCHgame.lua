
--------------------------------
-- @module CCHgame
-- @extend Ref
-- @parent_module 

--------------------------------
-- 
-- @function [parent=#CCHgame] CallRenderRender 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_addIntegerProperty 
-- @param self
-- @param #char key
-- @param #int value
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_isConversationActive 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_showInbox 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] initQuickSdk 
-- @param self
-- @param #unsigned int initHandler
-- @param #unsigned int loginHandler
-- @param #unsigned int loginOutHandler
-- @param #unsigned int switchHandler
-- @param #unsigned int exitHandler
-- @param #unsigned int payHandler
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] setPasteBoard 
-- @param self
-- @param #char str
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] isRectIntersectRect 
-- @param self
-- @param #rect_table buildingRect
-- @param #vec2_table offsetPos
-- @param #float scrollScale
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] callCustomerService 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] AdLevelAchieved 
-- @param self
-- @param #int level
-- @param #int score
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logSpentCreditsEvent 
-- @param self
-- @param #string contentId
-- @param #string contentType
-- @param #double totalValue
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] downloadFile 
-- @param self
-- @param #string url
-- @param #string filepath
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- @overload self, char, map_table         
-- @overload self, char         
-- @function [parent=#CCHgame] hs_showFAQSection
-- @param self
-- @param #char sectionPublishId
-- @param #map_table config
-- @return CCHgame#CCHgame self (return value: CCHgame)

--------------------------------
-- 
-- @function [parent=#CCHgame] setWaterShader 
-- @param self
-- @param #cc.Sprite sprite
-- @param #string normalMapName
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_addDateProperty 
-- @param self
-- @param #char key
-- @param #double secondsSinceEpoch
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_addBooleanProperty 
-- @param self
-- @param #char key
-- @param #bool value
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] updateRoleInfoWith 
-- @param self
-- @param #int isCreateRole
-- @param #string roleId
-- @param #string roleName
-- @param #string roleLevel
-- @param #string roleServerId
-- @param #string roleServerName
-- @param #string roleBalance
-- @param #string roleVipLevel
-- @param #string rolePartyName
-- @param #string roleCreateTime
-- @param #string partyName
-- @param #string partyId
-- @param #string gameRoleGender
-- @param #string gameRolePower
-- @param #string partyRoleId
-- @param #string professionId
-- @param #string profession
-- @param #string friendlist
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_leaveBreadCrumb 
-- @param self
-- @param #char breadCrumb
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_addStringProperty 
-- @param self
-- @param #char key
-- @param #char value
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] loginQuick 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] getDeviceInfo 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_getCountOfUnreadMessages 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logOutQuick 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] GetFileData 
-- @param self
-- @param #char fileName
-- @return string#string ret (return value: string)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] pay 
-- @param self
-- @param #string shopId
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logCreateGroupEvent 
-- @param self
-- @param #string groupID
-- @param #string groupName
-- @param #string groupType
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- @overload self, map_table         
-- @overload self         
-- @function [parent=#CCHgame] hs_showFAQs
-- @param self
-- @param #map_table config
-- @return CCHgame#CCHgame self (return value: CCHgame)

--------------------------------
-- 
-- @function [parent=#CCHgame] AdUpdateRoleInfo 
-- @param self
-- @param #int isCreateRole
-- @param #string roleId
-- @param #string roleName
-- @param #string roleLevel
-- @param #string roleServerId
-- @param #string roleServerName
-- @param #string roleBalance
-- @param #string roleVipLevel
-- @param #string rolePartyName
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logJoinGroupEvent 
-- @param self
-- @param #string groupID
-- @param #string groupName
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] callFacebookShare 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_logout 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] allExit 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] exitQuickSdk 
-- @param self
-- @param #unsigned int exitcall
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] FaceBookShare 
-- @param self
-- @param #string name
-- @param #string caption
-- @param #string description
-- @param #string link
-- @param #string pic
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logOut 
-- @param self
-- @param #int channelId
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_login 
-- @param self
-- @param #char identifier
-- @param #char name
-- @param #char email
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] getFps 
-- @param self
-- @return float#float ret (return value: float)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] AdRegisterSuccess 
-- @param self
-- @param #string uid
-- @param #string username
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] showCustomService 
-- @param self
-- @param #string uid
-- @param #string username
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] payQuick 
-- @param self
-- @param #double amount
-- @param #int count
-- @param #string cpOrderID
-- @param #string extrasParams
-- @param #string goodsID
-- @param #string goodsName
-- @param #string roleId
-- @param #string roleName
-- @param #string roleLevel
-- @param #string roleServerId
-- @param #string roleServerName
-- @param #string roleBalance
-- @param #string roleVipLevel
-- @param #string partyName
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_clearBreadCrumbs 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] unzipfile 
-- @param self
-- @param #char filepath
-- @param #char dstpath
-- @param #char passwd
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] getXGToken 
-- @param self
-- @return char#char ret (return value: char)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logAchievedLevelEvent 
-- @param self
-- @param #string level
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] startApp 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] IsRelease 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] setNoTouchMoveTableView 
-- @param self
-- @param #cc.TableView table
-- @param #bool _noTouchMove
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] AdPaySuccess 
-- @param self
-- @param #double orderAmount
-- @param #string cpOrderNo
-- @param #string goodsId
-- @param #string goodsName
-- @param #string currency
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] getQuickChannelType 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] UnScheduleAll 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] AdLoginSuccess 
-- @param self
-- @param #string uid
-- @param #string username
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_addProperties 
-- @param self
-- @param #map_table properties
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] get_lan 
-- @param self
-- @return char#char ret (return value: char)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] isNodeBeTouch 
-- @param self
-- @param #cc.Node sprite
-- @param #rect_table rect
-- @param #vec2_table touchPos
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] logCompletedTutorialEvent 
-- @param self
-- @param #string contentId
-- @param #bool success
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_setNameAndEmail 
-- @param self
-- @param #char name
-- @param #char email
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_setUserIdentifier 
-- @param self
-- @param #char userIdentifier
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] GetLuaDeviceRoot 
-- @param self
-- @return char#char ret (return value: char)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_setSDKLanguage 
-- @param self
-- @param #char locale
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] RestartGame 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] AdTorialCompletion 
-- @param self
-- @param #int success
-- @param #string coutent_id
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] isRectContainsPoint 
-- @param self
-- @param #rect_table rect
-- @param #vec2_table point
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- @overload self, char, map_table         
-- @overload self, char         
-- @function [parent=#CCHgame] hs_showSingleFAQ
-- @param self
-- @param #char publishId
-- @param #map_table config
-- @return CCHgame#CCHgame self (return value: CCHgame)

--------------------------------
-- 
-- @function [parent=#CCHgame] hs_registerDeviceToken 
-- @param self
-- @param #char deviceToken
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] hs_showAlertToRateApp 
-- @param self
-- @param #char url
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] downloadWarData 
-- @param self
-- @param #string url
-- @param #string filepath
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] sendTouch 
-- @param self
-- @param #vec2_table point
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- @overload self, map_table         
-- @overload self         
-- @function [parent=#CCHgame] hs_showConversation
-- @param self
-- @param #map_table config
-- @return CCHgame#CCHgame self (return value: CCHgame)

--------------------------------
-- 
-- @function [parent=#CCHgame] FaceBookPurchase 
-- @param self
-- @param #double money
-- @param #string currency
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] getPasteBoardStr 
-- @param self
-- @return char#char ret (return value: char)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] login 
-- @param self
-- @param #int channelId
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] callUserCenter 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] umengPaySuccess 
-- @param self
-- @param #double money
-- @param #string item
-- @param #int number
-- @param #double price
-- @param #int source
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] setNoTouchMove 
-- @param self
-- @param #ccui.ScrollView scrollView
-- @param #bool _noTouchMove
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
--------------------------------
-- 
-- @function [parent=#CCHgame] CCHgame 
-- @param self
-- @return CCHgame#CCHgame self (return value: CCHgame)
        
return nil
