//
//  PYCalendarTouchTools.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarTouchTools.h"
#import "PYCalendarGraphicsTools.h"
#import "PYCalendarTools.h"
#import <Utile/NSDate+Expand.h>
#import <Utile/EXTScope.h>
@interface PYCalendarTouchTools()

@property (nonatomic) id synTouchData;
@property (nonatomic) BOOL flagForceTouch1;
@property (nonatomic) BOOL flagForceTouch2;
@end

@implementation PYCalendarTouchTools
-(instancetype) init{
    if (self = [super init]) {
        self.synTouchData = [NSObject new];
        self.touchLongTime = .5;
        self.touchForce1 = 2.0;
        self.touchForce2 = 4.0;
        [self clearData];
    }
    return self;
}

-(BOOL) checkToucheBegan:(nonnull UITouch *) touch touchData:(nullable PYCalendarTouchData *) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(nonnull NSDate *) dateShow{
    
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    
    [self clearData];
    
    *touchDataPointer = PYCalendarTouchDataNull();
    
    if (IOS9_OR_LATER) {
        (*touchDataPointer).force.curForce = touch.force;
        (*touchDataPointer).force.maxForce = touch.force;
        (*touchDataPointer).force.maximumPossibleForce = touch.maximumPossibleForce;
    }
    (*touchDataPointer).touchBegin = [touch locationInView:touch.view];
    if (![self.class isEnableTouchWithPoint:(*touchDataPointer).touchBegin pointScan1:pointScan1 pointScan2:pointScan2]) {
        return false;
    }
    
    (*touchDataPointer).status = PYCalendarTouchBegin;
    
    [self.class toucheGetXIndexPointer:&((*touchDataPointer).pointBegin.x) yIndexPointer:&(*touchDataPointer).pointBegin.y touchPoint:(*touchDataPointer).touchBegin sizeScan:CGSizeMake(pointScan2.x, pointScan2.y) dateShow:dateShow];
    
    @synchronized(self) {
        self.flagForceTouch1 = false;
        self.flagForceTouch2 = false;
    }
    
    return true;
}

-(BOOL) checkTouching:(nonnull UITouch *) touch touchData:(nullable PYCalendarTouchData *) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(nonnull NSDate *) dateShow{
    
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    
    if ((*touchDataPointer).status == PYCalendarTouchUnknow || (*touchDataPointer).status == PYCalendarTouchEnd) {
        return false;
    }
    
    if (IOS9_OR_LATER) {
        (*touchDataPointer).force.curForce = touch.force;
        (*touchDataPointer).force.maxForce = MAX((*touchDataPointer).force.maxForce, touch.force);
    }
    
    (*touchDataPointer).touchEnd = [touch locationInView:touch.view];
    
    if (![self.class isEnableTouchWithPoint:(*touchDataPointer).touchBegin pointScan1:pointScan1 pointScan2:pointScan2]) {
        return false;
    }
    
    NSInteger xIndex;
    NSInteger yIndex;
    [self.class toucheGetXIndexPointer:&xIndex yIndexPointer:&yIndex touchPoint:(*touchDataPointer).touchEnd sizeScan:CGSizeMake(pointScan2.x, pointScan2.y) dateShow:dateShow];
    (*touchDataPointer).pointEnd = PYPointMake(xIndex, yIndex);
    
    (*touchDataPointer).status = PYCalendarTouchMove;
    
    [self synsetTouchData:(*touchDataPointer)];
    
    return true;
}

-(BOOL) checkToucheEnd:(nonnull UITouch *) touch touchData:(nullable PYCalendarTouchData *) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(nonnull NSDate *) dateShow{
    
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    if ((*touchDataPointer).status == PYCalendarTouchUnknow) {
        return false;
    }
    
    if (![self.class isEnableTouchWithPoint:(*touchDataPointer).touchBegin pointScan1:pointScan1 pointScan2:pointScan2]) {
        return false;
    }
    
    (*touchDataPointer).touchEnd = [touch locationInView:touch.view];
    NSInteger xIndex;
    NSInteger yIndex;
    [self.class toucheGetXIndexPointer:&xIndex yIndexPointer:&yIndex touchPoint:(*touchDataPointer).touchEnd sizeScan:CGSizeMake(pointScan2.x, pointScan2.y) dateShow:dateShow];
    (*touchDataPointer).pointEnd = PYPointMake(xIndex, yIndex);
    if (IOS9_OR_LATER) {
        (*touchDataPointer).force.curForce = touch.force;
        (*touchDataPointer).force.maxForce = MAX((*touchDataPointer).force.maxForce, touch.force);
    }
    (*touchDataPointer).status = PYCalendarTouchEnd;
    
    return true;
}

