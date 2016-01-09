//
//  PYCalendarTools.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/23.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYCalendarParams.h"

PYSolarTerm * _Nonnull pyCalendarGetSolarTerm(int year);

extern const unsigned int LunarCalendarDaysLength;
extern const char * _Nonnull LunarCalendarDays[31];
extern const char * _Nonnull LunarCalendarMonth[12];
extern const char * _Nonnull LunarCalendarRunMonth[12];

@interface PYCalendarTools : NSObject
+(BOOL) parsetToPointWithDate:(nonnull NSDate *) date dateShow:(nonnull NSDate *) dateShow isStart:(BOOL) isStart point:(nonnull PYPoint *) pointPointer;
+(nonnull NSDate *) parsetToDateWithPoint:(PYPoint) point dateShow:(nonnull NSDate *) dateShow;
+(void) getCalendarInfoWithPerNumDaysPointer:(nullable NSInteger *) perNumDaysPointer curNumDaysPointer:(nullable NSInteger *) curNumDaysPointer nextNumDaysPointer:(nullable NSInteger *) nextNumDaysPointer date:(nonnull const NSDate*) date;
+(void) blockIterater:(nonnull void (^) (NSInteger row, NSInteger align, PYDate date, PYDate dateMin, PYDate dateMax)) blockIterater date:(nonnull NSDate*) date dateMin:(nonnull NSDate *) dateMin dateMax:(nonnull NSDate *) dateMax;
/**
 获取年份对应的属性
 */
+(nullable const char *) lunarZodiacWithYear:(NSInteger) year;
/**
 根据朔日推算对应的公历日期
 */
+(bool) getYearPointer:(nullable NSInteger *) yearPointer monthPointer:(nullable NSInteger *) monthPointer dayPointer:(nullable NSInteger *) dayPointer totalLunarDays:(NSInteger) totalLunarDays;
/**
 根据朔日推算对应的农历时间
 */
+(bool) getLunarYearPointer:(nullable NSInteger *) lunarYearPointer lunarMonthPointer:(nullable NSInteger *) lunarMonthPointer lunarDayPointer:(nullable NSInteger *) lunarDayPointer totalLunarDays:(NSInteger)totalLunarDays;
/**
 公历日期朔日
 */
+(BOOL) getTotalDaysPointer:(nonnull NSInteger *) totalDaysPointer year:(NSInteger) year month:(NSInteger) month;
/**
 农历日期朔日
 */
+(BOOL) getTotalLunarDaysPointer:(nonnull NSInteger *) totalLunarDaysPointer year:(NSInteger) year month:(NSInteger) month;
/**
 返回农历年名称
 */
+(nonnull NSString *) getLunarYearNameWithYear:(NSInteger) year;
/**
 返回农历年闰月 0b*[4.]0000
 */
+(NSInteger) getDoubleLunarMonthWithYear:(NSInteger) year;
/**
 返回农历年闰月的天数 0b[1.][12.][4.]0
 */
+(NSInteger) getDoubleLunarMonthDaysWithYear:(NSInteger) year;
/**
 返回农历年月份的总天数0b*[12.][4.] 011011010010
 */
+(NSInteger) getLunarMonthDaysWithYear:(NSInteger) year month:(NSInteger) month;
/**
 返回农历年总天数
 */
+(NSInteger) getLunarDaysWithYear:(NSInteger) year;
@end
