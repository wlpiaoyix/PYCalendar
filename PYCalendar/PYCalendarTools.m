//
//  PYCalendarTools.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/23.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarTools.h"
#import <Utile/NSDate+Expand.h>

#include <stdio.h>
#include <stdlib.h>

const int PYCalendarToolsYearMin = 1900;
const int PYCalendarToolsYearMax = 2100;

static const double x_1900_1_6_2_5 = 693966.08680556;

double get_solar_term( int y , int n )
{
    static const int termInfo[] = {
        0      ,21208 ,42467 ,63836 ,85337 ,107014,
        128867,150921,173149,195551,218072,240693,
        263343,285989,308563,331033,353350,375494,
        397447,419210,440795,462224,483532,504758
    };
    return x_1900_1_6_2_5+365.2422*(y-1900)+termInfo[n]/(60.*24);
}

void  format_date( unsigned _days, PYDate *datePointer){
    static const int mdays[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
    int y , m , d , diff;
    unsigned days;
    
    days = 100 * (_days - _days/(3652425L/(3652425L-3652400L)) );
    y    = days / 36524; days %= 36524;
    m    = 1 + days/3044;        /* [1..12] */
    d    = 1 + (days%3044)/100;    /* [1..31] */
    
    diff =y*365+y/4-y/100+y/400+mdays[m-1]+d-((m<=2&&((y&3)==0)&&((y%100)!=0||y%400==0))) - _days;
    
    if( diff > 0 && diff >= d )    /* ~0.5% */
    {
        if( m == 1 )
        {
            --y; m = 12;
            d = 31 - ( diff - d );
        }
        else
        {
            d = mdays[m-1] - ( diff - d );
            if( --m == 2 )
                d += ((y&3)==0) && ((y%100)!=0||y%400==0);
        }
    }
    else
    {
        if( (d -= diff) > mdays[m] )    /* ~1.6% */
        {
            if( m == 2 )
            {
                if(((y&3)==0) && ((y%100)!=0||y%400==0))
                {
                    if( d != 29 )
                        m = 3 , d -= 29;
                }
                else
                {
                    m = 3 , d -= 28;
                }
            }
            else
            {
                d -= mdays[m];
                if( m++ == 12 )
                    ++y , m = 1;
            }
        }
    }
    if (datePointer) {
        *datePointer = PYDateMake(y, m, d);
    }
}
PYSolarTerm* pyCalendarGetSolarTerm(int year)
{
    static const char* solar_term_name[] = {
        "小寒","大寒","立春","雨水",
        "惊蛰","春分","清明","谷雨",
        "立夏","小满","芒种","夏至",
        "小暑","大暑","立秋","处暑",
        "白露","秋分","寒露","霜降",
        "立冬","小雪","大雪","冬至"
    };
    int i;
    if( year < 1900 || year > PYCalendarToolsYearMax )
        year = 2008;
    PYSolarTerm sts[50];
    for( i = 0; i < 24; ++i ) {
        PYDate date;
        format_date( (unsigned)get_solar_term( year , i ),&date);
        PYSolarTerm st = PYSolarTermMake(date, solar_term_name[i]);
        sts[i] = st;
    }
    PYSolarTerm * stsResult;
    stsResult = sts;
    return stsResult;
}




const unsigned int LunarCalendarInfoLength = 201;
const unsigned int LunarCalendarInfo[201] = {
    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
    0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
    0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
    0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
    0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
    
    0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,
    0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
    0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,
    0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
    
    0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
    0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
    0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
    0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
    0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,
    
    
    0x04b63,0x0937f,0x049f8,0x04970,0x064b0,0x068a6,0x0ea5f,0x06b20,0x0a6c4,0x0aaef,
    0x092e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,
    0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,
    0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x04b55,0x04b6f,0x0a570,0x054e4,0x0d260,
    0x0e968,0x0d520,0x0daa0,0x06aa6,0x056df,0x04ae0,0x0a9d4,0x0a4d0,0x0d150,0x0f252,
    0x0d520};

const unsigned int LunarCalendarDaysLength = 31;
const char * LunarCalendarDays[31] = {"初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十", "三一"};

const unsigned int LunarCalendarMonthLength = 12;
const char * LunarCalendarMonth[12] = {"正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月",  "十月", "冬月", "腊月"};

const unsigned int LunarCalendarRunMonthLength = 12;
const char * LunarCalendarRunMonth[12] = {"正月", "闰二月", "闰三月", "闰四月", "闰五月", "闰六月", "闰七月", "闰八月", "闰九月",  "闰十月", "闰冬月", "腊月"};

const unsigned int LunarCalendarZodiacLength = 12;
const char * LunarCalendarZodiac[12] = {"鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"};

const unsigned int LunarCalendarTianganLength = 10;
const char * LunarCalendarTiangan[10] =  {"甲","乙","丙","丁","戊","己","庚","辛","壬","癸"};

const unsigned int LunarCalendarDizhiLength = 12;
const char * LunarCalendarDizhi[12] =  {"子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"};

const float LunarCalendarSuoyue = 29.5306;

const unsigned int LunarCalendarInfoStart[6] = {12,1,30,1,1};

const unsigned int CalendarNonleapYearInfo[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
const unsigned int CalendarLeapYearInfo[12] = {31,29,31,30,31,30,31,31,30,31,30,31};

@implementation PYCalendarTools


+(void) checkDate:(NSDate **) datePointer isStart:(BOOL) isStart dateShow:(NSDate *) dateShow{
    NSInteger year = dateShow.year;
    NSInteger month = dateShow.month;
    
    NSInteger perNumDays;
    NSInteger curNumDays;
    NSInteger nextNumDays;
    
    [PYCalendarTools getCalendarInfoWithPerNumDaysPointer:&perNumDays curNumDaysPointer:&curNumDays nextNumDaysPointer:&nextNumDays date:dateShow];
    
    NSInteger totalDays = 0;
    [PYCalendarTools getTotalDaysPointer:&totalDays year:year month:month];
    NSInteger startTotalDays = totalDays - perNumDays;
    NSInteger endTotalDays = totalDays + curNumDays + nextNumDays;
    
    
    
    if (datePointer && *datePointer) {
        NSDate *date = *datePointer;
        
        NSInteger _year_ = date.year;
        NSInteger _month_ = date.month;
        NSInteger _day_ = date.day;
        
        NSInteger _totalDays_ = 0;
        [PYCalendarTools getTotalDaysPointer:&_totalDays_ year:_year_ month:_month_];
        _totalDays_ += _day_;
        

        if (isStart) {
            if (startTotalDays > _totalDays_) {
                NSInteger td;
                [PYCalendarTools getTotalDaysPointer:&td year:1970 month:1];
                date = [NSDate dateWithTimeIntervalSince1970:(startTotalDays - td) * 24 * 3600];
            }else if(endTotalDays < _totalDays_){
                date = nil;
            }
        }else{
            if (endTotalDays < _totalDays_) {
                NSInteger td;
                [PYCalendarTools getTotalDaysPointer:&td year:1970 month:1];
                date = [NSDate dateWithTimeIntervalSince1970:(endTotalDays - td - 1) * 24 * 3600];
            }else if(startTotalDays > _totalDays_){
                date = nil;
            }
        }
        *datePointer = date;
    }
}

+(PYPoint) parsetToPointWithDate:(NSDate * _Nonnull) _date_ dateShow:(NSDate * _Nonnull) dateShow isStart:(BOOL) isStart{
    
    NSInteger perNumDays;
    NSInteger curNumDays;
    NSInteger nextNumDays;
    [PYCalendarTools getCalendarInfoWithPerNumDaysPointer:&perNumDays curNumDaysPointer:&curNumDays nextNumDaysPointer:&nextNumDays date:dateShow];
    
    NSDate *date = _date_;
    
    PYPoint point = PYPointMake(-1, -1);
    [self checkDate:&date isStart:isStart dateShow:dateShow];
    
    if (!date) {
        return point;
    }
    
    if ((date.year == dateShow.year && date.month + 1 == dateShow.month) || (date.year + 1 == dateShow.year && dateShow.month == 1 && date.month == 12)) {
        point.y = 0;
        point.x = perNumDays - (date.numDaysInMonth - date.day) - 1;
    }else if(date.year == dateShow.year && date.month == dateShow.month){
        point.y = (date.day + perNumDays - 1) / 7;
        point.x = (date.day + perNumDays - 1) % 7;
    }else if((date.year == dateShow.year && date.month - 1 == dateShow.month) || (date.year - 1 == dateShow.year && dateShow.month == 12 && date.month == 1)){
        point.y = (perNumDays + curNumDays + nextNumDays) / 7 - 1;
        point.x = date.day + (perNumDays + curNumDays)  % 7 - 1;
    }
    return point;
}

+(NSDate * _Nonnull) parsetToDateWithPoint:(PYPoint) point dateShow:(NSDate * _Nonnull) dateShow{
    
    NSDate *date = dateShow;
    
    NSInteger perNumDays;
    [PYCalendarTools getCalendarInfoWithPerNumDaysPointer:&perNumDays curNumDaysPointer:nil nextNumDaysPointer:nil date:date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-date.day - perNumDays + 1];
    [offsetComponents setHour:-date.hour];
    [offsetComponents setMinute:-date.minute];
    [offsetComponents setSecond:-date.second];
    date = [gregorian dateByAddingComponents:offsetComponents
                                      toDate:date options:0];
    date = [date offsetDay:(int)(point.x + point.y * 7)];
    
    return date;
}
+(void) getCalendarInfoWithPerNumDaysPointer:(NSInteger * _Nullable) perNumDaysPointer curNumDaysPointer:(NSInteger * _Nullable) curNumDaysPointer nextNumDaysPointer:(NSInteger * _Nullable) nextNumDaysPointer date:(nonnull const NSDate*) date{
    NSInteger firstWeekDay = date.firstWeekDayInMonth;
    
    NSInteger preNumDays = 0;
    NSInteger curNumDays = 0;
    NSInteger nextNumDays = 0;
    
    //==>
    if (firstWeekDay < 7) {
        preNumDays = firstWeekDay;
    }
    curNumDays = date.numDaysInMonth;
    nextNumDays = 7 - (preNumDays + curNumDays) % 7;
    if (nextNumDays == 7) {
        nextNumDays = 0;
    }
    //<==
    if (perNumDaysPointer) {
        *perNumDaysPointer = preNumDays;
    }
    if (curNumDaysPointer) {
        *curNumDaysPointer = curNumDays;
    }
    if (nextNumDaysPointer) {
        *nextNumDaysPointer = nextNumDays;
    }
}

+(void) blockIterater:(nonnull void (^) (NSInteger row, NSInteger align, PYDate date, PYDate dateMin, PYDate dateMax)) blockIterater date:(nonnull NSDate*) date dateMin:(nonnull NSDate *) dateMin dateMax:(nonnull NSDate *) dateMax{
    
    
    NSInteger year;
    NSInteger month;
//    NSInteger firstWeekDay = date.firstWeekDayInMonth;
    
    NSDate *preDate = [date offsetMonth:-1];
    NSDate *nextDate = [date offsetMonth:1];
    NSInteger preNumDays = 0;
    NSInteger curNumDays = 0;
    NSInteger nextNumDays = 0;
    
    [self getCalendarInfoWithPerNumDaysPointer:&preNumDays curNumDaysPointer:&curNumDays nextNumDaysPointer:&nextNumDays date:date];
    
    
    NSInteger row = 0;
    NSInteger align = 0;
    //==>
    
    PYDate curdate;
    PYDate minDate = PYDateMake(dateMin.year, dateMin.month, dateMin.day);
    PYDate maxDate  = PYDateMake(dateMax.year, dateMax.month, dateMax.day);
    if (preNumDays > 0) {
        year = preDate.year;
        month = preDate.month;
        NSInteger maxNumDays = preDate.numDaysInMonth;
        curdate = PYDateMake(year, month, 0);
        for (NSInteger index = preNumDays -1; index >= 0; index --) {
            curdate.day = maxNumDays - index;
            blockIterater(row,align,curdate,minDate,maxDate);
            align ++;
        }
    }
    
    year = date.year;
    month = date.month;
    
    curdate = PYDateMake(year, month, 0);
    for (NSInteger index = 1; index <= curNumDays; index ++) {
        if (align > 6) {
            align = 0;
            ++row;
        }
        curdate.day = index;
        blockIterater(row,align,curdate,minDate,maxDate);
        align ++;
    }
    
    if (nextNumDays > 0) {
        year = nextDate.year;
        month = nextDate.month;
        
        curdate = PYDateMake(year, month, 0);
        for (NSInteger index = 1; index <= nextNumDays; index ++) {
            curdate.day = index;
            blockIterater(row,align,curdate,minDate,maxDate);
            align ++;
        }
    }
    //<==
}

/**
 获取年份对应的属性
 */
+(const char*) lunarZodiacWithYear:(NSInteger) year{
    if(year < PYCalendarToolsYearMin || year > PYCalendarToolsYearMax){
        return nil;
    }
    return LunarCalendarZodiac[(year - (PYCalendarToolsYearMin % 12)) % 12];
}
/**
 通过朔日获取公历日期
 */
+(bool) getYearPointer:(NSInteger * _Nullable) yearPointer monthPointer:(NSInteger * _Nullable) monthPointer dayPointer:(NSInteger * _Nullable) dayPointer totalLunarDays:(NSInteger) totalLunarDays{
    
    NSInteger _totalLunarDays = 0;
    for (NSInteger _year = PYCalendarToolsYearMin; _year <= PYCalendarToolsYearMax; _year++) {
        NSInteger yearDays = 365;
        if(_year != PYCalendarToolsYearMin && _year % 4 == 0){
            yearDays += 1;
        }
        _totalLunarDays += yearDays;
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= yearDays;
            *yearPointer = _year;
            break;
        }
        
    }
    NSInteger monthNum = 1;
    for (NSInteger index = 0; index < LunarCalendarMonthLength; index++) {
        NSInteger _monthDays = ((*yearPointer != PYCalendarToolsYearMin && *yearPointer % 4 == 0) ? CalendarLeapYearInfo : CalendarNonleapYearInfo)[index];
        _totalLunarDays += _monthDays;
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= _monthDays;
            *monthPointer = monthNum;
            break;
        }
        monthNum ++;
    }
    
    *dayPointer = totalLunarDays - _totalLunarDays + 1;
    
    return true;
}

