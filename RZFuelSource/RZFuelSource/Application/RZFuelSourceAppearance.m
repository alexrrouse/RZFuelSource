//
//  RZFuelSourceAppearance.m
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZFuelSourceAppearance.h"

// Categories
#import "UIColor+fuelSourceColors.h"

// Third Party
#import "REMenu.h"

@implementation RZFuelSourceAppearance

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)setStatusBarLight:(BOOL)light
{
    [[UIApplication sharedApplication] setStatusBarStyle:(light ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault)];
}

+ (void)setDefaultThemes
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[RZFuelSourceAppearance imageWithColor:[UIColor raizlabsRed]] forBarMetrics:UIBarMetricsDefault];
    
    // NOTE: reduced font size to 20 from 22 because at 22 "g"s are cut off
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont systemFontOfSize:18.f], NSFontAttributeName,
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          nil]];
}

+ (void)themeREMenu:(REMenu *)menu
{
    menu.shadowColor = [UIColor clearColor];
    menu.borderWidth = 0.f;
    menu.borderColor = [UIColor clearColor];
    menu.highlightedTextColor = [UIColor whiteColor];
    menu.highlightedSeparatorColor = [UIColor grayColor];
    menu.highlightedTextShadowColor = [UIColor clearColor];
    menu.highlightedBackgroundColor = [UIColor colorWithRed:180.f/255.f green:69.f/255.f blue:59.f/255.f alpha:1.f];
    menu.backgroundColor = [UIColor raizlabsRed];
    menu.separatorColor = [UIColor whiteColor];
    menu.separatorHeight = 0.5f;
    menu.textShadowColor = [UIColor clearColor];
    menu.textColor = [UIColor whiteColor];
    menu.font = [UIFont systemFontOfSize:18.f];
}

@end
