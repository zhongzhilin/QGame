/**
 * Copyright (c) 2015-2017 by Helpshift, Inc. All Rights Reserved.
 *
 */

#include "HelpshiftCocos2dx.h"

#include "platform/android/jni/JniHelper.h"
#include <android/log.h>
#include <string>

using namespace std;

static void (*alertToRateAppListener) (int result);
static void (*didReceiveNotificationCount) (int result);

static void (*helpshiftSessionBeganListener) () = NULL;
static void (*helpshiftSessionEndedListener) () = NULL;
static void (*newConversationStartedListener) (const char *message) = NULL;
static void (*userRepliedToConversationListener) (const char *message) = NULL;
static void (*userCompletedCustomerSatisfactionSurveyListener) (int rating, const char *message) = NULL;
static void (*didReceiveNotificationListener) (int newMessageCount) = NULL;
static void (*displayAttachmentListener)(const char *filePath) = NULL;
static void (*conversationEndedListener)() = NULL;

jobject parseValueVectorToArrayOfHashMaps (JNIEnv *env, cocos2d::ValueVector& data);

/*! \brief Parses the tags array
 *         from the metaData and creates a Java ArrayList
 *
 *  \param env The JNIEnv
 *  \param Tags The tags array which contains the tags.
 */
jobject parseValueVectorToArray (JNIEnv *env, cocos2d::ValueVector& tags) {
    if(tags.empty()) {
        return NULL;
    }
    const char* arraylist_class_name = "java/util/ArrayList";
    jclass clsArrayList = env->FindClass(arraylist_class_name);
    jmethodID arrayConstructorID = env->GetMethodID (clsArrayList, "<init>", "()V");
    jobject jarrayobj = env->NewObject(clsArrayList, arrayConstructorID);
    jmethodID array_add_method = 0;
    array_add_method = env->GetMethodID(clsArrayList, "add", "(Ljava/lang/Object;)Z");

    for (const auto &tag : tags)
    {
        std::string valStr = tag.asString();
        if (!valStr.empty()) {
            jstring value = env->NewStringUTF(valStr.c_str());
            env->CallBooleanMethod(jarrayobj, array_add_method, value);
        }
    }
    return jarrayobj;
}


jobject parseValueMapToHashMap (JNIEnv *env, cocos2d::ValueMap& properties) {
    if(properties.empty()) {
        return NULL;
    }
    const char* hashmap_class_name = "java/util/HashMap";
    jclass clsHashMap = env->FindClass(hashmap_class_name);
    jmethodID constructorID = env->GetMethodID (clsHashMap, "<init>", "()V");

    jobject jmapobj = env->NewObject(clsHashMap, constructorID);

    jmethodID map_put_method = 0;
    map_put_method = env->GetMethodID(clsHashMap, "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");

    jstring key ;

    for (auto iter = properties.begin(); iter != properties.end(); ++iter) {
        key = env->NewStringUTF(iter->first.c_str());
        if (iter->second.getType() == cocos2d::Value::Type::STRING) {
            std::string valueStr = properties[iter->first].asString();
            if(!valueStr.empty()) {
                jstring value = env->NewStringUTF(valueStr.c_str());
                env->CallObjectMethod(jmapobj, map_put_method, key, value);
            }
        } else if (iter->second.getType() == cocos2d::Value::Type::INTEGER) {
            int value = properties[iter->first].asInt();
            env->CallObjectMethod(jmapobj, map_put_method, key, value);
        } else if (iter->second.getType() == cocos2d::Value::Type::DOUBLE) {
            double value = properties[iter->first].asDouble();
            env->CallObjectMethod(jmapobj, map_put_method, key, value);
        } else if (iter->second.getType() == cocos2d::Value::Type::BOOLEAN) {
            int value = properties[iter->first].asBool();
            env->CallObjectMethod(jmapobj, map_put_method, key, value);
        } else if (iter->second.getType() == cocos2d::Value::Type::VECTOR) {
            cocos2d::ValueVector& array = iter->second.asValueVector();
            if (array.front().getType() == cocos2d::Value::Type::MAP) {
                env->CallObjectMethod(jmapobj, map_put_method, key, parseValueVectorToArrayOfHashMaps(env, array));
            } else {
                env->CallObjectMethod(jmapobj, map_put_method, key, parseValueVectorToArray(env, array));
            }
        } else if (iter->second.getType() == cocos2d::Value::Type::MAP) {
            env->CallObjectMethod(jmapobj, map_put_method, key, parseValueMapToHashMap(env, iter->second.asValueMap()));
        }
    }
    return jmapobj;
}


