//
//  ViewController.m
//  CoreLocation
//
//  Created by David Mills on 2019-05-17.
//  Copyright © 2019 David Mills. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  [self.locationManager requestWhenInUseAuthorization];

  [self.locationManager startUpdatingLocation];

  [self.mapView registerClass:MKPinAnnotationView.class forAnnotationViewWithReuseIdentifier:@"pin"];
}

- (CLLocationManager *)locationManager {
  if (!_locationManager) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    _locationManager.delegate = self;
  }

  return _locationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  CLLocation *location = locations[0];

  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  annotation.coordinate = location.coordinate;

  [self.mapView addAnnotation:annotation];

  MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.005, 0.005));

  [self.mapView setRegion:region animated:YES];

  NSLog(@"Location updated: %@", location);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusDenied:
      NSLog(@"Authorization denied");
      break;
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      NSLog(@"Authorization allowed");
      break;
    case kCLAuthorizationStatusNotDetermined:
      NSLog(@"I don't know if you have access yet");
      break;
    default:
      break;
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation isKindOfClass:MKUserLocation.class]) {
    return nil;
  }

  MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin" forAnnotation:annotation];

  pin.pinTintColor = UIColor.yellowColor;

  return pin;
}


@end
