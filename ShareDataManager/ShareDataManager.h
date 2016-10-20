//
//  ShareDataManager.h
//  GroupA
//
//  Created by Will Wei on 20/10/2016.
//  Copyright © 2016 Wecomic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareDataManager : NSObject

+ (instancetype) sharedManager;

- (NSDictionary *)readShareDataForBundleID:(NSString *)bundleIDStr;
- (BOOL)saveShareDataForBundleID:(NSString *)bundleIDStr WithInfoDict:(NSDictionary *)infoDict;

@end
