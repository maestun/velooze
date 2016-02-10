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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh:nil];
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


- (void)onStationsLoadedWithError:(NSError *)aError {
    mLastUpdate = [ACUtils getTick];
    [[self tvFavorites] reloadData];
    [self setPreferredContentSize: [[self tvFavorites] contentSize]];
    [[self view] setTranslatesAutoresizingMaskIntoConstraints:NO];
}


- (void)onStationUpdated:(Station *)aStation withError:(NSError *)aError {
    
}


- (NSString *)getLastUpdateString:(int64_t)aMilliseconds {
    int seconds = (int)(aMilliseconds / 1000);
    int minutes = (int)(seconds / 60);
    int hours = (int)(minutes / 60);
    
    NSString * ret = @"Dernière mise à jour à l'instant.";
    if(hours > 0 || minutes > 0 || seconds > 0) {
        NSString * prefix = @"Dernière mise à jour il y a ";
        NSString * h = (hours > 0)
            ? ([NSString stringWithFormat:@"%d heure%@, ", (int)hours, (hours == 1) ? @"" : @"s"])
            : @"";
        
        NSString * m = (minutes > 0)
            ? [NSString stringWithFormat:@"%d minute%@, ", (int)minutes, (minutes == 1) ? @"" : @"s"]
            : @"";
        
        NSString * s = (seconds > 0)
            ? [NSString stringWithFormat:@"%d seconde%@.", (int)seconds, (seconds == 1) ? @"" : @"s"]
            : @".";
        
        ret = [NSString stringWithFormat:@"%@%@%@%@", prefix, h, m, s];
    }
    return ret;
}


// ============================================================================
#pragma mark - UITableView
// ============================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([tableView frame]), [self tableView:tableView heightForHeaderInSection:section])];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setText:mLastUpdate == 0 ? @"" : [self getLastUpdateString:([ACUtils getTick] - mLastUpdate)]];
    [title setTextColor:FlatWhite];
    [title setFont:FONT(FONT_SZ_SMALL)];
    
    
    UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([tableView frame]) - 50, 0, 50, 20)];
    [[bt titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[bt  titleLabel] setFont:FONT(FONT_SZ_SMALL)];
    [[bt titleLabel] setTextColor:FlatWhite];
    [[bt titleLabel] setText:@"Refresh"];
    [[bt layer] setCornerRadius:5];
    [[bt layer] setMasksToBounds:YES];
    [bt addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    [title addSubview:bt];
    
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
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