jobject parseValueVectorToArrayOfHashMaps (JNIEnv *env, cocos2d::ValueVector& data) {
    if(data.empty()) {
        return NULL;
    }
    const char* arraylist_class_name = "java/util/ArrayList";
    jclass clsArrayList = env->FindClass(arraylist_class_name);
    jmethodID arrayConstructorID = env->GetMethodID (clsArrayList, "<init>", "()V");
    jobject jarrayobj = env->NewObject(clsArrayList, arrayConstructorID);
    jmethodID array_add_method = 0;
    array_add_method = env->GetMethodID(clsArrayList, "add", "(Ljava/lang/Object;)Z");

    for (const auto &map : data) {
        jobject value = parseValueMapToHashMap(env, (cocos2d::ValueMap &)map.asValueMap());
        env->CallBooleanMethod(jarrayobj, array_add_method, value);
    }
    return jarrayobj;
}


/*! \brief Parses the config dictionary
 *         and created a Java HashMap to pass to the native layer
 *
 *  \param env The JNIEnv
 *  \param config The config dictionary which contains various config options which accepted by the SDK
 */
jobject parseConfigDictionary (JNIEnv* env, cocos2d::ValueMap& config) {
    if(config.empty()) {
        return NULL;
    }
    const char* hashmap_class_name = "java/util/HashMap";
    jclass clsHashMap = env->FindClass(hashmap_class_name);
    jmethodID constructorID = env->GetMethodID (clsHashMap, "<init>", "()V");

    jobject jmapobj = env->NewObject(clsHashMap, constructorID);

    jmethodID map_put_method = 0;
    map_put_method = env->GetMethodID(clsHashMap, "put", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;");

    jstring key ;
    jstring data;

    for (auto iter = config.begin(); iter != config.end(); ++iter) {
        key = env->NewStringUTF(iter->first.c_str());
        // the object is a Dictionary
        if (iter->second.getType() == cocos2d::Value::Type::STRING) {
            std::string valueStr = config[iter->first].asString();
            if(!valueStr.empty()) {
                data = env->NewStringUTF(valueStr.c_str());
                env->CallObjectMethod(jmapobj, map_put_method, key, data);
            }
        } else if(iter->second.getType() == cocos2d::Value::Type::MAP) {
            cocos2d::ValueMap& metaData = config[iter->first].asValueMap();
            jobject metaMap = env->NewObject(clsHashMap, constructorID);
            if (!metaData.empty()) {
                for (auto metaIter = metaData.begin(); metaIter != metaData.end(); ++metaIter) {
                    std::string keyStr = metaIter->first;
                    if (!keyStr.empty()) {
                        jstring metaKey = env->NewStringUTF(keyStr.c_str());
                        if (metaIter->second.getType() == cocos2d::Value::Type::VECTOR) {
                            env->CallObjectMethod(metaMap, map_put_method, metaKey, parseValueVectorToArray(env, metaIter->second.asValueVector()));
                        } else if (metaIter->second.getType() == cocos2d::Value::Type::STRING) {
                            std::string valStr = metaIter->second.asString();
                            jstring value = env->NewStringUTF(valStr.c_str());
                            env->CallObjectMethod(metaMap, map_put_method, metaKey, value);
                        }
                    }
                }
            }
            env->CallObjectMethod(jmapobj, map_put_method, key, metaMap);
        } else if (iter->second.getType() == cocos2d::Value::Type::VECTOR) {
            std::string keyStr = iter->first;
            if (!keyStr.empty()) {
                if( keyStr == HS_WITH_TAGS_MATCHING) {
                    env->CallObjectMethod(jmapobj, map_put_method, key, parseValueVectorToArray(env, iter->second.asValueVector()));
                } else if (keyStr == HS_CUSTOM_CONTACT_US_FLOWS) {
                    env->CallObjectMethod(jmapobj, map_put_method, key, parseValueVectorToArrayOfHashMaps(env, iter->second.asValueVector()));
                }
            }
        }
    }

    return jmapobj;
}


/*! \brief You can use this api call to provide a way
 *         for the user to send feedback or start a new conversation with you.
 *
 */
void HelpshiftCocos2dx::showConversation(void) {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showConversation",
                                                             "()V");
    if (hasMethod) {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
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
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showConversation",
                                                             "(Ljava/util/HashMap;)V");
    if (hasMethod) {
        jobject hashMap = parseConfigDictionary(minfo.env, config);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, hashMap);
    }
}


