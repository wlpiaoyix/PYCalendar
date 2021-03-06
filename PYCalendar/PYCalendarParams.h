//
//  PYCalendarParams.h
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/2.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Utile/PYUtile.h>

typedef struct _PYPoint {
    NSInteger x,y;
} PYPoint;

PYUTILE_STATIC_INLINE PYPoint PYPointMake(NSInteger x, NSInteger y){
    PYPoint pointer = {x,y};
    return pointer;
}
typedef struct _PYDate {
    NSInteger year,month,day;
} PYDate;

PYUTILE_STATIC_INLINE PYDate PYDateMake(NSInteger year, NSInteger month, NSInteger day){
    PYDate date = {year, month, day};
    return date;
}

PYUTILE_STATIC_INLINE int PYDateIsMaxEqulesMin(PYDate * _Nonnull max, PYDate * _Nonnull min){
    if ((*max).year < (*min).year) {
        return -1;
    }
    if ((*max).year > (*min).year) {
        return 1;
    }
    if ((*max).month < (*min).month) {
        return -1;
    }
    if ((*max).month > (*min).month) {
        return 1;
    }
    if ((*max).day < (*min).day) {
        return -1;
    }
    if ((*max).day > (*min).day) {
        return 1;
    }
    return 0;
}

typedef struct _PYSolarTerm {
    BOOL isSolarTerm;
    PYDate date;
    const char * _Nonnull name;
} PYSolarTerm;

PYUTILE_STATIC_INLINE PYSolarTerm PYSolarTermMake(PYDate date, const char * _Nonnull name){
    PYSolarTerm st = {true, date, name};
    return st;
}



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



extern const NSString * _Nonnull PYCalendarFontWeekEnd;
extern const NSString * _Nonnull PYCalendarFontDay;
extern const NSString * _Nonnull PYCalendarFontLunarDay;
extern const NSString * _Nonnull PYCalendarFontHighlight;
extern const NSString * _Nonnull PYCalendarFontLunarHighlight;

extern const NSString * _Nonnull PYCalendarColorWeekEnd;
extern const NSString * _Nonnull PYCalendarColorDay;
extern const NSString * _Nonnull PYCalendarColorLunarDay;
extern const NSString * _Nonnull PYCalendarColorHighlight;
extern const NSString * _Nonnull PYCalendarColorOutDay;
extern const NSString * _Nonnull PYCalendarColorDisable;

extern const NSString * _Nonnull PYCalendarColorPainterLine;
extern const NSString * _Nonnull PYCalendarColorStyleLine;

@interface PYCalendarStyleContext : NSObject
//==>
@property (nonatomic, strong) UIFont * _Nullable fontWeekEnd;
@property (nonatomic, strong) UIFont * _Nullable fontDay;
@property (nonatomic, strong) UIFont * _Nullable fontLunarDay;
@property (nonatomic, strong) UIFont * _Nullable fontHighlight;
@property (nonatomic, strong) UIFont * _Nullable fontLunarHighlight;

@property (nonatomic, strong) UIColor * _Nullable colorWeekEnd;
@property (nonatomic, strong) UIColor * _Nullable colorDay;
@property (nonatomic, strong) UIColor * _Nullable colorOutDay;
@property (nonatomic, strong) UIColor * _Nullable colorLunarDay;

@property (nonatomic, strong) UIColor * _Nullable colorHighlight;
@property (nonatomic, strong) UIColor * _Nullable colorDisable;

@property (nonatomic, strong) UIColor * _Nullable colorPainterLine;
@property (nonatomic, strong) UIColor * _Nullable colorStyleLine;
//<==

@property (nonatomic) PYDate today;
@property (nonatomic) CGFloat fontWeekEndHeight;
@property (nonatomic) CGFloat fontDayHeight;
@property (nonatomic) CGFloat fontLunarDayHeight;
-(nonnull PYSolarTerm *) getSolarTermsWithYear:(NSInteger) year;
-(void) setAttributes:(nonnull NSDictionary<NSString *, id> *) attributes;
-(void) setAttributeWithKey:(NSString * _Nonnull) key value:(nonnull id) value;
-(nonnull id) getAttributeValueWithKey:(nonnull NSString *) key;

@end

