//
//  HelpshiftCocos2dx.mm
//  Helpshift Cocos2dx iOS SDK
//

#include "HelpshiftCocos2dx.h"
#include "HelpshiftCore.h"
#include "HelpshiftSupport.h"

#include "HelpshiftCampaigns.h"
#include "HelpshiftAll.h"

#include "HelpshiftCocos2dxDelegate.h"

#define kHsCocos2dxSDKVersion "1.6.0"

#pragma mark Utility methods.
static void hsAddObjectToNSArray(const cocos2d::Value& value, NSMutableArray *array);
static void hsAddObjectToNSDict(const std::string& key, const cocos2d::Value& value, NSMutableDictionary *dict);
static NSArray *hsParseFlowsFromFlowDicts(NSArray* flowDicts);
static NSDictionary *hsParseConfigDict(NSDictionary* nsDict);

static NSString* hsParseCString(const char *cstring) {
    if (cstring == NULL) {
        return NULL;
    }
    NSString * nsstring = [[NSString alloc] initWithBytes:cstring
                                                   length:strlen(cstring)
                                                 encoding:NSUTF8StringEncoding];
    return [nsstring autorelease];
}

static void hsAddObjectToNSArray(const cocos2d::Value& value, NSMutableArray *array)
{
    if(value.isNull()) {
        return;
    }
    // add string into array
    if (value.getType() == cocos2d::Value::Type::STRING) {
        NSString *element = [NSString stringWithCString:value.asString().c_str() encoding:NSUTF8StringEncoding];
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::FLOAT) {
        NSNumber *number = [NSNumber numberWithFloat:value.asFloat()];
        [array addObject:number];
    } else if (value.getType() == cocos2d::Value::Type::DOUBLE) {
        NSNumber *number = [NSNumber numberWithDouble:value.asDouble()];
        [array addObject:number];
    } else if (value.getType() == cocos2d::Value::Type::BOOLEAN) {
        NSNumber *element = [NSNumber numberWithBool:value.asBool()];
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::INTEGER) {
        NSNumber *element = [NSNumber numberWithInt:value.asInt()];
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::VECTOR) {
        NSMutableArray *element = [[NSMutableArray alloc] init];
        cocos2d::ValueVector valueArray = value.asValueVector();
        for (const auto &e : valueArray) {
            hsAddObjectToNSArray(e, element);
        }
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::MAP) {
        NSMutableDictionary *element = [NSMutableDictionary dictionary];
        auto valueDict = value.asValueMap();
        for (auto iter = valueDict.begin(); iter != valueDict.end(); ++iter) {
            hsAddObjectToNSDict(iter->first, iter->second, element);
        }
        [array addObject:element];
    }
}