/*! \brief Shows FAQ section activity.
 * This will show a FAQ section view with list of questions in that section. The search inside this view will be limited to the specified section. You can specify a section using publish ID of that section.
 *
 * \param sectionPublishId id specifying a section
 */
void HelpshiftCocos2dx::showFAQSection(const char *sectionPublishId) {
    if(sectionPublishId == NULL || strlen(sectionPublishId) == 0) {
        return;
    }
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showFAQSection",
                                                             "(Ljava/lang/String;)V");
    if (hasMethod) {
        jstring sectionPubId = minfo.env->NewStringUTF(sectionPublishId);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        sectionPubId);
    }
}


/*! \brief Shows FAQ section activity.
 * This will show a FAQ section view with list of questions in that section. The search inside this view will be limited to the specified section. You can specify a section using publish ID of that section.
 *
 * There are two flags supported in this config -
 * gotoConversationAfterContactUs (Default : "no") If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 * enableContactUs (Default : "yes") The enableContactUs flag will determine whether the Contact Us button is shown.
 * requireEmail (Default : "no" ) If requireEmail flag is set to "yes", an e-mail address is required while starting a new conversation.
 * \param sectionPublishId id specifying a section
 * \param config Additional config
 */
void HelpshiftCocos2dx::showFAQSection(const char *sectionPublishId, cocos2d::ValueMap& config) {
    if(sectionPublishId == NULL || strlen(sectionPublishId) == 0) {
        return;
    }

    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showFAQSection",
                                                             "(Ljava/lang/String;Ljava/util/HashMap;)V");
    if (hasMethod) {
        jstring sectionPubId = minfo.env->NewStringUTF(sectionPublishId);
        jobject hashMap = parseConfigDictionary(minfo.env, config);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        sectionPubId,
                                        hashMap);
    }
}


/*! \brief Shows question activity.
 *         This provides show question view provided a publish id of that question.
 *
 * \param publishId id specifying a question
 *
 */
void HelpshiftCocos2dx::showSingleFAQ(const char *publishId) {
    if(publishId == NULL || strlen(publishId) == 0) {
        return;
    }

    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showSingleFAQ",
                                                             "(Ljava/lang/String;)V");
    if (hasMethod) {
        jstring pubId = minfo.env->NewStringUTF(publishId);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, pubId);
    }
}


/*! \brief Shows question activity.
 *         This provides show question view provided a publish id of that question.
 *
 * There are two flags supported in this config -
 * gotoConversationAfterContactUs (Default : "no") If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 * enableContactUs (Default : "yes") The enableContactUs flag will determine whether the Contact Us button is shown.
 * requireEmail (Default : "no" ) If requireEmail flag is set to "yes", an e-mail address is required while starting a new conversation.
 *
 * \param publishId id specifying a question
 * \param config Additional config
 */
void HelpshiftCocos2dx::showSingleFAQ(const char *publishId, cocos2d::ValueMap& config) {
    if(publishId == NULL || strlen(publishId) == 0) {
        return;
    }

    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showSingleFAQ",
                                                             "(Ljava/lang/String;Ljava/util/HashMap;)V");
    if (hasMethod) {
        jstring pubId = minfo.env->NewStringUTF(publishId);
        jobject hashMap = parseConfigDictionary(minfo.env, config);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        pubId,
                                        hashMap);
    }
}


/*! \brief Shows faqs activity. This will show list of sections with search.
 *
 */
void HelpshiftCocos2dx::showFAQs() {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showFAQs",
                                                             "()V");
    if (hasMethod) {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}

/*! \brief Shows Inbox activity. This will show list of campaigns.
 *
 */
void HelpshiftCocos2dx::showInbox() {
        cocos2d::JniMethodInfo minfo;
        bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                                 "com/helpshift/HelpshiftBridge",
                                                                 "showInbox",
                                                                 "()V");
        if (hasMethod) {
                minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
        }
}

