//
//  TodayViewController.m
//  VeloozeWidget
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "TodayViewController.h"

@implementation TodayTableCell



- (void)setStation:(Station *)aStation {
        
    self.lbName.font = FONT(FONT_SZ_MEDIUM);
    self.lbBikes.font = FONT(FONT_SZ_SMALL);
    
    // name
    self.lbName.text = aStation.name;
    self.lbName.textColor = [UIColor lightTextColor];
    self.lbBikes.textColor = FlatWhite;
    
    // bikes
    self.lbBikes.text = aStation.subtitle;
    self.lbBikes.backgroundColor = aStation.color;
    self.lbBikes.layer.borderColor = FlatWhite.CGColor;
    self.lbBikes.layer.borderWidth = 1;
    self.lbBikes.layer.masksToBounds = true;
    self.lbBikes.layer.cornerRadius = 5;
    
    // badge
    CGFloat h = CGRectGetHeight(self.uvBadge.frame);
    self.uvBadge.layer.cornerRadius = h / 2;
    self.uvBadge.layer.borderColor = FlatWhite.CGColor;
    self.uvBadge.layer.borderWidth = 1;
    self.uvBadge.backgroundColor = aStation.color;

}

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[self tvFavorites] setDelegate:self];
    [[self tvFavorites] setDataSource:self];
    [[self tvFavorites] sizeToFit];
    
    NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self refresh];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    defaultMarginInsets.bottom = 8;
    return defaultMarginInsets;
}

- (void)refresh {
    [[StationManager instance] loadStations:self];
}

- (void)onStationsLoadedWithError:(NSError *)aError {
    [[self tvFavorites] reloadData];
    self.preferredContentSize = self.tvFavorites.contentSize;
    self.view.translatesAutoresizingMaskIntoConstraints = false;

}
- (void)onStationUpdated:(Station *)aStation withError:(NSError *)aError {
    
}



// ============================================================================
#pragma mark - UITableView
// ============================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = [[[FavoritesManager instance] favorites] count];
    NSLog(@"numberOfRowsInSection \(ret)");
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    TodayTableCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TodayTableCell class]) forIndexPath:indexPath];
    NSArray * favs = [[FavoritesManager instance] favorites];
    
//    let cell:TodayTableCell = tableView.dequeueReusableCellWithIdentifier("idTodayCell", forIndexPath: indexPath) as! TodayTableCell;
//    let favs = FavoritesManager.instance().getFavorites();
    int ident = [[favs objectAtIndex:[indexPath row]] intValue];
    
    // get availability
    for (Station * station in [[StationManager instance] stations])  {
        if(station.ident == ident) {
            [cell setStation:station];
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated: true];
}


@end
