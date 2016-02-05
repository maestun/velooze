//
//  MapVC.m
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "MapVC.h"


#define TIMER_INTERVAL_SEC      (5.0 * 60)
#define MAX_ANNOTATIONS         10
#define DEFAULT_ZOOM_OUT        5
#define DEFAULT_CAMERA_TARGET   CLLocationCoordinate2DMake(43.605340, 1.444727) // Capitole

static volatile BOOL sSyncing = NO;


@implementation StationAnnotation

- (instancetype)initWithStation:(Station *)aStation {
    self = [super init];
    
    
    
    return self;
}

@end


@implementation MapVC


- (void)viewDidLoad {
    [super viewDidLoad];

    // bouton "sync"
    UIButton * sync = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    UIImage * img = [UIImage imageNamed: @"icon_refresh"];
    img = [ACUtils tintedImageWithColor:FlatWhite image:img];
    [sync setBackgroundImage:img forState:UIControlStateNormal];
    [sync addTarget:self action:@selector(onRefreshClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sync]];

    
    // bouton "menu"
    UIButton * menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    img = [UIImage imageNamed: @"icon_menu"];
    img = [ACUtils tintedImageWithColor:FlatWhite image:img];
    [menu setBackgroundImage:img forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(onMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:menu]];
    
    // change la couleur de fond de la barre
    [[[self navigationController] navigationBar] setBarTintColor:APP_COLOR];
    
    // change le titre de la barre
    [[self navigationItem] setTitle:@"Vélooze !"];
    
    MKMapCamera * cam = [MKMapCamera cameraLookingAtCenterCoordinate:DEFAULT_CAMERA_TARGET fromDistance:1.0 pitch:0 heading:0];
    [[self mkMap] setCamera:cam animated:YES];
    [[self mkMap] setDelegate:self];
    [[self mkMap] setShowsUserLocation:YES];
    
    [[self btLocate] setImage:[ACUtils tintedImageWithColor:APP_COLOR image:[UIImage imageNamed:@"define_location"]] forState:UIControlStateNormal];
    
    [mLocationManager setDelegate:self];
    [mLocationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [mLocationManager requestWhenInUseAuthorization];
    [mLocationManager startUpdatingLocation];
    [mLocationManager startUpdatingHeading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self onRefreshClicked:nil];
    NSTimer * t = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL_SEC target:self selector:@selector(onRefreshClicked:) userInfo:nil repeats:YES];
    [t fire];
}


- (void)onRefreshClicked:(id)sender {
    if(sSyncing == NO) {
        [self rotateSyncButton];
        [[StationManager instance] loadStations:self];
    }
}


- (void)onMenuClicked:(id)sender {
    [[self sideMenuViewController] presentLeftMenuViewController];
}

- (IBAction)onLocateClicked:(id)sender {
    [mLocationManager startUpdatingLocation];
    [mLocationManager startUpdatingHeading];
}


-(void) rotateSyncButton {
    sSyncing = YES;
    UIView * bt = [[[self navigationItem] rightBarButtonItem] customView];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bt setTransform:CGAffineTransformMakeRotation(M_PI)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [bt setTransform:CGAffineTransformMakeRotation(0)];
        } completion:^(BOOL finished) {
            if(sSyncing) {
                [self rotateSyncButton];
            }
        }];
    }];
}


// ==========================================================================
#pragma mark - CLLocationManagerDelegate
// ==========================================================================
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // TODO:
    NSLog(@"Error %@", error);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation * loc = locations[0];
    MKMapCamera * cam = [MKMapCamera cameraLookingAtCenterCoordinate:[loc coordinate] fromDistance:1.0 pitch:0 heading:0];
    [[self mkMap] setCamera:cam animated:YES];
        // TODO: zoom level
    [mLocationManager stopUpdatingLocation];
}


// ==========================================================================
#pragma mark - MKMapViewDelegate
// ==========================================================================



// ==========================================================================
#pragma mark - Data Sync
// ==========================================================================
- (void)onStationsLoadedWithError:(NSError *)aError {
    sSyncing = NO;
    if(aError == nil) {
        [self refreshMarks];
    }
}


- (void)onStationUpdated:(Station *)aStation withError:(NSError *)aError {
    
}


- (void)refreshMarks {
    
    [[self mkMap] removeAnnotations:[[self mkMap] annotations]];
    
//    // dirty patch !!
//    if(StationLoader.instance().getStations().count == 0) {
//        self .refreshData();
//        return;
//    }

    int index = 0;
    for(Station * station in [[StationManager instance] stations]) {
        if(MKMapRectContainsPoint([[self mkMap] visibleMapRect], MKMapPointForCoordinate([station coord]))) {
            if(index++ < MAX_ANNOTATIONS) {
                MKPointAnnotation * pa = [[MKPointAnnotation alloc] init];
                [pa setCoordinate:[station coord]];
                [pa setTitle:[station name]];
                [pa setSubtitle:[station subtitle]];
                
                [[self mkMap] addAnnotation:pa];
            }
            else {
                break;
            }
        }
    }
//    
//    for station in StationLoader.instance().getStations() { //(var index = 0; index < MAX_RESULTS;) {
//        let bounds:GMSCoordinateBounds = GMSCoordinateBounds(region: self.mkMapView.projection.visibleRegion());
//        if(bounds.containsCoordinate(station.coords)) {
//            if(index++ > MAX_RESULTS) {
//                // dirty
//                return;
//            }
//            
//            var color:UIColor = station.avail_bikes > 0 ? (station.avail_bikes > 4 ? Config.StationColorNormal() : Config.StationColorWeak()) : Config.StationColorEmpty()
//            
//            
//            if(station.avail_bikes == station.total_bikes) {
//                color = Config.StationColorFull()
//            }
//            
//            // build pin icon from custom UIView
//            let mrk:BikeMarkerView = NSBundle.mainBundle().loadNibNamed("BikeViews", owner: self, options: nil)[1] as! BikeMarkerView
//            
//            
//            if(FavoritesManager.instance().isFavorite( station.num_station) == true) {
//                mrk.ivPin.image = Utils.tintedImageWithColor(color, fromImage: UIImage(named: "heart")!)
//                mrk.ivContour.image = Utils.tintedImageWithColor(FlatRed(), fromImage: UIImage(named: "heart_contour")!)
//                mrk.lbFreeBikes.frame = CGRectOffset(mrk.lbFreeBikes.frame, 0, 5);
//            }
//            else {
//                mrk.ivPin.image = Utils.tintedImageWithColor(color, fromImage: UIImage(named: "pin")!)
//                mrk.ivContour.image = UIImage(named: "pin_contour")!
//            }
//            
//            if(station.status == "OPEN") {
//                // TODO: optim chargement images
//                mrk.lbFreeBikes.text = String(station.avail_bikes!)
//            }
//            else {
//                // TODO: optim chargement images
//                mrk.ivPin.image = Utils.tintedImageWithColor(Config.StationColorNOK(), fromImage: UIImage(named: "pin")!)
//                mrk.lbFreeBikes.text = "HS"
//            }
//            
//            let marker = BikeMarker(station: station);
//            marker.map = self.mkMapView
//            marker.color = color
//            marker.icon = Utils.imageFromView(mrk)
//        }
//    }

}


- (void)showStation:(int)aIdent {
    
}

@end
