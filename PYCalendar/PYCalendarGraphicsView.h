//
//  PYCalenderView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarParams.h"

@interface PYCalendarGraphicsView : UIView

@property (nonatomic, strong) UIView * _Nullable viewSelected;
@property (nonatomic, strong) UIView * _Nullable viewAlert;

/**
 日期显示的方式
 NSCalendarUnitYear，NSCalendarUnitMonth，NSCalendarUnitDay
 */
@property (nonatomic) NSCalendarUnit calendarShowType;
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

@property (nonatomic, strong) void (^ _Nullable blockSelectedDate) (PYCalendarGraphicsView * _Nonnull graphicsView, NSDate * _Nonnull dateSelected);

@property (nonatomic, strong) void (^ _Nullable blockSelectedDates) (PYCalendarGraphicsView * _Nonnull graphicsView, NSArray<NSDate *> * _Nonnull dateSelecteds);

-(void) setAttributes:(NSDictionary<NSString *, id> * _Nonnull) attributes;
-(void) setAttributeWithKey:(NSString * _Nonnull) key value:(id _Nonnull) value;
-(id _Nullable) getAttributeValueWithKey:(NSString * _Nonnull) key;

-(void) reloadData;
@end
