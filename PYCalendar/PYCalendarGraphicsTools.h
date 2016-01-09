//
//  PYCalendarGraphicsTools.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/30.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarParams.h"

@interface PYCalendarGraphicsTools : NSObject

+(void) drawWeekEndWithContext:(nonnull CGContextRef) context font:(nonnull UIFont *) font color:(nonnull UIColor*) color absRect:(CGRect) absRect y:(CGFloat) y;

+(void) drawSpeciallyWithContext:(nonnull CGContextRef) context text:(nonnull NSString *) text font:(nonnull UIFont *) font color:(nonnull UIColor *) color absRect:(CGRect) absRect y:(CGFloat) y;

+(void) drawDayWithContext:(nonnull CGContextRef) context font:(nonnull UIFont *) font fontHeight:(CGFloat) fontHeight color:(nonnull UIColor*) color lunarFont:(nonnull UIFont *) lunarFont lunarfontHeight:(CGFloat) lunarfontHeight lunarColor:(nonnull UIColor*) lunarColor absRect:(CGRect) absRect relRect:(CGRect) relRect y:(CGFloat) y date:(PYDate) date luanrDate:(PYSolarTerm) lunarDate textRect:(nullable CGRect *) textRectPointer;

+(CGSize) drawCalendarWithContext:(nonnull CGContextRef) context size:(CGSize) size dateShow:(nonnull NSDate *) dateShow dateMin:(nonnull NSDate *) dateMin dateMax:(nonnull NSDate *) dateMax styleContext:(nonnull PYCalendarStyleContext *) styleContext;

+(void) drawStyleWithContext:(nonnull CGContextRef) context size:(CGSize) size dateShow:(NSDate *  _Nonnull) dateShow styleContext:(nonnull PYCalendarStyleContext *) styleContext;

+(BOOL) getDateValueWithHeight:(CGFloat) height date:(nonnull NSDate *) date weekEndInfoHeightPointer:(nullable CGFloat *) weekEndInfoHeightPointer numWeekendsPointer:(nullable NSUInteger *) numWeekendsPointer dayInfoHeightPointer:(nullable CGFloat *) dayInfoHeightPointer;
+(BOOL) isEnableDate:(nonnull PYDate *) date maxDate:(nonnull PYDate *) maxDate minDate:(nonnull PYDate *) minDate canChangeDate:(BOOL) canChangeDate;
@end
