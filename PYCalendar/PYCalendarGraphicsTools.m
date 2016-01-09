//
//  PYCalendarGraphicsTools.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/30.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarGraphicsTools.h"
#import <CoreText/CTStringAttributes.h>
#import <Utile/PYGraphicsDraw.h>
#import <Utile/PYUtile.h>
#import <Utile/EXTScope.h>
#import <Utile/PYGraphicsThumb.h>
#import <Utile/PYGraphicsDraw.h>
#import <Utile/NSDate+Expand.h>
#import <Utile/UIColor+Expand.h>
#import "PYCalendarTools.h"

NSArray *CalendarWeekNames;

UIColor *PYCalendarGradientColor1;
UIColor *PYCalendarGradientColor2;
UIColor *PYCalendarGradientColor3;


@implementation PYCalendarGraphicsTools
+(void) initialize{
    PYCalendarGradientColor1 = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    PYCalendarGradientColor2 = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    PYCalendarGradientColor3 = PYCalendarGradientColor1;
}

+(void) drawWeekEndWithContext:(nonnull CGContextRef) context font:(nonnull UIFont *) font color:(nonnull UIColor*) color absRect:(CGRect) absRect y:(CGFloat) y{
    if (CalendarWeekNames == nil) {
        CalendarWeekNames = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    
    CGSize fontSize = CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName]);
    
    CGRect rect = absRect;
    rect.size.width = absRect.size.width / [CalendarWeekNames count];
    rect.origin.y = absRect.origin.y + (rect.size.height - fontSize.height) / 2;
    CGFloat x = 0;
    for (NSString *weekName in CalendarWeekNames) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:weekName];
        [attribute setAttributes:@{(NSString*)kCTForegroundColorAttributeName:color,(NSString*)kCTFontAttributeName:font} range:NSMakeRange(0, attribute.length)];
        rect.origin.x = x + (rect.size.width - [PYUtile getBoundSizeWithTxt:attribute.string font:font size:fontSize].height)/2;
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:rect y:y scaleFlag:false];
        x += rect.size.width;
    }
}
+(void) drawSpeciallyWithContext:(nonnull CGContextRef) context text:(nonnull NSString *) text font:(nonnull UIFont *) font color:(nonnull UIColor *) color absRect:(CGRect) absRect y:(CGFloat) y {
    
    CGFloat borderWith = 1;
    CGFloat offsetValue = 0;
    CGFloat textHeight = [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName];
    CGFloat textWith = [PYUtile getBoundSizeWithTxt:text font:font size:CGSizeMake(999, textHeight)].width;
    CGRect rectText = CGRectNull;
    rectText.size = CGSizeMake(textWith, textHeight);
    rectText.origin = CGPointMake(absRect.origin.x + (absRect.size.width - rectText.size.width) - offsetValue - borderWith, absRect.origin.y + offsetValue + borderWith);
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:text];
    [attribute setAttributes:@{(NSString*)kCTForegroundColorAttributeName:color ,(NSString*)kCTFontAttributeName:font} range:NSMakeRange(0, attribute.length)];
    
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:rectText y:y scaleFlag:false];
    
    CGFloat radius = rectText.size.height * .4;
    CGFloat offsetPointerx = 3;
    CGPoint centerPointer1 = CGPointMake(rectText.origin.x + offsetPointerx, y - (rectText.origin.y + rectText.size.height * .5) + font.pointSize * .2);
    [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPointer1 radius:radius strokeColor:[color CGColor] fillColor:nil strokeWidth:borderWith startDegree:90 endDegree:270];
    CGPoint centerPointer2 = CGPointMake(centerPointer1.x - offsetPointerx * 2 + textWith, centerPointer1.y);
    [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPointer2 radius:radius strokeColor:[color CGColor] fillColor:nil strokeWidth:borderWith startDegree:270 endDegree:90];
    
    CGPoint startPoint = CGPointMake(centerPointer1.x, centerPointer1.y + radius);
    CGPoint endPoint = CGPointMake(startPoint.x + centerPointer2.x - centerPointer1.x, startPoint.y);
    [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:[color CGColor] strokeWidth:borderWith lengthPointer:nil length:0];
    startPoint.y -= radius * 2;
    endPoint.y = startPoint.y;
    [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:[color CGColor] strokeWidth:borderWith lengthPointer:nil length:0];
}
+(void) drawDayWithContext:(nonnull CGContextRef) context font:(nonnull UIFont *) font fontHeight:(CGFloat) fontHeight color:(nonnull UIColor*) color lunarFont:(nonnull UIFont *) lunarFont lunarfontHeight:(CGFloat) lunarfontHeight lunarColor:(nonnull UIColor*) lunarColor absRect:(CGRect) absRect relRect:(CGRect) relRect y:(CGFloat) y  date:(PYDate) date luanrDate:(PYSolarTerm) lunarDate textRect:(nullable CGRect *) textRectPointer{
    
    CGRect rect = CGRectNull;
    rect.origin.x = absRect.origin.x + relRect.origin.x;
    rect.origin.y = absRect.origin.y + relRect.origin.y;
    rect.size = relRect.size;
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",(int)date.day]];
    [attribute setAttributes:@{(NSString*)kCTForegroundColorAttributeName:color,(NSString*)kCTFontAttributeName:font} range:NSMakeRange(0, attribute.length)];
    
    NSInteger heightLuanrBlank = (rect.size.height - fontHeight - lunarfontHeight) * 0.05;
    NSInteger heightBlank = ((rect.size.height - fontHeight - lunarfontHeight) - heightLuanrBlank) / 2;
    CGRect r = CGRectMake(rect.origin.x + (rect.size.width - [PYUtile getBoundSizeWithTxt:[attribute string] font:font size:CGSizeMake(999, fontHeight)].width) / 2,  rect.origin.y + heightBlank, absRect.size.width, absRect.size.height);
    CGSize size01 =  [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:y scaleFlag:false];
    
    NSString *lunarText;
    if (lunarDate.isSolarTerm) {
        lunarText = [NSString stringWithUTF8String:lunarDate.name];
    }else{
        if (lunarDate.date.day > 1) {
            lunarText = [NSString stringWithUTF8String:LunarCalendarDays[lunarDate.date.day - 1]];
        }else if(lunarDate.date.month > 1){
            lunarText = [NSString stringWithUTF8String:LunarCalendarMonth[lunarDate.date.month - 1]];
        }else{
            lunarText = [NSString stringWithFormat:@"%@年",[PYCalendarTools getLunarYearNameWithYear:lunarDate.date.year]];
        }
        
    }
    attribute = [[NSMutableAttributedString alloc] initWithString:lunarText];
    [attribute setAttributes:@{(NSString*)kCTForegroundColorAttributeName:lunarColor,(NSString*)kCTFontAttributeName:lunarFont} range:NSMakeRange(0, attribute.length)];
    
    r = CGRectMake(rect.origin.x + (rect.size.width - [PYUtile getBoundSizeWithTxt:lunarText font:lunarFont size:CGSizeMake(999, lunarfontHeight)].width) / 2,  rect.origin.y + fontHeight + heightBlank + heightLuanrBlank , absRect.size.width, absRect.size.height);
    CGSize size02 =  [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:y scaleFlag:false];
    
    if (textRectPointer) {
        CGSize size = CGSizeMake(MAX(size01.width , size02.width), size01.height + heightLuanrBlank + size02.height);
        CGPoint point = CGPointMake((relRect.size.width - size.width) / 2, relRect.origin.y + heightBlank);
        
        *textRectPointer = CGRectNull;
        (*textRectPointer).size = size;
        (*textRectPointer).origin = point;
    }
}


