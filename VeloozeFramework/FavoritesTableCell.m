//
//  FavoritesTableCell.m
//  Velooze
//
//  Created by Olivier on 07/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "FavoritesTableCell.h"

@implementation FavoritesTableCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    
    [[self lbName] setFont:FONT_BOLD(FONT_SZ_MEDIUM)];
    [[self lbName] setTextColor:FlatWhite];

    [[self lbBikes] setTextAlignment:NSTextAlignmentCenter];
    [[self lbBikes] setFont:FONT(FONT_SZ_SMALL)];
    [[self lbBikes] setTextColor:FlatWhite];
    [[[self lbBikes] layer] setBorderColor:FlatWhite.CGColor];
    [[[self lbBikes] layer] setBorderWidth:1];
    [[[self lbBikes] layer] setCornerRadius:5];
    
    [[[self uvBadge] layer] setBorderColor:FlatWhite.CGColor];
    [[[self uvBadge] layer] setBorderWidth:1];
    [[[self uvBadge] layer] setCornerRadius:CGRectGetHeight([[self uvBadge] frame]) / 2];
}


- (void)setStation:(Station *)aStation forTableView:(UITableView *)aTableView {
    
    [self setTag:[aStation ident]];
    
    [[self uvBadge] setBackgroundColor:[aStation color]];
    
    [[self lbBikes] setBackgroundColor:[aStation color]];
    [[self lbBikes] setText:[aStation subtitle]];
    
    [[self lbName] setText:[aStation name]];
    
    MGSwipeButton * bt = [MGSwipeButton buttonWithTitle:@"Supprimer" backgroundColor:FlatRed callback:^BOOL(MGSwipeTableCell *sender) {
        [[FavoritesManager instance] toggleFavorite:[aStation ident]];
        [aTableView reloadData];
        return YES;
    }];
    [self setRightButtons:@[bt]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
