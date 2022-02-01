//
//  MessageStoreSpecs.swift
//  TotersMessagingTests
//
//  Created by Husam Dayya on 02/02/2022.
//

import Foundation

protocol MessageStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()
    func test_retrieve_deliversMessagesForSelectedContact()
    func test_storeSideEffects_runSerially()
}

protocol FailableRetrieveMessageStoreSpecs: MessageStoreSpecs {
    func test_retrieve_hasNoSideEffectsOnFailure()
    func test_retrieve_deliversFailureOnRetrieveError()
}

protocol FailableInsertMessageStoreSpecs: MessageStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_deliversOneMessageWhenInsertingSameMessageTwice()
    func test_insert_deliversErrorWhenInsertingSameMessageTwice()
}
