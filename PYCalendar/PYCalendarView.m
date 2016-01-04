//
//  PYCalendarView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/12/1.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarView.h"
#import "PYCalendarGraphicsView.h"
#import <Utile/PYUtile.h>
#import <Utile/UIColor+Expand.h>
#import <Utile/UIImage+Expand.h>
#import <Utile/NSDate+Expand.h>
#import <Utile/UIView+Expand.h>
#import <Utile/UIImage+Expand.h>
#import <Utile/PYGraphicsDraw.h>
#import <Utile/EXTScope.h>
#import <Dialog/Dialog.Framework.h>
#import "PYDatePikerView.h"


UIColor *PYCOPVDefaultColor1;
UIColor *PYCOPVDefaultColor2;

@interface PYCalendarView()<PYCalendarGraphicsProtocol>
@property (nonatomic, strong) UIButton *buttonPre;
@property (nonatomic, strong) UIButton *buttonNext;
@property (nonatomic, strong) UIButton *buttonDate;
@property (nonatomic, strong) UILabel *lableDate;
@property (nonatomic, strong) UIView *viewHead;
@property (nonatomic, strong) UIView *contextView;
@property (nonatomic, strong) UIImageView *imageViewDown;
@property (nonatomic, weak) PYCalendarGraphicsView *calendarView;
@property (nonatomic, strong) NSArray<PYCalendarGraphicsView*> *calendarViews;
@property (nonatomic) NSTimeInterval timeInterval;
@end

@implementation PYCalendarView
+(void) initialize{
    PYCOPVDefaultColor1 = [UIColor colorWithRed:26.0/255.0 green:85.0/255.0 blue:202.0/255.0 alpha:1];
    PYCOPVDefaultColor2 = [UIColor whiteColor];
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
    self.hasSound = true;
    self.viewHead = [UIView new];
    self.viewHead.backgroundColor = PYCOPVDefaultColor2;
    self.timeInterval = -1;
    
    self.buttonPre = [PYCalendarView createButtonWithName:@"上一月"];
    self.buttonNext = [PYCalendarView createButtonWithName:@"下一月"];
    self.buttonDate = [PYCalendarView createButtonWithName:@""];
    [self.buttonDate setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
    
    [self.buttonPre addTarget:self action:@selector(onclickPre) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonNext addTarget:self action:@selector(onclickNext) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonDate addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchDown];
    [self.buttonDate addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewHead addSubview:self.buttonPre];
    [self.viewHead addSubview:self.buttonNext];
    [self.viewHead addSubview:self.buttonDate];
    
    self.lableDate = [PYCalendarView createLableDate];
    [self.viewHead addSubview:self.lableDate];
    
    [self addSubview:self.viewHead];
    
    self.contextView = [UIView new];
    self.contextView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contextView];
    
    PYCalendarGraphicsView *calendarView01 = [self createCalendar];
    PYCalendarGraphicsView *calendarView02 = [self createCalendar];
    self.calendarViews = @[calendarView01, calendarView02];
    self.calendarView = calendarView01;
    [self.contextView addSubview:self.calendarView];
    
    UIImage *image = [UIImage imageWithSize:CGSizeMake(20, 15) blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        CGPoint p1 = CGPointMake(0, 0);
        CGPoint p2 = CGPointMake(p1.x + rect.size.width, p1.y);
        CGPoint p3 = CGPointMake(p2.x / 2, p2.y + rect.size.height);
        CGPoint points[3] = {p1, p2, p3};
        [PYGraphicsDraw drawPolygonWithContext:context pointer:points pointerLength:3 strokeColor:[[UIColor clearColor] CGColor] fillColor:[PYCOPVDefaultColor1 CGColor] strokeWidth:0];
    }];
    
    self.imageViewDown = [[UIImageView alloc] initWithImage:image];
    self.imageViewDown.frameSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
    [self.viewHead addSubview:self.imageViewDown];
    
    self.dateShow = [NSDate date];
    self.calendarView.delegate = self;
#ifdef DEBUG
    @weakify(self);
    [self setBlockSelectedDate:^(PYCalendarView * _Nonnull calendarView,NSDate * _Nonnull dateSelected) {
        @strongify(self);
        self.dateSelected = dateSelected;
    }];
    [self setBlockSelectedDates:^(PYCalendarView * _Nonnull calendarView, NSArray<NSDate *> * _Nonnull dateSelecteds) {
        @strongify(self);
        self.dateSelecteds = dateSelecteds;
    }];
