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

    [[[self btBikes] titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self btBikes] titleLabel] setFont:FONT(FONT_SZ_SMALL)];
    [[[self btBikes] titleLabel] setTextColor:FlatWhite];
//    [[[self lbBikes] layer] setBorderColor:FlatWhite.CGColor];
//    [[[self lbBikes] layer] setBorderWidth:1];
    [[[self btBikes] layer] setCornerRadius:5];
    [[[self btBikes] layer] setMasksToBounds:YES];
    
//    [[[self uvBadge] layer] setBorderColor:FlatWhite.CGColor];
//    [[[self uvBadge] layer] setBorderWidth:1];
    [[[self uvBadge] layer] setCornerRadius:CGRectGetHeight([[self uvBadge] frame]) / 2];
}


- (void)setStation:(Station *)aStation withDelegate:(id<FavoritesTableCellDelegate>)aDelegate {//forTableView:(UITableView *)aTableView {
    
    [self setTag:[aStation ident]];
    
    [[self uvBadge] setBackgroundColor:[aStation color]];
    
    [[self btBikes] setTag:[aStation ident]];
    [[self btBikes] setBackgroundColor:[aStation color]];
    [[self btBikes] setTitle:[aStation bikes] forState:UIControlStateNormal];
    [[self btBikes] addTarget:aDelegate action:@selector(onBikesClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self lbName] setText:[aStation name]];
    
    MGSwipeButton * bt = [MGSwipeButton buttonWithTitle:@"Supprimer" backgroundColor:FlatRed callback:^BOOL(MGSwipeTableCell *sender) {
        [aDelegate onDeleteClicked:[aStation ident]];
        return YES;
    }];
    
    [[bt titleLabel] setFont:FONT(FONT_SZ_MEDIUM)];
    [[bt titleLabel] setTextColor:FlatWhite];
    [self setLeftButtons:@[bt]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
