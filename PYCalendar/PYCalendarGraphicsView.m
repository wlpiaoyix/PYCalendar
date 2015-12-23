//
//  PYCalenderView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarGraphicsView.h"
#import "PYCalendarTools.h"
#import "PYCalendarGraphicsTools.h"
#import "PYCalendarTouchTools.h"
#import "NSDate+Lunar.h"
#import "UIImage+ImageEffects.h"
//#import <Utile/UIView+Expand.h>
#import <Utile/UIView+Expand.h>
#import <Utile/EXTScope.h>
#import <Utile/PYGraphicsThumb.h>
#import <Utile/PYGraphicsDraw.h>
#import <Utile/NSDate+Expand.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

PYDate PYCalendarDateMax;
PYDate PYCalendarDateMin;


@interface PYCalendarSelectedView : UIView

@property (nonatomic) int index;

@end

@interface PYCalendarGraphicsView ()

@property (nonatomic, strong) PYCalendarStyleContext *styleContext;

@property (nonatomic, strong) PYGraphicsThumb *gtCalendar;
@property (nonatomic, strong) PYGraphicsThumb *gtStyle;
@property (nonatomic, strong) PYGraphicsThumb *gtPainter;

@property (nonatomic, strong) PYCalendarTouchTools *touchTools;

@property (nonatomic, strong) UIImageView *visualEfView;


@end

