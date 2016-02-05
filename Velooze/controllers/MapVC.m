//
//  MapVC.m
//  Velooze
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 AppStud. All rights reserved.
//

#import "MapVC.h"


#define TIMER_INTERVAL_SEC      (5.0 * 60)
#define MAX_ANNOTATIONS         100
#define DEFAULT_ZOOM_OUT        10000
#define DEFAULT_CAMERA_TARGET   CLLocationCoordinate2DMake(43.605340, 1.444727) // Capitole

static volatile BOOL sSyncing = NO;


@implementation StationAnnotation

- (instancetype)initWithStation:(Station *)aStation {
    self = [super init];
    [self setStation:aStation];
    [self setCoordinate:[aStation coord]];
    [self setTitle:[aStation name]];
    [self setSubtitle:[aStation subtitle]];
    return self;
}

@end

@implementation StationAnnotationView
- (instancetype)initWithFrame:(CGRect)frame; {
    self = [super initWithFrame:frame];
    
    
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
    [[[self navigationController] navigationBar] setTintColor:FlatWhite]; // change la teinte du bouton "< Back"
    [[[self navigationController] navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: FlatWhite, NSForegroundColorAttributeName, FONT_BOLD(FONT_SZ_MEDIUM), NSFontAttributeName,nil]];

    
    MKMapCamera * cam = [MKMapCamera cameraLookingAtCenterCoordinate:DEFAULT_CAMERA_TARGET fromDistance:DEFAULT_ZOOM_OUT pitch:0 heading:0];
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
    MKMapCamera * cam = [MKMapCamera cameraLookingAtCenterCoordinate:[loc coordinate] fromDistance:DEFAULT_ZOOM_OUT pitch:0 heading:0];
    [[self mkMap] setCamera:cam animated:YES];
        // TODO: zoom level
    [mLocationManager stopUpdatingLocation];
}


// ==========================================================================
#pragma mark - MKMapViewDelegate
// ==========================================================================
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self refreshMarks];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    
        StationAnnotation * ann = (StationAnnotation *)annotation;
        
        static NSString * defaultPinID = @"velooze";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    
    
        if ( pinView == nil ) {

            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:defaultPinID];
        
            pinView.canShowCallout = YES;
        }
            UIImage * img = [ACUtils tintedImageWithColor:[[ann station] color] image:[UIImage imageNamed:@"pin.png"]];
            UIImageView * iv = [[UIImageView alloc] initWithImage: [ACUtils imageWithImage:img scaledToSize:CGSizeMake(48, 48)]];

            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
            [label setText:[NSString stringWithFormat:@"%d", [[ann station] available]]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:FONT(FONT_SZ_MEDIUM)];
            [label setTextColor:FlatWhite];
            
            [iv addSubview:label];
            pinView.image = [ACUtils imageWithView:iv];
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchUpInside];
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            pinView.rightCalloutAccessoryView = rightButton;
            pinView.canShowCallout = YES;
            pinView.draggable = YES;
            
    

    return pinView;
}


- (void)toggleFavorite:(id)aSender {
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

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
    int index = 0;
    for(Station * station in [[StationManager instance] stations]) {
        if(MKMapRectContainsPoint([[self mkMap] visibleMapRect], MKMapPointForCoordinate([station coord]))) {
            if(index++ < MAX_ANNOTATIONS) {
                StationAnnotation * pa = [[StationAnnotation alloc] initWithStation:station];
                [[self mkMap] addAnnotation:pa];
            }
            else {
                break;
            }
        }
    }
}


- (void)showStation:(int)aIdent {
    for(Station * station in [[StationManager instance] stations]) {
        if([station ident] == aIdent) {
            MKMapCamera * cam = [MKMapCamera cameraLookingAtCenterCoordinate:[station coord] fromDistance:DEFAULT_ZOOM_OUT pitch:0 heading:0];
            [[self mkMap] setCamera:cam animated:YES];
            break;
        }
    }
}

@end
