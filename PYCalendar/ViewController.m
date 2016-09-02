//
//  ViewController.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import <Utile/Utile.Framework.h>
#import "PYTimeView.h"

@interface ViewController ()
@property (strong, nonatomic) PYFrostedEffectView *forview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PYTimeView * tv = [PYTimeView new];
//    [self.view addSubview:tv];
    // Do any additional setup after loading the view, typically from a nib
    self.forview = [[PYFrostedEffectView alloc] initWithFrame:CGRectMake(0, 300, 320, 320)];
//    [self.view addSubview:self.forview];
//    [self.forview refreshForstedEffect];
//    
//    @weakify(self);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        @strongify(self);
//        @weakify(self);
//        __block NSUInteger index = 0;
//        while (true) {
//            index += 1;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                @strongify(self)
//                [self.forview refreshForstedEffect];
//            });
//            [NSThread sleepForTimeInterval:2];
//        }
//    });
    
}
-(void) viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