@implementation PYCalendarGraphicsView
+(void) initialize{
    PYCalendarDateMax = PYDateMake(2099, 12, 31);
    PYCalendarDateMin = PYDateMake(1901, 1, 1);
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initParams];
    }
    return self;
}
-(instancetype) init{
    if (self = [super init]) {
        [self initParams];
    }
    return self;
}
-(void) initParams{
    self.styleContext = [PYCalendarStyleContext new];
    self.touchTools = [PYCalendarTouchTools new];
    
    self.calendarShowType = NSCalendarUnitMonth;
    self.viewSelected = [PYCalendarSelectedView new];
    self.viewSelected.alpha = 0;
    self.viewSelected.frame = CGRectNull;
    
    self.viewAlert = [PYCalendarSelectedView new];
    self.viewAlert.alpha = 0;
    self.viewAlert.frame = CGRectNull;
    
    [self setAttributes:@{
                          PYCalendarFontDay : [UIFont systemFontOfSize:14],
                          PYCalendarFontLunarDay : [UIFont systemFontOfSize:10],
                          PYCalendarFontWeekEnd : [UIFont boldSystemFontOfSize:12],
                          PYCalendarFontHighlight : [UIFont boldSystemFontOfSize:14],
                          PYCalendarFontLunarHighlight : [UIFont boldSystemFontOfSize:10],
                          
                          PYCalendarColorDay : [UIColor blackColor],
                          PYCalendarColorWeekEnd : [UIColor darkGrayColor],
                          PYCalendarColorLunarDay : [UIColor orangeColor],
                          PYCalendarColorHighlight : [UIColor colorWithRed:1 green:0.4 blue:0.4 alpha:1],
                          PYCalendarColorOutDay : [UIColor darkGrayColor],
                          PYCalendarColorDisable : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3],
                          
                          PYCalendarColorStyleLine : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3],
                          PYCalendarColorPainterLine : [UIColor colorWithRed:0.3 green:0.4 blue:0.8 alpha:0.2]
                          }];
    
    self.dateShow = [NSDate date];
    
    if (self.visualEfView) {
        [self.visualEfView removeFromSuperview];
    }
    self.visualEfView = [UIImageView new];
    [self addSubview:self.visualEfView];
    
    @weakify(self);
    self.gtCalendar = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef ctx, id userInfo) {
        @strongify(self);
        [PYGraphicsDraw drawTextWithContext:ctx attribute:[NSMutableAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:YES];
        [PYCalendarGraphicsTools drawCalendarWithContext:ctx size:self.frameSize dateShow:self.dateShow dateMin:self.dateMin dateMax:self.dateMax styleContext:self.styleContext];
        self.visualEfView.frame = CGRectMake(0, 0, self.frameWidth, self.frameHeight);
    }];
    self.gtStyle = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef ctx, id userInfo) {
        @strongify(self);
        [PYCalendarGraphicsTools drawStyleWithContext:ctx size:self.frameSize dateShow:self.dateShow styleContext:self.styleContext];
    }];
    self.gtPainter = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef ctx, id userInfo) {
        @strongify(self);
        [self drawPainterWithContext:ctx userInfo:userInfo];
    }];
}
-(void) setDateShow:(NSDate *)dateShow{
    PYDate date = PYDateMake(dateShow.year, dateShow.month, dateShow.day);
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMax) == 1) {
        return;
    }
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMin) == -1) {
        return;
    }
    _dateShow = dateShow;
    [self reloadData];
}
-(void) reloadData{
    [self.viewSelected removeFromSuperview];
    [self addSubview:self.viewSelected];
    [self.viewAlert removeFromSuperview];
    [self addSubview:self.viewAlert];
    [self.touchTools clearData];
    [self.gtStyle executDisplay:nil];
    [self.gtCalendar executDisplay:nil];
    self.dateSelecteds = self.dateSelecteds;
    self.dateSelected = self.dateSelected;
}
-(void) setDateSelected:(NSDate *)dateSelected{
    
    PYDate date = PYDateMake(dateSelected.year, dateSelected.month, dateSelected.day);
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMax) == 1) {
        return;
    }
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMin) == -1) {
        return;
    }
    
    PYDate curDate = PYDateMake(dateSelected.year, dateSelected.month, dateSelected.day);
    PYDate maxDate = PYDateMake(self.dateMax.year, self.dateMax.month, self.dateMax.day);
    PYDate minDate = PYDateMake(self.dateMin.year, self.dateMin.month, self.dateMin.day);
    if (![PYCalendarGraphicsTools isEnableDate:&curDate maxDate:&maxDate minDate:&minDate canChangeDate:false]) {
        return;
    }
    _dateSelected = dateSelected;
    BOOL flag = false;
    @try {
        CGFloat weekEndInfoHeight = 0;
        NSUInteger numWeekends = 0;
        CGFloat dayInfoHeight= 0;
        
        if (![PYCalendarGraphicsTools getDateValueWithHeight:self.frameHeight date:self.dateShow weekEndInfoHeightPointer:&weekEndInfoHeight numWeekendsPointer:&numWeekends dayInfoHeightPointer:&dayInfoHeight]) {
            return;
        }
        
        NSInteger perNumDays;
        NSInteger curNumDays;
        NSInteger nextNumDays;
        [PYCalendarTools getCalendarInfoWithPerNumDaysPointer:&perNumDays curNumDaysPointer:&curNumDays nextNumDaysPointer:&nextNumDays date:self.dateShow];
        
        NSInteger xIndex = -1;
        NSInteger yIndex = -1;
        
        if (perNumDays == 0 && dateSelected.year == self.dateShow.year && dateSelected.month == self.dateShow.month) {
            xIndex = (dateSelected.day - 1) % 7;
            yIndex = (dateSelected.day - 1) / 7;
        }else if ((dateSelected.year == self.dateShow.year && dateSelected.month == self.dateShow.month - 1) || (dateSelected.month == 12 && self.dateShow.month == 1 && dateSelected.year == self.dateShow.year - 1)) {
            if (dateSelected.day < dateSelected.numDaysInMonth - perNumDays) {
                return;
            }
            xIndex =  perNumDays - (dateSelected.numDaysInMonth - dateSelected.day) - 1;
            yIndex = 0;
        }else if (dateSelected.year == self.dateShow.year && dateSelected.month == self.dateShow.month){
            xIndex = (dateSelected.day + perNumDays - 1) % 7;
            yIndex = (dateSelected.day + perNumDays - 1) / 7;
        }else if((dateSelected.year == self.dateShow.year && dateSelected.month == self.dateShow.month + 1) || (dateSelected.month ==1 && self.dateShow.month == 12 && dateSelected.year == self.dateShow.year + 1)){
            xIndex = dateSelected.day + (curNumDays + perNumDays - 1) % 7;
            yIndex = (perNumDays + curNumDays + nextNumDays - 1) / 7;
        }
        
        if (xIndex == -1 || yIndex == -1) {
            return;
        }
        
        __block CGRect r = CGRectMake(xIndex * self.frameWidth / 7 , weekEndInfoHeight + dayInfoHeight * yIndex, self.frameWidth / 7, dayInfoHeight);
        [UIView animateWithDuration:0.2 animations:^{
            self.viewSelected.alpha = 0.8;
            self.viewSelected.userInteractionEnabled = NO;
            self.viewSelected.frame = r;
            if ([self.viewSelected isKindOfClass:[PYCalendarSelectedView class]]) {
                ((PYCalendarSelectedView*)self.viewSelected).index = 0;
            }
        }];
        flag = true;
    }
    @finally {
        if (!flag) {
            self.viewSelected.alpha = 0;
            self.viewSelected.userInteractionEnabled = NO;
        }
    }
}
-(void) setDateSelecteds:(NSArray<NSDate *> *)dateSelecteds{
    
    _dateSelecteds = dateSelecteds;
    
    [self.touchTools clearData];
    
    [self.gtPainter executDisplay:nil];
    if (![dateSelecteds count]) {
        return;
    }
    
    PYDate maxDate = PYDateMake(self.dateMax.year, self.dateMax.month, self.dateMax.day);
    PYDate minDate = PYDateMake(self.dateMin.year, self.dateMin.month, self.dateMin.day);
    
    NSDate *start = nil;
    NSDate *end = nil;
    for (NSDate *date in dateSelecteds) {
        if (start == nil) {
            start = date;
        }else{
            end = date;
        }
        if (start && end) {
            
            if ([start timeIntervalSince1970] > [end timeIntervalSince1970]) {
                NSDate *temp = start;
                start = end;
                end = temp;
            }
            PYDate startDate = PYDateMake(start.year, start.month, start.day);
            PYDate endDate = PYDateMake(end.year, end.month, end.day);
            
            BOOL flag = false;
            if(![PYCalendarGraphicsTools isEnableDate:&startDate maxDate:&maxDate minDate:&minDate canChangeDate:true]){
                start = [NSDate dateWithYear:startDate.year month:startDate.month day:startDate.day hour:0 munite:0 second:0];
                flag = true;
            }
            if(![PYCalendarGraphicsTools isEnableDate:&endDate maxDate:&maxDate minDate:&minDate canChangeDate:true]){
                if (flag) {
                    end = start = nil;
                }else{
                    end = [NSDate dateWithYear:endDate.year month:endDate.month day:endDate.day hour:0 munite:0 second:0];
                }
            }
            PYPoint pointBegin = PYPointMake(-1, -1);
            PYPoint pointEnd = PYPointMake(-1, -1);
            
            pointBegin = [PYCalendarTools parsetToPointWithDate:start dateShow:self.dateShow isStart:YES];
            pointEnd = [PYCalendarTools parsetToPointWithDate:end dateShow:self.dateShow isStart:NO];
            
            [self.gtPainter executDisplay:@{@"x1":@(pointBegin.x), @"y1":@(pointBegin.y), @"x2":@(pointEnd.x), @"y2":@(pointEnd.y)}];
            
            start = nil;
            end = nil;
        }
    }
    
}
-(void) drawPainterWithContext:(nonnull CGContextRef) context userInfo:(NSDictionary<NSString *, NSNumber *>*) userInfo{
    CGFloat weekEndInfoHeight = 0;
    NSUInteger numWeekends = 0;
    CGFloat dayInfoHeight= 0;
    
    if (![PYCalendarGraphicsTools getDateValueWithHeight:self.frameHeight date:self.dateShow weekEndInfoHeightPointer:&weekEndInfoHeight numWeekendsPointer:&numWeekends dayInfoHeightPointer:&dayInfoHeight]) {
        return;
    }
    
    CGFloat w = self.frameWidth / 7;
    CGFloat g = dayInfoHeight * 2/3 ;
    
    
    PYPoint pointBegin = PYPointMake(-1, -1);
    PYPoint pointEnd = PYPointMake(-1, -1);
    
    if (userInfo) {
        pointBegin.x = [userInfo[@"x1"] integerValue];
        pointBegin.y = [userInfo[@"y1"] integerValue];
        pointEnd.x = [userInfo[@"x2"] integerValue];
        pointEnd.y = [userInfo[@"y2"] integerValue];
    }else{
        PYCanlendarTouchData __touchData = self.touchTools.touchData;
        if ([PYCalendarTouchTools isNewTouchPointer:&__touchData]) {
            return;
        }
        pointBegin = self.touchTools.touchData.pointBegin;
        pointEnd = self.touchTools.touchData.pointEnd;
    }
    
    PYPoint pointer1 = PYPointMake(-1, -1);
    PYPoint pointer2 = PYPointMake(-1, -1);
    
    
    if (pointEnd.y < pointBegin.y || (pointEnd.y == pointBegin.y && pointEnd.x < pointBegin.x)) {
        pointer2.x = pointBegin.x;
        pointer2.y = pointBegin.y;
        pointer1.x = pointEnd.x;
        pointer1.y = pointEnd.y;
    }else{
        pointer1.x = pointBegin.x;
        pointer1.y = pointBegin.y;
        pointer2.x = pointEnd.x;
        pointer2.y = pointEnd.y;

    }
    if (pointer2.y > self.frameHeight) {
        return;
    }
    
    for (NSInteger i = pointer1.y ; i <= pointer2.y; i ++) {
        if (pointer1.x  == -1 || pointer1.y  == -1 || pointer2.x == -1 || pointer2.y == -1) {
            break;
        }
        CGPoint startPoint = CGPointMake(-1, -1);
        CGPoint endPoint = CGPointMake(-1, -1);
        startPoint.y = weekEndInfoHeight + i * dayInfoHeight + dayInfoHeight / 2;
        endPoint.y = startPoint.y;
        if (i == pointer1.y ) {
            startPoint.x = w * pointer1.x + w/2;
            if (i == pointer2.y) {
                endPoint.x = startPoint.x + (pointer2.x - pointer1.x ) * w;
            }else{
                endPoint.x = self.frameWidth - w/2;
            }
        }else if (i == pointer2.y && i > pointer1.y ){
            startPoint.x = w/2;
            endPoint.x = startPoint.x + pointer2.x * w;
        }else if(i > pointer1.y  && i < pointer2.y){
            startPoint.x = w/2;
            endPoint.x = self.frameWidth - w/2;
        }
        if (startPoint.x > 0 && endPoint.x > 0) {
            [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:self.styleContext.colorPainterLine.CGColor strokeWidth:g lengthPointer:nil length:0];
        }
    }
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PYCanlendarTouchData touchData = PYCanlendarTouchDataNull();
    @try {
        [super touchesBegan:touches withEvent:event];
        
        UITouch *touch = touches.anyObject;
        if (!touch) {
            return;
        }
        
        CGFloat weekEndInfoHeight = self.frameHeight / 10;
        if(![self.touchTools checkToucheBegan:touch touchData:&touchData pointScan1:CGPointMake(0, weekEndInfoHeight) pointScan2:CGPointMake(self.frameWidth, self.frameHeight) dateShow:self.dateShow]){
            return;
        }
        
        if (!self.blockSelectedDate && !self.blockSelectedDates) {
            return;
        }
        
    }
    @finally {
        
        [self.touchTools synsetTouchData:touchData];
        
        if (!self.blockSelectedDates) {
            return;
        }
        
        @weakify(self);
        [self.touchTools startLongTouchWithBlockLongTouch:^{
            @strongify(self);
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.gtPainter executDisplay:nil];
            });
            
        }];
        
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PYCanlendarTouchData touchData = self.touchTools.touchData;
    @try {
        if (![self.touchTools isLongTouch:&touchData]) {
            [super touchesMoved:touches withEvent:event];
        }
        
        UITouch *touch = touches.anyObject;
        if (!touch) {
            return;
        }
        
        CGFloat weekEndInfoHeight = self.frameHeight / 10;
        if (![self.touchTools checkToucheMoved:touch touchData:&touchData pointScan1:CGPointMake(0, weekEndInfoHeight) pointScan2:CGPointMake(self.frameWidth, self.frameHeight) dateShow:self.dateShow]) {
            return;
        }
        
        if ([self.touchTools isLongTouch:&touchData]) {
            [self.touchTools synsetTouchData:touchData];
            [self.gtPainter executDisplay:nil];
        }
    }
    @finally {
        [self.touchTools synsetTouchData:touchData];
        if ([self.touchTools isForeTouch:&touchData]) {
//            self.visualEfView.alpha = touchData.currentForce / touchData.maxForce;
        }
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PYCanlendarTouchData touchData = self.touchTools.touchData;
    @try {
        UITouch *touch = touches.anyObject;
        if (!touch) {
            return;
        }
        CGFloat weekEndInfoHeight = self.frameHeight / 10;
        if(![self.touchTools checkToucheEnd:touch touchData:&touchData pointScan1:CGPointMake(0, weekEndInfoHeight) pointScan2:CGPointMake(self.frameWidth, self.frameHeight) dateShow:self.dateShow]){
            return;
        }
        
        if([self.touchTools isNormalTouch:&touchData] && !touchData.isMove){
            
            if (self.blockSelectedDate) {
                _blockSelectedDate(self, [PYCalendarTools parsetToDateWithPoint:touchData.pointEnd dateShow:self.dateShow]);
            }
        }else if ([self.touchTools isLongTouch:&touchData]){
            if (self.blockSelectedDates) {
                [self.touchTools synsetTouchData:touchData];
                NSDate *start = [PYCalendarTools parsetToDateWithPoint:self.touchTools.touchData.pointBegin dateShow:self.dateShow];
                NSDate *end = [PYCalendarTools parsetToDateWithPoint:self.touchTools.touchData.pointEnd dateShow:self.dateShow];
                _blockSelectedDates(self,@[start,end]);
            }
        }
    }
    @finally {
        [self.touchTools synsetTouchData:touchData];
        if (!self.touchTools.touchData.isEnd) {
            [super touchesEnded:touches withEvent:event];
        }
//        if (![self.touchTools isForeTouch:&touchData]) {
//            self.visualEfView.alpha = 0;
//        }else{
//            self.visualEfView.alpha = touchData.force / touchData.maxForce;
//        }
    }
}
-(void) setDateMin:(NSDate *)dateMin{
    PYDate date = PYDateMake(dateMin.year, dateMin.month, dateMin.day);
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMax) == 1) {
        return;
    }
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMin) == -1) {
        return;
    }
    _dateMin = [dateMin setCompentsWithBinary:0b111000];
}
-(void) setDateMax:(NSDate *)dateMax{
    PYDate date = PYDateMake(dateMax.year, dateMax.month, dateMax.day);
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMax) == 1) {
        return;
    }
    if (PYDateIsMaxEqulesMin(&date, &PYCalendarDateMin) == -1) {
        return;
    }
    _dateMax = [dateMax setCompentsWithBinary:0b111000];
}

