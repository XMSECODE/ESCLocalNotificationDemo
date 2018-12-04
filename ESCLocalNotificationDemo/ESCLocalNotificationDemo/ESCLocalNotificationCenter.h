//
//  ESCLocalNotificationCenter.h
//  ESCLocalNotificationDemo
//
//  Created by xiang on 2018/12/4.
//  Copyright © 2018 xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCLocalNotificationCenter : NSObject

+ (instancetype)shared;

- (void)addLocalNotificationWithTitle:(NSString *)title content:(NSString *)content userinfo:(NSDictionary *)userInfo afterTime:(int)afterTime identifier:(NSString *)identifier;

- (void)removeLocalNotificationWithId:(NSString *)identifier;

- (void)removeAllDeliveredNotifications;

@end

NS_ASSUME_NONNULL_END
