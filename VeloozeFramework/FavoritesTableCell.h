//
//  FavoritesTableCell.h
//  Velooze
//
//  Created by Olivier on 07/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "VeloozeFramework.h"

@protocol FavoritesTableCellDelegate <NSObject>


@end

@interface FavoritesTableCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIView *uvBadge;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbBikes;
- (void)setStation:(Station *)aStation forTableView:(UITableView *)aTableView;
@end