/**
 根据总天数推算对应的农历时间
 */
+(bool) getLunarYearPointer:(NSInteger * _Nullable) lunarYearPointer lunarMonthPointer:(NSInteger * _Nullable) lunarMonthPointer lunarDayPointer:(NSInteger * _Nullable) lunarDayPointer totalLunarDays:(NSInteger)totalLunarDays{
    NSInteger lunarYear = 0;
    NSInteger lunarMonth = 0;
    NSInteger lunarDay = 0;
    unsigned int _totalLunarDays = LunarCalendarInfoStart[2];
    for (unsigned int _year = PYCalendarToolsYearMin; _year <= PYCalendarToolsYearMax; _year++) {
        _totalLunarDays += [self getLunarDaysWithYear:_year];
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= [self getLunarDaysWithYear:_year];
            lunarYear = _year;
            break;
        }
    }
    NSInteger ruiyue =  [self getDoubleLunarMonthWithYear:lunarYear];
    for (NSInteger _month = 1; _month <= 12; _month++) {
        NSInteger monthDays = [self getLunarMonthDaysWithYear:lunarYear month:_month];
        _totalLunarDays += monthDays;
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= monthDays;
            lunarMonth = _month;
            break;
        }
        if(_month == ruiyue){
            monthDays = [self getDoubleLunarMonthDaysWithYear:lunarYear];
            _totalLunarDays += monthDays;
            if(_totalLunarDays > totalLunarDays){
                _totalLunarDays -= monthDays;
                lunarMonth = -_month;
                break;
            }
        }
    }
    lunarDay = totalLunarDays - _totalLunarDays + 1;
    if (lunarYearPointer) {
        *lunarYearPointer = lunarYear;
    }
    if (lunarMonthPointer) {
        *lunarMonthPointer = lunarMonth;
    }
    if (lunarDayPointer) {
        *lunarDayPointer = lunarDay;
    }
    return true;
}

