//
//  ShareDataManager.m
//  GroupA
//
//  Created by Will Wei on 20/10/2016.
//  Copyright © 2016 Wecomic. All rights reserved.
//

#import "ShareDataManager.h"

#define AppGroupIdentifierStr           @"group.wecomic.sharedata"
#define AppGroupDateFromGlipJSON        @"dataFromGlip.json"
#define AppGroupDateFromRCJSON          @"dataFromRC.json"

@interface ShareDataManager ()
{
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
        NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AppGroupIdentifierStr];
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
    
    NSLog(@"%d", isSuccess);
    return isSuccess;
}

#pragma mark - public

// For RC use
- (BOOL)RCSaveShareDataToGlipWithInfoDict:(NSDictionary *)infoDict;
{
    return [self saveShareDataToURL:_shareInfoFromRCURL withInfoDict:infoDict];
}

- (NSDictionary *)RCReadShareDataFromGlip;
{
    return [self readShareDataWithURL:_shareInfoFromGlipURL];
}

// For Glip use
- (BOOL)GlipSaveShareDataToRCWithInfoDict:(NSDictionary *)infoDict;
{
    return [self saveShareDataToURL:_shareInfoFromGlipURL withInfoDict:infoDict];
}

- (NSDictionary *)GlipReadShareDataFromRC;
{
    return [self readShareDataWithURL:_shareInfoFromRCURL];
}

@end
