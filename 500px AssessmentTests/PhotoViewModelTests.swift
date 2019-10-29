//
//  PhotoViewModelTests.swift
//  500px AssessmentTests
//
//  Created by Saim Zahid on 2019-10-25.
//  Copyright © 2019 Saim Zahid. All rights reserved.
//

import XCTest
@testable import _00px_Assessment

class PhotoViewModelTests: XCTestCase {
    var user: User!
    var photo: Photo!
    var viewModel: PhotoViewModel!
    
    override func setUp() {
        user = User(fullName: "Jane Doe", avatarUrl: "......")
        photo = Photo(name: "Sample Photo", user: user, imageUrl: ["........"], createdAt: "2013-03-10T02:00:00Z", positiveVotesCount: 100, commentsCount: 34)
        viewModel = PhotoViewModel(photo: photo)
    }

    override func tearDown() {
        user = nil
        photo = nil
        viewModel = nil
    }

    func testImageStateShouldBeNew() {
        XCTAssertEqual(viewModel.imageDownloadState, ImageDownloadState.new)
    }
    
    
    func testFormattedLikesTextShouldBe100Likes() {
        XCTAssertEqual(viewModel.formattedLikesText, "100 likes")
    }
    
    func testNameShouldBeSamplePhoto() {
        XCTAssertEqual(viewModel.name, "Sample Photo")
    }
}
