//
//  RZViewController.m
//  RZFuelSource
//
//  Created by Stephen Barnes on 6/27/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZMapViewController.h"

// Model Data
#import "RZFuelType.h"

// Categories
#import "NSString+FuelType.h"
#import "UIImage+RZSnapshotHelpers.h"

// Utilities
#import "RZFuelSourceAppearance.h"

// Third Party
#import "REMenu.h"
#import "REMenuItem.h"

@interface RZMapViewController ()

@property (nonatomic, assign) RZFuelType  selectedFuelType;
@property (nonatomic, strong) REMenu      *dropdownMenu;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) NSArray     *fuelTypes;

@end

@implementation RZMapViewController

#pragma mark - Init Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _selectedFuelType = RZFuelTypeElectric;
}

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTitle:[[NSString shortDescriptionForFuelType:self.selectedFuelType] uppercaseString]];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"FUELTYPE" style:UIBarButtonItemStylePlain target:self action:@selector(fuelTypeFilterWithSender:)]];
}

#pragma mark - Overidden Properties

- (NSArray *)fuelTypes
{
    if (_fuelTypes == nil) {
        NSMutableArray *mutableFuelTypes = [[NSMutableArray alloc] initWithCapacity:kRZFuelTypeNumObjects];
        for (NSUInteger i = kRZFuelTypeFirstObject; i < kRZFuelTypeNumObjects; i++ ) {
            [mutableFuelTypes addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
        _fuelTypes = [mutableFuelTypes copy];
    }
    return _fuelTypes;
}

- (REMenu *)dropdownMenu
{
    if (_dropdownMenu == nil) {
        _dropdownMenu = [[REMenu alloc] initWithItems:[self dropDownItems]];
        [_dropdownMenu setCloseOnSelection:YES];
        [RZFuelSourceAppearance themeREMenu:_dropdownMenu];
    }
    return _dropdownMenu;
}

- (void)setSelectedFuelType:(RZFuelType)selectedFuelType
{
    [self removeBlur];
    _selectedFuelType = selectedFuelType;
    [self setTitle:[[NSString shortDescriptionForFuelType:selectedFuelType] uppercaseString]];
}

#pragma mark - Create Drop Down Items

- (NSArray *)dropDownItems
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:[[self fuelTypes] count]];
    
    __weak RZMapViewController *weakSelf = self;
    for (NSUInteger i = 0; i < [[self fuelTypes] count]; i++ ) {
        RZFuelType fuelTypeForItem = [[[self fuelTypes] objectAtIndex:i] unsignedIntegerValue];
        
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:[[NSString descriptionForFuelType:fuelTypeForItem] uppercaseString]
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [weakSelf setSelectedFuelType:item.tag];
                                                          
                                                      }];
        item.tag = fuelTypeForItem;
        [menuItems addObject:item];
    }
    
    return [menuItems copy];
}

#pragma mark - Blurring

- (void)removeBlur
{
    if (self.blurredImageView != nil) {
        [UIView animateWithDuration:0.3f animations:^{
            self.blurredImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.blurredImageView removeFromSuperview];
            self.blurredImageView = nil;
        }];
    }
}

- (void)blurAndAddView
{
    self.blurredImageView = [[UIImageView alloc] initWithImage:[UIImage rz_blurredImageByCapturingView:self.view afterScreenUpdate:NO withRadius:3.f tintColor:[UIColor colorWithWhite:0.5f alpha:0.5f] saturationDeltaFactor:0.75f]];
    self.blurredImageView.alpha = 0.f;
    [self.view addSubview:self.blurredImageView];
    [UIView animateWithDuration:0.3f animations:^{
        self.blurredImageView.alpha = 1.f;
    }];
}
     
#pragma mark - Actions
     
- (void)fuelTypeFilterWithSender:(id)sender
{
    if (![self.dropdownMenu isOpen]) {
        [self blurAndAddView];
        [self.dropdownMenu showFromNavigationController:self.navigationController];
    } else {
        __weak RZMapViewController *weakSelf = self;
        [self.dropdownMenu closeWithCompletion:^{
            [weakSelf removeBlur];
        }];
    }
}

@end
