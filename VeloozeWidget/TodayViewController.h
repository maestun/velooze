//
//  TodayViewController.h
//  VeloozeWidget
//
//  Created by developer on 05/02/2016.
//  Copyright © 2016 maestun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NotificationCenter/NotificationCenter.h>
#import "VeloozeFramework.h"


//@interface TodayTableCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel * lbBikes;
//@property (weak, nonatomic) IBOutlet UILabel * lbName;
//@property (weak, nonatomic) IBOutlet UIView * uvBadge;
//@end

@interface TodayViewController : UIViewController <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate, StationManagerDelegate, FavoritesTableCellDelegate> {
    int64_t mLastUpdate;
}
@property (weak, nonatomic) IBOutlet UITableView *tvFavorites;
//@property (weak, nonatomic) IBOutlet UIButton *btRefresh;
//@property (weak, nonatomic) IBOutlet UILabel *lbRefresh;
//- (IBAction)onRefreshClicked:(id)sender;

@end
