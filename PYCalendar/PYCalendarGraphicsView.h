//
//  PYCalenderView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarParams.h"

@class PYCalendarGraphicsView;



@protocol PYCalendarGraphicsProtocol <NSObject>
@optional
//==>日期单选和多选
-(void) dateSelcted:(NSDate * _Nullable) date calendar:(PYCalendarGraphicsView * _Nonnull) calendar;
-(void) dateSelcteds:(NSArray<NSDate *> * _Nullable) dates calendar:(PYCalendarGraphicsView * _Nonnull) calendar;
//<==
-(void) touchForce:(CGFloat) force calendar:(PYCalendarGraphicsView * _Nonnull) calendar;
-(BOOL) touchForce1WithCalendar:(PYCalendarGraphicsView * _Nonnull) calendar;
-(BOOL) touchForce2WithCalendar:(PYCalendarGraphicsView * _Nonnull) calendar;
@end


@interface PYCalendarGraphicsView : UIView

@property (nonatomic, strong) UIView * _Nullable viewSelected;

@property (nonatomic, assign) id<PYCalendarGraphicsProtocol> _Nullable delegate;
/**
 日期显示的方式
 NSCalendarUnitYear，NSCalendarUnitMonth，NSCalendarUnitDay
 */
@property (nonatomic) NSCalendarUnit calendarShowType;
/**
 显示的日期
 */
@property (nonatomic, strong) NSDate * _Nullable dateShow;
/**
 选择的日期
 */
@property (nonatomic, strong) NSDate * _Nullable dateSelected;
/**
 选择的日期
 */
@property (nonatomic, strong) NSArray<NSDate*> * _Nullable dateSelecteds;

@property (nonatomic) NSDate * _Nullable dateMin;
@property (nonatomic) NSDate * _Nullable dateMax;

-(void) setAttributes:(NSDictionary<NSString *, id> * _Nonnull) attributes;
-(void) setAttributeWithKey:(nonnull NSString *) key value:(id _Nonnull) value;
-(id _Nullable) getAttributeValueWithKey:(nonnull NSString *) key;

-(void) reloadData;
@end
