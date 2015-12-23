//
//  NSDate+Lunar.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/24.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Lunar)
+(NSInteger) getTotalDay1900_1970;
+(instancetype) dateWithYear:(NSUInteger) year month:(NSUInteger) month day:(NSUInteger) day hour:(NSUInteger) hour munite:(NSUInteger) munite second:(NSUInteger) second;
/**
 朔日
 */
@property (nonatomic, readonly) NSInteger totalLunarDays;
/**
 农历年
 */
@property (nonatomic,readonly) NSInteger lunarYear;
/**
 农历月
 */
@property (nonatomic,readonly) NSInteger lunarMonth;
/**
 农历日
 */
@property (nonatomic,readonly) NSInteger lunarDay;
/**
 农历当月天数
 */
@property (nonatomic,readonly) NSInteger lunarNumDaysInManth;
/**
 农历年名称
 */
@property (nonatomic, strong) NSString *lunarYearName;
/**
 农历年属相
 */
@property (nonatomic, strong) NSString *lunarYearZodiac;
@end
