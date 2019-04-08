/**
 * Copyright (c) 2015-2017 by Helpshift, Inc. All Rights Reserved.
 *
 */

//
//  HelpshiftCocos2dx.h
//  Helpshift Cocos2dx SDK
//

#ifndef HelpshiftCocos2dx_h
#define HelpshiftCocos2dx_h

#include "cocos2d.h"

#define HS_GOTO_CONVERSATION_AFTER_CONTACT_US "gotoConversationAfterContactUs"
#define HS_ENABLE_IN_APP_NOTIFICATION "enableInAppNotification"
#define HS_ENABLE_CONTACT_US "enableContactUs"
#define HS_ENABLE_CHAT "enableChat"
#define HS_META_DATA_KEY "hs-custom-metadata"
#define HS_TAGS_KEY "hs-tags"
#define HS_REQUIRE_EMAIL "requireEmail"
#define HS_HIDE_NAME_AND_EMAIL "hideNameAndEmail"
#define HS_CONVERSATION_PREFILL_TEXT "conversationPrefillText"
#define HS_ENABLE_FULL_PRIVACY "enableFullPrivacy"
#define HS_SHOW_SEARCH_ON_NEW_CONVERSATION "showSearchOnNewConversation"
#define HS_PRESENT_FULL_SCREEN_ON_IPAD "presentFullScreenOniPad"
#define HS_SHOW_CONVERSATION_RESOLUTION_QUESTION "showConversationResolutionQuestion"
#define HS_ENABLE_DEFAULT_FALL_BACK_LANGUAGE "enableDefaultFallbackLanguage"
#define HS_ENABLE_INBOX_POLLING "enableInboxPolling"
#define HS_ENABLE_LOGGING "enableLogging"
#define HS_WITH_TAGS_MATCHING "withTagsMatching"
#define HS_FILTER_TAGS "tags"
#define HS_DISABLE_ENTRY_EXIT_ANIMATIONS "disableEntryExitAnimations"
#define HS_SHOW_CONVERSATION_INFO_SCREEN "showConversationInfoScreen"

#define HS_ADD_FAQS_TO_DEVICE_SEARCH "addFaqsToDeviceSearch"
#define HS_ADD_FAQS_TO_DEVICE_SEARCH_ON_INSTALL "on_install"
#define HS_ADD_FAQS_TO_DEVICE_SEARCH_AFTER_VIEWING_FAQS "after_viewing_faqs"
#define HS_ADD_FAQS_TO_DEVICE_SEARCH_NEVER "never"

#define HS_ENABLE_CONTACT_US_ALWAYS "always"
#define HS_ENABLE_CONTACT_US_NEVER "never"
#define HS_ENABLE_CONTACT_US_AFTER_VIEWING_FAQS "after_viewing_faqs"
#define HS_ENABLE_CONTACT_US_AFTER_MARKING_ANSWER_UNHELPFUL "after_marking_answer_unhelpful"

#define HS_ALERT_CLOSE 0
#define HS_ALERT_FEEDBACK 1
#define HS_ALERT_SUCCESS 2
#define HS_ALERT_FAIL 3

#define HS_USER_ACCEPTED_SOLUTION "User accepted the solution"
#define HS_USER_REJECTED_SOLUTION "User rejected the solution"
#define HS_USER_SENT_SCREENSHOT "User sent a screenshot"
#define HS_USER_REVIEWED_APP "User reviewed the app"

#define HS_FLOW_TYPE "type"
#define HS_FLOW_CONFIG "config"
#define HS_FLOW_TITLE_RESOURCE "titleResourceName"
#define HS_FLOW_TITLE "title"
#define HS_FLOW_DATA "data"

#define HS_FAQS_FLOW "faqsFlow"
#define HS_CONVERSATION_FLOW "conversationFlow"
#define HS_FAQ_SECTION_FLOW "faqSectionFlow"
#define HS_SINGLE_FAQ_FLOW "singleFaqFlow"
#define HS_DYNAMIC_FORM_FLOW "dynamicFormFlow"
#define HS_CUSTOM_CONTACT_US_FLOWS "customContactUsFlows"

