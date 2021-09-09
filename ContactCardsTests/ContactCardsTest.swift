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
	func testNames() {
		let contact=CNMutableContact()
		contact.givenName="John"
		contact.familyName="Doe"
		contact.namePrefix="Jr"
		contact.nameSuffix="II"
		contact.nickname="Johnny"
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		XCTAssert(returnedContact.givenName==contact.givenName)
		XCTAssert(returnedContact.familyName==contact.familyName)
		XCTAssert(returnedContact.namePrefix==contact.namePrefix)
		XCTAssert(returnedContact.nameSuffix==contact.nameSuffix)
		XCTAssert(returnedContact.nickname==contact.nickname)
	}
	func testCompany() {
		let contact=CNMutableContact()
		contact.organizationName="Celeritas Apps"
		contact.jobTitle="Developer"
		contact.departmentName="R&D"
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		XCTAssert(returnedContact.organizationName==contact.organizationName)
		XCTAssert(returnedContact.jobTitle==contact.jobTitle)
		XCTAssert(returnedContact.departmentName==contact.departmentName)
	}
	func testPhoneNumbers() {
		let contact=CNMutableContact()
		let mobilePhone="123-456-7890"
		contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: mobilePhone)))
		let workPhone1="098-765-4321"
		contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: CNPhoneNumber(stringValue: workPhone1)))
		let workPhone2="444-444-4444"
		contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelWork, value: CNPhoneNumber(stringValue: workPhone2)))
		let homePhone="111-111-1111"
		contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelHome, value: CNPhoneNumber(stringValue: homePhone)))
		let otherPhone="777-777-7777"
		contact.phoneNumbers.append(CNLabeledValue<CNPhoneNumber>(label: CNLabelOther, value: CNPhoneNumber(stringValue: otherPhone)))
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		let firstPhoneData=returnedContact.phoneNumbers[0]
		XCTAssert(firstPhoneData.label==CNLabelPhoneNumberMobile)
		XCTAssert(firstPhoneData.value.stringValue==contact.phoneNumbers[0].value.stringValue)
		let secondPhoneData=returnedContact.phoneNumbers[1]
		XCTAssert(secondPhoneData.label==CNLabelWork)
		XCTAssert(secondPhoneData.value.stringValue==contact.phoneNumbers[1].value.stringValue)
		let thirdPhoneData=returnedContact.phoneNumbers[2]
		XCTAssert(thirdPhoneData.label==CNLabelWork)
		XCTAssert(thirdPhoneData.value.stringValue==contact.phoneNumbers[2].value.stringValue)
		let fourthPhoneData=returnedContact.phoneNumbers[3]
		XCTAssert(fourthPhoneData.label==CNLabelHome)
		XCTAssert(fourthPhoneData.value.stringValue==contact.phoneNumbers[3].value.stringValue)
		let fifthPhoneData=returnedContact.phoneNumbers[4]
		XCTAssert(fifthPhoneData.label==CNLabelOther)
		XCTAssert(fifthPhoneData.value.stringValue==contact.phoneNumbers[4].value.stringValue)
	}
	func testEmails() {
		let contact=CNMutableContact()
		let homeEmail="home@gmail.com"
		contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: homeEmail as NSString))
		let workEmail1="work1@gmail.com"
		contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: workEmail1 as NSString))
		let workEmail2="work2@gmail.com"
		contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: workEmail2 as NSString))
		let otherEmail="other@gmail.com"
		contact.emailAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: otherEmail as NSString))
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		let firstEmail=returnedContact.emailAddresses[0]
		XCTAssert(firstEmail.label==CNLabelHome)
		XCTAssert(firstEmail.value==contact.emailAddresses[0].value as NSString)
		let secondEmail=returnedContact.emailAddresses[1]
		XCTAssert(secondEmail.label==CNLabelWork)
		XCTAssert(secondEmail.value==contact.emailAddresses[1].value as NSString)
		let thirdEmail=returnedContact.emailAddresses[2]
		XCTAssert(thirdEmail.label==CNLabelWork)
		XCTAssert(thirdEmail.value==contact.emailAddresses[2].value as NSString)
		let fourthEmail=returnedContact.emailAddresses[3]
		XCTAssert(fourthEmail.label==CNLabelOther)
		XCTAssert(fourthEmail.value==contact.emailAddresses[3].value as NSString)
	}
	func testSocialProfiles() {
		let contact=CNMutableContact()
		let twitterUsername="contactcardsontwitter"
		contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: nil, username:
																												twitterUsername, userIdentifier: nil, service: CNSocialProfileServiceTwitter)))
		let linkedInURL="http://contactcardslinkedinurl"
		contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: linkedInURL, username:
																												nil, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)))
		let facebookURL="http://contactcardsfacebookURL"
		contact.socialProfiles.append(CNLabeledValue<CNSocialProfile>(label: nil, value: CNSocialProfile(urlString: facebookURL, username:
																												nil, userIdentifier: nil, service: CNSocialProfileServiceFacebook)))
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		let firstSocialProfile=returnedContact.socialProfiles[0]
		XCTAssert(firstSocialProfile.value.service.lowercased()==CNSocialProfileServiceTwitter.lowercased())
		XCTAssert(firstSocialProfile.value.username==contact.socialProfiles[0].value.username)
		let secondSocialProfile=returnedContact.socialProfiles[1]
		XCTAssert(secondSocialProfile.value.service.lowercased()==CNSocialProfileServiceLinkedIn.lowercased())
		XCTAssert(secondSocialProfile.value.urlString==contact.socialProfiles[1].value.urlString)
		let thirdSocialProfile=returnedContact.socialProfiles[2]
		XCTAssert(thirdSocialProfile.value.service.lowercased()==CNSocialProfileServiceFacebook.lowercased())
		XCTAssert(thirdSocialProfile.value.urlString==contact.socialProfiles[2].value.urlString)
	}
	func testURLs() {
		let contact=CNMutableContact()
		contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelHome, value: "http://home.com"))
		contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: "http://work1.com"))
		contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelWork, value: "http://work2.com"))
		contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: "http://other1.com"))
		contact.urlAddresses.append(CNLabeledValue<NSString>(label: CNLabelOther, value: "http://other2.com"))
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		let firstURL=returnedContact.urlAddresses[0]
		XCTAssert(firstURL.label==CNLabelHome)
		XCTAssert(firstURL.value==contact.urlAddresses[0].value)
		let secondURL=returnedContact.urlAddresses[1]
		XCTAssert(secondURL.label==CNLabelWork)
		XCTAssert(secondURL.value==contact.urlAddresses[1].value)
		let thirdURL=returnedContact.urlAddresses[2]
		XCTAssert(thirdURL.label==CNLabelWork)
		XCTAssert(thirdURL.value==contact.urlAddresses[2].value)
		let fourthURL=returnedContact.urlAddresses[3]
		XCTAssert(fourthURL.label==CNLabelOther)
		XCTAssert(fourthURL.value==contact.urlAddresses[3].value)
		let fifthURL=returnedContact.urlAddresses[4]
		XCTAssert(fifthURL.label==CNLabelOther)
		XCTAssert(fifthURL.value==contact.urlAddresses[4].value)
	}
	func testAddresses() {
		let contact=CNMutableContact()
		let homeAddress=CNMutablePostalAddress()
		homeAddress.street="123 Dalton"
		homeAddress.city="Atlanta"
		homeAddress.state="GA"
		homeAddress.postalCode="99999"
		contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: homeAddress))
		let workAddress=CNMutablePostalAddress()
		workAddress.street="77 Berkshire"
		workAddress.city="San Antonio"
		workAddress.state="TX"
		workAddress.postalCode="44444"
		contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelWork, value: workAddress))
		let otherAddress=CNMutablePostalAddress()
		otherAddress.street="25 Robinson"
		otherAddress.city="Santa Barbara"
		otherAddress.state="CA"
		otherAddress.postalCode="11111"
		contact.postalAddresses.append(CNLabeledValue<CNPostalAddress>(label: CNLabelOther, value: otherAddress))
		createContactViewController.fillWithContact(contact: contact)
		let returnedContact=createContactViewController.getContactFromFields()
		let firstAddress=returnedContact.postalAddresses[0]
		XCTAssert(firstAddress.label==CNLabelHome)
		XCTAssert(firstAddress.value==contact.postalAddresses[0].value)
		let secondAddress=returnedContact.postalAddresses[1]
		XCTAssert(secondAddress.label==CNLabelWork)
		XCTAssert(secondAddress.value==contact.postalAddresses[1].value)
		let thirdAddress=returnedContact.postalAddresses[2]
		XCTAssert(thirdAddress.label==CNLabelOther)
		XCTAssert(thirdAddress.value==contact.postalAddresses[2].value)
	}
	func testCreateShareableFile() {
		let managedObjectContext=(UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
		guard let context=managedObjectContext else {
			XCTAssert(false)
			return
		}
		let contactCard=NSEntityDescription.entity(forEntityName: ContactCardMO.entityName, in: context)
		guard let card=contactCard else {
			XCTAssert(false)
			return
		}
		let contactCardRecord=ContactCardMO(entity: card, insertInto: context)
		setFields(contactCardMO: contactCardRecord, filename: "Test Card", cnContact: CNContact(), color: ColorChoice.red.rawValue)
		ActiveContactCard.shared.contactCard=contactCardRecord
		contactCardViewController.loadContact()
		XCTAssert(contactCardViewController.itemProvidersForActivityItemsConfiguration.count==1)
		managedObjectContext?.delete(contactCardRecord)
	}
	/*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
*/
}
