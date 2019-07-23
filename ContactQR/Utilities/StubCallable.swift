//
//  StubCallable.swift
//  CardQR
//
//  Created by Matt Roberts on 6/6/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//
import Foundation
class StubCallable: Callable {
    //so it won't crash while you haven't developed your Callable yet
    func call() {
        print("Stub callable: you need to implement a Callable or delete the use of the protocol.")
    }
}
