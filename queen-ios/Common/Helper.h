//
//  Helper.h
//  ConsumerApp
//
//  Created by Yip on 5/12/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define UNUSED(expr) do { (void)(expr); } while (0)

@interface Helper : NSObject
+(UIColor*)colorWithHexString:(NSString*)hex;
//+(NSString*)stringFromDate:(NSDate*)date;
//+(NSDate*)dateFromString:(NSString*)string;
//+(NSString*)formatDisplayDateWithStartTime:(NSDate*) startTime EndTime:(NSDate*) endTime HideYear:(BOOL)isHideYear;
//+(NSString*)getChartroomDateFormat:(NSDate*)date;
//
+(UIColor*) colorFromCustomIndex:(int)customIndex;
//+(NSString*) fontNameFromCustomIndex:(int)customIndex;
//+(float) fontSizeFromCustomIndex:(int)customIndex;
//
//+(CGSize) shadowOffset;
//+(float) shadowOpacity;
//+ (CLLocationDistance)distanceKmBetweenCoordinate:(CLLocationCoordinate2D)originCoordinate andCoordinate:(CLLocationCoordinate2D)destinationCoordinate ;

@end