/*! \brief Gets count of unread campaign messages.
 *
 * \return The count of unread campaign messages in the user's inbox.
 *
 */
int HelpshiftCocos2dx::getCountOfUnreadMessages() {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "getCountOfUnreadMessages",
                                                             "()I");
    if(hasMethod) {
        return minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID);
    }
}

/*! \brief Shows faqs activity. This will show list of sections with search.
 *
 * There are two flags supported in this config -
 * gotoConversationAfterContactUs (Default : "no") If set to "yes". Helpshift SDK will land on conversation activity after starting a new conversation. If set to "no" Helpshift SDK will land on last activity before starting a new conversation.
 * enableContactUs (Default : "yes") The enableContactUs flag will determine whether the Contact Us button is shown.
 * requireEmail (Default : "no" ) If requireEmail flag is set to "yes", an e-mail address is required while starting a new conversation.
 *
 * \param config Additional config
 */
void HelpshiftCocos2dx::showFAQs(cocos2d::ValueMap& config) {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showFAQs",
                                                             "(Ljava/util/HashMap;)V");
    if (hasMethod) {
        jobject hashMap = parseConfigDictionary(minfo.env, config);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, hashMap);
    }
}

void HelpshiftCocos2dx::showDynamicForm(cocos2d::ValueVector& data) {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showDynamicForm",
                                                             "(Ljava/util/List;)V");
    if (hasMethod) {
        jobject listOfHashMaps = parseValueVectorToArrayOfHashMaps(minfo.env, data);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, listOfHashMaps);
    }
}

/*! \brief API to login a user to the Help section.
 * \param identifier The unique id for the login
 * \param name User name
 * \param email User email
 */
void HelpshiftCocos2dx::login(const char *identifier, const char *name, const char *email) {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "login",
                                                             "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if(hasMethod) {
        jstring idStr = minfo.env->NewStringUTF(identifier);
        jstring nameStr = minfo.env->NewStringUTF(name);
        jstring emailStr = minfo.env->NewStringUTF(email);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        idStr,
                                        nameStr,
                                        emailStr);
    }
}

/*! \brief API to logout the current user
 */
void HelpshiftCocos2dx::logout() {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "logout",
                                                             "()V");
    if(hasMethod) {
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID);
    }
}

/*! \brief You can specify the name and email for your User.
 * If you want to reset previously set values, please provide NULL for both params
 * \param name User name
 * \param email User email
 */
void HelpshiftCocos2dx::setNameAndEmail(const char *name, const char *email) {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "setNameAndEmail",
                                                             "(Ljava/lang/String;Ljava/lang/String;)V");
    if(hasMethod) {
        jstring nameStr = minfo.env->NewStringUTF(name);
        jstring emailStr = minfo.env->NewStringUTF(email);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        nameStr,
                                        emailStr);
    }
}


/*! \brief If you already have indentification for your users, you can specify that as well.
 *
 * \param userIdentifier A custom user identifier
 *
 */
void HelpshiftCocos2dx::setUserIdentifier(const char *userIdentifier) {
    if(userIdentifier == NULL || strlen(userIdentifier) == 0) {
        return;
    }
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "setUserIdentifier",
                                                             "(Ljava/lang/String;)V");
    if(hasMethod) {
        jstring idStr = minfo.env->NewStringUTF(userIdentifier);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, idStr);
    }
}


/*! \brief If you are using GCM push or Urban Airship and if you want to enable Push Notification in the Helpshift Android SDK, set the Android Push ID (APID) using this method
 *
 * \param deviceToken The Android Push Id
 */
void HelpshiftCocos2dx::registerDeviceToken(const char *deviceToken) {
    if(deviceToken == NULL || strlen(deviceToken) == 0) {
        return;
    }

    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "registerDeviceToken",
                                                             "(Ljava/lang/String;)V");
    if(hasMethod) {
        jstring devTokenStr = minfo.env->NewStringUTF(deviceToken);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        devTokenStr);
    }
}


/*! \brief Add additonal debugging information in your code.
 * You can add additional debugging statements to your code,
 * and see exactly what the user was doing right before they started a new conversation.
 *
 * \param breadCrumb Action/Message to add to bread-crumbs list.
 */