#endif
    
    self.dateMin = [[NSDate date] offsetYear:-2];
    self.dateMax = [self.dateMin offsetYear:4];
}
-(PYCalendarGraphicsView*) createCalendar{
    PYCalendarGraphicsView *calendarView = [PYCalendarGraphicsView new];
    calendarView.backgroundColor = [UIColor whiteColor];
    return calendarView;
}
-(void) setDateMin:(NSDate *)dateMin{
    for (PYCalendarGraphicsView *graphicsView in self.calendarViews) {
        graphicsView.dateMin = dateMin;
    }
    _dateMin = self.calendarViews.firstObject.dateMin;
}
-(void) setDateMax:(NSDate *)dateMax{
    for (PYCalendarGraphicsView *graphicsView in self.calendarViews) {
        graphicsView.dateMax = dateMax;
    }
    _dateMax = self.calendarViews.firstObject.dateMax;
}
-(void) onclickPre{
    self.dateShow = [self.dateShow offsetMonth:-1];
}

-(void) onclickNext{
    self.dateShow = [self.dateShow offsetMonth:1];
}
-(void) touchBegin{
    self.timeInterval = [NSDate timeIntervalSinceReferenceDate];
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        for (int i = 0; i < 20; i++) {
            if (self.timeInterval < 0) {
                return;
            }
            [NSThread sleepForTimeInterval:0.01];
        }
        if (self.timeInterval < 0) {
            return;
        }
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            NSTimeInterval timeInterval = self.timeInterval;
            self.timeInterval = -1;
            if (timeInterval > 0) {
                self.dateSelected = [NSDate date];
                if (!(self.dateShow.year == self.dateSelected.year && self.dateSelected.month == self.dateShow.month)) {
                    self.dateShow = self.dateSelected;
                }
            }
        });
    });
}
-(void) touchUp{
    if (self.timeInterval < 0) {
        return;
    }
    self.timeInterval = -1;
    PYDatePikerView *picker = [PYDatePikerView new];
    picker.selectedDate = self.dateShow;
    [PYDailogTools setTitle:@"日期调整" targetView:picker];
    @weakify(self);
    [PYDailogTools showWithTargetView:picker block:^(UIView * _Nonnull view, NSUInteger index) {
        @strongify(self);
        [PYPopupTools hiddenWithTargetView:view];
        if (index == 0) {
            self.dateShow = ((PYDatePikerView*)view).selectedDate;
        }
        
    } buttonNames:@[@"确定",@"取消" ]];
}

-(void) setDateShow:(NSDate *)dateShow{
    if (self.dateShow.year == dateShow.year && self.dateShow.month == dateShow.month) {
        return;
    }
    PYCalendarGraphicsView *other = self.calendarViews.firstObject == self.calendarView ? self.calendarViews.lastObject : self.calendarViews.firstObject;
    PYCalendarGraphicsView *cur = self.calendarView;
    other.dateShow = dateShow;
    
    if (other.dateShow != dateShow) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if (dateShow.timeIntervalSince1970 > _dateShow.timeIntervalSince1970) {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.contextView cache:false];
        if(_hasSound)[PYUtile soundWithPath:[NSString stringWithFormat:@"%@/PYCalendarSound.bundle/turn01.wav",bundleDir] isShake:NO];
    }else{
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.contextView cache:false];
        if(_hasSound)[PYUtile soundWithPath:[NSString stringWithFormat:@"%@/PYCalendarSound.bundle/turn02.wav",bundleDir] isShake:NO];
    }
    [UIView commitAnimations];
    [other removeFromSuperview];
    
    self.calendarView = other;
    
    other.dateSelected = cur.dateSelected;
    other.dateSelecteds = cur.dateSelecteds;
    
    _dateShow = other.dateShow;
    
    cur.userInteractionEnabled = NO;
    other.userInteractionEnabled = YES;
    [self.contextView addSubview:other];
    
    self.lableDate.text = [self.dateShow dateFormateDate:@"yyyy-MM"];
    
    CGSize sizeText = [PYUtile getBoundSizeWithTxt:self.lableDate.text font:self.lableDate.font size:CGSizeMake(999, self.lableDate.frameHeight)];
    CGPoint imagePoint = CGPointMake(self.viewHead.frameWidth/2 + sizeText.width/ 2 + 5, (self.viewHead.frameHeight - self.imageViewDown.frameHeight) / 2);
    self.imageViewDown.frameOrigin = imagePoint;
}
-(void) setDateSelecteds:(NSArray<NSDate *> *)dateSelecteds{
    self.calendarView.dateSelecteds = dateSelecteds;
    _dateSelecteds = dateSelecteds;
}
-(void) setDateSelected:(NSDate *)dateSelected{
    self.calendarView.dateSelected = dateSelected;
    _dateSelected = dateSelected;
}
-(void) setBlockSelectedDate:(void (^)(PYCalendarView * _Nonnull calendarView,NSDate * _Nonnull dateSelected))blockSelectedDate{
    _blockSelectedDate = [blockSelectedDate copy];
    for (PYCalendarGraphicsView *cgv in self.calendarViews) {
        cgv.delegate = self;
        
    }
}
-(void) setBlockSelectedDates:(void (^)(PYCalendarView * _Nonnull calendarView, NSArray<NSDate *> * _Nonnull dateSelecteds))blockSelectedDates{
    _blockSelectedDates = [blockSelectedDates copy];
    for (PYCalendarGraphicsView *cgv in self.calendarViews) {
        cgv.delegate = self;
    }
}

