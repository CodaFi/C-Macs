//
//  CMacsTypes.c
//  CMacs
//
//  Created by Robert Widmann on 11/29/14.
//  Copyright (c) 2014 CodaFi. All rights reserved.
//

#include "CMacsTypes.h"

CMacsSimpleMessage cmacs_simple_msgSend = (CMacsSimpleMessage)objc_msgSend;
CMacsVoidMessage cmacs_void_msgSend	 = (CMacsVoidMessage)objc_msgSend;
CMacsVoidMessage1 cmacs_void_msgSend1 = (CMacsVoidMessage1)objc_msgSend;
CMacsRectMessage1 cmacs_rect_msgSend1 = (CMacsRectMessage1)objc_msgSend;
CMacsWindowInitMessage cmacs_window_init_msgSend = (CMacsWindowInitMessage)objc_msgSend;
