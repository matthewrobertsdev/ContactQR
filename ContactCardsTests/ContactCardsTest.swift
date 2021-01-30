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
	var contactCardViewController: ContactCardViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		createContactViewController=storyboard.instantiateViewController(withIdentifier:
																					"CreateContactViewController") as? CreateContactViewController
		createContactViewController.loadViewIfNeeded()
		contactCardViewController=storyboard.instantiateViewController(withIdentifier:
																					"ContactCardViewController") as? ContactCardViewController
		contactCardViewController.loadViewIfNeeded()
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
	func createFullContact() -> CNContact {
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
		let workPhone1="098-765-4321"
		fullContact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: CNPhoneNumber(stringValue: workPhone1)))
		let workPhone2="444-444-4444"
		fullContact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: CNPhoneNumber(stringValue: workPhone2)))
		let homePhone="111-111-1111"
		fullContact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelHome, value: CNPhoneNumber(stringValue: homePhone)))
		let otherPhone="777-777-7777"
		fullContact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelOther, value: CNPhoneNumber(stringValue: otherPhone)))
		let homeEmail="home@gmail.com"
		fullContact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: homeEmail as NSString))
		let workEmail1="work1@gmail.com"
		fullContact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: workEmail1 as NSString))
		let workEmail2="work2@gmail.com"
		fullContact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: workEmail2 as NSString))
		let otherEmail="other@gmail.com"
		fullContact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: otherEmail as NSString))
		let twitterUsername="contactcardsontwitter"
		fullContact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: nil, username:
																												twitterUsername, userIdentifier: nil, service: CNSocialProfileServiceTwitter)))
		let linkedInURL="http://contactcardslinkedinurl"
		fullContact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: linkedInURL, username:
																												nil, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)))
		let facebookURL="http://contactcardsfacebookURL"
		fullContact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: facebookURL, username:
																												nil, userIdentifier: nil, service: CNSocialProfileServiceFacebook)))
		fullContact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: "http://home.com"))
		fullContact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: "http://work1.com"))
		fullContact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: "http://work2.com"))
		fullContact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: "http://other1.com"))
		fullContact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: "http://other2.com"))
		let homeAddress=CNMutablePostalAddress()
		homeAddress.street="123 Dalton"
		homeAddress.city="Atlanta"
		homeAddress.state="GA"
		homeAddress.postalCode="99999"
		fullContact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: homeAddress))
		let workAddress=CNMutablePostalAddress()
		workAddress.street="77 Berkshire"
		workAddress.city="San Antonio"
		workAddress.state="TX"
		workAddress.postalCode="44444"
		fullContact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelWork, value: workAddress))
		let otherAddress=CNMutablePostalAddress()
		otherAddress.street="25 Robinson"
		otherAddress.city="Santa Barbara"
		otherAddress.state="CA"
		otherAddress.postalCode="11111"
		fullContact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelOther, value: otherAddress))
		return fullContact
	}
	func testFullContact() {
		let fullContact=createFullContact()
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
		let firstPhoneData=returnedContact.phoneNumbers[0]
		XCTAssert(firstPhoneData.label==CNLabelPhoneNumberMobile)
		XCTAssert(firstPhoneData.value.stringValue==fullContact.phoneNumbers[0].value.stringValue)
		let secondPhoneData=returnedContact.phoneNumbers[1]
		XCTAssert(secondPhoneData.label==CNLabelWork)
		XCTAssert(secondPhoneData.value.stringValue==fullContact.phoneNumbers[1].value.stringValue)
		let thirdPhoneData=returnedContact.phoneNumbers[2]
		XCTAssert(thirdPhoneData.label==CNLabelWork)
		XCTAssert(thirdPhoneData.value.stringValue==fullContact.phoneNumbers[2].value.stringValue)
		let fourthPhoneData=returnedContact.phoneNumbers[3]
		XCTAssert(fourthPhoneData.label==CNLabelHome)
		XCTAssert(fourthPhoneData.value.stringValue==fullContact.phoneNumbers[3].value.stringValue)
		let fifthPhoneData=returnedContact.phoneNumbers[4]
		XCTAssert(fifthPhoneData.label==CNLabelOther)
		XCTAssert(fifthPhoneData.value.stringValue==fullContact.phoneNumbers[4].value.stringValue)
		let firstEmail=returnedContact.emailAddresses[0]
		XCTAssert(firstEmail.label==CNLabelHome)
		XCTAssert(firstEmail.value==fullContact.emailAddresses[0].value as NSString)
		let secondEmail=returnedContact.emailAddresses[1]
		XCTAssert(secondEmail.label==CNLabelWork)
		XCTAssert(secondEmail.value==fullContact.emailAddresses[1].value as NSString)
		let thirdEmail=returnedContact.emailAddresses[2]
		XCTAssert(thirdEmail.label==CNLabelWork)
		XCTAssert(thirdEmail.value==fullContact.emailAddresses[2].value as NSString)
		let fourthEmail=returnedContact.emailAddresses[3]
		XCTAssert(fourthEmail.label==CNLabelOther)
		XCTAssert(fourthEmail.value==fullContact.emailAddresses[3].value as NSString)
		let firstSocialProfile=returnedContact.socialProfiles[0]
		XCTAssert(firstSocialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased())
		XCTAssert(firstSocialProfile.value.username==fullContact.socialProfiles[0].value.username)
		let secondSocialProfile=returnedContact.socialProfiles[1]
		XCTAssert(secondSocialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased())
		XCTAssert(secondSocialProfile.value.urlString==fullContact.socialProfiles[1].value.urlString)
		let thirdSocialProfile=returnedContact.socialProfiles[2]
		XCTAssert(thirdSocialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased())
		XCTAssert(thirdSocialProfile.value.urlString==fullContact.socialProfiles[2].value.urlString)
		let firstURL=returnedContact.urlAddresses[0]
		XCTAssert(firstURL.label==CNLabelHome)
		XCTAssert(firstURL.value==fullContact.urlAddresses[0].value)
		let secondURL=returnedContact.urlAddresses[1]
		XCTAssert(secondURL.label==CNLabelWork)
		XCTAssert(secondURL.value==fullContact.urlAddresses[1].value)
		let thirdURL=returnedContact.urlAddresses[2]
		XCTAssert(thirdURL.label==CNLabelWork)
		XCTAssert(thirdURL.value==fullContact.urlAddresses[2].value)
		let fourthURL=returnedContact.urlAddresses[3]
		XCTAssert(fourthURL.label==CNLabelOther)
		XCTAssert(fourthURL.value==fullContact.urlAddresses[3].value)
		let fifthURL=returnedContact.urlAddresses[4]
		XCTAssert(fifthURL.label==CNLabelOther)
		XCTAssert(fifthURL.value==fullContact.urlAddresses[4].value)
		let firstAddress=returnedContact.postalAddresses[0]
		XCTAssert(firstAddress.label==CNLabelHome)
		XCTAssert(firstAddress.value==fullContact.postalAddresses[0].value)
		let secondAddress=returnedContact.postalAddresses[1]
		XCTAssert(secondAddress.label==CNLabelWork)
		XCTAssert(secondAddress.value==fullContact.postalAddresses[1].value)
		let thirdAddress=returnedContact.postalAddresses[2]
		XCTAssert(thirdAddress.label==CNLabelOther)
		XCTAssert(thirdAddress.value==fullContact.postalAddresses[2].value)
	}
	func testCreateShareableFile() {
		ActiveContactCard.shared.contactCard?.vCardString=ContactDataConverter.cnContactToVCardString(cnContact: createFullContact())
		contactCardViewController.loadContact()
		XCTAssert(contactCardViewController.itemProvidersForActivityItemsConfiguration.count==1)
	}
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
