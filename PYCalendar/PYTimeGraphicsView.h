//
//  PYTimeGraphicsView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 16/7/10.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <Utile/PYUtile.h>
#import "PYTimeParams.h"

@interface PYTimeGraphicsView : UIView

@property (nonatomic) PYTime time;
@property (nonatomic) CGFloat strokeWith;
@property (nonatomic, strong, nullable) UIColor * strokeColor;
-(void) refreshClock;
@end
