//
//  TodayViewController.m
//  VeloozeWidget
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "TodayViewController.h"

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[self tvFavorites] setDelegate:self];
    [[self tvFavorites] setDataSource:self];
//    [[self tvFavorites] sizeToFit];
    [[self tvFavorites] setBackgroundColor:[UIColor clearColor]];

    UILabel * bg = [[UILabel alloc] initWithFrame:[[self view] frame]];
    [bg setTextColor:FlatWhite];
    [bg setFont:FONT( FONT_SZ_MEDIUM )];
    [bg setTextAlignment:(NSTextAlignmentCenter)];
    [bg setText:@"Aucune station en favoris."];
    
    NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:t forMode:NSRunLoopCommonModes];

//    [[self btRefresh] setBackgroundColor:APP_COLOR];
//    [[[self btRefresh] titleLabel] setTextAlignment:(NSTextAlignmentCenter)];
//    [[[self btRefresh] titleLabel] setTextColor:FlatWhite];
//    [[[self btRefresh] titleLabel] setFont:FONT(FONT_SZ_SMALL)];
//    [[[self btRefresh] titleLabel] setText:@"Vérifier"];
//    
//    [[self lbRefresh] setTextColor:FlatWhite];
//    [[self lbRefresh] setFont:FONT(FONT_SZ_SMALL)];
    
    NSBundle *framework_bundle = [NSBundle bundleWithIdentifier:@"com.appstud.VeloozeFramework"];
    [[self tvFavorites] registerNib:[UINib nibWithNibName:@"FavoritesTableCell" bundle:framework_bundle] forCellReuseIdentifier:@"idFavoritesTableCell"];

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
    [self refresh:nil];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    defaultMarginInsets.bottom = 8;
    return UIEdgeInsetsZero;
}


//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//
//    size.height = CGRectGetHeight([[self btRefresh] frame]) + CGRectGetHeight([[self tvFavorites] frame]);
//    
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//
//    self ani
//}

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
    NSLog(@"numberOfRowsInSection %ld", ret);
    [[tableView backgroundView] setHidden:(ret != 0)];
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * favs = [[FavoritesManager instance] favorites];
    int favid = [[favs objectAtIndex:[indexPath row]] intValue];
    Station * st = [[StationManager instance] getStation:favid];
    FavoritesTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"idFavoritesTableCell" forIndexPath:indexPath];
    [cell setStation:st withDelegate:self];//forTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated: true];
    
    NSArray * favs = [[FavoritesManager instance] favorites];
    int favid = [[favs objectAtIndex:[indexPath row]] intValue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"velooze://ident=%d", favid]];
    [[self extensionContext] openURL:url completionHandler:nil];

}


// ============================================================================
#pragma mark - FavoritesTableCellDelegate
// ============================================================================
- (void)onBikesClicked:(UIButton *)aSender {
    [self refreshStation:(int)[aSender tag]];
}

- (void)onDeleteClicked:(int)aIdent {
    
}


- (void)refreshStation:(int)aIdent {
    [[StationManager instance] updateStations:aIdent withDelegate:self];
}


- (void)refresh:(id)sender {
    [[StationManager instance] loadStations:self];
}
@end
