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

#define FAVS_KEY    @"group.appstud.sharingdata"

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
    
    NSUserDefaults * def = [[NSUserDefaults alloc] initWithSuiteName:FAVS_KEY];
    NSArray * temp = [def objectForKey:FAVS_KEY];
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
        [mFavs removeObject:[NSNumber numberWithInt:aIdent]];
    }
    else {
        [mFavs addObject:[NSNumber numberWithInt:aIdent]];
    }
    NSUserDefaults * def = [[NSUserDefaults alloc] initWithSuiteName:FAVS_KEY];
    [def setObject:[self favorites] forKey:FAVS_KEY];
}


- (BOOL)isFavorite:(int)aIdent {
    return ([mFavs indexOfObject:[NSNumber numberWithInt:aIdent]] != NSNotFound);
}

@end