-(void) startLongTouchWithBlockLongTouch:(void (^_Nullable) (void)) blockLongTouch{
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        NSUInteger longTime = self.touchLongTime / 0.05;
        NSInteger index = 0;
        while (self.touchData.status != PYCalendarTouchEnd && self.touchData.status != PYCalendarTouchUnknow && index < longTime) {
            [NSThread sleepForTimeInterval:0.05];
            index ++;
        }
        
        PYCalendarTouchData touchData = self.touchData;
        if (touchData.force.maxForce > self.touchForce2) {
            touchData.type = PYCalendarTouchFore2;
        }else if (touchData.force.maxForce > self.touchForce1) {
            touchData.type = PYCalendarTouchFore1;
        }else if (index >= longTime && ![PYCalendarTouchTools isTouchMoveWithTouchData:&_touchData]) {
            touchData.type = PYCalendarTouchLong;
        }else if(index < longTime &&![PYCalendarTouchTools isTouchMoveWithTouchData:&_touchData]){
            touchData.type = PYCalendarTouchNormal;
        }else{
            touchData.type = PYCalendarTouchInValid;
        }
        
        @synchronized(self.synTouchData) {
            [self synsetTouchData:touchData];
            if (self.touchData.type == PYCalendarTouchLong && blockLongTouch) {
                blockLongTouch();
            }
        }
    });
}
-(void) synsetTouchData:(PYCalendarTouchData)touchData{
    @synchronized(self.synTouchData) {
        _touchData = touchData;
    }
}
-(void) clearData{
    [self synsetTouchData:PYCalendarTouchDataNull()];
    self.flagForceTouch1 = false;
    self.flagForceTouch2 = false;
}

-(BOOL) isForeTouch:(nullable PYCalendarTouchData *) touchDataPointer{
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    if ((*touchDataPointer).status == PYCalendarTouchBegin) {
        return false;
    }
    if ((*touchDataPointer).type == PYCalendarTouchLong) {
        return false;
    }
    if ((*touchDataPointer).force.maxForce < self.touchForce1) {
        return false;
    }
    return true;
}

-(BOOL) isForeTouch1:(nullable PYCalendarTouchData *) touchDataPointer{
    
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    if ((*touchDataPointer).type == PYCalendarTouchLong) {
        return false;
    }
    if ((*touchDataPointer).force.maxForce < self.touchForce1 || (*touchDataPointer).force.maxForce > self.touchForce2) {
        if (self.flagForceTouch1) {
            return false;
        }
    }
    if (self.flagForceTouch1) {
        return false;
    }
    @synchronized(self) {
        self.flagForceTouch1 = true;
    }
    return true;
}

-(BOOL) isForeTouch2:(nullable PYCalendarTouchData *) touchDataPointer{
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    if ((*touchDataPointer).type == PYCalendarTouchLong) {
        return false;
    }
    if ((*touchDataPointer).force.maxForce < self.touchForce2) {
        return false;
    }
    if (self.flagForceTouch2) {
        return false;
    }
    @synchronized(self) {
        self.flagForceTouch2 = true;
    }
    return true;
}

-(BOOL) isLongTouch:(nullable PYCalendarTouchData *) touchDataPointer{
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    if ((*touchDataPointer).force.maxForce >= self.touchForce1) {
        return false;
    }
    if ((*touchDataPointer).type != PYCalendarTouchLong) {
        return false;
    }
    return true;
}

