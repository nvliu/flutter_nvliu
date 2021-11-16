//
//  AsrManager.h
//  Runner
//
//  Created by Ying Wang on 2021/5/1.
//  Copyright © 2021 The Gitter Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsrManager: NSObject
typedef void(^AsrCallback)(NSString* mseeage);
+(instancetype)initWith: (AsrCallback)success failure: (AsrCallback)failure;
-(void)start;
-(void)stop;
-(void)cancel;
@end

