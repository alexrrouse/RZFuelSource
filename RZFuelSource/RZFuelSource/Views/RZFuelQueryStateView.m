//
//  RZStateSpinner.m
//  RZFuelSource
//
//  Created by bking on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZFuelQueryStateView.h"
#import <QuartzCore/QuartzCore.h>

@interface RZFuelQueryStateView()
@property (nonatomic, strong) UIImageView *nucleousImage;
@property (nonatomic, strong) UIImageView *orbitImage;

@property (nonatomic, assign) RZFuelQueryState currentState;
@end

@implementation RZFuelQueryStateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nucleousImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_atom_inner"]];
        self.orbitImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_atom_outer"]];
        
        [self addSubview:self.nucleousImage];
        [self addSubview:self.orbitImage];
    }
    return self;
}

- (void)animateTransform
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: -(M_PI * 2.0)];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    [self.orbitImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setState:(RZFuelQueryState)state animated:(BOOL)animated
{
    if (self.currentState == state) { return; }
    CGFloat initialSpring = state == RZFuelQueryStateWaiting ? 2 : 10;
    
    [UIView animateWithDuration:animated ? 1 : 0 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:initialSpring options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (state == RZFuelQueryStateWaiting) {
            self.orbitImage.transform = CGAffineTransformMakeScale(0.4, 0.4);
        } else {
            self.orbitImage.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {

    }];
    if (state == RZFuelQueryStateQueryActive) {
        [self animateTransform];
//    } else {
//        [self.orbitImage.layer removeAnimationForKey:@"rotationAnimation"];
    }
    self.currentState = state;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished && self.currentState == RZFuelQueryStateQueryActive) {
        [self animateTransform];
    }
}


@end
