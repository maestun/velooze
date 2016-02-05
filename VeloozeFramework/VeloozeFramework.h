//
//  VeloozeFramework.h
//  VeloozeFramework
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationManager.h"
#import "FavoritesManager.h"


//! Project version number for VeloozeFramework.
FOUNDATION_EXPORT double VeloozeFrameworkVersionNumber;

//! Project version string for VeloozeFramework.
FOUNDATION_EXPORT const unsigned char VeloozeFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <VeloozeFramework/PublicHeader.h>

// ==========================================================================================
// COLORS : modify these colors if needed, beware of bad taste !!!
// ==========================================================================================
#define APP_COLOR               FlatRed

// ==========================================================================================
// FONTS : modify these fonts if needed, beware of the width !!!
// ==========================================================================================
#define __FONT_BASE                             @"AvenirNext"
#define __FONT_REGULAR                          @"-Regular"
#define __FONT_BOLD                             @"-DemiBold"
#define __FONT_LITE                             @"-UltraLight"
#define FONT_SZ_XLARGE                          26
#define FONT_SZ_LARGE                           20
#define FONT_SZ_MEDIUM                          16
#define FONT_SZ_SMALL                           12
#define FONT_SZ_XSMALL                          10
#define FONT(sz)                                [UIFont fontWithName:[NSString stringWithFormat:@"%@%@", __FONT_BASE, __FONT_REGULAR] size:(sz)]
#define FONT_BOLD(sz)                           [UIFont fontWithName:[NSString stringWithFormat:@"%@%@", __FONT_BASE, __FONT_BOLD] size:(sz)]
#define FONT_LITE(sz)                           [UIFont fontWithName:[NSString stringWithFormat:@"%@%@", __FONT_BASE, __FONT_LITE] size:(sz)]

