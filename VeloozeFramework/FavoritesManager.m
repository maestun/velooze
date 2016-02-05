//
//  FavoritesManager.m
//  velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

//
//  FavoritesManager.m
//  velooze
//
//  Created by Olivier on 04/02/2016.
//  Copyright © 2016 maestun. All rights reserved.
//

#import "FavoritesManager.h"

#define FAVS_KEY    @"FAVS_KEY"

static FavoritesManager * sInstance = nil;

@implementation FavoritesManager

+ (FavoritesManager *)instance {
    if(sInstance == nil) {
        sInstance = [[FavoritesManager alloc] init];
    }
    return sInstance;
}


- (instancetype)init {
    self = [super init];
    NSArray * temp = [[NSUserDefaults standardUserDefaults] objectForKey:FAVS_KEY];
    if(temp == nil) {
        temp = [NSArray array];
    }
    mFavs = [NSMutableArray arrayWithArray:temp];
    return self;
}


- (NSArray *)favorites {
    return [NSArray arrayWithArray:mFavs];
}


- (void)toggleFavorite:(int)aIdent {
    if([self isFavorite:aIdent]) {
        [mFavs removeObjectIdenticalTo:[NSNumber numberWithInt:aIdent]];
    }
    else {
        [mFavs addObject:[NSNumber numberWithInt:aIdent]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[self favorites] forKey:FAVS_KEY];
}


- (BOOL)isFavorite:(int)aIdent {
    return ([mFavs indexOfObject:[NSNumber numberWithInt:aIdent]] != NSNotFound);
}

@end