/**
 公历月份的总天数
 */
+(BOOL) getTotalDaysPointer:(NSInteger * _Nonnull) totalDaysPointer year:(NSInteger) year month:(NSInteger) month{
    BOOL result =  [self ifValidDataWithYear:year month:month day:1];
    if(result == false){
        return result;
    }
    NSInteger suffYears = year - PYCalendarToolsYearMin;
    NSInteger M4 = suffYears % 4;
    NSInteger D4 = suffYears / 4;
    NSInteger days = suffYears * 365 + D4;
    if(year % 4 == 0){
        days -= 1;
    }
    if(M4 == 0){
        NSInteger index = 1;
        for (NSInteger i = 0; i < LunarCalendarMonthLength; i++) {
            NSInteger _days = CalendarLeapYearInfo[i];
            if(index >= labs(month)){
                break;
            }
            days += _days;
            ++index;
        }
    }else{
        NSInteger index = 1;
        for (NSInteger i = 0; i < LunarCalendarMonthLength; i++) {
            NSInteger _days = CalendarNonleapYearInfo[i];
            if(index >= labs(month)){
                break;
            }
            days += _days;
            ++index;
        }
    }
    *totalDaysPointer = days;
    return result;
}
/**
 农历月份的总天数
 */
+(BOOL) getTotalLunarDaysPointer:(NSInteger * ) totalLunarDaysPointer year:(NSInteger) year month:(NSInteger) month{
    BOOL result = [self ifValidLunarDataWithYear:year month:month day:1];
    if(result == false){
        return result;
    }
    NSInteger days = LunarCalendarInfoStart[2];
    for (NSInteger _year = PYCalendarToolsYearMin; _year < year; _year++) {
        days += [self getLunarDaysWithYear:_year];
    }
    
    NSInteger ruiyue = [self getDoubleLunarMonthWithYear:year];
    for (NSInteger _months = 1; _months < labs(month);  _months++) {
        if(ruiyue > 0 && ruiyue == labs(month) - 1){
            days += [self getDoubleLunarMonthDaysWithYear:year]; //self.doubleLunarMonthDays(year: year)
        }else if(month < -1 && labs(month) == ruiyue){
            break;
        }
        days += [self getLunarMonthDaysWithYear:year month:_months]; //self.lunarMonthDays(year: year, month: _months)
    }
    *totalLunarDaysPointer = days;
    return result;
}

