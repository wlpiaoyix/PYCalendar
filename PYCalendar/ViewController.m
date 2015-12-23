//
//  ViewController.m
//  PYCalendar
//
//  Created by wlpiaoyi on 15/11/19.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"
#import <Utile/UIView+Expand.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageVIew.backgroundColor = [UIColor whiteColor];
    self.imageVIew.image = [self.imageVIew.image applyExtraLightEffect];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [self.view drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