+(CGSize) drawCalendarWithContext:(nonnull CGContextRef) context size:(CGSize) size dateShow:(nonnull NSDate *) dateShow dateMin:(nonnull NSDate *) dateMin dateMax:(nonnull NSDate *) dateMax styleContext:(nonnull PYCalendarStyleContext *) styleContext{
    CGFloat weekEndInfoHeight = 0;
    NSUInteger numWeekends = 0;
    CGFloat dayInfoHeight= 0;
    
    if (![self getDateValueWithHeight:size.height date:dateShow weekEndInfoHeightPointer:&weekEndInfoHeight numWeekendsPointer:&numWeekends dayInfoHeightPointer:&dayInfoHeight]) {
        return CGSizeMake(-1, -1);
    }
    
    [PYCalendarGraphicsTools drawWeekEndWithContext:context font:styleContext.fontWeekEnd color:styleContext.colorWeekEnd absRect:CGRectMake(0, 0, size.width, weekEndInfoHeight) y:size.height];
    
    __block CGContextRef blockCtx = context;
    __block NSUInteger blockweekEndInfoHeight = weekEndInfoHeight;
    __block CGRect r1 = CGRectMake(0 , weekEndInfoHeight, size.width / 7, dayInfoHeight);
    __block CGRect r2 = r1;
    r2.origin = CGPointMake(0, 0);
    
    @weakify(styleContext);
    __block CGSize blocksize = size;
    __block BOOL flagDisable = true;
    __block CGRect block_sizeDayText = CGRectMake(-1, -1, -1, -1);
    [PYCalendarTools blockIterater:^(NSInteger row, NSInteger align, PYDate date, PYDate dateMin, PYDate dateMax) {
        @strongify(styleContext)
        
        if (row == 0 && date.day == 1) {
            flagDisable = false;
        }else if(row != 0 && date.day == 1){
            flagDisable = true;
        }
        
        NSInteger totalLunarDays;
        [PYCalendarTools getTotalDaysPointer:&totalLunarDays year:date.year month:date.month];
        totalLunarDays += date.day - 1;
        PYSolarTerm lunarSt;
        lunarSt.isSolarTerm = false;
        int ii = 0;
        for (int i = 0; i < 24; i++) {
            PYSolarTerm st = [styleContext getSolarTermsWithYear:date.year][i];
            ii = i;
            if (st.date.year == date.year && st.date.month == date.month && st.date.day == date.day) {
                lunarSt = st;
                break;
            }
        }
        
        if (lunarSt.isSolarTerm == false) {
            
            NSInteger lunarYear;
            NSInteger lunarMonth;
            NSInteger lunarDay;
            [PYCalendarTools getLunarYearPointer:&lunarYear lunarMonthPointer:&lunarMonth lunarDayPointer:&lunarDay totalLunarDays:totalLunarDays];
            lunarSt.date = PYDateMake(lunarYear, lunarMonth, lunarDay);
            
            if(lunarSt.date.month == 12 && lunarSt.date.day == [PYCalendarTools getLunarMonthDaysWithYear:lunarSt.date.year month:lunarSt.date.month]){
                lunarSt.name = "除夕";
                lunarSt.isSolarTerm = true;
            }else if(lunarSt.date.month == 1 && lunarSt.date.day == 15){
                lunarSt.name = "元宵";
                lunarSt.isSolarTerm = true;
            }
        }
        
        r1.origin = CGPointMake(align * r1.size.width, blockweekEndInfoHeight + row * r1.size.height);
        
        CGFloat fontHeight = styleContext.fontDayHeight;
        UIFont *fontDay = styleContext.fontDay;
        UIColor *color = styleContext.colorDay;
        
        CGFloat lunarfontHeight = styleContext.fontLunarDayHeight;
        UIFont *lunarFont = styleContext.fontLunarDay;
        UIColor *lunarColor = styleContext.colorLunarDay;
        BOOL isDisable = ![self isEnableDate:&date maxDate:&dateMax minDate:&dateMin canChangeDate:false];
        if (isDisable) {
            color = styleContext.colorDisable;
            lunarColor = styleContext.colorDisable;
        }else if (flagDisable) {
            color = styleContext.colorOutDay;
            lunarColor = styleContext.colorOutDay;
        }else{
            if(align == 0 || align == 6){
                color = styleContext.colorHighlight;
                fontDay = styleContext.fontHighlight;
            }else{
                color = styleContext.colorDay;
                lunarColor = styleContext.colorLunarDay;
            }
            if (lunarSt.date.day == 1 || lunarSt.isSolarTerm) {
                lunarFont = styleContext.fontLunarHighlight;
                lunarColor = styleContext.colorHighlight;
            }
        }
        
        __block CGSize block_blocksize = blocksize;
        
        [PYCalendarGraphicsTools drawDayWithContext:blockCtx font:fontDay fontHeight:fontHeight color:color lunarFont:lunarFont lunarfontHeight:lunarfontHeight lunarColor:lunarColor absRect:r1 relRect:r2 y:blocksize.height date:PYDateMake(date.year, date.month, date.day) luanrDate:lunarSt textRect:&block_sizeDayText];
        if (styleContext.today.year == date.year && styleContext.today.month == date.month && styleContext.today.day == date.day) {
            UIColor *colorToday;
            if (!flagDisable) {
                colorToday = styleContext.colorHighlight;
            }else{
                colorToday = styleContext.colorOutDay;
            }
            
            UIFont *font = [UIFont systemFontOfSize: MIN(block_blocksize.width * 8 / 320, block_blocksize.height * 8 / 260) ];
            NSString *text = @"今天";
            [PYCalendarGraphicsTools drawSpeciallyWithContext:blockCtx text:text font:font color:colorToday absRect:r1 y:block_blocksize.height];
        }
    } date:dateShow dateMin:dateMin dateMax:dateMax];
    return block_sizeDayText.size;
}

