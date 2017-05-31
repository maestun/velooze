//
//  RootVC.m
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 maestun. All rights reserved.
//

#import "RootVC.h"


@implementation RootVC


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
//    self.contentViewShadowColor = COLOR_SHADOW;
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    [self setBouncesHorizontally:NO];
    [self setFadeMenuView:NO];
    [self setScaleContentView:NO];
    [self setScaleMenuView:NO];
    [self setPanGestureEnabled:YES];
    [self setDelegate:self];
    
    // menu
    [self setLeftMenuViewController: [self.storyboard instantiateViewControllerWithIdentifier:@"idMenuVC"]];
    
    // front
    [self setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"idMainNC"]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    MenuVC * menu = (MenuVC *)menuViewController;
    [[menu tvFavorites] reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
