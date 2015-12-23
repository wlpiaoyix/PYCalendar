//
//  PYCalendarView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/1.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYCalendarView : UIView
@property (nonatomic) BOOL hasSound;
/**
 显示的日期
 */
@property (nonatomic, strong) NSDate * _Nonnull dateShow;
/**
 选择的日期
 */
@property (nonatomic, strong) NSDate * _Nonnull dateSelected;
/**
 选择的日期
 */
@property (nonatomic, strong) NSArray<NSDate*> * _Nullable dateSelecteds;

@property (nonatomic, strong) NSDate * _Nonnull dateMin;
@property (nonatomic, strong) NSDate * _Nonnull dateMax;

@property (nonatomic, strong) void (^ _Nullable blockSelectedDate) (PYCalendarView * _Nonnull calendarView, NSDate * _Nonnull dateSelected);

@property (nonatomic, strong) void (^ _Nullable blockSelectedDates) (PYCalendarView * _Nonnull calendarView, NSArray<NSDate *> * _Nonnull dateSelecteds);

@end