/**
 返回农历年名称
 */
+(NSString * _Nonnull) getLunarYearNameWithYear:(NSInteger) year{
    NSInteger suffixYear = year - 1864;
    return [NSString stringWithFormat:@"%@%@",[NSString stringWithUTF8String:LunarCalendarTiangan[suffixYear % LunarCalendarTianganLength]], [NSString stringWithUTF8String:LunarCalendarDizhi[suffixYear % LunarCalendarDizhiLength]]];
}
/**
 返回农历年闰月 0b*[4.]0000
 */
+(NSInteger) getDoubleLunarMonthWithYear:(NSInteger) year{
    return (LunarCalendarInfo[year - PYCalendarToolsYearMin] & 0xf);
}
/**
 返回农历年闰月的天数 0b[1.][12.][4.]0
 */
+(NSInteger) getDoubleLunarMonthDaysWithYear:(NSInteger) year{
    if([self getDoubleLunarMonthWithYear:year] != 0){
        return (((LunarCalendarInfo[year - PYCalendarToolsYearMin] & 0x10000) != 0) ? 30 : 29);
    } else {
        return 0;
    }
}

/**
 返回农历年月份的总天数0b*[12.][4.] 011011010010
 */
+(NSInteger) getLunarMonthDaysWithYear:(NSInteger) year month:(NSInteger) month{
    return (((LunarCalendarInfo[year - PYCalendarToolsYearMin] & (0x10000 >> labs(month))) != 0) ? 30 : 29);
}

