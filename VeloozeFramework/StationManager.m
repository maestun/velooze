//
//  StationManager.m
//  velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "StationManager.h"

static StationManager * sInstance =     nil;

#define BASE_URL                        @"https://api.jcdecaux.com/"
#define CONTRACT                        @"Toulouse"
#define STATIONS_URL                    @"vls/v1/stations?contract=__CONTRACT__&apiKey="
#define STATION_URL                     @"vls/v1/stations/__STATION__?contract=__CONTRACT__&apiKey="
#define JCD_API_KEY                     @"d8cfd0ae8eb4101c6bd46b95031811d1451ca147"

@implementation Station
@end


@implementation StationManager

+ (StationManager *)instance {
    if(sInstance == nil) {
        sInstance = [[StationManager alloc] init];
    }
    return sInstance;
}


- (Station *)getStation:(int)aIdent {
    Station * station = nil;
    for(station in [self stations]) {
        if([station ident] == aIdent) {
            break;
        }
    }
    return station;
}


- (void)loadStations:(id<StationManagerDelegate>)aDelegate {
    
    NSString * url =  [NSString stringWithFormat:@"%@%@%@", BASE_URL, STATIONS_URL, JCD_API_KEY];
    url = [url stringByReplacingOccurrencesOfString:@"__CONTRACT__" withString:CONTRACT];
    
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // obtained JSON array
        NSArray * json = (NSArray *)responseObject;
        NSMutableArray * temp = [NSMutableArray array];
        for(NSDictionary * dic in json) {
            [temp addObject: [self buildStation:dic]];
        }
        [self setStations:[NSArray arrayWithArray:temp]];
        
        
        
        [aDelegate onStationsLoadedWithError:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [aDelegate onStationsLoadedWithError:error];
    }];
}


- (void)updateStations:(int)aIdent withDelegate:(id<StationManagerDelegate>)aDelegate {
    
    NSString * url =  [NSString stringWithFormat:@"%@%@%@", BASE_URL, STATION_URL, JCD_API_KEY];
    url = [url stringByReplacingOccurrencesOfString:@"__CONTRACT__" withString:CONTRACT];
    url = [url stringByReplacingOccurrencesOfString:@"__STATION__" withString:[NSString stringWithFormat:@"%d", aIdent]];
    
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [aDelegate onStationUpdated:[self buildStation:responseObject] withError:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [aDelegate onStationUpdated:nil withError:error];
    }];
}


- (Station *)buildStation:(NSDictionary *)aJSON {
    Station * ret = nil;
    NSDictionary * pos = aJSON[@"position"];
    if (pos) {
        NSString * name = [aJSON[@"name"] componentsSeparatedByString:@" - "][1];
        NSString * status = aJSON[@"status"];
        NSString * address = aJSON[@"addres"];
        int number = [aJSON[@"number"] intValue];
        int total = [aJSON[@"bike_stands"] intValue];
        int available = [aJSON[@"available_bikes"] intValue];
        double lon = [pos[@"lng"] doubleValue];
        double lat = [pos[@"lat"] doubleValue];
        
        UIColor * color = COLOR_STATION_NORMAL;
        NSString * subtitle = [NSString stringWithFormat:@"Vélos disponibles: %d / %d", available, total];
        NSString * bikes = [NSString stringWithFormat:@"%d / %d", available, total];
        if([status isEqualToString:@"OPEN"] == NO) {
            color = COLOR_STATION_NOK;
            subtitle = @"Fermée";
        }
        else if(available == 0) {
            color = COLOR_STATION_EMPTY;
        }
        else if(available < 5) {
            color = COLOR_STATION_WEAK;
        }
        else if(available == total) {
            color = COLOR_STATION_FULL;
        }

        ret = [[Station alloc] init];
        [ret setColor:color];
        [ret setName:name];
        [ret setSubtitle:subtitle];
        [ret setAddress:address];
        [ret setBikes:bikes];
        [ret setStatus:status];
        [ret setCoord:CLLocationCoordinate2DMake(lat, lon)];
        [ret setIdent:number];
        [ret setAvailable:available];
        [ret setTotal:total];
    }
    return ret;
}

@end
