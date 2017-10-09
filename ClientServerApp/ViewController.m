//
//  ViewController.m
//  ClientServerApp
//
//  Created by supermacho on 09.10.17.
//  Copyright © 2017 student. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray* personsArray;
@end

@implementation ViewController
static NSInteger personsInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.personsArray = [NSMutableArray array];
    [self getPersonsFromServer];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API 

- (void) getPersonsFromServer {
    [[ServerManager sharedManager] getPersonsWithOffset:[self.personsArray count]
count:personsInRequest
onSuccess:^(NSArray *persons) {
    [self.personsArray addObjectsFromArray:persons];
    
    NSMutableArray* newPath = [NSMutableArray array];
    for (int i = (int)[self.personsArray count] - (int)[persons count]; i < [self.personsArray count]; i++) {
        [newPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}
inFailure:^(NSError *error, NSInteger statusCode) {
    NSLog(@"ERROR = %@, code = %ld", [error localizedDescription], statusCode);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.personsArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == [self.personsArray count]) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
        
    }else {
        User* person = [self.personsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
        NSURLRequest* request = [NSURLRequest requestWithURL:person.imageUrl];
        __weak UITableViewCell* weakCell = cell;
        cell.imageView.image = nil;
        [self maskImage:cell.imageView.image withMask:nil];
        [cell.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       weakCell.imageView.image = image;
                                       
                                       CALayer *mask = [CALayer layer];
                                       mask.contents = (id)[[UIImage imageNamed:@"mask.png"] CGImage];
                                       mask.frame = CGRectMake(0, 0, 15, 15);
                                       weakCell.imageView.layer.mask = mask;
                                       weakCell.imageView.layer.masksToBounds = YES;
                                       [weakCell layoutSubviews];
                                   } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       
                                   }];
    }
    return cell;
    
}
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    CGImageRelease(maskedImageRef);
    CGImageRelease(mask);
    return maskedImage;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.personsArray count]) {
        [self getPersonsFromServer];
    }
}

@end
