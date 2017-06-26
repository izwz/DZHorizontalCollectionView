//
//  ViewController.m
//  DZHorizontalCollectionView
//
//  Created by zwz on 2017/6/22.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import "ViewController.h"
#import "DZHorizontalCollectionView.h"
#import "DZBannerModel.h"
#import "DZBannerView.h"
#import "DZAdView.h"
#import "DZAdModel.h"

@interface ViewController ()<DZHorizontalCollectionViewDataSource,DZHorizontalCollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *bannerModels1;

@property (nonatomic,strong) DZHorizontalCollectionView *banner1;

@property (nonatomic,strong) NSMutableArray *bannerModels2;

@property (nonatomic,strong) DZHorizontalCollectionView *banner2;

@property (nonatomic,strong) NSMutableArray *adModels1;

@property (nonatomic,strong) DZHorizontalCollectionView *aDView1;

@property (nonatomic,strong) NSMutableArray *adModels2;

@property (nonatomic,strong) DZHorizontalCollectionView *aDView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _bannerModels1 = [NSMutableArray array];
    _bannerModels2 = [NSMutableArray array];
    _adModels1 = [NSMutableArray array];
    _adModels2 = [NSMutableArray array];
    
    
    for (NSInteger i = 0 ; i < 5; i ++) {
        DZBannerModel *model = [[DZBannerModel alloc] init];
        model.age = i;
        model.name = [NSString stringWithFormat:@"banner_%ld",(long)i];
        [_bannerModels1 addObject:model];
    }
    for (NSInteger i = 0 ; i < 5; i ++) {
        DZBannerModel *model = [[DZBannerModel alloc] init];
        model.age = i;
        model.name = [NSString stringWithFormat:@"banner_%ld",(long)i];
        [_bannerModels2 addObject:model];
    }
    
    for (NSInteger i = 0; i < 5; i ++) {
        DZAdModel *adModel = [[DZAdModel alloc] init];
        adModel.carName = [NSString stringWithFormat:@"ad_%ld",(long)i];
        [_adModels1 addObject:adModel];
    }
    
    for (NSInteger i = 0; i < 8; i ++) {
        DZAdModel *adModel = [[DZAdModel alloc] init];
        adModel.carName = [NSString stringWithFormat:@"ad_%ld",(long)i];
        [_adModels2 addObject:adModel];
    }
    
    [self.view addSubview:self.banner1];
    [self.view addSubview:self.banner2];
    [self.view addSubview:self.aDView1];
    [self.view addSubview:self.aDView2];
    
    [self performSelector:@selector(test) withObject:nil afterDelay:3];
    
}

#pragma mark - DZHorizontalCollectionViewDelegate

- (void)dzCollectionView:(DZHorizontalCollectionView *)dzCollectionView didSelectItemAtIndex:(NSInteger)index {
    if (dzCollectionView == _banner1) {
        
    }else if (dzCollectionView == _banner2) {
        
    }else if (dzCollectionView == _aDView1) {
        
    }else if (dzCollectionView == _aDView2) {
        
    }
}

#pragma mark - DZHorizontalCollectionViewDataSource

- (NSArray *)contentModelsForDzCollectionView:(DZHorizontalCollectionView *)dzCollectionView {
    if (dzCollectionView == _banner1) {
        return self.bannerModels1;
    }else if (dzCollectionView == _banner2) {
        return self.bannerModels2;
    }else if (dzCollectionView == _aDView1) {
        return self.adModels1;
    }else if (dzCollectionView == _aDView2) {
        return self.adModels2;
    }
    return nil;
}

- (UIView *)contentViewForDzCollectionView:(DZHorizontalCollectionView *)dzCollectionView {
    if (dzCollectionView == _banner1) {
        DZBannerView *view = [[DZBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
        [dzCollectionView registerViewClass:[DZBannerView class] refreshMthod:@selector(setModel:)];
        return view;
    }else if (dzCollectionView == _banner2) {
        DZBannerView *view = [[DZBannerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80, 120)];
        [dzCollectionView registerViewClass:[DZBannerView class] refreshMthod:@selector(setModel:)];
        return view;
    }else if (dzCollectionView == _aDView1) {
        DZAdView *view = [[DZAdView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 60 * 2, 120)];
        [dzCollectionView registerViewClass:[DZAdView class] refreshMthod:@selector(setModel:)];
        return view;
    }else if (dzCollectionView == _aDView2) {
        DZAdView *view = [[DZAdView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 140 * 2, 120)];
        [dzCollectionView registerViewClass:[DZAdView class] refreshMthod:@selector(setModel:)];
        return view;
    }
    return nil;
}

#pragma mark - lazy laod

- (DZHorizontalCollectionView *)banner1 {
    if (!_banner1) {
        _banner1 = [[DZHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 120)];
        _banner1.margin = 0;
        _banner1.infinite = YES;
        _banner1.spacing = 0;
        _banner1.delegate = self;
        _banner1.dataSource = self;
    }
    return _banner1;
}

- (DZHorizontalCollectionView *)banner2 {
    if (!_banner2) {
        _banner2 = [[DZHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 120)];
        _banner2.margin = 40;
//        _banner2.infinite = YES;
        _banner2.spacing = 10;
        _banner2.delegate = self;
        _banner2.dataSource = self;
    }
    return _banner2;
}

- (DZHorizontalCollectionView *)aDView1 {
    if (!_aDView1) {
        _aDView1 = [[DZHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, 120)];
        CGFloat margin = 60;
        _aDView1.style = DZHorizontalCollectionViewStyleCoverflow;
//        _aDView1.infinite = YES;
        _aDView1.itemWidth = [UIScreen mainScreen].bounds.size.width - margin * 2;
        _aDView1.margin = margin;
        _aDView1.spacing = 0;
        _aDView1.delegate = self;
        _aDView1.dataSource = self;
    }
    return _aDView1;
}

- (DZHorizontalCollectionView *)aDView2 {
    if (!_aDView2) {
        _aDView2 = [[DZHorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 500, [UIScreen mainScreen].bounds.size.width, 120)];
        CGFloat margin = 140;
        _aDView2.style = DZHorizontalCollectionViewStyleCoverflow;
        _aDView2.infinite = YES;
        _aDView2.itemWidth = [UIScreen mainScreen].bounds.size.width - margin * 2;
        _aDView2.margin = margin;
        _aDView2.spacing = 0;
        _aDView2.minScale = 0.7;
        _aDView2.delegate = self;
        _aDView2.dataSource = self;
    }
    return _aDView2;
}

- (void)test {
//    [_banner1 setCurrentIndex:3 animated:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
