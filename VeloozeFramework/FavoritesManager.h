//
//  FavoritesManager.h
//  velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 maestun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

FOUNDATION_EXPORT @interface FavoritesManager : NSObject {
    NSMutableArray * mFavs;
}

+ (FavoritesManager *)instance;
- (NSArray *)favorites;
- (void)toggleFavorite:(int)aIdent;
- (BOOL)isFavorite:(int)aIdent;

@end