void HelpshiftCocos2dx::leaveBreadCrumb(const char *breadCrumb) {
    if(breadCrumb == NULL || strlen(breadCrumb) == 0) {
        return;
    }

    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "leaveBreadCrumb",
                                                             "(Ljava/lang/String;)V");
    if(hasMethod) {
        jstring breadCrumbStr = minfo.env->NewStringUTF(breadCrumb);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        breadCrumbStr);
    }
}


/*! \brief Show an alert to let the user rate your app
 *
 * \param url The url of your app on the play store
 * \param action A callback function which takes a HSAlertToRateAppAction param
 * and returns void. This callback function will be called to let the developer
 * know what the user's response was to the Alert.
 */
void HelpshiftCocos2dx::showAlertToRateApp(const char *url,
                                           void (*action) (int result)) {
    if(url == NULL || strlen(url) == 0) {
        return;
    }
    if (action) {
        alertToRateAppListener = action;
    }
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "showAlertToRateApp",
                                                             "(Ljava/lang/String;)V");
    if(hasMethod) {
        jstring idStr = minfo.env->NewStringUTF(url);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, idStr);
    }
}


/*! \brief Clears Breadcrumbs list. Breadcrumbs list stores upto 100 latest actions. You'll receive those in every Issue. But if for reason you want to clear previous messages (On app load, for eg), you can do that by calling this api.
 *
 */
void HelpshiftCocos2dx::clearBreadCrumbs() {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "clearBreadCrumbs",
                                                             "()V");
    if(hasMethod) {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
}


/*! \brief Gets notification count
 *
 * \return The count of new notifications for updates to the conversation
 *
 */
int HelpshiftCocos2dx::getNotificationCount(bool isAsync, void (*receiver) (int result)) {
    cocos2d::JniMethodInfo minfo;
    if(receiver) {
        didReceiveNotificationCount = receiver;
    }

    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "getNotificationCount",
                                                             "(Z)I");
    if(hasMethod) {
        return minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID, isAsync);
    }
}


/*! \brief If you receive a push notification from the Helpshift server, the "origin" field of the notification will be set to "helpshift". In such a case, you can forward the notification to Helpshift.
 * \param notification The notification object received.
 */

void HelpshiftCocos2dx::handlePush(cocos2d::ValueMap& notification) {
    if (notification.empty()) {
        return;
    }
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "handlePush",
                                                             "(Ljava/util/HashMap;)V");
    if(hasMethod) {
        jobject notificationMap = parseValueMapToHashMap(minfo.env, notification);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        notificationMap);
    }
}

void HelpshiftCocos2dx::registerSessionDelegates (void (*sessionBeganListener)(),
                                                  void (*sessionEndedListener)()) {
    if (sessionBeganListener != NULL) {
        helpshiftSessionBeganListener = sessionBeganListener;
    }
    if (sessionEndedListener != NULL) {
        helpshiftSessionEndedListener = sessionEndedListener;
    }
}

void HelpshiftCocos2dx::registerConversationDelegates (void (*newConversationStartedListenerArg)(const char *message),
                                                       void (*userRepliedToConversationListenerArg)(const char *message),
                                                       void (*userCompletedCustomerSatisfactionSurveyListenerArg)(int rating, const char *feedback),
                                                       void (*didReceiveNotificationListenerArg)(int newMessageCount),
                                                       void (*conversationEndedListenerArg)()) {
    if(newConversationStartedListenerArg != NULL) {
        newConversationStartedListener = newConversationStartedListenerArg;
    }

    if(userRepliedToConversationListenerArg != NULL) {
        userRepliedToConversationListener = userRepliedToConversationListenerArg;
    }

    if(userCompletedCustomerSatisfactionSurveyListenerArg != NULL) {
        userCompletedCustomerSatisfactionSurveyListener = userCompletedCustomerSatisfactionSurveyListenerArg;
    }

    if(didReceiveNotificationListenerArg != NULL) {
        didReceiveNotificationListener = didReceiveNotificationListenerArg;
    }

    if(conversationEndedListenerArg != NULL) {
        conversationEndedListener = conversationEndedListenerArg;
    }
}

