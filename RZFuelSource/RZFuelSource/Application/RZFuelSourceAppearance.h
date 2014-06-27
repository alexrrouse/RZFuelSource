//
//  RZFuelSourceAppearance.h
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class REMenu;

@interface RZFuelSourceAppearance : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (void)setDefaultThemes;
+ (void)themeREMenu:(REMenu *)menu;

@end
