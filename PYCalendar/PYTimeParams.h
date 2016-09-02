//
//  PYTimeParams.h
//  PYCalendar
//
//  Created by wlpiaoyi on 16/7/10.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <Utile/PYUtile.h>
#ifndef PYTimeParams_h
#define PYTimeParams_h

typedef struct _PYTime {
    NSInteger hour,minute,second;
} PYTime;

PYUTILE_STATIC_INLINE PYTime PYTimeMake(NSInteger hour, NSInteger minute, NSInteger second){
    PYTime time = {hour, minute, second};
    return time;
}

#endif /* PYTimeParams_h */
