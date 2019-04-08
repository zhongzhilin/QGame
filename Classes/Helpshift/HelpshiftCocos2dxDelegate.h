//
//  HelpshiftDelegate.h
//

#import <Foundation/Foundation.h>
#import "HelpshiftSupport.h"

@interface HelpshiftCocos2dxDelegate : NSObject <HelpshiftSupportDelegate>


+ (HelpshiftCocos2dxDelegate *) sharedInstance;


@property (nonatomic) void (*notificationCountHandler) (int count);
@property (nonatomic) void (*inAppNotificationCountHandler) (int count);
@property (nonatomic) void (*newConversationHandler) (const char *message);
@property (nonatomic) void (*newConversationMessageHandler) (const char *message);
@property (nonatomic) void (*csatCompletedHandler) (int rating, const char *message);
@property (nonatomic) void (*displayAttachmentFileHandler) (const char *path);
@property (nonatomic) void (*sessionBeganHandler) (void);
@property (nonatomic) void (*sessionEndedHandler) (void);
@property (nonatomic) void (*conversationEndedHandler) (void);
@property (nonatomic, strong) NSArray *supportedFileFormats;;

@end
