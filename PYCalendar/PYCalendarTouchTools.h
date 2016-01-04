//
//  PYCalendarTouchTools.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYCalendarParams.h"


typedef struct _PYForce {
    CGFloat curForce,maxForce,maximumPossibleForce;
} PYForce;

PYUTILE_STATIC_INLINE PYForce PYForceNull(){
    PYForce force = { -1, -1, -1};
    return force;
}


typedef enum : NSInteger{
    PYCalendarTouchUnknow = -1,
    PYCalendarTouchBegin = 0,
    PYCalendarTouchMove = 1,
    PYCalendarTouchEnd = 2
} PYCalendarTouchStatus;

typedef enum : NSInteger{
    PYCalendarTouchInValid = -1,
    PYCalendarTouchNormal = 0,
    PYCalendarTouchLong = 1,
    PYCalendarTouchFore1 = 2,
    PYCalendarTouchFore2 = 3
} PYCalendarTouchType;

typedef struct _PYCalendarTouchData {
    PYPoint pointBegin;
    PYPoint pointEnd;
    
    CGPoint touchBegin;
    CGPoint touchEnd;
    
    PYForce force;
    
    PYCalendarTouchStatus status;
    PYCalendarTouchType type;
    
} PYCalendarTouchData;

PYUTILE_STATIC_INLINE PYCalendarTouchData PYCalendarTouchDataNull(){
    PYPoint p1 = {-1,-1};
    PYPoint p2 = {-1,-1};
    CGPoint p3 = {-1,-1};
    CGPoint p4 = {-1,-1};
    PYForce force = PYForceNull();
    PYCalendarTouchData date = {p1, p2, p3, p4, force, PYCalendarTouchUnknow, PYCalendarTouchInValid};
    return date;
}

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
