//
//  ShareDataManager.m
//  GroupA
//
//  Created by Will Wei on 20/10/2016.
//  Copyright © 2016 Wecomic. All rights reserved.
//

#import "ShareDataManager.h"

#define AppGroupShareDataNormal         @"group.com.ringcentral.app"
#define AppGroupShareDataInHouse        @"group.com.ringcentral.watchshared"

#define AppGroupDateFromGlipJSON        @"dataFromGlip.json"
#define AppGroupDateFromRCJSON          @"dataFromRC.json"

@interface ShareDataManager ()
{
    BOOL            _isInHouse;
    NSURL           *_shareInfoFromGlipURL;
    NSURL           *_shareInfoFromRCURL;
}
@end

@implementation ShareDataManager

+ (instancetype) sharedManagerForInHouse:(BOOL)isInHouse;
{
    static dispatch_once_t once;
    static ShareDataManager *sharedManager = nil;
    dispatch_once (&once, ^()
                   {
                       sharedManager = [[ShareDataManager alloc] initForInHouse:isInHouse];
                   });
    return sharedManager;
}

- (instancetype) initForInHouse:(BOOL)isInHouse;
{
    if (self = [super init])
    {
        NSURL *containerURL = nil;
        if (_isInHouse)
        {
            containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupShareDataInHouse];
        }
        else
        {
            containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupShareDataNormal];
        }
        _shareInfoFromGlipURL  = [containerURL URLByAppendingPathComponent:AppGroupDateFromGlipJSON];
        _shareInfoFromRCURL    = [containerURL URLByAppendingPathComponent:AppGroupDateFromRCJSON];
    }
    
    return self;
}

- (NSDictionary *)readShareDataWithURL:(NSURL *)dstURL;
{
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

- (BOOL)saveShareDataToURL:(NSURL *)dstURL withInfoDict:(NSDictionary *)infoDict;
{
    BOOL isSuccess = NO;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    if (jsonData)
    {
        isSuccess = [jsonData writeToURL:dstURL atomically:YES];
    }
    return isSuccess;
}

#pragma mark - public

// For RC
- (BOOL)RCSaveShareDataToGlipWithInfoDict:(NSDictionary *)infoDict;
{
    return [self saveShareDataToURL:_shareInfoFromRCURL withInfoDict:infoDict];
}

- (NSDictionary *)RCReadShareDataFromGlip;
{
    return [self readShareDataWithURL:_shareInfoFromGlipURL];
}

// For Glip
- (BOOL)GlipSaveShareDataToRCWithInfoDict:(NSDictionary *)infoDict;
{
    return [self saveShareDataToURL:_shareInfoFromGlipURL withInfoDict:infoDict];
}

- (NSDictionary *)GlipReadShareDataFromRC;
{
    return [self readShareDataWithURL:_shareInfoFromRCURL];
}

@end