static void hsAddObjectToNSDict(const std::string& key, const cocos2d::Value& value, NSMutableDictionary *dict)
{
    if(value.isNull() || key.empty()) {
        return;
    }
    NSString *keyStr = [NSString stringWithCString:key.c_str() encoding:NSUTF8StringEncoding];
    if (value.getType() == cocos2d::Value::Type::MAP) {
        NSMutableDictionary *dictElement = [[NSMutableDictionary alloc] init];
        cocos2d::ValueMap subDict = value.asValueMap();
        for (auto iter = subDict.begin(); iter != subDict.end(); ++iter) {
            hsAddObjectToNSDict(iter->first, iter->second, dictElement);
        }

        [dict setObject:dictElement forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::FLOAT) {
        NSNumber *number = [NSNumber numberWithFloat:value.asFloat()];
        [dict setObject:number forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::DOUBLE) {
        NSNumber *number = [NSNumber numberWithDouble:value.asDouble()];
        [dict setObject:number forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::BOOLEAN) {
        NSNumber *element = [NSNumber numberWithBool:value.asBool()];
        [dict setObject:element forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::INTEGER) {
        NSNumber *element = [NSNumber numberWithInt:value.asInt()];
        [dict setObject:element forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::STRING) {
        NSString *strElement = [NSString stringWithCString:value.asString().c_str() encoding:NSUTF8StringEncoding];
        [dict setObject:strElement forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::VECTOR) {
        NSMutableArray *arrElement = [NSMutableArray array];
        cocos2d::ValueVector array = value.asValueVector();
        for(const auto& v : array) {
            hsAddObjectToNSArray(v, arrElement);
        }
        [dict setObject:arrElement forKey:keyStr];
    }
}

static NSDictionary *hsValueMapToNSDictionary(cocos2d::ValueMap& dict) {
    NSMutableDictionary *nsDict = [NSMutableDictionary dictionary];
    for (auto iter = dict.begin(); iter != dict.end(); ++iter)
    {
        hsAddObjectToNSDict(iter->first, iter->second, nsDict);
    }
    return nsDict;
}

static NSArray *hsVectorOfMapsToNSArray(cocos2d::ValueVector& data) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (const auto &map : data) {
        NSDictionary *dictionary = hsValueMapToNSDictionary((cocos2d::ValueMap&) map.asValueMap());
        [array addObject:dictionary];
    }
    return array;
}

static NSArray *hsParseFlowsFromFlowDicts(NSArray* flowDicts) {
    
    NSMutableArray *flows = [[NSMutableArray alloc] init];
    for (NSDictionary *flowDict in flowDicts) {
        id flow = nil;
        NSString *type = flowDict[@HS_FLOW_TYPE];
        NSString *title = flowDict[@HS_FLOW_TITLE];
        id data = flowDict[@HS_FLOW_DATA];
        NSDictionary *configOptions = flowDict[@HS_FLOW_CONFIG];
        if (configOptions && configOptions.allKeys.count > 0) {
            configOptions = hsParseConfigDict(configOptions);
        }
        
        if ([type isEqualToString:@HS_FAQS_FLOW]) {
            flow = [HelpshiftSupport flowToShowFAQsWithDisplayText:title andConfigOptions:configOptions];
        } else if ([type isEqualToString:@HS_CONVERSATION_FLOW]) {
            flow = [HelpshiftSupport flowToShowConversationWithDisplayText:title andConfigOptions:configOptions];
        } else if ([type isEqualToString:@HS_FAQ_SECTION_FLOW]) {
            flow = [HelpshiftSupport flowToShowFAQSectionForPublishId:data withDisplayText:title andConfigOptions:configOptions];
        } else if ([type isEqualToString:@HS_SINGLE_FAQ_FLOW]) {
            flow = [HelpshiftSupport flowToShowSingleFAQForPublishId:data withDisplayText:title andConfigOptions:configOptions];
        } else if ([type isEqualToString:@HS_DYNAMIC_FORM_FLOW]) {
            NSArray *nestedFlows = hsParseFlowsFromFlowDicts(data);
            flow = [HelpshiftSupport flowToShowNestedDynamicFormWithFlows:nestedFlows withDisplayText:title];
        }
        
        if (flow) {
            [flows addObject:flow];
        }
    }
    
    return flows;
}

static NSDictionary *hsParseConfig(cocos2d::ValueMap& dict) {
    NSDictionary *nsDict = hsValueMapToNSDictionary(dict);
    if ([nsDict objectForKey:@"supportedFileFormats"]) {
        [HelpshiftCocos2dxDelegate sharedInstance].supportedFileFormats = [nsDict objectForKey:@"supportedFileFormats"];
    }
    
    //In case of custom contact us flows, replace the dymanic form dicts with HSFlow objects
    if (nsDict[@HS_CUSTOM_CONTACT_US_FLOWS]) {
        NSArray *flows = hsParseFlowsFromFlowDicts(nsDict[@HS_CUSTOM_CONTACT_US_FLOWS]);
        NSMutableDictionary *newConfig = [nsDict mutableCopy];
        newConfig[@HS_CUSTOM_CONTACT_US_FLOWS] = flows;
        nsDict = [NSDictionary dictionaryWithDictionary:newConfig];
    }
    
    return nsDict;
}

static NSDictionary *hsParseConfigDict(NSDictionary* nsDict) {
    if ([nsDict objectForKey:@"supportedFileFormats"]) {
        [HelpshiftCocos2dxDelegate sharedInstance].supportedFileFormats = [nsDict objectForKey:@"supportedFileFormats"];
    }
    
    //In case of custom contact us flows, replace the dymanic form dicts with HSFlow objects
    if (nsDict[@HS_CUSTOM_CONTACT_US_FLOWS]) {
        NSArray *flows = hsParseFlowsFromFlowDicts(nsDict[@HS_CUSTOM_CONTACT_US_FLOWS]);
        NSMutableDictionary *newConfig = [nsDict mutableCopy];
        newConfig[@HS_CUSTOM_CONTACT_US_FLOWS] = flows;
        nsDict = [NSDictionary dictionaryWithDictionary:newConfig];
    }
    
    return nsDict;
}

static void (*alertToRateAppAction) (int result);

/*! \brief Initialize helpshift support
 *
 * When initializing Helpshift you must pass these three tokens. You initialize Helpshift by adding the following lines in the implementation file for your app delegate, ideally at the top of AppDelegate::applicationDidFinishLaunching(). If you use this api to initialize helpshift support, in-app notifications will be enabled by default.
 *
 * \param apiKey This is your developer API Key
 * \param domainName This is your domain name without any http:// or forward slashes
 * \param appID This is the unique ID assigned to your app
 */
void HelpshiftCocos2dx::install(const char *apiKey,
                                        const char *domainName,
                                        const char *appID) {
    cocos2d::ValueMap defaultConfig;
    install(apiKey, domainName, appID, defaultConfig);
}

/*! \brief Initialize helpshift support
 *
 * When initializing Helpshift you must pass these three tokens. You initialize Helpshift by adding the following lines in the implementation file for your app delegate, ideally at the top of AppDelegate::applicationDidFinishLaunching().
 *
 * \param apiKey This is your developer API Key
 * \param domainName This is your domain name without any http:// or forward slashes
 * \param appID This is the unique ID assigned to your app
 * \param config This is the dictionary which contains additional configuration options for the HelpshiftSDK. Currently we support the "enableInAppNotification" as the only available option. Possible values are <"yes"/"no">. If you set the flag to "yes", the helpshift SDK will show notifications similar to the banner notifications supported by Apple Push notifications. These notifications will alert the user of any updates to ongoing conversations. If you set the flag to "no", the in-app notifications will be disabled.
 */
void HelpshiftCocos2dx::install(const char *apiKey,
                                        const char *domainName,
                                        const char *appID,
                                        cocos2d::ValueMap& config) {
    [HelpshiftCore initializeWithProvider:[HelpshiftAll sharedInstance]];
    config["sdkType"] = "cocos2dx";
    config["pluginVersion"] = kHsCocos2dxSDKVersion;
    config["runtimeVersion"] = cocos2d::cocos2dVersion();
    [HelpshiftCore installForApiKey:hsParseCString(apiKey)
                         domainName:hsParseCString(domainName)
                              appID:hsParseCString(appID)
                        withOptions:hsParseConfig(config)];
    [[HelpshiftSupport sharedInstance] setDelegate:[HelpshiftCocos2dxDelegate sharedInstance]];
}

/*! \brief Shows faqs screen. This will show list of sections with search.
 *
 */
void HelpshiftCocos2dx::showFAQs() {
    [HelpshiftSupport showFAQs:[UIApplication sharedApplication].keyWindow.rootViewController withOptions:nil];
}

/*! \brief Shows faqs screen. This will show list of sections with search.
 *
 * There are 2 flags supported in this config -
 * gotoConversationAfterContactUs (Default : "no") If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 * enableContactUs (Default : "yes") The enableContactUs flag will determine whether the Contact Us button is shown.
 *
 * \param config Additional config
 */
void HelpshiftCocos2dx::showFAQs(cocos2d::ValueMap& config) {

    [HelpshiftSupport showFAQs:[UIApplication sharedApplication].keyWindow.rootViewController withOptions:hsParseConfig(config)];
}

/*! \brief You can use this api call to provide a way
 *         for the user to send feedback or start a new conversation with you.
 *
 */
void HelpshiftCocos2dx::showConversation() {

   [HelpshiftSupport showConversation:[UIApplication sharedApplication].keyWindow.rootViewController withOptions:nil];

}

/*! \brief You can use this api call to provide a way
 *         for the user to send feedback or start a new conversation with you.
 * There is one flag supported in this config -
 * gotoConversationAfterContactUs (Default : "no")
 * If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 *
 * \param config Extra config
 */
void HelpshiftCocos2dx::showConversation(cocos2d::ValueMap& config) {
    [HelpshiftSupport showConversation:[UIApplication sharedApplication].keyWindow.rootViewController withOptions:hsParseConfig(config)];
}

/*! \brief Shows FAQ section screen.
 * This will show a FAQ section view with list of questions in that section. The search inside this view will be limited to the specified section. You can specify a section using publish ID of that section.
 *
 * \param sectionPublishId id specifying a section
 */
void HelpshiftCocos2dx::showFAQSection(const char *sectionPublishId) {
    [HelpshiftSupport showFAQSection:hsParseCString(sectionPublishId)
                      withController:[UIApplication sharedApplication].keyWindow.rootViewController
                         withOptions:nil];
}

/*! \brief Shows FAQ section screen.
 * This will show a FAQ section view with list of questions in that section. The search inside this view will be limited to the specified section. You can specify a section using publish ID of that section.
 *
 * There are 2 flags supported in this config -
 * gotoConversationAfterContactUs (Default : "no") If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 * enableContactUs (Default : "yes") The enableContactUs flag will determine whether the Contact Us button is shown.
 *
 * \param sectionPublishId id specifying a section
 * \param config Additional config
 */
void HelpshiftCocos2dx::showFAQSection(const char *sectionPublishId, cocos2d::ValueMap& config) {
    [HelpshiftSupport showFAQSection:hsParseCString(sectionPublishId)
                      withController:[UIApplication sharedApplication].keyWindow.rootViewController
                         withOptions:hsParseConfig(config)];

}

/*! \brief Shows question screen.
 *         This provides show question view provided a publish id of that question.
 *
 * \param publishId id specifying a question
 *
 */
void HelpshiftCocos2dx::showSingleFAQ(const char *publishId) {
    [HelpshiftSupport showSingleFAQ:hsParseCString(publishId)
                     withController:[UIApplication sharedApplication].keyWindow.rootViewController
                        withOptions:nil];

}

/*! \brief Shows question screen.
 *         This provides show question view provided a publish id of that question.
 *
 * There are 2 flags supported in this config -
 * gotoConversationAfterContactUs (Default : "no") If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 * enableContactUs (Default : "yes") The enableContactUs flag will determine whether the Contact Us button is shown.
 *
 * \param publishId id specifying a question
 * \param config Additional config
 */
void HelpshiftCocos2dx::showSingleFAQ(const char *publishId, cocos2d::ValueMap& config) {
    [HelpshiftSupport showSingleFAQ:hsParseCString(publishId)
                     withController:[UIApplication sharedApplication].keyWindow.rootViewController
                        withOptions:hsParseConfig(config)];
}


void HelpshiftCocos2dx::showDynamicForm(const char *title, cocos2d::ValueVector& data) {
    NSArray *flows = hsParseFlowsFromFlowDicts(hsVectorOfMapsToNSArray(data));
    [HelpshiftSupport showDynamicFormOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                            withTitle:hsParseCString(title)
                                             andFlows:flows
                                    withConfigOptions:nil];
}

/*! \brief To pause and restart the display of inapp notification
 *         This provides show question view provided a publish id of that question.
 *
 * When this method is called with boolean value true, inapp notifications are paused and not displayed.
 * To restart displaying inapp notifications pass the boolean value false.
 *
 * \param pauseInApp the boolean value to pause/restart inapp nofitications
 */
void HelpshiftCocos2dx::pauseDisplayOfInAppNotification(bool pauseInApp) {
    [HelpshiftSupport pauseDisplayOfInAppNotification:pauseInApp];
}

/*! \brief Login a user with a given identifier
 *
 * This api introduces support for multiple logins in Helpshift.
 * The identifier uniquely identifies the user. Name and email are optional.
 * If any Helpshift session is active, then any login attempt is ignored.
 *
 * \param identifier The unique identifier for the use
 * \param name The name of the user
 * \param email The email of the user
 *
 * @available Available in SDK version 4.10.0 or later
 *
 */

/*! \brief Shows campaigns inbox.
 *
 */
void HelpshiftCocos2dx::showInbox() {
    [HelpshiftCampaigns showInboxOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController withOptions:nil];
}

/*! \brief Shows campaigns inbox.
 *
 * There is 1 flag supported in this config -
 * presentFullScreenOniPad : Show the Inbox UI in fullscreen mode on iPad.
 * \param config Additional config
 */
void HelpshiftCocos2dx::showInbox(cocos2d::ValueMap& config) {
    [HelpshiftCampaigns showInboxOnViewController:[UIApplication sharedApplication].keyWindow.rootViewController withOptions:hsParseConfig(config)];
}

/*! \brief Return the current count of unread campaign messages in the Inbox.
 *
 */
int HelpshiftCocos2dx::getCountOfUnreadMessages() {
    return (int)[HelpshiftCampaigns getCountOfUnreadMessages];
}

void HelpshiftCocos2dx::refetchMessages() {
    [HelpshiftCampaigns refetchMessages];
}

void HelpshiftCocos2dx::log(const char *message) {
    [HelpshiftSupport log:hsParseCString(message)];
}

void HelpshiftCocos2dx::login(const char *identifier, const char *name, const char *email) {
    [HelpshiftCore loginWithIdentifier:hsParseCString(identifier) withName:hsParseCString(name) andEmail:hsParseCString(email)];
}

void HelpshiftCocos2dx::logout() {
    [HelpshiftCore logout];
}

/*! \brief You can specify the name and email for your User.
 * To reset the name and email values set previously, you can pass null for both params
 *
 * \param name User name
 * \param email User email
 */
void HelpshiftCocos2dx::setNameAndEmail(const char *name, const char *email) {
    [HelpshiftCore setName:hsParseCString(name) andEmail:hsParseCString(email)];
}

/*! \brief If you already have indentification for your users, you can specify that as well.
 *
 * \param userIdentifier A custom user identifier
 *
 */
void HelpshiftCocos2dx::setUserIdentifier(const char *userIdentifier) {
    [HelpshiftSupport setUserIdentifier:hsParseCString(userIdentifier)];
}

/*! \brief Adds additonal debugging information in your code. You can add additional debugging statements to your code, and see exactly what the user was doing right before they started a new conversation.
 *
 * \param breadCrumb Action/Message to add to bread-crumbs list.
 */
void HelpshiftCocos2dx::leaveBreadCrumb(const char *breadCrumb) {
    [HelpshiftSupport leaveBreadCrumb:hsParseCString(breadCrumb)];
}

/*! \brief Clears Breadcrumbs list. Breadcrumbs list stores upto 100 latest actions. You'll receive those in every Issue. But if for reason you want to clear previous messages (On app load, for eg), you can do that by calling this api.
 *
 */
void HelpshiftCocos2dx::clearBreadCrumbs() {
    [HelpshiftSupport clearBreadCrumbs];
}

/*! \brief Gets notification count
 *
 * \return The count of new notifications for updates to the conversation
 *
 */
int HelpshiftCocos2dx::getNotificationCountFromRemote(bool isRemote, void (*notificationHandler) (int count)) {
    [HelpshiftCocos2dxDelegate sharedInstance].notificationCountHandler = notificationHandler;
    return (int)[HelpshiftSupport getNotificationCountFromRemote:isRemote];
}

/*! \brief Set the inApp notification handler
 *
 *
 */
void HelpshiftCocos2dx::setInAppNotificationHandler(void (*inAppNotificationHandler) (int count)) {
    [HelpshiftCocos2dxDelegate sharedInstance].inAppNotificationCountHandler = inAppNotificationHandler;
}


/*! \brief Set the session delegates
 *
 *
 */
void HelpshiftCocos2dx::registerSessionDelegates(void (*sessionBeganHandler) (void), void (*sessionEndedHandler) (void)) {
    [HelpshiftCocos2dxDelegate sharedInstance].sessionBeganHandler = sessionBeganHandler;
    [HelpshiftCocos2dxDelegate sharedInstance].sessionEndedHandler = sessionEndedHandler;
}

void HelpshiftCocos2dx::registerConversationDelegates (void (*newConversationStartedListener)(const char *message),
                                           void (*userRepliedToConversationListener)(const char *message),
                                           void (*userCompletedCustomerSatisfactionSurveyListener)(int rating, const char *feedback),
                                           void (*conversationEndedListener)()) {
    [HelpshiftCocos2dxDelegate sharedInstance].newConversationHandler = newConversationStartedListener;
    [HelpshiftCocos2dxDelegate sharedInstance].newConversationMessageHandler = userRepliedToConversationListener;
    [HelpshiftCocos2dxDelegate sharedInstance].csatCompletedHandler = userCompletedCustomerSatisfactionSurveyListener;
    [HelpshiftCocos2dxDelegate sharedInstance].conversationEndedHandler = conversationEndedListener;
}

/*! \brief Register the device token with Helpshift for getting Push notifications
 *
 * \param deviceToken The deviceToken for the device
 *
 */
void HelpshiftCocos2dx::registerDeviceToken(const char *deviceToken) {
    [HelpshiftCore registerDeviceToken:[hsParseCString(deviceToken) dataUsingEncoding:NSUTF8StringEncoding]];
}

/*! \brief Forward the local notification information to Helpshift for opening the conversation
 *
 * \param issueId The issueId for which a new local notification was received
 *
 */
void HelpshiftCocos2dx::handleLocalNotification(const char *issueId) {
    NSString *issueID = hsParseCString(issueId);
    UILocalNotification *localNotif = [[[UILocalNotification alloc] init] autorelease];
    localNotif.userInfo = @{ @"issue_id": issueID };
    [HelpshiftCore handleLocalNotification:localNotif
                            withController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

/*! \brief Forward the push notification information to Helpshift for opening the conversation
 *
 * \param notification The notification dictionary which was received
 *
 */
void HelpshiftCocos2dx::handleRemoteNotification(cocos2d::ValueMap& notification) {
    [HelpshiftCore handleRemoteNotification:hsParseConfig(notification)
                                   isAppLaunch:false
                                withController:[UIApplication sharedApplication].keyWindow.rootViewController];
}


/*! \brief Show alert for app rating
 *
 * To manually show an alert for app rating, you need automated reviews disabled in admin.
 * Also, if there is an ongoing conversation, the review alert will not show up.
 * The result of the interaction will be available through the callback which is supplied as param.
 *
 *  \param url The url of the app in the app store
 *  \param action Pointer to a callback function which takes and int and returns void.
 */

void HelpshiftCocos2dx::showAlertToRateApp(const char *url, void (*action) (int result)) {
    alertToRateAppAction = action;
    [HelpshiftSupport showAlertToRateAppWithURL:hsParseCString(url)
                            withCompletionBlock:^(HelpshiftSupportAlertToRateAppAction action) {
                                if (alertToRateAppAction != nil) {
                                    alertToRateAppAction(action);
                                }
                            }];
}

/*! \brief Set SDK Language
 *
 * Change the SDK language manually. By default, Helpshift picks up the device language.
 * If there is no localisation found for the language code or if a Helpshift session is already active, this method returns false.
 * Note: Switching between RTL and LTR languages will change the actual language used but the UI controls will not change as this requires OS support.
 *
 *  \param locale The string representing the language code. (like “fr” for french)
 */

bool HelpshiftCocos2dx::setSDKLanguage(const char* locale) {
    NSString *localeStr = hsParseCString(locale);
    return [HelpshiftSupport setSDKLanguage:localeStr];
}

bool HelpshiftCocos2dx::isConversationActive() {
    return [HelpshiftSupport isConversationActive];
}

void HelpshiftCocos2dx::registerDisplayAttachmentDelegate(void (*displayAttachmentHandler)(const char *)) {
    [HelpshiftCocos2dxDelegate sharedInstance].displayAttachmentFileHandler = displayAttachmentHandler;
}

#pragma mark Campaigns API

bool HelpshiftCocos2dx::addStringProperty(const char* key, const char* value) {
    return [HelpshiftCampaigns addProperty:hsParseCString(key) withString:hsParseCString(value)];
}

bool HelpshiftCocos2dx::addIntegerProperty(const char* key, int value) {
    return [HelpshiftCampaigns addProperty:hsParseCString(key) withInteger:value];
}

bool HelpshiftCocos2dx::addBooleanProperty(const char* key, bool value) {
    return [HelpshiftCampaigns addProperty:hsParseCString(key) withBoolean:value];
}

bool HelpshiftCocos2dx::addDateProperty(const char* key, double secondsSinceEpoch) {
    return [HelpshiftCampaigns addProperty:hsParseCString(key) withDate:[[NSDate alloc] initWithTimeIntervalSince1970:secondsSinceEpoch]];
}

void HelpshiftCocos2dx::addProperties(cocos2d::ValueMap& properties) {
    [HelpshiftCampaigns addProperties:hsValueMapToNSDictionary(properties)];
}
