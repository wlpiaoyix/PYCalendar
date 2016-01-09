//
//  PYCalendarParams.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/2.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarParams.h"
#import "PYCalendarTools.h"
#import <Utile/PYUtile.h>
#import <Utile/NSDate+Expand.h>



const NSString * _Nonnull PYCalendarFontWeekEnd = @"adfadf";
const NSString * _Nonnull PYCalendarFontDay = @"hhjfgh";
const NSString * _Nonnull PYCalendarFontLunarDay = @"dfd5";
const NSString * _Nonnull PYCalendarFontHighlight = @"eqdadf";
const NSString * _Nonnull PYCalendarFontLunarHighlight = @"dedfv";

const NSString * _Nonnull PYCalendarColorWeekEnd = @"erhha";
const NSString * _Nonnull PYCalendarColorDay = @"frthsw";
const NSString * _Nonnull PYCalendarColorLunarDay = @"zcdty ";
const NSString * _Nonnull PYCalendarColorHighlight = @"sdfwkewaddf";
const NSString * _Nonnull PYCalendarColorOutDay = @"dqqp[pl.";
const NSString * _Nonnull PYCalendarColorDisable = @"dqqp[pl.ss";

const NSString * _Nonnull PYCalendarColorPainterLine = @"dsaqdcf";
const NSString * _Nonnull PYCalendarColorStyleLine = @"adsewrsqedf";


@implementation PYCalendarStyleContext{
@private
    PYSolarTerm * _Nullable solarTerm;
}

-(instancetype) init{
    if (self = [super init]) {
        
        NSDate * date = [NSDate date];
        self.today = PYDateMake(date.year, date.month, date.day);
        
    }
    return self;
}


-(void) setFontDay:(UIFont *)fontDay{
    _fontDay = fontDay;
    self.fontDayHeight = [PYUtile getFontHeightWithSize:fontDay.pointSize fontName:fontDay.fontName];
}
-(void) setFontLunarDay:(UIFont *)fontLunarDay{
    _fontLunarDay = fontLunarDay;
    self.fontLunarDayHeight = [PYUtile getFontHeightWithSize:fontLunarDay.pointSize fontName:fontLunarDay.fontName];
}
-(void) setFontWeekEnd:(UIFont *)fontWeekEnd{
    _fontWeekEnd = fontWeekEnd;
    self.fontWeekEndHeight = [PYUtile getFontHeightWithSize:fontWeekEnd.pointSize fontName:fontWeekEnd.fontName];
}

-(nonnull PYSolarTerm *) getSolarTermsWithYear:(NSInteger) year{
    @synchronized(self) {
        if (solarTerm == nil || solarTerm[0].date.year != year) {
            solarTerm = pyCalendarGetSolarTerm((int)year);
        }
    }
    return solarTerm;
}

-(void) setAttributes:(nonnull NSDictionary<NSString *, id> *) attributes{
    for (NSString *key in attributes) {
        id value = attributes[key];
        [self setAttributeWithKey:key value:value];
    }
}
-(void) setAttributeWithKey:(nonnull NSString *) key value:(nonnull id) value{
    if ([key isEqualToString:(NSString*)PYCalendarFontWeekEnd]) {
        if (![value isKindOfClass:[UIFont class]]) {
            return;
        }
        self.fontWeekEnd = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontDay]) {
        if (![value isKindOfClass:[UIFont class]]) {
            return;
        }
        self.fontDay = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontLunarDay]) {
        if (![value isKindOfClass:[UIFont class]]) {
            return;
        }
        self.fontLunarDay = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontHighlight]) {
        if (![value isKindOfClass:[UIFont class]]) {
            return;
        }
        self.fontHighlight = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontLunarHighlight]) {
        if (![value isKindOfClass:[UIFont class]]) {
            return;
        }
        self.fontLunarHighlight = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorWeekEnd]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorWeekEnd = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorDay]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorDay = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorLunarDay]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorLunarDay = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorHighlight]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorHighlight = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorOutDay]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorOutDay = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorDisable]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorDisable = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorPainterLine]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorPainterLine = value;
        return;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorStyleLine]) {
        if (![value isKindOfClass:[UIColor class]]) {
            return;
        }
        self.colorStyleLine = value;
        return;
    }
    
}
-(nonnull id) getAttributeValueWithKey:(nonnull NSString *) key{
    if ([key isEqualToString:(NSString*)PYCalendarFontWeekEnd]) {
        return self.fontWeekEnd;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontDay]) {
        return self.fontDay;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontLunarDay]) {
        return self.fontLunarDay;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontHighlight]) {
        return self.fontHighlight;
    }
    if ([key isEqualToString:(NSString*)PYCalendarFontLunarHighlight]) {
        return self.fontLunarHighlight;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorWeekEnd]) {
        return self.colorWeekEnd;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorDay]) {
        return self.colorDay;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorLunarDay]) {
        return self.colorLunarDay;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorHighlight]) {
        return self.colorHighlight;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorOutDay]) {
        return self.colorOutDay;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorDisable]) {
        return self.colorDisable;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorPainterLine]) {
        return self.colorStyleLine;
    }
    if ([key isEqualToString:(NSString*)PYCalendarColorStyleLine]) {
        return self.colorStyleLine;
    }
    return nil;
}

@end
