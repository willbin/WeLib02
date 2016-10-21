//
//  ShareDataManager.h
//  GroupA
//
//  Created by Will Wei on 20/10/2016.
//  Copyright © 2016 Wecomic. All rights reserved.
//

#import <Foundation/Foundation.h>

//v 0.0.4
@interface ShareDataManager : NSObject

+ (instancetype) sharedManager;

// For RC use
- (BOOL)RCSaveShareDataToGlipWithInfoDict:(NSDictionary *)infoDict;
- (NSDictionary *)RCReadShareDataFromGlip;

// For Glip use
- (BOOL)GlipSaveShareDataToRCWithInfoDict:(NSDictionary *)infoDict;
- (NSDictionary *)GlipReadShareDataFromRC;

@end
