//
//  ViewController.m
//  JHMapNavRouteDemo
//
//  Created by Jiang Hao on 2018/7/10.
//  Copyright © 2018年 Jiang Hao. All rights reserved.
//

#import "ViewController.h"
#import <JHSheetActionView.h>
#import <MapKit/MapKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
//开始导航
- (IBAction)onClickButton {
   JHSheetActionView *sheetView= [[JHSheetActionView alloc] init];
    sheetView.sheetItems=@[@[@"Apple 地图",@"高德地图",@"百度地图",@"腾讯地图"],@[@"取消"]];
    sheetView.callBackCellForRowIndex = ^(NSInteger index) {
        NSString *urlsting=nil;
        CLLocationCoordinate2D  coordinate = CLLocationCoordinate2DMake(39.918058, 116.397026);
        NSString * name=@"故宫博物馆";
        
        switch (index) {
                //Apple 地图
            case 1:{
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
                tolocation.name=name;
                [MKMapItem openMapsWithItems:@[currentLocation,tolocation]launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            }
                break;
                //高德地图
            case 2:{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                    urlsting =[[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&t=0",coordinate.latitude,coordinate.longitude,name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                }
                
            }
                break;
                //百度地图
            case 3:{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
                    //转换百度坐标
                    CLLocationCoordinate2D xcoordinate=[self getBaiDuCoordinateByGaoDeCoordinate:coordinate];
                    urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",xcoordinate.latitude,xcoordinate.longitude,name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                }
              
            }
                break;
                //腾讯地图
            case 4:{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]){
                    urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%lf,%lf&referer=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77",name,coordinate.latitude,coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                }
              
            }
                break;
                
            default:
                break;
        }
        //打开应用内跳转
        if(!urlsting) return;
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
        }
        
        
    };
    [sheetView showView];
}

// 高德地图经纬度转换为百度地图经纬度
- (CLLocationCoordinate2D)getBaiDuCoordinateByGaoDeCoordinate:(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
}

@end
