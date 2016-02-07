//
//  MenuVC.m
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "MenuVC.h"

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self tvFavorites] setDataSource:self];
    [[self tvFavorites] setDelegate:self];
    [[self tvFavorites] setBackgroundColor:[UIColor clearColor]];
    

    NSBundle *framework_bundle = [NSBundle bundleWithIdentifier:@"com.appstud.VeloozeFramework"];
    [[self tvFavorites] registerNib:[UINib nibWithNibName:@"FavoritesTableCell" bundle:framework_bundle] forCellReuseIdentifier:CELL_ID(FavoritesTableCell)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ============================================================================
// MARK: - UITableView
// ============================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[FavoritesManager instance] favorites] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * favs = [[FavoritesManager instance] favorites];
    int favid = [[favs objectAtIndex:[indexPath row]] intValue];
    Station * st = [[StationManager instance] getStation:favid];
    FavoritesTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID(FavoritesTableCell) forIndexPath:indexPath];
    [cell setStation:st forTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * favs = [[FavoritesManager instance] favorites];
    int favid = [[favs objectAtIndex:[indexPath row]] intValue];

    UINavigationController * nc = (UINavigationController *)[[self sideMenuViewController] contentViewController];
    MapVC * vc = (MapVC *)[nc visibleViewController];
    [vc showStation:favid];
    [[self sideMenuViewController] hideMenuViewController];
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
