//
//  ViewController.m
//  LabelTag
//
//  Created by juanmao on 16/12/9.
//  Copyright © 2016年 juanmao. All rights reserved.
//

#import "ViewController.h"
#import "AOTag.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,AOTagDelegate>
@property(nonatomic, strong)UITableView     *tableView;
@property(nonatomic, strong)NSMutableArray  *itemArr;
@property(nonatomic, strong)AOTagList       *tagList;
    ///存放选中的item
@property(nonatomic, strong)NSMutableArray  *selectedItemArr;
    ///无选项时的文字提示
@property(nonatomic, strong)UILabel         *emptyLab;
@property(nonatomic, strong)UIView          *headerLine;
@property(nonatomic, strong)UIButton        *resetItemBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"标签";
    _itemArr = [NSMutableArray array];
    _selectedItemArr = [NSMutableArray array];
    [self initData];
    [self createTagView];
    [self createFooterBtn];
}

- (void)initData{
    for (int i =1; i<=10; i++) {
        if (i % 2 == 0) {
            [self.itemArr addObject:[NSString stringWithFormat:@"分类%d试试文字过长",i]];
        }else{
            [self.itemArr addObject:[NSString stringWithFormat:@"分类%d",i]];
        }
    }
    [self.tableView reloadData];
}

- (void)createTagView{
    self.tagList = [[AOTagList alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 60) showType:verticalScroll];
    self.tagList.backgroundColor = [UIColor whiteColor];
    self.tagList.delegate = self;
    self.tagList.hidden = YES;
    [self.view addSubview:self.tagList];
    
    self.emptyLab = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                             64,
                                                             self.view.bounds.size.width,
                                                             60)];
    self.emptyLab.textColor = [UIColor colorWithRed:131/255 green:131/255 blue:131/255 alpha:1];
    self.emptyLab.font = [UIFont systemFontOfSize:15];
    self.emptyLab.text = @"   当前没有筛选项";
    self.emptyLab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.emptyLab];
    self.emptyLab.hidden = !self.tagList.hidden;
    
    self.headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 124, self.view.bounds.size.width, 0.5)];
    self.headerLine.backgroundColor = [UIColor colorWithRed:230/255 green:231/255 blue:232/255 alpha:1];
    [self.view addSubview:self.headerLine];
}

- (void)createFooterBtn{
    self.resetItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetItemBtn.frame = CGRectMake(0, self.view.bounds.size.height-48, self.view.bounds.size.width, 48);
    [self.resetItemBtn setTitle:@"重置筛选项" forState:UIControlStateNormal];
    self.resetItemBtn.backgroundColor = [UIColor blackColor];
    [self.resetItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resetItemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.resetItemBtn];
    self.resetItemBtn.enabled = NO;
    self.resetItemBtn.alpha = 0.4;
    [self.resetItemBtn addTarget:self action:@selector(removeAllTags) forControlEvents:UIControlEventTouchUpInside];
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 61, self.view.bounds.size.width, self.view.bounds.size.height-48-61) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *itemName = self.itemArr[indexPath.row];
    if (currentCell.accessoryType == UITableViewCellAccessoryNone) {
            //勾选
        [self.selectedItemArr addObject:itemName];
        [self.tagList addTag:itemName withImage:nil];
    }else{
            //取消勾选
        [self.selectedItemArr removeObject:itemName];
        for (AOTag *tag in self.tagList.tags)
        {
                //遍历所有tag，删除对应tag
            if ([tag.tTitle isEqualToString:itemName])
            {
                [self.tagList removeTag:tag];
                break;
            }
        }
        
    }
    [self changeResetBtnStatus];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row < self.itemArr.count) {
        cell.textLabel.text = self.itemArr[indexPath.row];
    }
    self.emptyLab.hidden = self.selectedItemArr.count;
    self.tagList.hidden = !self.selectedItemArr.count;
    if (self.selectedItemArr.count > 0) {
        for (NSString *nameStr in self.selectedItemArr) {
            if ([nameStr isEqualToString:self.itemArr[indexPath.row]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    return cell;
}

#pragma mark AOTagDelegate
- (void)tagDidRemoveTag:(AOTag *)tag{
    for (NSString *typeName in self.itemArr) {
        if ([typeName isEqualToString:tag.tTitle]) {
            [self.selectedItemArr removeObject:typeName];
        }
    }
    [self changeResetBtnStatus];
    [self.tableView reloadData];
}

#pragma mark buttonClick
- (void)removeAllTags{
    [self.tagList removeAllTag];
    [self.selectedItemArr removeAllObjects];
    self.tagList.hidden = YES;
    self.emptyLab.hidden = NO;
    [self.tableView reloadData];
    [self changeResetBtnStatus];
}

- (void)changeResetBtnStatus{
    //更改重置按钮状态
    if (self.selectedItemArr.count)
    {
        self.resetItemBtn.alpha = 1;
        self.resetItemBtn.enabled = YES;
    }
    else
    {
        self.resetItemBtn.enabled = NO;
        self.resetItemBtn.alpha = 0.4;
    }
}
@end
