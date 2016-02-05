//
//  MenuVC.h
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "VeloozeFramework.h"
#import "MapVC.h"

@interface MenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvFavorites;

@end