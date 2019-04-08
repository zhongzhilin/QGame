//
//  iosHelper.m
//  QGame
//
//  Created by untory on 2017/1/20.
//
//

#include "iosHelper.h"
#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <ThinkingSDK/ThinkingAnalyticsSDK.h>
#include "MobClickCpp.h"

void iosHelper::copy(const char* str) {
    
    NSLog(@"void iosHelper::copy(const char* str) {");
    
    NSString *nsMessage= [[NSString alloc] initWithCString:str encoding:NSUTF8StringEncoding];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (nsMessage == nil) {
        return;
    }
    pasteboard.string = nsMessage;

}

// facebook 统计
void iosHelper::FaceBookPurchase(double money, const char* currency)
{
    NSString * curren = [NSString stringWithUTF8String:currency];
}

void iosHelper::FaceBookActivateApp()
{
    [FBSDKAppEvents activateApp];
}

// 友盟支付统计
void iosHelper::umengPaySuccess(double money, const char* item , int number, double price,int source)
{
    umeng::MobClickCpp::pay(money, source, item, number, price);
}


// appsflayer统计
void iosHelper::AdRegisterSuccess(const char* uid, const char* username)
{
    // 先前quicksdk的接口，已经去除
}

void iosHelper::AdLoginSuccess(const char* uid, const char* username)
{
}

void iosHelper::AdUpdateRoleInfo(int isCreateRole, const char* roleId, const char* roleName, const char* roleLevel,const char* roleServerId, const char* roleServerName, const char* roleBalance, const char* roleVipLevel, const char* rolePartyName)
{
    // 先前quicksdk的接口，已经去除
}

void iosHelper::AdPaySuccess(double orderAmount, const char* cpOrderNo, const char* goodsId, const char* goodsName,const char* currency)
{
    NSString * ncpOrderNo = [NSString stringWithUTF8String:cpOrderNo];
    NSString * ngoodsId = [NSString stringWithUTF8String:goodsId];
    NSString * ncurrency = [NSString stringWithUTF8String:currency];
    NSNumber * norderAmount = [NSNumber numberWithDouble:orderAmount];
}

void iosHelper::AdTorialCompletion( int success,const char* coutent_id)
{
    BOOL isSuccess = (success == 1)?YES:NO;
    NSNumber *number = [NSNumber numberWithBool:isSuccess];
}

void iosHelper::AdLevelAchieved(int level, int score)
{
    NSNumber * nlevel = [NSNumber numberWithInt:level];
    NSNumber * nscore = [NSNumber numberWithInt:score];
}

const char* iosHelper::get_lan()
{
    NSString *languageStr = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    // 中文特殊处理
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    if([language isEqualToString:@"zh-Hant"])
    {
        languageStr = @"zh-TW"; // 繁体
    }else if([language isEqualToString:@"zh-HK"]){
        languageStr = @"zh-TW"; // 繁体
    }
    NSLog(@" =========> languageStr=%@ ",languageStr);
    return [languageStr UTF8String];
}