-(BOOL) isNormalTouch:(nullable PYCalendarTouchData *) touchDataPointer{
    if (touchDataPointer == nil) {
        touchDataPointer = &_touchData;
    }
    if ((*touchDataPointer).force.maxForce >= self.touchForce1) {
        return false;
    }
    if ((*touchDataPointer).type != PYCalendarTouchNormal && (*touchDataPointer).type != PYCalendarTouchInValid) {
        return false;
    }
    if ([PYCalendarTouchTools isTouchMoveWithTouchData:touchDataPointer]) {
        return false;
    }
    return true;
}
/**
 检查有效的Point
 */
+(void) checkEnablePoint:(nonnull PYPoint *) pointPointer date:(nullable NSDate *) date dateShow:(nonnull NSDate *) dateShow{
    
    NSInteger perNumDays;
    NSInteger curNumDays;
    NSInteger nextNumDays;
    [PYCalendarTools getCalendarInfoWithPerNumDaysPointer:&perNumDays curNumDaysPointer:&curNumDays nextNumDaysPointer:&nextNumDays date:dateShow];
    NSDate * begin = [[dateShow setCompentsWithBinary:0b110000] offsetDay:(int)-perNumDays];
    NSDate * end = [begin offsetDay:(int)(perNumDays + curNumDays + nextNumDays + 1)];
    
    if (begin.timeIntervalSince1970 > date.timeIntervalSince1970) {
        *pointPointer = PYPointMake(-1,-1);
        return;
    }
    
    if (end.timeIntervalSince1970 < date.timeIntervalSince1970) {
        *pointPointer = PYPointMake(7,7);
        return;
    }
    
    NSInteger numDays = (date.timeIntervalSince1970 - begin.timeIntervalSince1970) / (3600 * 24);
    *pointPointer = PYPointMake(numDays % 7, numDays / 7);
}
/**
 是否触摸移动
 */
+(BOOL) isTouchMoveWithTouchData:(nonnull PYCalendarTouchData *) touchDataPointer{
    if ((*touchDataPointer).touchBegin.x == -1
        || (*touchDataPointer).touchBegin.y == -1
        || (*touchDataPointer).touchEnd.x == -1
        || (*touchDataPointer).touchEnd.y == -1) {
        return false;
    }
    if (ABS((*touchDataPointer).touchBegin.x - (*touchDataPointer).touchEnd.x) < 2 && ABS((*touchDataPointer).touchBegin.y - (*touchDataPointer).touchEnd.y) < 2) {
        return false;
    }
    return true;
}

+(void) toucheGetXIndexPointer:(nonnull NSInteger *) xIndexPointer yIndexPointer:(nonnull NSInteger *) yIndexPointer touchPoint:(CGPoint) touchPoint sizeScan:(CGSize) sizeScan dateShow:(nonnull NSDate *) dateShow{
    CGFloat weekEndInfoHeight = 0;
    NSUInteger numWeekends = 0;
    CGFloat dayInfoHeight= 0;
    
    if (![PYCalendarGraphicsTools getDateValueWithHeight:sizeScan.height date:dateShow weekEndInfoHeightPointer:&weekEndInfoHeight numWeekendsPointer:&numWeekends dayInfoHeightPointer:&dayInfoHeight]) {
        return;
    }
    if (touchPoint.y <= weekEndInfoHeight) {
        return;
    }
    *xIndexPointer = touchPoint.x / (sizeScan.width / 7);
    *yIndexPointer = (touchPoint.y - weekEndInfoHeight) / dayInfoHeight;
}

+(BOOL) isNewTouchPointer:(nonnull PYCalendarTouchData *) touchDataPointer{
    
    if ((*touchDataPointer).pointBegin.x == -1 || (*touchDataPointer).pointBegin.y == -1 || (*touchDataPointer).pointEnd.x == -1 || (*touchDataPointer).pointEnd.y == -1) {
        return true;
    }
    return false;
}
+(BOOL) isEnableTouchWithPoint:(CGPoint) point pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2{
    
    if (point.x < pointScan1.x || point.x > pointScan2.x) {
        return false;
    }
    
    if (point.y < pointScan1.y || point.y > pointScan2.y) {
        return false;
    }
    
    return true;
}
@end
