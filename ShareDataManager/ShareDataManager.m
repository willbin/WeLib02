//
//  ShareDataManager.m
//  GroupA
//
//  Created by Will Wei on 20/10/2016.
//  Copyright © 2016 Wecomic. All rights reserved.
//

#import "ShareDataManager.h"

#define GlipBundleIdentifier        @"com.glip.mobile"
#define RCMobileBundleIdentifier    @"com.ringcentral.RingCentralMobile"

#define AppGroupIdentifierStr       @"group.wecomic.sharedata"

#define AppGroupDateFromGlipJSON      @"dataFromGlip.json"
#define AppGroupDateFromRCJSON        @"dataFromRC.json"

@interface ShareDataManager ()
{
    NSDictionary    *_srcDict;
    NSDictionary    *_dataFromGlipDict;
    NSDictionary    *_dataFromRCDict;
    
    NSURL           *_shareInfoFromGlipURL;
    NSURL           *_shareInfoFromRCURL;
}
@end

@implementation ShareDataManager

+ (instancetype) sharedManager;
{
    static dispatch_once_t once;
    static ShareDataManager *sharedManager = nil;
    dispatch_once (&once, ^()
                   {
                       sharedManager = [[ShareDataManager alloc] init];
                   });
    return sharedManager;
}

- (instancetype) init;
{
    if (self = [super init])
    {
        _dataFromGlipDict = @{
                              @"mailbox" : @{@"id" : @"123456789",
                                             @"unreadBadge" : [NSNumber numberWithInt:32]},
                              @"currentId" : @"987654321"
                              };
        _dataFromRCDict = @{
                            @"mailbox" : @{@"id" : @"123456789",
                                           @"unreadBadge" : [NSNumber numberWithInt:32],
                                           @"authCode" : @"abc123!@#",
                                           @"phoneNum" : @"13800001111",
                                           @"email" : @"abc@ringcentral.com"
                                           },
                            @"currentId" : @"987654321"
                            };
        
        NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupIdentifierStr];
        _shareInfoFromGlipURL  = [containerURL URLByAppendingPathComponent:AppGroupDateFromGlipJSON];
        _shareInfoFromRCURL    = [containerURL URLByAppendingPathComponent:AppGroupDateFromRCJSON];
    }
    
    return self;
}

- (NSDictionary *)readShareDataForBundleID:(NSString *)bundleIDStr;
{
    // TODO: need a accurate check!
    NSURL *dstURL = [bundleIDStr isEqualToString:GlipBundleIdentifier] ? _shareInfoFromRCURL : _shareInfoFromGlipURL ;
    
    NSDictionary *returnDict = nil;
    NSData *jsonData = [NSData dataWithContentsOfURL:dstURL];
    if (jsonData)
    {
        returnDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    }
    
    return returnDict;
}

- (BOOL)saveShareDataForBundleID:(NSString *)bundleIDStr WithInfoDict:(NSDictionary *)infoDict;
{
    NSURL *dstURL = [bundleIDStr isEqualToString:GlipBundleIdentifier] ? _shareInfoFromGlipURL : _shareInfoFromRCURL ;
    BOOL isSuccess = NO;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    if (jsonData)
    {
        isSuccess = [jsonData writeToURL:dstURL atomically:YES];
    }
    
    NSLog(@"%d", isSuccess);
    return isSuccess;
}

@end
