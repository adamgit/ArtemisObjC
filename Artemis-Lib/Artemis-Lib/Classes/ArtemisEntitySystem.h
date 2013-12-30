/**
 
 */
#import <Foundation/Foundation.h>

#import "ArtemisAspect.h"
#import "ArtemisBag.h"
#import "ArtemisBitSet.h"
#import "ArtemisImmutableBag.h"
#import "ArtemisEntityObserver.h"

@class ArtemisWorld;

@interface ArtemisEntitySystem : NSObject <ArtemisEntityObserver>

@property(nonatomic,assign /** weak */) ArtemisWorld* world;
@property(nonatomic) BOOL isPassive, isDummy;
@property(nonatomic,retain) ArtemisBag* actives;

/** Objc: needed for subclasses, java doesnt have this problem */
- (id)initWithAspect:(ArtemisAspect*) aspect;

-(void) begin;
-(void) end;
-(void) process;

-(BOOL) checkProcessing;
-(void) processEntities:(NSObject<ArtemisImmutableBag>*) entities;

-(void) initialize;
-(void) inserted:(ArtemisEntity*) entity;
-(void) removed:(ArtemisEntity*) entity;

-(void) check:(ArtemisEntity*) entity;

-(void) added:(ArtemisEntity*) entity;
-(void) changed:(ArtemisEntity*) entity;
-(void) deleted:(ArtemisEntity*) entity;
-(void) disabled:(ArtemisEntity*) entity;
-(void) enabled:(ArtemisEntity*) entity;

@end