void HelpshiftCocos2dx::registerDisplayAttachmentDelegate (void (*displayAttachmentListenerArg)(const char *filePath)) {
    if(displayAttachmentListenerArg != NULL) {
        displayAttachmentListener = displayAttachmentListenerArg;
    }
}


bool HelpshiftCocos2dx::isConversationActive() {
    cocos2d::JniMethodInfo minfo;
    int retVal;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "isConversationActive",
                                                             "()Z");
    if(hasMethod) {
        retVal = minfo.env->CallStaticBooleanMethod(minfo.classID,
                                                minfo.methodID);
    }
    return retVal;
}

/*! \brief Calls the Helpshift log class with provided arguments
 *
 * \param logFunction corresponds to the log level
 * \param tagString the debug tag to use
 * \param logString the log message
 */
int logger (const char* logFunction, const char *tagString, const char* logString) {
    if(tagString == NULL || logString == NULL ||
       strlen(logString) == 0) {
        return -1;
    }

    cocos2d::JniMethodInfo minfo;
    int retVal;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/support/Log",
                                                             logFunction,
                                                             "(Ljava/lang/String;Ljava/lang/String;)I");
    if(hasMethod) {
        jstring logStr = minfo.env->NewStringUTF(logString);
        jstring tagStr = minfo.env->NewStringUTF(tagString);
        retVal = minfo.env->CallStaticIntMethod(minfo.classID,
                                                minfo.methodID,
                                                tagStr,
                                                logStr);
    }
    return retVal;
}

bool HelpshiftCocos2dx::setSDKLanguage(const char *locale) {
    if(locale == NULL || strlen(locale) == 0) {
        return false;
    }
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "setSDKLanguage",
                                                             "(Ljava/lang/String;)V");
    if(hasMethod) {
        jstring idStr = minfo.env->NewStringUTF(locale);
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, idStr);
    }
    return true;
}

bool HelpshiftCocos2dx::addStringProperty(const char *key, const char *value) {
    cocos2d::JniMethodInfo minfo;
    int retVal;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "addProperty",
                                                             "(Ljava/lang/String;Ljava/lang/String;)Z");
    if(hasMethod) {
        jstring keyStr = minfo.env->NewStringUTF(key);
        jstring valueStr = minfo.env->NewStringUTF(value);
        retVal = minfo.env->CallStaticBooleanMethod(minfo.classID,
                                                minfo.methodID,
                                                keyStr,
                                                valueStr);
    }
    return retVal;
}

bool HelpshiftCocos2dx::addIntegerProperty(const char *key, int value) {
    cocos2d::JniMethodInfo minfo;
    int retVal;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "addProperty",
                                                             "(Ljava/lang/String;I)Z");
    if(hasMethod) {
        jstring keyStr = minfo.env->NewStringUTF(key);
        retVal = minfo.env->CallStaticBooleanMethod(minfo.classID,
                                                minfo.methodID,
                                                keyStr,
                                                value);
    }
    return retVal;
}

bool HelpshiftCocos2dx::addBooleanProperty(const char *key, bool value) {
    cocos2d::JniMethodInfo minfo;
    int retVal;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "addProperty",
                                                             "(Ljava/lang/String;Z)Z");
    if(hasMethod) {
        jstring keyStr = minfo.env->NewStringUTF(key);
        retVal = minfo.env->CallStaticBooleanMethod(minfo.classID,
                                                minfo.methodID,
                                                keyStr,
                                                value);
    }
    return retVal;
}

bool HelpshiftCocos2dx::addDateProperty(const char *key, double value) {
    cocos2d::JniMethodInfo minfo;
    int retVal;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "addProperty",
                                                             "(Ljava/lang/String;D)Z");
    if(hasMethod) {
        jstring keyStr = minfo.env->NewStringUTF(key);
        retVal = minfo.env->CallStaticBooleanMethod(minfo.classID,
                                                minfo.methodID,
                                                keyStr,
                                                value);
    }
    return retVal;
}


void HelpshiftCocos2dx::addProperties(cocos2d::ValueMap& properties) {
    cocos2d::JniMethodInfo minfo;
    bool hasMethod = cocos2d::JniHelper::getStaticMethodInfo(minfo,
                                                             "com/helpshift/HelpshiftBridge",
                                                             "addProperties",
                                                             "(Ljava/util/HashMap;)V");
    if(hasMethod) {
        jobject propertiesObject = parseValueMapToHashMap(minfo.env, properties);
        minfo.env->CallStaticVoidMethod(minfo.classID,
                                        minfo.methodID,
                                        propertiesObject);
    }
}


