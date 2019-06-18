//
//  LXFBrowserViewController.m
//  KDSLife
//
//  Created by PChome on 2017/3/22.
//
//

#import "LXF_BrowserViewController.h"
#import "LXF_BrowserCollectionViewCell.h"

#import "LXF_config.h"

@interface LXF_BrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong) NSArray *thumbArr;

@property (nonatomic, assign) BOOL isHideNaviBar;

@property (nonatomic, assign) NSInteger initIndex;


@end

@implementation LXF_BrowserViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [self removeObserver:self forKeyPath:@"initIndex"];
}

- (instancetype)initWithPhotosArr:(NSArray *)photosArr andThumbArr:(NSArray *)thumbArr andIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        if (photosArr) {
            self.photosArr = [NSArray arrayWithArray:photosArr];
        }
        if (thumbArr) {
            self.thumbArr = [NSArray arrayWithArray:thumbArr];
        }
        self.initIndex = index;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentIndex"]) {
        [self.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld", (long)self.currentIndex + 1, (long)self.photosArr.count]];
        return;
    }
    if ([keyPath isEqualToString:@"initIndex"]) {
        [self.indexLabel setText:[NSString stringWithFormat:@"%ld/%ld", (long)self.initIndex + 1, (long)self.photosArr.count]];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configCollectionView];
    [self configIndexLabel];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"initIndex" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if (self.photosArr.count > self.initIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.initIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)configCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentOffset = CGPointMake(0, 0);
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.photosArr.count, self.view.frame.size.height);
    
//    UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
//    [self.collectionView addGestureRecognizer:tagGes];
    
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[LXF_BrowserCollectionViewCell class] forCellWithReuseIdentifier:@"LXFBrowserCollectionViewCell"];
}

- (void)configIndexLabel
{
    self.indexLabel = [[UILabel alloc] init];
    NSString *str = [NSString stringWithFormat:@"%ld/%ld", (long)self.initIndex + 1, (long)self.photosArr.count];
    UIFont *font = [UIFont boldSystemFontOfSize:17.f];
    [self.indexLabel setFrame:CGRectMake(0.f, 0.f, self.view.width, 40.f)];
    [self.indexLabel setBackgroundColor:[UIColor clearColor]];
    [self.indexLabel setTextColor:[UIColor whiteColor]];
    [self.indexLabel setFont:font];
    [self.indexLabel setTextAlignment:NSTextAlignmentCenter];
    [self.indexLabel setText:str];
    [self.view addSubview:self.indexLabel];
}

#pragma mark - currentMethod
- (void)back
{
    if (self.presentingViewController || !self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offSet = scrollView.contentOffset;
    self.currentIndex = offSet.x / self.view.frame.size.width;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXF_BrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXFBrowserCollectionViewCell" forIndexPath:indexPath];
    cell.masterViewController = self;
    
    cell.singleTapGestureBlock = ^(){
        [self back];
    };

    id image = self.photosArr[indexPath.item];
    if ([image isKindOfClass:[UIImage class]]) {
        [cell setImage:image];
    }else if ([image isKindOfClass:[NSString class]]) {
        NSString *urlStr = self.photosArr[indexPath.item];
        NSString *thumbStr = self.thumbArr[indexPath.item];
        
        [cell setUrlStr:urlStr andThumbStr:thumbStr];
    }
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
