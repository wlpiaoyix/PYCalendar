//
//  PYTimeView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 16/7/10.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYTimeView.h"
#import "PYTimeGraphicsView.h"
#import <Utile/PYViewAutolayoutCenter.h>
#import <Utile/NSDate+Expand.h>

@interface PYTimeView()
@property (nonatomic, strong, nonnull) UIDatePicker * timePicker;
@property (nonatomic, strong , nonnull) PYTimeGraphicsView * timeGraphicsView;
@end

@implementation PYTimeView
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
-(void)dateChanged:(id)sender{
    PYTime time = PYTimeMake(self.timePicker.date.hour, self.timePicker.date.minute, 0);
    self.time = time;
}
-(void) initWithParam{
    
    self.backgroundColor = [UIColor whiteColor];
    self.timePicker = [[UIDatePicker alloc] init];
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    self.timePicker.minuteInterval = 1;
    [self.timePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview: self.timePicker];
    
    self.timeGraphicsView = [PYTimeGraphicsView new];
    [self addSubview:self.timeGraphicsView];
    
    [PYViewAutolayoutCenter persistConstraint:self.timePicker relationmargins:UIEdgeInsetsMake(0, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    [PYViewAutolayoutCenter persistConstraint:self.timePicker size:CGSizeMake(DisableConstrainsValueMAX, 100)];
    [PYViewAutolayoutCenter persistConstraint:self.timeGraphicsView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemMake((__bridge void * _Nullable)(_timePicker), nil, nil, nil)];
    self.frame = CGRectMake(0, 0, 300, 300);
    
}

-(void) setStrokeWith:(CGFloat)strokeWith{
    _strokeWith = strokeWith;
    self.timeGraphicsView.strokeWith = strokeWith;
}
-(void) setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
    self.timeGraphicsView.strokeColor = strokeColor;
}
-(void) setTime:(PYTime)time{
    _time = time;
    self.timeGraphicsView.time = time;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    self.time = self.time;
    [self.timeGraphicsView refreshClock];
}

@end
