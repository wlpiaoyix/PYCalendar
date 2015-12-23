//
//  PYCalendarTouchTools.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYCalendarParams.h"


typedef struct _PYCanlendarTouchData {
    PYPoint pointBegin;
    PYPoint pointEnd;
    
    CGPoint touchBegin;
    CGPoint touchEnd;
    
    CGFloat force;
    CGFloat currentForce;
    CGFloat maxForce;
    
    BOOL isBegin;
    BOOL isMove;
    BOOL isEnd;
    BOOL isLongTouch;
    
} PYCanlendarTouchData;

PYUTILE_STATIC_INLINE PYCanlendarTouchData PYCanlendarTouchDataNull(){
    PYPoint p1 = {-1,-1};
    PYPoint p2 = {-1,-1};
    CGPoint p3 = {-1,-1};
    CGPoint p4 = {-1,-1};
    PYCanlendarTouchData date = {p1, p2, p3, p4, -1, -1, -1, false, false, false, false};
    return date;
}

@interface PYCalendarTouchTools : NSObject
@property (nonatomic) CGFloat touchLongTime;
@property (nonatomic) CGFloat touchForce;
@property (nonatomic, readonly) PYCanlendarTouchData touchData;
-(BOOL) checkToucheBegan:(UITouch * _Nonnull) touch touchData:(PYCanlendarTouchData * _Nonnull) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(NSDate * _Nonnull) dateShow;
-(BOOL) checkToucheMoved:(UITouch * _Nonnull) touch touchData:(PYCanlendarTouchData * _Nonnull) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(NSDate * _Nonnull) dateShow;
-(BOOL) checkToucheEnd:(UITouch * _Nonnull) touch touchData:(PYCanlendarTouchData * _Nonnull) touchDataPointer pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2 dateShow:(NSDate * _Nonnull) dateShow;

-(void) startLongTouchWithBlockLongTouch:(void (^_Nullable) (void)) blockLongTouch;
-(void) clearData;
-(void) synsetTouchData:(PYCanlendarTouchData) touchData;

-(BOOL) isForeTouch:(PYCanlendarTouchData * _Nonnull) touchDataPointer;
-(BOOL) isLongTouch:(PYCanlendarTouchData * _Nonnull) touchDataPointer;
-(BOOL) isNormalTouch:(PYCanlendarTouchData * _Nonnull) touchDataPointer;

+(void) toucheGetXIndexPointer:(NSInteger * _Nonnull) xIndexPointer yIndexPointer:(NSInteger * _Nonnull) yIndexPointer touchPoint:(CGPoint) touchPoint sizeScan:(CGSize) sizeScan dateShow:(NSDate * _Nonnull) dateShow;
+(BOOL) isNewTouchPointer:(PYCanlendarTouchData * _Nonnull) touchDataPointer;
+(BOOL) isEnableTouchWithPoint:(CGPoint) point pointScan1:(CGPoint) pointScan1 pointScan2:(CGPoint) pointScan2;

@end
