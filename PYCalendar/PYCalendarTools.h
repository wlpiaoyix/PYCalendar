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
+(PYPoint) parsetToPointWithDate:(nonnull NSDate *) _date_ dateShow:(nonnull NSDate *) dateShow isStart:(BOOL) isStart;
+(nonnull NSDate *) parsetToDateWithPoint:(PYPoint) point dateShow:(nonnull NSDate *) dateShow;
+(void) getCalendarInfoWithPerNumDaysPointer:(NSInteger * _Nullable) perNumDaysPointer curNumDaysPointer:(NSInteger * _Nullable) curNumDaysPointer nextNumDaysPointer:(NSInteger * _Nullable) nextNumDaysPointer date:(nonnull const NSDate*) date;
+(void) blockIterater:(nonnull void (^) (NSInteger row, NSInteger align, PYDate date, PYDate dateMin, PYDate dateMax)) blockIterater date:(nonnull NSDate*) date dateMin:(nonnull NSDate *) dateMin dateMax:(nonnull NSDate *) dateMax;
/**
 获取年份对应的属性
 */
+(const char * _Nullable) lunarZodiacWithYear:(NSInteger) year;
/**
 根据朔日推算对应的公历日期
 */
+(bool) getYearPointer:(NSInteger * _Nullable) yearPointer monthPointer:(NSInteger * _Nullable) monthPointer dayPointer:(NSInteger * _Nullable) dayPointer totalLunarDays:(NSInteger) totalLunarDays;
/**
 根据朔日推算对应的农历时间
 */
+(bool) getLunarYearPointer:(NSInteger * _Nullable) lunarYearPointer lunarMonthPointer:(NSInteger * _Nullable) lunarMonthPointer lunarDayPointer:(NSInteger * _Nullable) lunarDayPointer totalLunarDays:(NSInteger)totalLunarDays;
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
