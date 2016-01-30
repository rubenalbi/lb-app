//
//  NSObject_Constants.h
//  BusLondon
//
//  Created by Rubén Albiach on 09/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#define NUM_SECTIONS        7

#define NUM_SECTION_1_ITEMS 2
#define NUM_SECTION_2_ITEMS 14
#define NUM_SECTION_3_ITEMS 5

#define RATIO_DISTANCE  500

#define METERS_PER_MILE 1609.344

#define TFL_APP_CREDENTIALS @"app_id=b4cfdcd0&app_key=ee2d65d36b4f1881b46dd5d0d7c33c26"

#define TFL_NEAR_STOPS @"https://api.tfl.gov.uk/StopPoint?lat=%f&lon=%f&stopTypes=NaptanPublicBusCoachTram&radius=%d&returnLines=True&%@"

#define TFL_STOP_ARRIVALS @"https://api.tfl.gov.uk/StopPoint/%@/Arrivals?%@"

#define TFL_VEHICLE_ARRIVALS @"http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1?RegistrationNumber=%@&ReturnList=StopPointIndicator,StopPointName,StopCode2,EstimatedTime,Latitude,Longitude"