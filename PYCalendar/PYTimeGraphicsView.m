//
//  PYTimeGraphicsView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 16/7/10.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYTimeGraphicsView.h"
#import <Utile/UIView+Expand.h>
#import <Utile/PYGraphicsDraw.h>
#import <Utile/PYGraphicsThumb.h>
#import <Utile/EXTScope.h>
#import <Utile/PYUtile.h>


@implementation PYTimeGraphicsView{
@private
    PYGraphicsThumb *gtTime;
    PYGraphicsThumb *gtPoint;
    PYGraphicsThumb *gtNum;
}
//+(PYTime) parsePointToTime:(CGPoint) point centerPoint:(CGPoint) centerPoint{
//    PYTime  time = PYTimeMake(0, 0, 0);
//    if (point.x < centerPoint.x) {
//        if (point.y < centerPoint.y) {
//            time.hour = sin(<#double#>)
//        }else{
//        
//        }
//    }else{
//    
//    }
//    return time;
//}
+(void) drawClickWithLineB:(CGFloat)  lineB circelB:(CGFloat) circelB size:(CGSize) size blockDraw:(void (^)(CGPoint center, CGFloat strokeWidth, NSUInteger index)) blockDraw{
    
    CGFloat radius = MIN(size.width, size.height) / 2;
    CGFloat offx = size.width > size.height ? (size.width - size.height) / 2 : 0;
    CGFloat offy = size.width < size.height ? (size.height - size.width) / 2 : 0;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat vx = 0;
    CGFloat vy = 0;
    for (NSUInteger num = 0; num < 60; num ++) {
        if (num < 15) {
            
            vx = sin(parseDegreesToRadians(((CGFloat)num) / 15 * 90));
            vy = cos(parseDegreesToRadians(((CGFloat)num) / 15 * 90));
            
            x = ( vx + 1) * radius;
            y = (1 - vy) * radius;
            
            x -= lineB * vx;
            x -= circelB * vx;
            
            y += lineB * vy;
            y += circelB * vy;
            
        }else if(num >= 15 && num < 30){
            vx = cos(parseDegreesToRadians(((CGFloat)num - 15) / 15 * 90));
            vy = sin(parseDegreesToRadians(((CGFloat)num - 15) / 15 * 90));
            
            x = (1 + vx) * radius;
            y = (1 + vy) * radius;
            
            x -= lineB * vx;
            x -= circelB * vx;
            
            y -= lineB * vy;
            y -= circelB * vy;
            
        }else if(num >= 30 && num < 45){
            
            vx =  sin(parseDegreesToRadians(((CGFloat)num - 30) / 15 * 90));
            vy = cos(parseDegreesToRadians(((CGFloat)num - 30) / 15 * 90));
            
            x = (1 - vx) * radius;
            y = (1 + vy) * radius;
            
            x += lineB * vx;
            x += circelB * vx;
            
            y -= lineB * vy;
            y -= circelB * vy;
            
        }else{
            
            vx = cos(parseDegreesToRadians(((CGFloat)num - 45) / 15 * 90));
            vy = sin(parseDegreesToRadians(((CGFloat)num - 45) / 15 * 90));
            
            x = (1 - vx) * radius;
            y = (1 - vy) * radius;
            
            x += lineB * vx;
            x += circelB * vx;
            
            y += lineB * vy;
            y += circelB * vy;
        }
        x += offx;
        x += offy;
        blockDraw(CGPointMake(x, y), lineB * 2, num);
    }
}
-(void) initWithParam{
    self.strokeWith = 10;
    @unsafeify(self);
    gtPoint = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        CGPoint centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [PYGraphicsDraw drawLineWithContext:ctx startPoint:centerPoint endPoint:centerPoint strokeColor:[UIColor orangeColor].CGColor strokeWidth:4 lengthPointer:nil length:0];
        
        @strongify(self);
        [PYTimeGraphicsView drawClickWithLineB:1 circelB:10 size:self.frame.size blockDraw:^(CGPoint center, CGFloat strokeWidth, NSUInteger index) {
            if(index % 5 != 0){
                [PYGraphicsDraw drawLineWithContext:ctx startPoint:center endPoint:center strokeColor:[UIColor blackColor].CGColor strokeWidth:strokeWidth lengthPointer:nil length:0];
            }
        }];
    }];
    gtNum = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [PYGraphicsDraw drawTextWithContext:ctx attribute:[[NSMutableAttributedString alloc] init] rect:self.bounds y:self.bounds.size.height scaleFlag:YES];
        [PYTimeGraphicsView drawClickWithLineB:1 circelB:10 size:self.frame.size blockDraw:^(CGPoint center, CGFloat strokeWidth, NSUInteger index) {
            if(index % 5 == 0){
                int value = (int)index/5;
                value = value == 0 ? 12 : value;
                UIFont * font = [UIFont systemFontOfSize:12];
                NSMutableAttributedString * valueArg = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",value] attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:font}];
                CGSize size = [PYUtile getBoundSizeWithAttributeTxt:valueArg size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
                CGPoint  p = CGPointMake(center.x - size.width/2, center.y - size.height/2);
                CGRect r = CGRectMake(p.x, p.y, size.width, size.height);
                [PYGraphicsDraw drawTextWithContext:ctx attribute:valueArg rect:r y:self.bounds.size.height scaleFlag:NO];
            }
        }];
    }];
    
    gtTime = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        CGSize size = self.frame.size;
        CGPoint centerPoint = CGPointMake(size.width / 2, size.height / 2);
        CGFloat radius = MIN(size.width, size.height) / 2 - self.strokeWith / 2 - 20;
        CGFloat value = self.time.hour % 12;
        if (value < 3) {
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:-90 endDegree:-90 + (value / 3 + ((CGFloat)self.time.minute) / (60 * 3))  * 90];
            return;
        }else{
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:-90 endDegree:0];
        }
        if (value < 6) {
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:0 endDegree:((value - 3) / 3 + ((CGFloat)self.time.minute) / (60 * 3))  * 90];
            return;
        }else{
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:0 endDegree:90];
        }
        if (value < 9) {
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:90 endDegree:((value - 6) / 3 + ((CGFloat)self.time.minute) / (60 * 3))  * 90 + 90];
            return;
        }else{
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:90 endDegree:180];
        }
        if (value < 12 && value >= 9) {
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:180 endDegree:((value - 9) / 3 + ((CGFloat)self.time.minute) / (60 * 3))  * 90 + 180];
            return;
        }else{
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:centerPoint radius:radius strokeColor:self.strokeColor ? self.strokeColor.CGColor : [UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:self.strokeWith startDegree:180 endDegree:270];
        }
        
    }];
}
-(instancetype) init{
    if (self = [super init]) {
        [self initWithParam];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initWithParam];
    }
    return self;
}
-(void) setTime:(PYTime)time{
    _time = time;
    [gtTime executDisplay:nil];
}
-(void) refreshClock{
    [gtPoint executDisplay:nil];
    [gtNum executDisplay:nil];
}



@end
