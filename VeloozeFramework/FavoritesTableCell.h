//
//  FavoritesTableCell.h
//  Velooze
//
//  Created by Olivier on 07/02/2016.
//  Copyright © 2016 maestun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "Config.h"
#import "StationManager.h"

@protocol FavoritesTableCellDelegate <NSObject>
- (void)onBikesClicked:(UIButton *)aSender;
- (void)onDeleteClicked:(int)aIdent;
@end

@interface FavoritesTableCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIView *uvBadge;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIButton *btBikes;
//- (void)setStation:(Station *)aStation forTableView:(UITableView *)aTableView;
- (void)setStation:(Station *)aStation withDelegate:(id<FavoritesTableCellDelegate>)aDelegate;
@end
