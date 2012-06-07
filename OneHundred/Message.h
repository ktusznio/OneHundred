//
//  Message.h
//  OneHundred
//
//  Created by Kamil Tusznio and Max Woghiren on 12-06-07.
//  Copyright (c) 2012 Lost City Studios Inc. All rights reserved.
//

typedef enum {
    MessageTypeServerDesignation = 0,
    MessageTypeGameBegin
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomDesignation;
} MessageServerDesignation;

typedef struct {
    Message message;
} MessageGameBegin;