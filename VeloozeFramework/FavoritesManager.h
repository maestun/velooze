//
//  FavoritesManager.h
//  velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT @interface FavoritesManager : NSObject {
    NSMutableArray * mFavs;
}

+ (FavoritesManager *)instance;
- (NSArray *)favorites;
- (void)toggleFavorite:(int)aIdent;
- (BOOL)isFavorite:(int)aIdent;

@end
