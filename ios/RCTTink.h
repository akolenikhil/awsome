//
//  RCTTink.h
//  binbox
//
//  Created by Roshan Porwal on 12/06/21.
//

#ifndef RCTTink_h
#define RCTTink_h
//  RCTCalendarModule.h
#import <React/RCTBridgeModule.h>
@interface RCTTink : NSObject <RCTBridgeModule>
-(NSString*)GetJSON:(id)object;
@end




#endif /* RCTTink_h */
