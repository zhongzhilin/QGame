//
//  HelpshiftDelegate.m
//

#import "HelpshiftCocos2dxDelegate.h"
#import "HelpshiftCocos2dx.h"
#import "Helpshift.h"

@implementation HelpshiftCocos2dxDelegate

@synthesize notificationCountHandler, inAppNotificationCountHandler;

+ (HelpshiftCocos2dxDelegate *) sharedInstance {
    static HelpshiftCocos2dxDelegate *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HelpshiftCocos2dxDelegate alloc] init];
    });
    return instance;
}

- (void) didReceiveNotificationCount:(NSInteger)count {
    if ([HelpshiftCocos2dxDelegate sharedInstance].notificationCountHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].notificationCountHandler((int)count);
    }
}

- (void) didReceiveInAppNotificationWithMessageCount:(NSInteger)count {
    if ([HelpshiftCocos2dxDelegate sharedInstance].inAppNotificationCountHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].inAppNotificationCountHandler((int)count);
    }
}

- (void) newConversationStartedWithMessage:(NSString *)newConversationMessage {
    if ([HelpshiftCocos2dxDelegate sharedInstance].newConversationHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].newConversationHandler([newConversationMessage UTF8String]);
    }
}

- (void) userRepliedToConversationWithMessage:(NSString *)newMessage {
    if ([HelpshiftCocos2dxDelegate sharedInstance].newConversationMessageHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].newConversationMessageHandler([newMessage UTF8String]);
    }
}

- (void) userCompletedCustomerSatisfactionSurvey:(NSInteger)rating withFeedback:(NSString *)feedback {
    if ([HelpshiftCocos2dxDelegate sharedInstance].csatCompletedHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].csatCompletedHandler((int)rating, [feedback UTF8String]);
    }
}

- (BOOL) displayAttachmentFileAtLocation:(NSURL *)fileLocation onViewController:(UIViewController *)parentViewController {
    NSString *filePath = [fileLocation path];
    if ([HelpshiftCocos2dxDelegate sharedInstance].displayAttachmentFileHandler) {
        if([HelpshiftCocos2dxDelegate sharedInstance].supportedFileFormats != nil) {
            bool fileFormatAvailable = false;
            for(NSString *item in [HelpshiftCocos2dxDelegate sharedInstance].supportedFileFormats)
            {
                if([[filePath pathExtension] isEqualToString:item]) {
                    fileFormatAvailable = true;
                }
            }
            if(fileFormatAvailable) {
                [HelpshiftCocos2dxDelegate sharedInstance].displayAttachmentFileHandler([filePath UTF8String]);
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    }
    return NO;
}

- (void) helpshiftSupportSessionHasEnded {
    if ([HelpshiftCocos2dxDelegate sharedInstance].sessionEndedHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].sessionEndedHandler();
    }
}

- (void) helpshiftSupportSessionHasBegun {
    if ([HelpshiftCocos2dxDelegate sharedInstance].sessionBeganHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].sessionBeganHandler();
    }
}

- (void) conversationEnded {
    if ([HelpshiftCocos2dxDelegate sharedInstance].conversationEndedHandler) {
        [HelpshiftCocos2dxDelegate sharedInstance].conversationEndedHandler();
    }
}

@end
