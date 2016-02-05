//
//  SplashVC.m
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "SplashVC.h"


@implementation SplashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:APP_COLOR];
    [[self ivIcon] setImage:[ACUtils tintedImageWithColor:FlatWhite image:[UIImage imageNamed:@"bmx"]]];
    [[StationManager instance] loadStations:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onStationsLoadedWithError:(NSError *)aError {
    if(aError) {
        // TODO:

    }
    else {
        RootVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idRootVC"];
        [self presentViewController:vc animated:YES completion:^{
            ;
        }];
    }
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
