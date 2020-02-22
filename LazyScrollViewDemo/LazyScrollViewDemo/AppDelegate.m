//
//  AppDelegate.m
//  LazyScrollViewDemo
//
//  Copyright (c) 2015-2018 Alibaba. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import <LazyScroll/TMLazyModelBucket.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    TMLazyModelBucket *bucket = [[TMLazyModelBucket alloc] initWithBucketHeight: 100];

    TMLazyItemModel *model1 = [[TMLazyItemModel alloc] init];
    [model1 setAbsRect:CGRectMake(0, 0, 10, 40)];
    [model1 setZPosition:2];

    TMLazyItemModel *model2 = [[TMLazyItemModel alloc] init];
    [model2 setAbsRect:CGRectMake(0, 40, 20, 70)];
    [model2 setZPosition:10];

    TMLazyItemModel *model3 = [[TMLazyItemModel alloc] init];
    [model3 setAbsRect:CGRectMake(0, 70, 30, 100)];
    [model3 setZPosition:9];

    TMLazyItemModel *model4 = [[TMLazyItemModel alloc] init];
    [model4 setAbsRect:CGRectMake(0, 100, 40, 40)];
    [model4 setZPosition:1];

    [bucket addModels: @[model1, model2, model3, model4]];

    NSArray<TMLazyItemModel *> *list = [bucket showingModelsFrom:100 to:200];

    for (NSInteger i = 0; i<list.count; i++) {
        NSLog(@"%@", NSStringFromCGRect(list[i].absRect));
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
