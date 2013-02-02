//
//  LRLocationManager.m
//
//  Created by Denis Smirnov on 12-06-16.
//  Copyright (c) 2012 Leetr.com. All rights reserved.
//

#import "LRLocationManager.h"

@interface LRLocationManager () {
    NSMutableArray *_listeners;
    CLLocationManager *_locationManager;
    BOOL _isUpdatingLocation;
}

- (void)bump;

@end

@implementation LRLocationManager

@synthesize currentLocation = _currentLocation;

//
+ (LRLocationManager *)sharedInstance
{
    static LRLocationManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

+ (CLLocationDistance)distanceTo:(CLLocation *)location
{
    return [[LRLocationManager sharedInstance] distanceTo:location];
}

//
- (id)init
{
    self = [super init];
    
    if (self) {
        _listeners = [[NSMutableArray alloc] init];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _currentLocation = nil;
    }
    
    return self;
}

//
- (void)dealloc
{
    [_listeners release];
    [_locationManager release];
    
    if (_currentLocation != nil) {
        [_currentLocation release];
    }
    
    [super dealloc];
}

//
- (void)bump
{
    if (_listeners.count == 0 && _isUpdatingLocation) {
        [_locationManager stopUpdatingLocation];
        _isUpdatingLocation = NO;
    } else if (!_isUpdatingLocation){
        [_locationManager startUpdatingLocation];
        _isUpdatingLocation = YES;
    }
}

//
- (void)addListener:(id<CLLocationManagerDelegate>)listener
{
    if (listener != nil) {
        [_listeners addObject:listener];
    }
    
    [self bump];
}

//
- (void)removeListener:(id<CLLocationManagerDelegate>)listener
{
    if (listener != nil) {
        [_listeners removeObject:listener];
    }
    
    [self bump];
}

- (CLLocationDistance)distanceTo:(CLLocation *)location
{
    if (_currentLocation == nil || location == nil) {
        return NAN;
    }
    
    return [_currentLocation distanceFromLocation:location];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (_currentLocation != newLocation) {
        if (_currentLocation != nil) {
            [_currentLocation release];
            _currentLocation = nil;
        }
        
        _currentLocation = newLocation;
        
        if (_currentLocation != nil) {
            [_currentLocation retain];
        }
    }
    
    for (id listener in _listeners) {
        if ([listener conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {
            [listener locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        }
    }
}

@end
