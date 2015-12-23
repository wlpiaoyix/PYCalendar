//
//  AppDelegate.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "AppDelegate.h"
#import "PYCalendarTools.h"
#import <Utile/Utile.Framework.h>
#import "NSDate+Lunar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSInteger year,month,day;
    NSInteger totalDays = 20000;
    [PYCalendarTools getYearPointer:&year monthPointer:&month dayPointer:&day totalLunarDays:totalDays];
    
    [PYCalendarTools getTotalDaysPointer:&totalDays year:year month:month];
    totalDays += day -1;
    
    [PYCalendarTools getLunarYearPointer:&year lunarMonthPointer:&month lunarDayPointer:&day totalLunarDays:totalDays];
    
    [PYCalendarTools getTotalLunarDaysPointer:&totalDays year:year month:month];
    totalDays += day - 1;
    
    
    NSDate *date = [NSDate dateWithYear:1922 month:1 day:1 hour:0 munite:1 second:1];
    NSLog(@"%d-%d-%d",date.year,date.month,date.day);
    NSLog(@"%d-%d-%d %@",date.lunarYear,date.lunarMonth,date.lunarDay,date.lunarYearZodiac);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end