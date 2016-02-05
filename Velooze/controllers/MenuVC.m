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
    NSString * clazz = NSStringFromClass([MGSwipeTableCell class]);
    MGSwipeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:clazz forIndexPath:indexPath];
    if(cell == nil) {
        [[cell textLabel] setTextColor:FlatWhite];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        [[cell textLabel] setFont:FONT(FONT_SZ_MEDIUM)];
        cell = [[MGSwipeTableCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:clazz];
        [cell setBackgroundColor:[UIColor clearColor]];
        MGSwipeButton * bt = [MGSwipeButton buttonWithTitle:@"Supprimer" backgroundColor:FlatRed callback:^BOOL(MGSwipeTableCell *sender) {
            [[FavoritesManager instance] toggleFavorite:favid];
            [[self tvFavorites] reloadData];
            return YES;
        }];
        [cell setRightButtons:@[bt]];
    }
    
    Station * st = [[StationManager instance] getStation:favid];
    [[cell textLabel] setText:[st name]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * favs = [[FavoritesManager instance] favorites];
    int favid = [[favs objectAtIndex:[indexPath row]] intValue];

    MapVC * vc = (MapVC *) [[self sideMenuViewController] contentViewController];
    [vc showStation:favid];
    
    [[self sideMenuViewController] hideMenuViewController];
}


//func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    tableView .deselectRowAtIndexPath(indexPath, animated: true);
//    
//    let favs:NSDictionary =  FavoritesManager.instance().getFavorites();
//    
//    let nc:RootNC = self.sideMenuController() as! RootNC;
//    //        nc.topViewController;
//    
//    let map:MapVC = nc.topViewController as! MapVC;//self.navigationController?.topViewController! as! MapVC;
//    let key:String = favs.allKeys[indexPath.row] as! String;
//    map.showStation(Int(key)!);
//    map.hideSideMenuView();
//}
//



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
