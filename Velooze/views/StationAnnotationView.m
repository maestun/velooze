//
//  StationAnnotationView.m
//  Velooze
//
//  Created by Olivier on 07/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "StationAnnotationView.h"

static UIImage * sFavON = nil;
static UIImage * sFavOFF = nil;
static UIImage * sPin = nil;

static NSMutableDictionary * sTintedPins = nil;

@implementation StationAnnotationView

- (void)awakeFromNib {
    if(sPin == nil) {
        sPin = [UIImage imageNamed:@"pin_filled"];
        sFavOFF = [ACUtils tintedImageWithColor:FlatRed image:[UIImage imageNamed:@"like"]];
        sFavON = [ACUtils tintedImageWithColor:FlatRed image:[UIImage imageNamed:@"like_filled"]];
        sTintedPins = [NSMutableDictionary dictionary];
    }
    
    [[self lbBikes] setTextColor:FlatWhite];
    [[self lbBikes] setTextAlignment:NSTextAlignmentCenter];
    [[self lbBikes] setFont:FONT_BOLD(FONT_SZ_MEDIUM)];

    [[self ivFav] setImage:sFavON];
    [self setCanShowCallout:YES];
}

- (void)setStation:(Station *)aStation {
    UIImage * pin = [sTintedPins objectForKey:[aStation color]];
    if(pin == nil) {
        pin = [ACUtils tintedImageWithColor:[aStation color] image:sPin];
        [sTintedPins setObject:pin forKey:[aStation color]];
    }
    
    [[self ivFav] setHidden:![[FavoritesManager instance] isFavorite:[aStation ident]]];
    [[self ivPin] setImage:pin];
    [[self ivPin] setTag:[aStation ident]];
    [[self lbBikes] setText:[NSString stringWithFormat:@"%d", [aStation available]]];
}

- (UIView *)rightCalloutAccessoryView {
    UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [bt setTag:[[self ivPin] tag]];
    [self refreshButton:bt];
    [bt addTarget:self action:@selector(onToggleClicked:) forControlEvents:UIControlEventTouchUpInside];
    return bt;
}


- (void)refreshButton:(UIButton *)aButton {
    BOOL isfav = [[FavoritesManager instance] isFavorite:(int)[aButton tag]];
    UIImage * img = isfav ? sFavON : sFavOFF;
    [aButton setImage:img forState:UIControlStateNormal];
    [[self ivFav] setHidden:!isfav];
}


- (void)onToggleClicked:(id)aSender {
    UIButton * bt = (UIButton *)aSender;
    [[FavoritesManager instance] toggleFavorite:(int)[bt tag]];
    [self refreshButton:bt];
}

- (void)layoutSubviews {
    
    if ([self isSelected]) {
        for(UIView * subview in [self subviews]) {
            if([[subview subviews] count] > 0) {
                // A LIIIIIITTLE BIT HACKY
                // TODO: rendre ça safe
                NSArray * views = [[[[[[[[[subview subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:1] subviews] objectAtIndex:0] subviews];

                UIView * bg = (UIView *)views[0];
                [bg setBackgroundColor:FlatGray];
                
                UILabel * title = (UILabel *)views[2];
                [title setFont:FONT_BOLD(FONT_SZ_MEDIUM)];
                [title setTextColor:FlatWhite];

                UILabel * subtitle = (UILabel *)views[5];
                [subtitle setFont:FONT(FONT_SZ_SMALL)];
                [subtitle setTextColor:FlatWhite];
            }
        }
    }
    [super layoutSubviews];
}

@end
