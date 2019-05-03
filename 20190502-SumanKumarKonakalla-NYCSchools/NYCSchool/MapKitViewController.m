//
//  MapKitViewController.m
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/3/19.
//  Copyright © 2019 My Org. All rights reserved.
//

#import "MapKitViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface MapKitViewController  () <MKMapViewDelegate,CLLocationManagerDelegate>
    @property (strong,nonatomic) CLLocationManager *locationMgr;
@end

@implementation MapKitViewController
@synthesize mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MAP Route";
    MKCoordinateRegion region = MKCoordinateRegionMake(self.schoolLocation, MKCoordinateSpanMake(0.02, 0.02));
    [self.mapView setRegion:region animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.schoolLocation;
    annotation.title = self.schoolName ;
    annotation.subtitle = [self.primaryAddress stringByReplacingOccurrencesOfString:@"\n" withString:@","] ;
    //Add Annotation for School Location
    [self.mapView addAnnotation:annotation];
    [self.mapView setShowsUserLocation:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.delegate = self;
    [self.locationMgr requestWhenInUseAuthorization];
    [self.locationMgr requestLocation];
    [self.locationMgr startUpdatingLocation];
}

//Generate Random Color for direction route
-(UIColor *) generateRandomColor {
    
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

//Request Directions
-(void)getDirections{
  
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.mapView.userLocation.coordinate]];
    request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.schoolLocation]];
    request.requestsAlternateRoutes = YES;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * response,NSError *error){
        if (error){
            return;
        }
        //Draw polyline for Route
        for (MKRoute *route in response.routes) {
            [self.mapView addOverlay:route.polyline];
            [self.mapView setVisibleMapRect:[self.mapView mapRectThatFits:route.polyline.boundingMapRect] animated:YES];
        }
    }];
    
}
#pragma mark - MKMapView
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [self generateRandomColor];
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DROP_PIN"];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    if (annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude){
        [pinView setPinTintColor:[UIColor blueColor]];
    }
    return pinView;
}
#pragma mark - LocationManager
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self getDirections];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"error %@",error.localizedDescription);
}


@end
