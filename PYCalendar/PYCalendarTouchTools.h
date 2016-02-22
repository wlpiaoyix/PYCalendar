//
//  PYCalendarTouchTools.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYCalendarParams.h"


@interface PYCalendarTouchTools : NSObject
@property (nonatomic) CGFloat touchLongTime;
@property (nonatomic) CGFloat touchForce1;
@property (nonatomic) CGFloat touchForce2;
@property (nonatomic, readonly) PYCalendarTouchData touchData;
-(BOOL) checkToucheBegan:(nonnull UITouch *) touch touchData:(nullable PYCalendarTouchData *) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(nonnull NSDate *) dateShow;
-(BOOL) checkTouching:(nonnull UITouch *) touch touchData:(nullable PYCalendarTouchData *) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(nonnull NSDate *) dateShow;
-(BOOL) checkToucheEnd:(nonnull UITouch *) touch touchData:(nullable PYCalendarTouchData *) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(nonnull NSDate *) dateShow;

-(void) startLongTouchWithBlockLongTouch:(void (^_Nullable) (void)) blockLongTouch;
-(void) clearData;
-(void) synsetTouchData:(PYCalendarTouchData) touchData;

-(BOOL) isForeTouch:(nullable PYCalendarTouchData *) touchDataPointer;
-(BOOL) isForeTouch1:(nullable PYCalendarTouchData *) touchDataPointer;
-(BOOL) isForeTouch2:(nullable PYCalendarTouchData *) touchDataPointer;
-(BOOL) isLongTouch:(nullable PYCalendarTouchData *) touchDataPointer;
-(BOOL) isNormalTouch:(nullable PYCalendarTouchData *) touchDataPointer;

/**
 检查有效的Point
 */
+(void) checkEnablePoint:(nonnull PYPoint *) pointPointer date:(nullable NSDate *) date dateShow:(nonnull NSDate *) dateShow;
/**
 是否触摸移动
 */
+(BOOL) isTouchMoveWithTouchData:(nonnull PYCalendarTouchData *) touchDataPointer;
+(void) toucheGetXIndexPointer:(nonnull NSInteger *) xIndexPointer yIndexPointer:(nonnull NSInteger *) yIndexPointer touchPoint:(CGPoint) touchPoint sizeScan:(CGSize) sizeScan dateShow:(nonnull NSDate *) dateShow;
+(BOOL) isNewTouchPointer:(nonnull PYCalendarTouchData *) touchDataPointer;
+(BOOL) isEnableTouchWithPoint:(CGPoint) point pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2;

@end
