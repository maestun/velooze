//
//  MapVC.h
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VeloozeFramework.h"
#import "ACUtils.h"
#import <RESideMenu/RESideMenu.h>


@interface StationAnnotation : MKPointAnnotation
@property (weak, nonatomic) Station *station;
@end

@interface StationAnnotationView : MKAnnotationView
@end


@interface MapVC : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, StationManagerDelegate> {
    CLLocationManager * mLocationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mkMap;
@property (weak, nonatomic) IBOutlet UIButton *btLocate;
- (IBAction)onLocateClicked:(id)sender;

- (void)showStation:(int)aIdent;

@end
