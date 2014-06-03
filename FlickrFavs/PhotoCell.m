//
//  PhotoCell.m
//  FlickrFavs
//
//  Created by Vik Denic on 6/2/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

@end