+(void) drawStyleWithContext:(nonnull CGContextRef) context size:(CGSize) size dateShow:(NSDate *  _Nonnull) dateShow styleContext:(nonnull PYCalendarStyleContext *) styleContext{
    CGFloat weekEndInfoHeight = 0;
    NSUInteger numWeekends = 0;
    CGFloat dayInfoHeight= 0;
    
    if (![PYCalendarGraphicsTools getDateValueWithHeight:size.height date:dateShow weekEndInfoHeightPointer:&weekEndInfoHeight numWeekendsPointer:&numWeekends dayInfoHeightPointer:&dayInfoHeight]) {
        return;
    }
    
    CGPoint startPoint = CGPointMake(0, weekEndInfoHeight);
    CGPoint endPoint = CGPointMake(size.width, startPoint.y);
    [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:styleContext.colorStyleLine.CGColor strokeWidth:0.5 lengthPointer:nil length:0];
    
    CGPoint p1 = CGPointMake(0, 0);
    CGPoint p4 = CGPointMake(p1.x , p1.y + endPoint.y);
    [PYGraphicsDraw drawLinearGradientWithContext:context colorValues:(CGFloat[]){
        styleContext.colorStyleLine.red, styleContext.colorStyleLine.green, styleContext.colorStyleLine.blue, styleContext.colorStyleLine.alpha,
        0,0,0,0,
        styleContext.colorStyleLine.red, styleContext.colorStyleLine.green, styleContext.colorStyleLine.blue, styleContext.colorStyleLine.alpha
    } alphas:(CGFloat[]){
        0.0f,
        0.5f,
        1.0f
    } length:3  startPoint:p1 endPoint:p4];
    
    for (NSInteger i = 0; i < numWeekends; i++) {
        startPoint.y += dayInfoHeight;
        endPoint.y  = startPoint.y;
        [PYGraphicsDraw drawLineWithContext:context startPoint:startPoint endPoint:endPoint strokeColor:styleContext.colorStyleLine.CGColor strokeWidth:0.5 lengthPointer:nil length:0];
        p1.y = startPoint.y - dayInfoHeight;
        p4.y = endPoint.y;
    }
}