-(void) setAttributes:(NSDictionary<NSString *, id> * _Nonnull) attributes{
    [self.styleContext setAttributes:attributes];
}
-(void) setAttributeWithKey:(NSString * _Nonnull) key value:(id _Nonnull) value{
    [self.styleContext setAttributeWithKey:key value:value];
}
-(id _Nullable) getAttributeValueWithKey:(NSString * _Nonnull) key{
    return [self.styleContext getAttributeValueWithKey:key];
}
@end

@implementation PYCalendarSelectedView{
@private
    PYGraphicsThumb * gt;
}
-(instancetype) init{
    if (self = [super init]) {
        @weakify(self);
        gt = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef ctx, id userInfo) {
            @strongify(self);
            CGFloat w = MIN(self.frameWidth, self.frameHeight) * 0.1;
            CGFloat s = 2;
            UIColor *color = userInfo;
            CGPoint p1 = CGPointMake(w, w);
            CGPoint p2 = CGPointMake(p1.x, self.frameHeight - w - p1.y);
            CGPoint p3 = CGPointMake(p2.x + w, p2.y + w);
            CGPoint p4 = CGPointMake(self.frameWidth - w, p3.y);
            [PYGraphicsDraw drawLineWithContext:ctx startPoint:p1 endPoint:p2 strokeColor:color.CGColor strokeWidth:s lengthPointer:nil length:0];
            [PYGraphicsDraw drawLineWithContext:ctx startPoint:p3 endPoint:p4 strokeColor:color.CGColor strokeWidth:s lengthPointer:nil length:0];
            CGFloat radius = p3.x - p2.x;
            CGPoint pointCenter = CGPointMake(p3.x , p2.y);
            [PYGraphicsDraw drawCircleWithContext:ctx pointCenter:pointCenter radius:radius strokeColor:color.CGColor fillColor:[UIColor clearColor].CGColor strokeWidth:s startDegree:90 endDegree:180];
        }];
    }
    return self;
}

-(void) setIndex:(int)index{
    self.backgroundColor = [UIColor clearColor];
    UIColor *color;
    _index = index;
    switch (self.index) {
        case 1:  {
            color = [UIColor greenColor];
        }
            break;
            
        default:{
            color = [UIColor orangeColor];
        }
            break;
    }
    [gt executDisplay:color];
}

@end

