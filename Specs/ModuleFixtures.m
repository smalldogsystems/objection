#import "ModuleFixtures.h"

BOOL gEagerSingletonHook = NO;

@implementation Car(Meta)

+ (id)manufacture {
  return [[[Car alloc] init] autorelease];
}

@end


@implementation AfterMarketGearBox
- (void)shiftUp {
  
}

- (void)shiftDown {
  
}
@end

@implementation EagerSingleton
objection_register_singleton(EagerSingleton)
- (void)awakeFromObjection {
  gEagerSingletonHook = YES;
}
@end


@implementation MyModule
@synthesize engine=_engine;
@synthesize gearBox=_gearBox;
@synthesize instrumentInvalidEagerSingleton=_instrumentInvalidEagerSingleton;
@synthesize instrumentInvalidMetaClass = _instrumentInvalidMetaClass;

- (id)initWithEngine:(Engine *)engine andGearBox:(id<GearBox>)gearBox {
  if ((self = [super init])) {
    _engine = [engine retain];
    _gearBox = [gearBox retain];
  }
  
  return self;
}

- (void)configure {
  [self bind:_engine toClass:[Engine class]];
  [self bind:_gearBox toProtocol:@protocol(GearBox)];
  [self bindClass:[VisaCCProcessor class] toProtocol:@protocol(CreditCardProcessor)];
  if (self.instrumentInvalidMetaClass) {
    [self bindMetaClass:(id)@"sneaky" toProtocol:@protocol(MetaCar)];
  } else {
    [self bindMetaClass:[Car class] toProtocol:@protocol(MetaCar)];    
  }
  
  if (self.instrumentInvalidEagerSingleton) {
    [self registerEagerSingleton:[Car class]];
  } else {
    [self registerEagerSingleton:[EagerSingleton class]];
  }
  
}

- (void)dealloc {
  [_engine release];_engine = nil;
  [_gearBox release];_gearBox = nil;
  [super dealloc];
}

@end

@implementation CarProvider
- (id)createInstance:(JSObjectionInjector *)context
{
  Car *car = [context getObject:[ManualCar class]];
  car.engine = (id)@"my engine";
  return car;
}
@end

@implementation GearBoxProvider
- (id)createInstance:(JSObjectionInjector *)context
{
  return [[[AfterMarketGearBox alloc] init] autorelease];
}
@end


@implementation ProviderModule
- (void)configure
{
  [self bindProvider:[[[CarProvider alloc] init] autorelease] toClass:[Car class]];
  [self bindProvider:[[[GearBoxProvider alloc] init] autorelease] toProtocol:@protocol(GearBox)];
}
@end

@implementation BlockModule

- (void)configure
{
  NSString *myEngine = [NSString stringWithString:@"My Engine"];
  
  [self bindBlock:^(JSObjectionInjector *context) {
    Car *car = [context getObject:[ManualCar class]];
    car.engine = (id)myEngine;
    return (id)car;    
  } toClass:[Car class]];
  
  AfterMarketGearBox *gearBox = [[[AfterMarketGearBox alloc] init] autorelease];
  [self bindBlock:^(JSObjectionInjector *context) {
    return (id)gearBox;
  } toProtocol:@protocol(GearBox)];
}

@end

@implementation CreditCardValidator
@end

@implementation VisaCCProcessor
objection_register_singleton(VisaCCProcessor)
objection_requires(@"validator")

@synthesize validator = _validator;

- (void)processNumber:(NSString *)number {
  
}

- (void)dealloc {
  [_validator release];
  [super dealloc];
}
@end