+(BOOL) getDateValueWithHeight:(CGFloat) height date:(nonnull NSDate *) date weekEndInfoHeightPointer:(nullable CGFloat *) weekEndInfoHeightPointer numWeekendsPointer:(nullable NSUInteger *) numWeekendsPointer dayInfoHeightPointer:(nullable CGFloat *) dayInfoHeightPointer {
    
    if (!date) {
        return false;
    }
    
    CGFloat weekEndInfoHeight = height / 10;
    NSUInteger numWeekends = 0;
    CGFloat dayInfoHeight= 0;
    
    NSInteger perNumDays;
    NSInteger curNumDays;
    NSInteger nextNumDays;
    [PYCalendarTools getCalendarInfoWithPerNumDaysPointer:&perNumDays curNumDaysPointer:&curNumDays nextNumDaysPointer:&nextNumDays date:date];
    numWeekends = (perNumDays + curNumDays + nextNumDays);
    if (numWeekends % 7) {
        NSAssert(false, @"PYCalendarTools getCalendarInfoWithPerNumDaysPointer result is erro in PYCalendarGraphicsView reloadData");
        return false;
    }
    numWeekends = numWeekends / 7;
    dayInfoHeight = (height - weekEndInfoHeight) / (CGFloat)numWeekends;
    
    *weekEndInfoHeightPointer = weekEndInfoHeight;
    *numWeekendsPointer = numWeekends;
    *dayInfoHeightPointer = dayInfoHeight;
    return true;
}

+(BOOL) isEnableDate:(nonnull PYDate *) date maxDate:(nonnull PYDate *) maxDate minDate:(nonnull PYDate *) minDate canChangeDate:(BOOL) canChangeDate{
    if (PYDateIsMaxEqulesMin(date, minDate) == -1) {
        if (canChangeDate) {
            *date = *minDate;
        }
        return false;
    }
    if (PYDateIsMaxEqulesMin(maxDate, date) == -1 ) {
        if (canChangeDate) {
            *date = *maxDate;
        }
        return false;
    }
    return true;
}


@end
