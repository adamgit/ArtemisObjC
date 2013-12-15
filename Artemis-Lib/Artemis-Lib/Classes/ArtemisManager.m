#import "ArtemisManager.h"

#import "ArtemisEntity.h"

@implementation ArtemisManager

-(void)initialize { } 

#pragma mark - implementation of protocol

-(void) added:(ArtemisEntity*) entity{ }
-(void) changed:(ArtemisEntity*) entity { }
-(void) deleted:(ArtemisEntity*) entity { }
-(void) disabled:(ArtemisEntity*) entity { }
-(void) enabled:(ArtemisEntity*) entity { }

@end
