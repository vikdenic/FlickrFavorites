//
//  FavoritesViewController.m
//  FlickrFavs
//
//  Created by Vik Denic on 6/2/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "FavoritesViewController.h"
#import "PhotoCell.h" 

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.savedFavoritesArray = [[NSMutableArray alloc]init];
}



@end
