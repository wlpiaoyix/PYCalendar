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
#import <Utile/UIView+Expand.h>
#import <Utile/EXTScope.h>
#import <Utile/PYGraphicsThumb.h>
#import <Utile/PYGraphicsDraw.h>
#import <Utile/NSDate+Expand.h>
#import <Utile/PYFrostedEffectView.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Dialog/PYDailogTools.h>
#import <Dialog/PYPopupTools.h>

PYDate PYCalendarDateMax;
PYDate PYCalendarDateMin;

static NSUInteger MAXPointTouchLength = 10;

@interface PYCalendarSelectedView : UIView

@property (nonatomic) int index;

@end

@interface PYCalendarGraphicsView (){
@private
    PYPoint pointTouchs[10];
    NSUInteger pointTouchLength;
    
}

@property (nonatomic, strong) PYCalendarStyleContext *styleContext;

@property (nonatomic, strong) PYGraphicsThumb *gtCalendar;
@property (nonatomic, strong) PYGraphicsThumb *gtStyle;
@property (nonatomic, strong) PYGraphicsThumb *gtPainter;

@property (nonatomic, strong) PYFrostedEffectView *feView;
@property (nonatomic, strong) PYCalendarTouchTools *touchTools;

@property (nonatomic) PYPoint pointEnableStart;
@property (nonatomic) PYPoint pointEnableEnd;

