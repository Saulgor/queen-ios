//
//  Helper.m
//  ConsumerApp
//
//  Created by Yip on 5/12/14.
//
//

#import "Helper.h"

@implementation Helper

/*
 for (NSString* family in [UIFont familyNames])
 {
 NSLog(@"%@", family);
 
 for (NSString* name in [UIFont fontNamesForFamilyName: family])
 {
 NSLog(@"  %@", name);
 }
 }
 
 OpenSans-Semibold
 OpenSans
 */
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

    if ([cString length] != 6) return  [UIColor grayColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//
//+(NSString *)stringFromDate:(NSDate *)date{
//
//    NSDateFormatter *dateFormatter = [[self class] defaultDateFormatter];
//
//    return [dateFormatter stringFromDate:date];
//}
//+(NSDate *)dateFromString:(NSString *)string{
//
//    NSDateFormatter *dateFormatter = [[self class] defaultDateFormatter];
//
//    return [dateFormatter dateFromString:string];
//}
//+(NSDateFormatter*)defaultDateFormatter{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
//    [dateFormatter setLocale:enUSPOSIXLocale];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
//    return dateFormatter;
//}
//+(NSString*)formatDisplayDateWithStartTime:(NSDate*) startTime EndTime:(NSDate*) endTime HideYear:(BOOL)isHideYear{
//
//    NSString* result = @"";
//
//    {
//        NSDateFormatter *uiDateFormatter = [[NSDateFormatter alloc] init];
//        //                 NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
//        //                 [uiDateFormatter setLocale:enUSPOSIXLocale];
//        if (isHideYear) {
//            [uiDateFormatter setDateFormat:@"M'月'd'日 'HH:mm'"];
//        } else{
//            [uiDateFormatter setDateFormat:@"yyyy'年'M'月'd'日 'HH:mm'"];
//        }
//
//        result = [result stringByAppendingString:[uiDateFormatter stringFromDate:startTime]];
//    }
//
//    {
//        NSDateFormatter *uiDateFormatter = [[NSDateFormatter alloc] init];
//        //                 NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
//        //                 [uiDateFormatter setLocale:enUSPOSIXLocale];
//        [uiDateFormatter setDateFormat:@"' - 'HH:mm'"];
//
//        result = [result stringByAppendingString: [uiDateFormatter stringFromDate:endTime]];
//    }
//
//    return result;
//}
//
//+(NSString*)getChartroomDateFormat:(NSDate*) date {
//    NSString* result = @"";
//
//    if (nil != date) {
//        
//        {
//            NSDateFormatter *uiDateFormatter = [[NSDateFormatter alloc] init];
//            //                 NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
//            //                 [uiDateFormatter setLocale:enUSPOSIXLocale];
//            [uiDateFormatter setDateFormat:@"yyyy'-'M'-'d' 'HH:mm'"];
//            
//            result = [result stringByAppendingString:[uiDateFormatter stringFromDate:date]];
//        }
//        
//
//    }
//    
//     return result;
//}
//
+(UIColor*) colorFromCustomIndex:(int)customIndex{

    UIColor * fontColor = [Helper colorWithHexString:@"22c064"];

    if(customIndex == 1){
        fontColor = [Helper colorWithHexString:@"1c1c1c"]; // black background
    }else if (customIndex ==2){
        fontColor = [Helper colorWithHexString:@"333333"]; // font black
    }else if (customIndex ==3){
        fontColor = [Helper colorWithHexString:@"FFFFFF"]; // white background
    }

    return fontColor;
}
//+(NSString*) fontNameFromCustomIndex:(int)customIndex{
//
//    NSString * fontName = @"STHeitiSC-Light";
//
//    if(customIndex == 1){
//        fontName = @"STHeitiSC-Medium";
//    }
//
//    return fontName;
//}
//+(float) fontSizeFromCustomIndex:(int)customIndex{
//    float fontSize = 12;
//
//    if(customIndex == 1){
//        fontSize = 14;
//    }else if(customIndex== 2){
//        fontSize = 16;
//    }else if(customIndex== 3){
//        fontSize = 19;
//    }
//
//    return fontSize;
//
//}
//+(CGSize) shadowOffset{
//    return CGSizeMake(0,0);
//}
//+(float) shadowOpacity{
//    return 0.15;
//}
//
//+ (CLLocationDistance)distanceKmBetweenCoordinate:(CLLocationCoordinate2D)originCoordinate andCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
//    CLLocation *originLocation = [[CLLocation alloc] initWithLatitude:originCoordinate.latitude longitude:originCoordinate.longitude];
//    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:destinationCoordinate.latitude longitude:destinationCoordinate.longitude];
//    CLLocationDistance distance = [originLocation distanceFromLocation:destinationLocation] / 1000.0;
//
//
//    return distance;
//}
@end