-(void) dateSelcted:(NSDate * _Nullable) date calendar:(PYCalendarGraphicsView * _Nonnull) calendar{
    if (self.blockSelectedDate) {
        _blockSelectedDate(self,date);
        if (date == calendar.dateSelected) {
            if(self.hasSound)[PYUtile soundWithPath:[NSString stringWithFormat:@"%@/PYCalendarSound.bundle/click.wav",bundleDir] isShake:NO];
        }else{
            if(self.hasSound)[PYUtile soundWithPath:[NSString stringWithFormat:@"%@/PYCalendarSound.bundle/noclick.wav",bundleDir] isShake:NO];
        }
    }
}
-(void) dateSelcteds:(NSArray<NSDate *> * _Nullable) dates calendar:(PYCalendarGraphicsView * _Nonnull) calendar{
    if (self.blockSelectedDates) {
        _blockSelectedDates(self, dates);
    }
}

-(void) layoutSubviews{
    [super layoutSubviews];
    self.viewHead.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    
    self.buttonPre.frame = CGRectMake(0, 0, 80, self.viewHead.frame.size.height);
    self.buttonNext.frame = CGRectMake(self.frame.size.width - self.buttonPre.frame.size.width, 0, self.buttonPre.frame.size.width, self.buttonPre.frame.size.height);
    self.buttonDate.frame = CGRectMake((self.frameWidth - self.buttonPre.frameWidth) / 2, self.buttonPre.frameY, self.buttonPre.frameWidth, self.buttonPre.frameHeight);
    self.lableDate.frame = CGRectMake(self.buttonPre.frame.size.width, 0, self.viewHead.frame.size.width - self.buttonPre.frame.size.width * 2, self.viewHead.frame.size.height);
    
    self.contextView.frame = CGRectMake(0, self.viewHead.frame.size.height, self.frame.size.width, (self.frame.size.height - self.viewHead.frame.size.height));
    self.calendarViews.firstObject.frameSize = self.contextView.frame.size;
    self.calendarViews.firstObject.frameOrigin = CGPointMake(0, 0);
    self.calendarViews.lastObject.frameSize = self.contextView.frame.size;
    self.calendarViews.lastObject.frameOrigin = CGPointMake(0, 0);
    
    CGSize sizeText = [PYUtile getBoundSizeWithTxt:self.lableDate.text font:self.lableDate.font size:CGSizeMake(999, self.lableDate.frameHeight)];
    CGPoint imagePoint = CGPointMake(self.viewHead.frameWidth/2 + sizeText.width/ 2 + 5, (self.viewHead.frameHeight - self.imageViewDown.frameHeight) / 2);
    self.imageViewDown.frameOrigin = imagePoint;
    
    [self.calendarView reloadData];
}

+(UILabel *) createLableDate{
    UILabel *lable = [UILabel new];
    lable.font = [UIFont systemFontOfSize:16];
    lable.textColor = PYCOPVDefaultColor1;
    lable.numberOfLines = 0;
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}

+(UIButton*) createButtonWithName:(NSString*) name{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:PYCOPVDefaultColor1 forState:UIControlStateNormal];
    [button setTitleColor:PYCOPVDefaultColor2 forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageWithColor:PYCOPVDefaultColor2] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:PYCOPVDefaultColor1] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:name forState:UIControlStateNormal];
    return button;
}


@end
