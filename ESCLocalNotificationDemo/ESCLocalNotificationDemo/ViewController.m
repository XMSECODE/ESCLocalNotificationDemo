//
//  ViewController.m
//  ESCLocalNotificationDemo
//
//  Created by xiang on 2018/12/4.
//  Copyright © 2018 xiang. All rights reserved.
//

#import "ViewController.h"
#import "ESCLocalNotificationCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (IBAction)didClickLocalNotification:(id)sender {
    NSDictionary *userInfo = @{@"id":@"1234",
                               @"content":@"你好"
                               };
    [[ESCLocalNotificationCenter shared] addLocalNotificationWithTitle:@"测试"
                                                               content:@"你好"
                                                              userinfo:userInfo
                                                             afterTime:30
                                                            identifier:@"testid"];
}
- (IBAction)didClickRemoveNotification:(id)sender {
    [[ESCLocalNotificationCenter shared] removeLocalNotificationWithId:@"testid"];
}

@end
