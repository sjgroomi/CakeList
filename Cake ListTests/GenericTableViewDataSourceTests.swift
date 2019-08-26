//
//  GenericTableViewDataSourceTests.swift
//  Cake ListTests
//
//  Created by Stephen Groom on 26/08/2019.
//  Copyright © 2019 Stewart Hart. All rights reserved.
//

import XCTest
@testable import Cake_List

class GenericTableViewDataSourceTests: XCTestCase {
    private class TestCell: UITableViewCell {
        let string: String
        
        init(string: String) {
            self.string = string
            super.init(style: .default, reuseIdentifier: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private let strings = ["one", "two", "three", "four", "five"]
    private let tableView = UITableView()
    private var dataSource: UITableViewDataSource!
    
    override func setUp() {
        super.setUp()
        
        dataSource = GenericTableViewDataSource(items: strings,
                                                cellConfigurator: { _, string in
                                                    return TestCell(string: string)
        })
    }
    
    func testNumberOfRowsIsEqualToNumberOfItems() {
        XCTAssertEqual(5, dataSource.tableView(tableView, numberOfRowsInSection: 0))
    }
    
    func testCellForRowAtIndexPathReturnsCorrectCell() {
        let cell = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0))
        XCTAssertEqual("four", (cell as? TestCell)?.string)
    }
}
