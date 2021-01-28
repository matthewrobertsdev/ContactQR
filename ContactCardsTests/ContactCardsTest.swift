//
//  CardQRTests.swift
//  CardQRTests
//
//  Created by Matt Roberts on 12/6/18.
//  Copyright © 2018 Matt Roberts. All rights reserved.
//
import XCTest
import Contacts
@testable import Contact_Cards
class ContactCardsTests: XCTestCase {
	var createContactViewController: CreateContactViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		createContactViewController=storyboard.instantiateViewController(withIdentifier:
																					"CreateContactViewController") as? CreateContactViewController
		createContactViewController.loadViewIfNeeded()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testEmptyContact() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		createContactViewController.fillWithContact(contact: CNContact())
		let returnedContact=createContactViewController.getContactFromFields()
		XCTAssert(returnedContact.givenName=="")
    }
	func testFullContact() {
		let fullContact=CNMutableContact()
		fullContact.givenName="John"
		fullContact.familyName="Doe"
		fullContact.namePrefix="Jr"
		fullContact.nameSuffix="II"
		fullContact.nickname="Johnny"
		fullContact.organizationName="Celeritas Apps"
		fullContact.jobTitle="Developer"
		fullContact.departmentName="R&D"
		let mobilePhone="123-456-7890"
		fullContact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: mobilePhone)))
		createContactViewController.fillWithContact(contact: fullContact)
		let returnedContact=createContactViewController.getContactFromFields()
		XCTAssert(returnedContact.givenName==fullContact.givenName)
		XCTAssert(returnedContact.familyName==fullContact.familyName)
		XCTAssert(returnedContact.namePrefix==fullContact.namePrefix)
		XCTAssert(returnedContact.nameSuffix==fullContact.nameSuffix)
		XCTAssert(returnedContact.nickname==fullContact.nickname)
		XCTAssert(returnedContact.organizationName==fullContact.organizationName)
		XCTAssert(returnedContact.jobTitle==fullContact.jobTitle)
		XCTAssert(returnedContact.departmentName==fullContact.departmentName)
		let firstPhoneData=returnedContact.phoneNumbers.first
		XCTAssert(firstPhoneData?.label==CNLabelPhoneNumberMobile)
		XCTAssert(firstPhoneData?.value.stringValue==mobilePhone)
	}
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
