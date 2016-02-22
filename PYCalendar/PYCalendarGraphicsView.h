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
-(void) dateSelcted:(NSDate * _Nullable) date calendar:(nonnull PYCalendarGraphicsView *) calendar;
-(void) dateSelcteds:(NSArray<NSDate *> * _Nullable) dates calendar:(nonnull PYCalendarGraphicsView *) calendar;
//<==
-(BOOL) touchMoveWithCalendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
-(BOOL) touchLongWithCalendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
-(BOOL) touchUpLongWithCalendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
-(BOOL) touchNormalWithCalendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
//==>Force touch
-(void) touchForce:(CGFloat) force calendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
-(BOOL) touchForce1WithCalendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
-(BOOL) touchForce2WithCalendar:(nonnull PYCalendarGraphicsView *) calendar touchData:(PYCalendarTouchData) touchData;
//==>
@end


@interface PYCalendarGraphicsView : UIView

@property (nonatomic, readonly) CGSize sizeDayText;

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

-(void) setAttributes:(nonnull NSDictionary<NSString *, id> *) attributes;
-(void) setAttributeWithKey:(nonnull NSString *) key value:(nonnull id) value;
-(nonnull id) getAttributeValueWithKey:(nonnull NSString *) key;
/**
 所有的数据必须要在reloadData之后才会更新到UI层
 */
-(void) reloadData;
@end
