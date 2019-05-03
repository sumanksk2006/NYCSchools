//
//  MapKitViewController.h
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/3/19.
//  Copyright © 2019 My Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapKitViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *schoolName;
@property (strong, nonatomic) NSString *primaryAddress;
@property (assign, nonatomic) CLLocationCoordinate2D schoolLocation;
@end

NS_ASSUME_NONNULL_END