@property (nonatomic, strong) id synPoint;

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
    self.synPoint = [NSObject new];
    self.styleContext = [PYCalendarStyleContext new];
    self.touchTools = [PYCalendarTouchTools new];
    
    self.calendarShowType = NSCalendarUnitMonth;
    self.viewSelected = [PYCalendarSelectedView new];
    self.viewSelected.alpha = 0;
    
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
    
    self.feView = [PYFrostedEffectView new];
    
    @weakify(self);
    self.gtCalendar = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef ctx, id userInfo) {
        @strongify(self);
        [PYGraphicsDraw drawTextWithContext:ctx attribute:[NSMutableAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:YES];
        _sizeDayText = [PYCalendarGraphicsTools drawCalendarWithContext:ctx size:self.frameSize dateShow:self.dateShow dateMin:self.dateMin dateMax:self.dateMax styleContext:self.styleContext];
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
    [self synPointEnable];
}
-(void) reloadData{
    [self.viewSelected removeFromSuperview];
    [self addSubview:self.viewSelected];
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
    if ([dateSelecteds count] > MAXPointTouchLength) {
        UIView *view = [UIView new];
        [PYDailogTools setTitle:@"温馨提示" targetView:view];
        [PYDailogTools setMessage:[NSString stringWithFormat:@"单次最多支持%d个时间段的选择",(int)MAXPointTouchLength/2] blockStyle:nil targetView:view];
        [PYDailogTools showWithTargetView:view block:^(UIView * _Nonnull view, NSUInteger index) {
            [PYPopupTools hiddenWithTargetView:view];
        } buttonNames:@[@"确定"]];
    }else{
        _dateSelecteds = dateSelecteds;
    }
    
    
    [self.touchTools clearData];
    
    [self.gtPainter executDisplay:nil];
    if (![self.dateSelecteds count]) {
        return;
    }
    
    PYDate maxDate = PYDateMake(self.dateMax.year, self.dateMax.month, self.dateMax.day);
    PYDate minDate = PYDateMake(self.dateMin.year, self.dateMin.month, self.dateMin.day);
    
    NSDate *start = nil;
    NSDate *end = nil;
    NSUInteger index = 0;
    for (NSDate *date in self.dateSelecteds) {
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
            
            if ([PYCalendarTools parsetToPointWithDate:start dateShow:self.dateShow isStart:YES point:&pointBegin]
                && [PYCalendarTools parsetToPointWithDate:end dateShow:self.dateShow isStart:NO point:&pointEnd]) {
                if (pointBegin.x == -1 || pointBegin.y == -1) {
                    if (pointEnd.x != -1 && pointEnd.y != -1 ) {
                        pointBegin.y = pointEnd.y;
                        pointBegin.x = -2;
                    }
                }else if (pointEnd.x == -1 || pointEnd.y == -1) {
                    if (pointBegin.x != -1 && pointBegin.y != -1 ) {
                        pointEnd.y = pointBegin.y;
                        pointEnd.x = 7;
                    }
                }
            }
            
            pointTouchs[index++] = pointBegin;
            pointTouchs[index++] = pointEnd;
            start = nil;
            end = nil;
        }
    }
    pointTouchLength = MIN(index, MAXPointTouchLength);
    [self.gtPainter executDisplay:@""];
    
}
-(void) drawPainterWithContext:(nonnull CGContextRef) context userInfo:(NSDictionary<NSString *, NSNumber *>*) userInfo{
    CGFloat weekEndInfoHeight = 0;
    NSUInteger numWeekends = 0;
    CGFloat dayInfoHeight= 0;
    
    if (![PYCalendarGraphicsTools getDateValueWithHeight:self.frameHeight date:self.dateShow weekEndInfoHeightPointer:&weekEndInfoHeight numWeekendsPointer:&numWeekends dayInfoHeightPointer:&dayInfoHeight]) {
        return;
    }
    
    __block CGFloat w = self.frameWidth / 7;
    __block CGFloat g = MAX(dayInfoHeight * 2/3, 30);
    
    @weakify(self);
    void (^blockDraw)(PYPoint begin, PYPoint end) = ^(PYPoint pointBegin, PYPoint pointEnd){
        @strongify(self);
        
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
                    endPoint.x = self.frameWidth + w/2;
                }
            }else if (i == pointer2.y && i > pointer1.y ){
                startPoint.x = -w/2;
                endPoint.x = w/2 + pointer2.x * w;
            }else if(i > pointer1.y  && i < pointer2.y){
                startPoint.x = -w/2;
                endPoint.x = self.frameWidth + w/2;
            }
            if (startPoint.x != -1 && endPoint.x != -1) {
                [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:self.styleContext.colorPainterLine.CGColor strokeWidth:g lengthPointer:nil length:0];
                [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:self.styleContext.colorHighlight.CGColor strokeWidth:g/4 lengthPointer:nil length:0];
            }
        }
    };
    
    
    if (userInfo) {
        NSUInteger index = 0;
        while (index < pointTouchLength) {
            PYPoint pointBegin = pointTouchs[index++];
            PYPoint pointEnd = pointTouchs[index++];
            blockDraw(pointBegin, pointEnd);
        }
    }else{
        PYCalendarTouchData __touchData = self.touchTools.touchData;
        if ([PYCalendarTouchTools isNewTouchPointer:&__touchData]) {
            return;
        }
        PYPoint pointBegin = self.touchTools.touchData.pointBegin;
        PYPoint pointEnd = self.touchTools.touchData.pointEnd;
        blockDraw(pointBegin, pointEnd);
    }
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PYCalendarTouchData touchData = PYCalendarTouchDataNull();
    BOOL flag = true;
    @try {
        
        UITouch *touch = touches.anyObject;
        if (!touch) {
            return;
        }
        
        PYPoint pointBegin = PYPointMake(0, 0);
        [PYCalendarTouchTools toucheGetXIndexPointer:&(pointBegin.x) yIndexPointer:&(pointBegin.y) touchPoint:[touch locationInView:touch.view] sizeScan:self.frameSize dateShow:self.dateShow];
        if (pointBegin.y < self.pointEnableStart.y){
            return;
        }
        if (pointBegin.y == self.pointEnableStart.y && pointBegin.x < self.pointEnableStart.x){
            return;
        }
        
        if (pointBegin.y > self.pointEnableEnd.y) {
            return;
        }
        if (pointBegin.y == self.pointEnableEnd.y && pointBegin.x > self.pointEnableEnd.x) {
            return;
        }
        
        CGFloat weekEndInfoHeight = self.frameHeight / 10;
        if(![self.touchTools checkToucheBegan:touch touchData:&touchData pointScan1:CGPointMake(0, weekEndInfoHeight) pointScan2:CGPointMake(self.frameWidth, self.frameHeight) dateShow:self.dateShow]){
            return;
        }
        flag = false;
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
    @finally {
        if (flag) {
            [super touchesBegan:touches withEvent:event];
        }
        [self.touchTools synsetTouchData:touchData];
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PYCalendarTouchData touchData = self.touchTools.touchData;
    BOOL flag = true;
    @try {
        UITouch *touch = touches.anyObject;
        if (!touch) {
            return;
        }

        CGFloat weekEndInfoHeight = self.frameHeight / 10;
        if (![self.touchTools checkTouching:touch touchData:&touchData pointScan1:CGPointMake(0, weekEndInfoHeight) pointScan2:CGPointMake(self.frameWidth, self.frameHeight) dateShow:self.dateShow]) {
            return;
        }
        
        if ([self.touchTools isLongTouch:&touchData]) {
            if ([PYCalendarTouchTools isTouchMoveWithTouchData:&touchData]) {
                flag = false;
                [self.touchTools synsetTouchData:touchData];
                [self.gtPainter executDisplay:nil];
            }
        }else if ([self.touchTools isForeTouch:&touchData]) {
            flag = false;
            
            BOOL flagFore = true;
            if([self.touchTools isForeTouch1:&touchData]){
                if (self.delegate && [self.delegate respondsToSelector:@selector(touchForce1WithCalendar:touchPoint:)]) {
                    flagFore = flagFore && [self.delegate touchForce1WithCalendar:self touchPoint:[touch locationInView:touch.view]];
                }
                if (flagFore) {
                    [self.feView removeFromSuperview];
                    self.feView.frameSize = self.frameSize;
                    self.feView.frameOrigin = CGPointMake(0, 0);
                    [self addSubview:self.feView];
                }
            }
            if([self.touchTools isForeTouch2:&touchData]){
                if (self.delegate && [self.delegate respondsToSelector:@selector(touchForce2WithCalendar:touchPoint:)]) {
                    flagFore = flagFore && [self.delegate touchForce2WithCalendar:self touchPoint:[touch locationInView:touch.view]];
                }
            }
            
            CGFloat value =  touchData.force.curForce / touchData.force.maximumPossibleForce;
            if (flagFore) {
                self.feView.effectValue = value;
                [self.feView refreshForstedEffect];
            }else{
                [self.feView removeFromSuperview];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(touchForce:calendar:touchPoint:)]) {
                [self.delegate touchForce:value calendar:self touchPoint:[touch locationInView:touch.view]];
            }
        }
    }
    @finally {
        [self.touchTools synsetTouchData:touchData];
        if (flag) {
            [super touchesMoved:touches withEvent:event];
        }
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PYCalendarTouchData touchData = self.touchTools.touchData;
    BOOL flag = true;
    @try {
        UITouch *touch = touches.anyObject;
        if (!touch) {
            return;
        }
        CGFloat weekEndInfoHeight = self.frameHeight / 10;
        if(![self.touchTools checkToucheEnd:touch touchData:&touchData pointScan1:CGPointMake(0, weekEndInfoHeight) pointScan2:CGPointMake(self.frameWidth, self.frameHeight) dateShow:self.dateShow]){
            return;
        }
        
        if([self.touchTools isNormalTouch:&touchData]){
            flag = false;
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(dateSelcted:calendar:)]) {
                [self.delegate dateSelcted:[PYCalendarTools parsetToDateWithPoint:touchData.pointEnd dateShow:self.dateShow] calendar:self];
            }
        }else if ([self.touchTools isLongTouch:&touchData]){
            flag = false;
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(dateSelcteds:calendar:)]) {
                [self.touchTools synsetTouchData:touchData];
                NSDate *start = [PYCalendarTools parsetToDateWithPoint:self.touchTools.touchData.pointBegin dateShow:self.dateShow];
                NSDate *end = [PYCalendarTools parsetToDateWithPoint:self.touchTools.touchData.pointEnd dateShow:self.dateShow];
                [self.delegate dateSelcteds:@[start, end] calendar:self];
            }
        }
        
    }
    @finally {
        [self.touchTools synsetTouchData:touchData];
        [self.feView removeFromSuperview];
        if (flag) {
            [super touchesEnded:touches withEvent:event];
        }
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
    [self synPointEnable];
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
    [self synPointEnable];
    
}

-(void) setAttributes:(nonnull NSDictionary<NSString *, id> *) attributes{
    [self.styleContext setAttributes:attributes];
}
-(void) setAttributeWithKey:(nonnull NSString *) key value:(nonnull id) value{
    [self.styleContext setAttributeWithKey:key value:value];
}
-(nonnull id) getAttributeValueWithKey:(nonnull NSString *) key{
    return [self.styleContext getAttributeValueWithKey:key];
}

-(void) synPointEnable{
    @synchronized(_synPoint) {
        if (!self.dateShow) {
            return;
        }
        if (self.dateMin) {
            [PYCalendarTouchTools checkEnablePoint:&_pointEnableStart date:_dateMin dateShow:self.dateShow];
        }
        if (self.dateMax) {
            [PYCalendarTouchTools checkEnablePoint:&_pointEnableEnd date:_dateMax dateShow:self.dateShow];
        }
    }
    
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

