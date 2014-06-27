//
//  RZStateSpinner.h
//  RZFuelSource
//
//  Created by bking on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RZFuelQueryStateWaiting,
    RZFuelQueryStateQueryActive,
    RZFuelQueryStateIsGood
} RZFuelQueryState;

@interface RZFuelQueryStateView : UIView

- (void)setState:(RZFuelQueryState)state animated:(BOOL)animated;

@end
