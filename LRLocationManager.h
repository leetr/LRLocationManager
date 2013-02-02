//
//  LRLocationManager.h
//
//  Created by Denis Smirnov on 12-06-16.
//  Copyright (c) 2012 Leetr.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LRLocationManager : NSObject <CLLocationManagerDelegate>{
    
}

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

+ (LRLocationManager *)sharedInstance;
+ (CLLocationDistance)distanceTo:(CLLocation *)location;

- (void)addListener:(id<CLLocationManagerDelegate>)listener;
- (void)removeListener:(id<CLLocationManagerDelegate>)listener;

- (CLLocationDistance)distanceTo:(CLLocation *)location;
@end