/*! \mainpage Documentation for the Cocos2dx plugin
 *
 * The HelpshiftCocos2dx plugin exposes the C++ Helpshift API for cocos2dx games.
 */

/*! \brief API for the Cocos2dx plugin for Helpshift Cocos2dx SDK
 *
 */

class HelpshiftCocos2dx
{
public:

    static void showFAQs();
    static void showFAQs(cocos2d::ValueMap& config);
    static void showConversation();
    static void showConversation(cocos2d::ValueMap& config);
    static void showFAQSection(const char *sectionPublishId);
    static void showFAQSection(const char *sectionPublishId, cocos2d::ValueMap& config);
    static void showSingleFAQ(const char *publishId);
    static void showSingleFAQ(const char *publishId, cocos2d::ValueMap& config);
    static void setNameAndEmail(const char *name, const char *email);
    static void setUserIdentifier(const char *userIdentifier);
    static void registerDeviceToken(const char *deviceToken);
    static void leaveBreadCrumb(const char *breadCrumb);
    static void clearBreadCrumbs();
    static void showAlertToRateApp (const char *url, void (*action) (int result));
    static void login(const char *identifier, const char *name, const char *email);
    static void logout();
    static void registerSessionDelegates (void (*sessionBeganListener)(),
                                          void (*sessionEndedListener)());
    static void registerDisplayAttachmentDelegate (void (*displayAttachmentListener)(const char *filePath));

    static bool setSDKLanguage(const char* locale);
    static bool isConversationActive();

    static bool addStringProperty(const char* key, const char* value);
    static bool addIntegerProperty(const char* key, int value);
    static bool addBooleanProperty(const char* key, bool value);
    static bool addDateProperty(const char* key, double secondsSinceEpoch);
    static void addProperties(cocos2d::ValueMap& properties);

    static void showInbox();
    static int  getCountOfUnreadMessages();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    static void install( const char *apiKey, const char *domainName, const char *appID);
    static void install( const char *apiKey, const char *domainName, const char *appID, cocos2d::ValueMap& config);
    static void pauseDisplayOfInAppNotification(bool pauseInApp);
    static int  getNotificationCountFromRemote(bool isRemote, void (*notificationHandler) (int count));
    static void handleLocalNotification(const char *issueId);
    static void handleRemoteNotification(cocos2d::ValueMap& notification);
    static void setInAppNotificationHandler (void (*inAppNotificationHandler) (int count));
    static void registerConversationDelegates (void (*newConversationStartedListener)(const char *message),
                                               void (*userRepliedToConversationListener)(const char *message),
                                               void (*userCompletedCustomerSatisfactionSurveyListener)(int rating, const char *feedback),
                                               void (*conversationEndedListener)());
    static void showDynamicForm(const char *title, cocos2d::ValueVector& data);
    static void showInbox(cocos2d::ValueMap& config);
    static void refetchMessages();
    static void log(const char *message);
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    static int  getNotificationCount(bool isAsync, void (*receiver) (int count));
    static void handlePush(cocos2d::ValueMap& notification);
    static void registerConversationDelegates (void (*newConversationStartedListenerArg)(const char *message),
                                               void (*userRepliedToConversationListenerArg)(const char *message),
                                               void (*userCompletedCustomerSatisfactionSurveyListenerArg)(int rating, const char *feedback),
                                               void (*didReceiveNotificationListenerArg)(int newMessageCount),
                                               void (*conversationEndedListenerArg)());
    static int  logd(const char *tag, const char *format, ...);
    static int  logi(const char *tag, const char *format, ...);
    static int  logw(const char *tag, const char *format, ...);
    static int  logv(const char *tag, const char *format, ...);
    static void showDynamicForm(cocos2d::ValueVector& data);
#endif
};

#endif
