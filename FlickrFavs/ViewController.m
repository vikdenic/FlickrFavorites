//
//  ViewController.m
//  FlickrFavs
//
//  Created by Vik Denic on 6/2/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"
#import "FavoritesViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSString *searchedText;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSMutableArray *photosArray;
@property NSMutableArray *favoritesArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.photosArray = [[NSMutableArray alloc]init];
    self.favoritesArray = [[NSMutableArray alloc]init];

    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

-(void)getPhotosArray:(NSString *)searchTerm
{
    {
        // Retreives photos from Flickr API via user's custom search term
        NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=467efe39db0425dcccde0a74c2a7e8a9&tags=%@&per_page=10&format=json&nojsoncallback=1", searchTerm];

        NSURL *url  = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSDictionary *returnedResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

             NSArray *tempArray = [[returnedResults objectForKey:@"photos"] objectForKey:@"photo"];

             // Resets images displayed in collectionView upon new search
             [self.photosArray removeAllObjects];

             for (NSDictionary *dictionary in tempArray)
             {
                 NSString *farm = [dictionary objectForKey:@"farm"];
                 NSString *server = [dictionary objectForKey:@"server"];
                 NSString *ident = [dictionary objectForKey:@"id"];
                 NSString *secret = [dictionary objectForKey:@"secret"];

                 NSString *imageURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_m.jpg",farm, server, ident, secret];
                 NSURL *imageURL = [NSURL URLWithString:imageURLString];
                 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];

                 [self.photosArray addObject:image];
                 [self.collectionView reloadData];
             }
         }];
    }
}

#pragma mark - Delegates
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchedText = self.searchBar.text;
    [self getPhotosArray:self.searchedText];
    [self.searchBar resignFirstResponder];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.imageView.image = [self.photosArray objectAtIndex:indexPath.row];

    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Gets width of screen
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, 120.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *photo = [self.photosArray objectAtIndex:indexPath.row];
    [self.favoritesArray addObject:photo];
    NSLog(@"Item selected");
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSIndexPath *selectedIndexPath = self.collectionView.indexPathsForSelectedItems;
//    FavoritesViewController *favVC = segue.destinationViewController;
//    favVC.savedFavoritesArray = self.favoritesArray;
//}

@end
