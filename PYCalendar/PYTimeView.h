//
//  PYTimeView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 16/7/10.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYTimeParams.h"

@interface PYTimeView : UIView

@property (nonatomic) PYTime time;
@property (nonatomic) CGFloat strokeWith;
@property (nonatomic, strong, nullable) UIColor * strokeColor;

@end
