//
//  StationManager.h
//  velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import <ChameleonFramework/Chameleon.h>
#import "Config.h"

@interface Station : NSObject

@property (retain, nonatomic) NSString *    name;
@property (retain, nonatomic) NSString *    subtitle;
@property (retain, nonatomic) NSString *    address;
@property (retain, nonatomic) NSString *    status;
@property (retain, nonatomic) NSString *    bikes;
@property (retain, nonatomic) UIColor *     color;
@property int                               ident;
@property int                               available;
@property int                               total;
@property CLLocationCoordinate2D            coord;

@end


@protocol StationManagerDelegate <NSObject>

@optional
- (void)onStationsLoadedWithError:(NSError *)aError;
- (void)onStationUpdated:(Station *)aStation withError:(NSError *)aError;
@end


@interface StationManager : NSObject {
    NSArray * mStations;
}

@property (strong, nonatomic) NSArray * stations;

+ (StationManager *)instance;
- (Station *)getStation:(int)aIdent;
- (void)loadStations:(id<StationManagerDelegate>)aDelegate;
- (void)updateStations:(int)aIdent withDelegate:(id<StationManagerDelegate>)aDelegate;
@end
