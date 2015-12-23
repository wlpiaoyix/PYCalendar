//
//  NSDate+Lunar.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/24.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSDate+Lunar.h"
#import "PYCalendarTools.h"
#import <Utile/NSDate+Expand.h>

NSInteger PYCalendarTotalDay1900_1970 = 0;

@implementation NSDate(Lunar)
@dynamic totalLunarDays,lunarYear,lunarMonth,lunarDay,lunarNumDaysInManth,lunarYearZodiac,lunarYearName;
+(NSInteger) getTotalDay1900_1970{
    if (PYCalendarTotalDay1900_1970 == 0) {
        [PYCalendarTools getTotalDaysPointer:&PYCalendarTotalDay1900_1970 year:1970 month:1];
    }
    return PYCalendarTotalDay1900_1970;
}
+(instancetype) dateWithYear:(NSUInteger) year month:(NSUInteger) month day:(NSUInteger) day hour:(NSUInteger) hour munite:(NSUInteger) munite second:(NSUInteger) second{
    NSInteger totalDays;
    [PYCalendarTools getTotalDaysPointer:&totalDays year:year month:month];
    totalDays += day - 1;
    totalDays -= [self getTotalDay1900_1970];
    long long int totalSeconds = totalDays;
    totalSeconds *= 3600 * 24;
    totalSeconds += 3600 * hour + munite * 60 + second;
    totalSeconds += 3600 * 24;
    totalSeconds -= [NSTimeZone localTimeZone].secondsFromGMT;
    return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)totalSeconds];
}

-(NSInteger) totalLunarDays{
    NSInteger totalLunarDays;
    [PYCalendarTools getTotalDaysPointer:&totalLunarDays year:self.year month:self.month];
    totalLunarDays += self.day - 1;
    return totalLunarDays;
}
-(NSInteger) lunarYear{
    NSInteger lunarYear;
    [PYCalendarTools getLunarYearPointer:&lunarYear lunarMonthPointer:nil lunarDayPointer:nil totalLunarDays:self.totalLunarDays];
    return lunarYear;
}
-(NSInteger) lunarMonth{
    NSInteger lunarMonth;
    [PYCalendarTools getLunarYearPointer:nil lunarMonthPointer:&lunarMonth lunarDayPointer:nil totalLunarDays:self.totalLunarDays];
    return lunarMonth;
}
-(NSInteger) lunarDay{
    NSInteger lunarDay;
    [PYCalendarTools getLunarYearPointer:nil lunarMonthPointer:nil lunarDayPointer:&lunarDay totalLunarDays:self.totalLunarDays];
    return lunarDay;
}
-(NSInteger) lunarNumDaysInManth{
    NSInteger lunarYear;
    NSInteger lunarMonth;
    [PYCalendarTools getLunarYearPointer:&lunarYear lunarMonthPointer:&lunarMonth lunarDayPointer:nil totalLunarDays:self.totalLunarDays];
    return [PYCalendarTools getLunarMonthDaysWithYear:lunarYear month:lunarMonth];
}

-(NSString*) lunarYearName{
    return [PYCalendarTools getLunarYearNameWithYear:self.lunarYear];
}

-(NSString*) lunarYearZodiac {
    return [NSString stringWithUTF8String:[PYCalendarTools lunarZodiacWithYear:self.lunarYear]];
}

@end
