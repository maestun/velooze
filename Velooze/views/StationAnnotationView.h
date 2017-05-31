//
//  StationAnnotationView.h
//  Velooze
//
//  Created by Olivier on 07/02/2016.
//  Copyright © 2016 maestun. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ACUtils.h"
#import "VeloozeFramework.h"


@interface StationAnnotationView : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIImageView *ivPin;
@property (weak, nonatomic) IBOutlet UIImageView *ivFav;
@property (weak, nonatomic) IBOutlet UILabel *lbBikes;
- (void)setStation:(Station *)aStation;
@end
