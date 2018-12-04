//
//  ESCLocalNotificationCenter.m
//  ESCLocalNotificationDemo
//
//  Created by xiang on 2018/12/4.
//  Copyright © 2018 xiang. All rights reserved.
//

#import "ESCLocalNotificationCenter.h"
#import <UIKit/UIKit.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface ESCLocalNotificationCenter ()

@end

static ESCLocalNotificationCenter *staticESCLocalNotificationCenter;

@implementation ESCLocalNotificationCenter

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticESCLocalNotificationCenter = [[ESCLocalNotificationCenter alloc] init];
    });
    return staticESCLocalNotificationCenter;
}

- (void)addLocalNotificationWithTitle:(NSString *)title content:(NSString *)content userinfo:(NSDictionary *)userInfo afterTime:(int)afterTime identifier:(NSString *)identifier{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10) {
        [self iOS10earlyCreateLocalNotificationWithTitle:title content:content userinfo:userInfo afterTime:afterTime identifier:identifier];
    }else{
        [self iOS10laterCreateLocalNotificationWithTitle:title content:content userinfo:userInfo afterTime:afterTime identifier:identifier];
    }
}

- (void)iOS10earlyCreateLocalNotificationWithTitle:(NSString *)title content:(NSString *)content userinfo:(NSDictionary *)userInfo afterTime:(int)afterTime identifier:(NSString *)identifier{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:afterTime];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = content;
    if (@available(iOS 8.2, *)) {
        localNotification.alertTitle = title;
    } else {
        // Fallback on earlier versions
    }
    NSString *identifierString = identifier;
    if (identifierString == nil || identifierString.length == 0) {
        identifierString = [NSString stringWithFormat:@"%d--%d--%d",rand() % 100000,rand() % 100000,rand() % 100000];
    }
    if (userInfo == nil) {
        localNotification.userInfo = @{@"identifier":identifierString};
    }else {
        NSMutableDictionary *temDict = [userInfo mutableCopy];
        [temDict setObject:identifierString forKey:@"identifier"];
        localNotification.userInfo = [temDict copy];
    }
    localNotification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)iOS10laterCreateLocalNotificationWithTitle:(NSString *)title content:(NSString *)content userinfo:(NSDictionary *)userInfo afterTime:(int)afterTime identifier:(NSString *)identifier{
    
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
        notificationContent.title = title;
        notificationContent.body = content;
        notificationContent.userInfo = userInfo;
        notificationContent.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:afterTime repeats:NO];
        
        NSString *identifierString = identifier;
        if (identifierString == nil || identifierString.length == 0) {
            identifierString = [NSString stringWithFormat:@"%d--%d--%d",rand() % 100000,rand() % 100000,rand() % 100000];
        }
        
        UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:identifierString content:notificationContent trigger:trigger];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"推送成功");
            }else {
                NSLog(@"推送失败==%@",error);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)removeLocalNotificationWithId:(NSString *)identifier {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10) {
        [self iOS10earlyRemoveLocalNotificationWithId:identifier];
    }else{
        [self iOS10laterRemoveLocalNotificationWithId:identifier];
    }
}

- (void)removeAllDeliveredNotifications {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10) {
        [self iOS10earlyRemoveAllDeliveredNotifications];
    }else{
        [self iOS10laterRemoveAllDeliveredNotifications];
    }
}

- (void)iOS10laterRemoveAllDeliveredNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)iOS10earlyRemoveAllDeliveredNotifications {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    }
}

- (void)iOS10laterRemoveLocalNotificationWithId:(NSString *)identifier {
    if (@available(iOS 10.0,*)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    }
}

- (void)iOS10earlyRemoveLocalNotificationWithId:(NSString *)identifier {
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notificationArray) {
        if ([[notification.userInfo objectForKey:@"identifier"] isEqualToString:identifier]) {        
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
