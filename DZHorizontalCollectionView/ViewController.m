//
//  ViewController.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "ViewController.h"
#import "DZHorizontalCollectionView.h"
#import "DZModel.h"
#import "DZCollectionViewCell.h"
#import "DZAdViewCell.h"
#import "DZAdModel.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *models;

@property (nonatomic,strong) DZHorizontalCollectionView *dzCollectionView;

@property (nonatomic,strong) NSMutableArray *carModels;

@property (nonatomic,strong) DZHorizontalCollectionView *dzADView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _models = [NSMutableArray array];
    _carModels = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < 8; i ++) {
        DZModel *model = [[DZModel alloc] init];
        model.age = i;
        model.name = [NSString stringWithFormat:@"name_%ld",(long)i];
        [_models addObject:model];
    }
    
    for (NSInteger i = 0; i < 8; i ++) {
        DZAdModel *adModel = [[DZAdModel alloc] init];
        adModel.carName = [NSString stringWithFormat:@"CarName_%ld",(long)i];
        [_carModels addObject:adModel];
    }
    
    [self.view addSubview:self.dzCollectionView];
    [self.dzCollectionView reloadData:self.models];
    
    [self.view addSubview:self.dzADView];
    [self.dzADView reloadData:self.carModels];
}

#pragma mark - lazy laod

- (DZHorizontalCollectionView *)dzCollectionView {
    if (!_dzCollectionView) {
        _dzCollectionView = [[DZHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 200) customCell:[DZCollectionViewCell class]];
        _dzCollectionView.margin = 10;
        _dzCollectionView.spacing = 20;
    }
    return _dzCollectionView;
}

- (DZHorizontalCollectionView *)dzADView {
    if (!_dzADView) {
        _dzADView = [[DZHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 200) customCell:[DZAdViewCell class]];
        CGFloat width = 100;
        _dzADView.itemWidth = width;
        _dzADView.margin = ([UIScreen mainScreen].bounds.size.width - width) / 2;
        _dzADView.spacing = 10;
        
    }
    return _dzADView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