// thinkdata 数据统计
void iosHelper::tDSetAccountId(const char* account_id)
{
    NSString* accoutId = [NSString stringWithUTF8String:account_id];
    [[ThinkingAnalyticsSDK sharedInstance] login:accoutId];
}
void iosHelper::tDRemoveAccountId()
{
    [[ThinkingAnalyticsSDK sharedInstance] logout];
}
void iosHelper::tDSetPublicProperties(const char* channelId,const char* roleId,const char* serverId,const char* level,const char* city)
{
    NSString* channelIdStr = [NSString stringWithUTF8String:channelId];
    NSString* roleIdStr = [NSString stringWithUTF8String:roleId];
    NSString* serverIdStr = [NSString stringWithUTF8String:serverId];
    NSString* levelStr = [NSString stringWithUTF8String:level];
    NSString* cityStr = [NSString stringWithUTF8String:city];
    [[ThinkingAnalyticsSDK sharedInstance] setSuperProperties:@{
                            @"channel":channelIdStr,
                            @"role_id":roleIdStr,
                            @"server":serverIdStr,
                            @"level":levelStr,
                            @"city":cityStr,
    }];
}
void iosHelper::tDRegister()
{
    [[ThinkingAnalyticsSDK sharedInstance] track:@"register" properties:nil];
}
void iosHelper::tDLogin()
{
    [[ThinkingAnalyticsSDK sharedInstance] track:@"login" properties:nil];
}
void iosHelper::tDLoginOut(const char* online_time)
{
    NSString* online_timeStr = [NSString stringWithUTF8String:online_time];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"logout" properties:@{
       @"online_time":online_timeStr,
    }];
}
void iosHelper::tDLevelup(const char* roleLevel)
{
    NSString* roleLevelStr = [NSString stringWithUTF8String:roleLevel];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"levelup" properties:@{
                            @"new_level":roleLevelStr,
    }];
}
void iosHelper::tDCreateRole(const char* roleType)
{
    NSString* roleTypeStr = [NSString stringWithUTF8String:roleType];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"create_role" properties:@{
                                        @"role_type":roleTypeStr,
                                                                         }];
}
void iosHelper::tDOrderInit(const char* order_id, double pay_amount)
{
    NSString* order_idStr = [NSString stringWithUTF8String:order_id];
    NSNumber * pay_amountNum = [NSNumber numberWithDouble:pay_amount];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"order_init" properties:@{
        @"order_id":order_idStr,
        @"pay_amount":pay_amountNum,
   }];
}
void iosHelper::tDOrderFinish(const char* order_id,const char* pay_method, double pay_amount)
{
    NSString* order_idStr = [NSString stringWithUTF8String:order_id];
    NSString* pay_methodStr = [NSString stringWithUTF8String:pay_method];
    NSNumber * pay_amountNum = [NSNumber numberWithDouble:pay_amount];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"order_finish" properties:@{
                    @"order_id":order_idStr,
                    @"pay_method":pay_methodStr,
                    @"pay_amount":pay_amountNum,
    }];
}
void iosHelper::tDJoinGuild(const char* guild_id, const char* guild_name)
{
    NSString* guild_idStr = [NSString stringWithUTF8String:guild_id];
    NSString* guild_nameStr = [NSString stringWithUTF8String:guild_name];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"join_guild" properties:@{
              @"guild_id":guild_idStr,
              @"guild_name":guild_nameStr,
      }];
}
void iosHelper::tDLeaveGuild(const char* guild_id, const char* guild_name,const char* leave_reason)
{
    NSString* guild_idStr = [NSString stringWithUTF8String:guild_id];
    NSString* guild_nameStr = [NSString stringWithUTF8String:guild_name];
    NSString* leave_reasonStr = [NSString stringWithUTF8String:leave_reason];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"leave_guild" properties:@{
        @"guild_id":guild_idStr,
        @"guild_name":guild_nameStr,
        @"leave_reason":leave_reasonStr,
    }];
}
void iosHelper::tDCreateGuild(const char* guild_id, const char* guild_name)
{
    NSString* guild_idStr = [NSString stringWithUTF8String:guild_id];
    NSString* guild_nameStr = [NSString stringWithUTF8String:guild_name];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"create_guild" properties:@{
        @"guild_id":guild_idStr,
        @"guild_name":guild_nameStr,
        }];
}
void iosHelper::tDArenaEnter(const char* rank)
{
    NSString* rankStr = [NSString stringWithUTF8String:rank];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"arena_enter" properties:@{
          @"rank":rankStr,
          }];
}
void iosHelper::tDArenaWin(const char* rank, const char* get_honour)
{
    NSString* rankStr = [NSString stringWithUTF8String:rank];
    NSString* get_honourStr = [NSString stringWithUTF8String:get_honour];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"arena_win" properties:@{
         @"rank":rankStr,
         @"get_honour":get_honourStr,
         }];
}
void iosHelper::tDArenaLost(const char* rank, const char* get_honour)
{
    NSString* rankStr = [NSString stringWithUTF8String:rank];
    NSString* get_honourStr = [NSString stringWithUTF8String:get_honour];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"arena_lost" properties:@{
       @"rank":rankStr,
       @"get_honour":get_honourStr,
       }];
}
void iosHelper::tDAddFriend(const char* target_role_id)
{
    NSString* target_role_idStr = [NSString stringWithUTF8String:target_role_id];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"add_friend" properties:@{
     @"target_role_id":target_role_idStr,
     }];
}
void iosHelper::tDChat(const char* target_role_id, const char* chat_channel)
{
    NSString* target_role_idStr = [NSString stringWithUTF8String:target_role_id];
    NSString* chat_channelStr = [NSString stringWithUTF8String:chat_channel];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"chat" properties:@{
    @"target_role_id":target_role_idStr,
    @"chat_channel":chat_channelStr,
    }];
}
void iosHelper::tDDelFriend(const char* target_role_id)
{
    NSString* target_role_idStr = [NSString stringWithUTF8String:target_role_id];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"del_friend" properties:@{
    @"target_role_id":target_role_idStr,
    }];
}
void iosHelper::tDShopBuy(const char* shop_type, const char* token_type, const char* token_cost, const char* item_id)
{
    NSString* shop_typeStr = [NSString stringWithUTF8String:shop_type];
    NSString* token_typeStr = [NSString stringWithUTF8String:token_type];
    NSString* token_costStr = [NSString stringWithUTF8String:token_cost];
    NSString* item_idStr = [NSString stringWithUTF8String:item_id];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"shop_buy" properties:@{
      @"shop_type":shop_typeStr,
      @"token_type":token_typeStr,
      @"token_cost":token_costStr,
      @"item_id":item_idStr,
  }];
}
void iosHelper::tDSommon(const char* sommon_type, const char* token_type, const char* token_cost)
{
    NSString* sommon_typeStr = [NSString stringWithUTF8String:sommon_type];
    NSString* token_typeStr = [NSString stringWithUTF8String:token_type];
    NSString* token_costStr = [NSString stringWithUTF8String:token_cost];
    [[ThinkingAnalyticsSDK sharedInstance] track:@"sommon" properties:@{
      @"sommon_type":sommon_typeStr,
      @"token_type":token_typeStr,
      @"token_cost":token_costStr,
      }];
}
void iosHelper::tDSetUserProper(const char* role_name, const char* current_level)
{
    NSString* role_nameStr = [NSString stringWithUTF8String:role_name];
    NSString* current_levelStr = [NSString stringWithUTF8String:current_level];
    [[ThinkingAnalyticsSDK sharedInstance] user_set:@{
      @"role_name":role_nameStr,
      @"current_level":current_levelStr,
      }];
}
void iosHelper::tDAddUserProper(const char* total_revenue, const char* total_login)
{
    NSString* total_revenueStr = [NSString stringWithUTF8String:total_revenue];
    NSString* total_loginStr = [NSString stringWithUTF8String:total_login];
    [[ThinkingAnalyticsSDK sharedInstance] user_add:@{
      @"total_revenue":total_revenueStr,
      @"total_login":total_loginStr,
      }];
}









