//
//  PYCalendarTouchTools.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarTouchTools.h"
#import "PYCalendarGraphicsTools.h"
#import <Utile/EXTScope.h>
@interface PYCalendarTouchTools()

@property (nonatomic) id synTouchData;
@end

@implementation PYCalendarTouchTools
-(instancetype) init{
    if (self = [super init]) {
        self.synTouchData = [NSObject new];
        self.touchLongTime = .5;
        self.touchForce = 3.;
        [self clearData];
    }
    return self;
}

-(BOOL) checkToucheBegan:(UITouch * _Nonnull) touch touchData:(PYCanlendarTouchData * _Nonnull) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(NSDate * _Nonnull) dateShow;{
    [self clearData];
    *touchDataPointer = PYCanlendarTouchDataNull();
    (*touchDataPointer).isBegin = true;
    if (IOS9_OR_LATER) {
        (*touchDataPointer).currentForce = touch.force;
        (*touchDataPointer).force = touch.force;
        (*touchDataPointer).maxForce = touch.maximumPossibleForce;
    }
    (*touchDataPointer).touchBegin = [touch locationInView:touch.view];
    if (![self.class isEnableTouchWithPoint:(*touchDataPointer).touchBegin pointScan1:pointScan1 pointScan2:pointScan2]) {
        return false;
    }
    
    (*touchDataPointer).isBegin = true;
    
    [self.class toucheGetXIndexPointer:&((*touchDataPointer).pointBegin.x) yIndexPointer:&(*touchDataPointer).pointBegin.y touchPoint:(*touchDataPointer).touchBegin sizeScan:CGSizeMake(pointScan2.x, pointScan2.y) dateShow:dateShow];
    
    return true;
}

-(BOOL) checkToucheMoved:(UITouch * _Nonnull) touch touchData:(PYCanlendarTouchData * _Nonnull) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(NSDate * _Nonnull) dateShow{

    if (!(*touchDataPointer).isBegin) {
        return false;
    }
    
    if (IOS9_OR_LATER) {
        (*touchDataPointer).currentForce = touch.force;
        (*touchDataPointer).force = MAX((*touchDataPointer).force, touch.force);
    }
    
    (*touchDataPointer).touchEnd = [touch locationInView:touch.view];
    
    if (ABS((*touchDataPointer).touchBegin.x - (*touchDataPointer).touchEnd.x) <= 1 && ABS((*touchDataPointer).touchBegin.y - (*touchDataPointer).touchEnd.y) <= 1) {
        return false;
    }
    
    if (![self.class isEnableTouchWithPoint:(*touchDataPointer).touchBegin pointScan1:pointScan1 pointScan2:pointScan2]) {
        return false;
    }
    
    NSInteger xIndex;
    NSInteger yIndex;
    [self.class toucheGetXIndexPointer:&xIndex yIndexPointer:&yIndex touchPoint:(*touchDataPointer).touchEnd sizeScan:CGSizeMake(pointScan2.x, pointScan2.y) dateShow:dateShow];
    if (xIndex == self.touchData.pointEnd.x && yIndex == self.touchData.pointEnd.y) {
        return false;
    }
    (*touchDataPointer).pointEnd = PYPointMake(xIndex, yIndex);
    
    if (((*touchDataPointer).pointEnd.x == (*touchDataPointer).pointBegin.x && (*touchDataPointer).pointEnd.y == (*touchDataPointer).pointBegin.y)) {
        return false;
    }
    
    (*touchDataPointer).isMove = true;
    
    [self synsetTouchData:(*touchDataPointer)];
    
    return true;
}

-(BOOL) checkToucheEnd:(UITouch * _Nonnull) touch touchData:(PYCanlendarTouchData * _Nonnull) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(NSDate * _Nonnull) dateShow{
    
    if (!(*touchDataPointer).isBegin) {
        return false;
    }
    
    if (![self.class isEnableTouchWithPoint:(*touchDataPointer).touchBegin pointScan1:pointScan1 pointScan2:pointScan2]) {
        return false;
    }
    
    NSInteger xIndex;
    NSInteger yIndex;
    [self.class toucheGetXIndexPointer:&xIndex yIndexPointer:&yIndex touchPoint:(*touchDataPointer).touchEnd sizeScan:CGSizeMake(pointScan2.x, pointScan2.y) dateShow:dateShow];
    (*touchDataPointer).pointEnd = PYPointMake(xIndex, yIndex);
    (*touchDataPointer).touchEnd = [touch locationInView:touch.view];
    if (IOS9_OR_LATER) {
        (*touchDataPointer).currentForce = touch.force;
        (*touchDataPointer).force = MAX((*touchDataPointer).force, touch.force);
    }
    (*touchDataPointer).isEnd = true;
    
    return true;
}


-(void) startLongTouchWithBlockLongTouch:(void (^_Nullable) (void)) blockLongTouch{
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        
        NSUInteger longTime = self.touchLongTime / 0.05;
        NSInteger index = 0;
        while (self.touchData.isBegin && !self.touchData.isMove && !self.touchData.isEnd && index < longTime) {
            [NSThread sleepForTimeInterval:0.05];
            index ++;
        }
        
        PYCanlendarTouchData touchData = self.touchData;
        if (index >= longTime) {
            touchData.isLongTouch = true;
        }
        
        @synchronized(self.synTouchData) {
            [self synsetTouchData:touchData];
            if (self.touchData.isLongTouch && blockLongTouch) {
                blockLongTouch();
            }
        }
    });
}
-(void) synsetTouchData:(PYCanlendarTouchData)touchData{
    @synchronized(self.synTouchData) {
        _touchData = touchData;
    }
}
-(void) clearData{
    [self synsetTouchData:PYCanlendarTouchDataNull()];
}

-(BOOL) isForeTouch:(PYCanlendarTouchData * _Nonnull) touchDataPointer{
    if ((*touchDataPointer).force < self.touchForce) {
        return false;
    }
    return true;
}

-(BOOL) isLongTouch:(PYCanlendarTouchData * _Nonnull) touchDataPointer{
    if (!(*touchDataPointer).isLongTouch) {
        return false;
    }
    if ([self isForeTouch:touchDataPointer]) {
        return false;
    }
    return true;
}

-(BOOL) isNormalTouch:(PYCanlendarTouchData * _Nonnull) touchDataPointer{
    if ((*touchDataPointer).isLongTouch) {
        return false;
    }
    if ([self isForeTouch:touchDataPointer]) {
        return false;
    }
    return true;
}


+(void) toucheGetXIndexPointer:(NSInteger * _Nonnull) xIndexPointer yIndexPointer:(NSInteger * _Nonnull) yIndexPointer touchPoint:(CGPoint) touchPoint sizeScan:(CGSize) sizeScan dateShow:(NSDate * _Nonnull) dateShow{
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

+(BOOL) isNewTouchPointer:(PYCanlendarTouchData * _Nonnull) touchDataPointer{
    if ((*touchDataPointer).pointBegin.x == -1 || (*touchDataPointer).pointBegin.y == -1 || (*touchDataPointer).pointEnd.x == -1 || (*touchDataPointer).pointEnd.y == -1) {
        return true;
    }
    return false;
}
+(BOOL) isEnableTouchWithPoint:(CGPoint) point pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2{
    
    if (point.x < pointScan1.x && point.x > pointScan2.x) {
        return false;
    }
    
    if (point.y < pointScan1.y && point.y > pointScan2.y) {
        return false;
    }
    
    return true;
}
@end