/**
 返回农历年总天数
 */
+(NSInteger) getLunarDaysWithYear:(NSInteger) year{
    NSInteger i = 0x8000;
    NSInteger sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1){
        if ((LunarCalendarInfo[year - PYCalendarToolsYearMin] & i) != 0){
            sum += 1;
        }
    }
    return (sum + [self getDoubleLunarMonthDaysWithYear:year]);
}


+(BOOL) ifValidLunarDataWithYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day{
    if(year > PYCalendarToolsYearMax){
        return false;
    }
    if(year < PYCalendarToolsYearMin){
        return false;
    }
    if(month < 1){
        return false;
    }
    if(month > 13){
        return false;
    }
    
    if([self getDoubleLunarMonthWithYear:year] == 0 && month > 12){
        return false;
    }
    if(day < 1){
        return false;
    }
    if(day > 29 && [self getLunarMonthDaysWithYear:year month:month] < day){
        return false;
    }
    return true;
}
+(BOOL) ifValidDataWithYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day{
    if(year > PYCalendarToolsYearMax){
        return false;
    }
    if(year < PYCalendarToolsYearMin){
        return false;
    }
    if(month < 1){
        return false;
    }
    if(month > 12){
        return false;
    }
    if(day < 1){
        return false;
    }
    if(year % 4 == 0 && (CalendarLeapYearInfo[month - 1] < day)){
        return false;
    }else if(CalendarNonleapYearInfo[month - 1] < day){
        return false;
    }
    return true;
}

@end
