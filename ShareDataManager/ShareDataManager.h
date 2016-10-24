//
//  ShareDataManager.h
//  GroupA
//
//  Created by Will Wei on 20/10/2016.
//  Copyright © 2016 Wecomic. All rights reserved.
//

#import <Foundation/Foundation.h>

//v 0.0.6
@interface ShareDataManager : NSObject

+ (instancetype) sharedManagerForInHouse:(BOOL)isInHouse;

// For RC
- (BOOL)RCSaveShareDataToGlipWithInfoDict:(NSDictionary *)infoDict;
- (NSDictionary *)RCReadShareDataFromGlip;

// For Glip
- (BOOL)GlipSaveShareDataToRCWithInfoDict:(NSDictionary *)infoDict;
- (NSDictionary *)GlipReadShareDataFromRC;

@end