/*! \brief Adds logs with debug level
 */
int HelpshiftCocos2dx::logd(const char *tag, const char *format, ...) {
    va_list arg;
    va_start (arg, format);
    char *logString = NULL;
    vasprintf (&logString, format, arg);
    va_end (arg);
    return logger("d", tag, logString);
}


/*! \brief Adds logs with info level
 */
int HelpshiftCocos2dx::logi(const char *tag, const char *format, ...) {
    va_list arg;
    va_start (arg, format);
    char *logString = NULL;
    vasprintf (&logString, format, arg);
    va_end (arg);
    return logger("i", tag, logString);
}

/*! \brief Adds logs with warn level
 */
int HelpshiftCocos2dx::logw(const char *tag, const char *format, ...) {
    va_list arg;
    va_start (arg, format);
    char *logString = NULL;
    vasprintf (&logString, format, arg);
    va_end (arg);
    return logger("w", tag, logString);
}

/*! \brief Adds logs with verbose level
 */
int HelpshiftCocos2dx::logv(const char *tag, const char *format, ...) {
    va_list arg;
    va_start (arg, format);
    char *logString = NULL;
    vasprintf (&logString, format, arg);
    va_end (arg);
    return logger("v", tag, logString);
}


extern "C" {
    void Java_com_helpshift_HelpshiftBridge_alertToRateAppAction (JNIEnv *env,
                                                                  jobject object,
                                                                  int message) {
        if(alertToRateAppListener) {
            alertToRateAppListener(message);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_didReceiveNotificationCount (JNIEnv *env,
                                                                         jobject object,
                                                                         int message) {
        if(didReceiveNotificationCount) {
            didReceiveNotificationCount(message);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_helpshiftSessionBegan (JNIEnv *env,
                                                                   jobject object) {
        if(helpshiftSessionBeganListener) {
            helpshiftSessionBeganListener();
        }
    }

    void Java_com_helpshift_HelpshiftBridge_helpshiftSessionEnded (JNIEnv *env,
                                                                   jobject object) {
        if(helpshiftSessionEndedListener) {
            helpshiftSessionEndedListener();
        }
    }

    void Java_com_helpshift_HelpshiftBridge_newConversationStarted (JNIEnv *env,
                                                                    jobject object,
                                                                    jstring messageString) {
        const char *message  = env->GetStringUTFChars(messageString, NULL);
        if(newConversationStartedListener) {
            newConversationStartedListener(message);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_userRepliedToConversation (JNIEnv *env,
                                                                       jobject object,
                                                                       jstring messageString) {
        const char *message  = env->GetStringUTFChars(messageString, NULL);
        if(userRepliedToConversationListener) {
            userRepliedToConversationListener(message);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_userCompletedCustomerSatisfactionSurvey (JNIEnv *env,
                                                                                     jobject object,
                                                                                     int rating,
                                                                                     jstring feedbackString) {
        const char *feedback = env->GetStringUTFChars(feedbackString, NULL);
        if(userCompletedCustomerSatisfactionSurveyListener) {
            userCompletedCustomerSatisfactionSurveyListener(rating, feedback);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_didReceiveNotification(JNIEnv *env,
                                                                    jobject object,
                                                                    int newMessageCount) {
        if(didReceiveNotificationListener) {
            didReceiveNotificationListener(newMessageCount);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_displayAttachmentFile(JNIEnv *env,
                                                                    jobject object,
                                                                    jstring filePath) {
        const char *path = env->GetStringUTFChars(filePath, NULL);
        if(displayAttachmentListener) {
            displayAttachmentListener(path);
        }
    }

    void Java_com_helpshift_HelpshiftBridge_conversationEnded (JNIEnv *env,
                                                                 jobject object) {
        if(conversationEndedListener) {
            conversationEndedListener();
        }
    }

    jstring Java_com_helpshift_HelpshiftBridge_getRuntimeVersion(JNIEnv *env,
                                                                   jobject object) {
        return env->NewStringUTF(cocos2d::cocos2dVersion());
    }

}
