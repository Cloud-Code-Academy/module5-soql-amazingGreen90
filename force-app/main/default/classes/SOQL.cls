/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Frank Aldridge
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List <Lead> getAllLeads() {
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead];
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List <Contact> firstNameJohn() {
        return [SELECT Id, Name FROM Contact WHERE FirstName = 'John'];
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List <Id> contactIdsByLastName () {
        List <Id> contactIds = new List<Id>();
        List <Contact> conList = [SELECT Id FROM Contact WHERE LastName = 'Smith' OR LastName = 'Jones'];
        for (Contact contact : conList){
            contactIds.add(contact.Id);
        }
        return contactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List <Opportunity> closedWonOppsByAcct (Id accountId) {
        return [SELECT Id, Name, StageName, AccountId, CloseDate, Amount FROM Opportunity WHERE StageName = 'Closed Won' AND AccountId = :accountId];
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer numOfAccts() {
        List <Account> accts = [SELECT Id FROM Account];
        return accts.size();
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map <Id, Task> tasksDueNextWeek() {
        Map <Id, Task> taskMap = new Map <Id, Task>();
        List <Task> taskList = [SELECT Id FROM Task WHERE ActivityDate <= NEXT_N_DAYS:7];
        for(Task t : taskList){
            taskMap.put(t.Id, t);
        }
        return taskMap;
    }
    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List <Contact> contactDomains () {
        String domain = 'example.com';
        List <Contact> conExampleEmail = [SELECT Id, Name, Email FROM Contact];
        List <Contact> conWithExample = new List <Contact>();
        for(Contact c : conExampleEmail){
            if(c.Email.contains(domain)){
                conWithExample.add(c);
            }
        }
        return conWithExample;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        if(keyword == null){
            return new List <Opportunity>();
        }
        List <Opportunity> opps = [SELECT Id, Name FROM Opportunity];
        List <Opportunity> oppsWithKeyword = new List <Opportunity>();
        for(Opportunity o : opps){
            if(o.Name.contains(keyword)){
                oppsWithKeyword.add(o);
            }
        }
        return oppsWithKeyword; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List <Case> getFilterCaseOrigins() {
        List <String> originList = new List <String> {'Web', 'Email', ''};
        List <Case> caseList = [SELECT Id, Origin FROM Case WHERE Origin NOT IN :originList];
        return caseList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List <Lead> webEngLeads (String leadSource, String keyword) {
        List <Lead> leads = [SELECT Id, LastName, Company, Phone, Email, LeadSource, Title FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :('%' + keyword + '%')];
        return leads;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List <String> conLastName = new List <String>();
        // Query the Contacts
        List <Contact> conToAcct = [SELECT Id, LastName FROM Contact WHERE AccountId = :accountId];
        // Loop through each Contact and add the LastName to the list
        for (Contact c :conToAcct) {
            conLastName.add(c.LastName);
        }

        // Return the list of Contact LastNames
        return conLastName; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] rev = 
        [
            SELECT SUM(Amount) oppSum 
            FROM Opportunity 
            WHERE StageName = :stage OR Amount > 10000
        ];

        Decimal totalRev = (Decimal) rev[0].get('oppSum'); 
        // Return the total revenue
        return totalRev; // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List <Account> accts = 
        [
            SELECT Id, Name
            FROM Account
            ORDER BY Name ASC
            LIMIT 10
        ];
        return accts; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List <Opportunity> opps = 
        [
            SELECT Id, Amount, CloseDate
            FROM Opportunity
            WHERE Amount > 100000
            ORDER BY CloseDate
            LIMIT 5
        ];
        return opps; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List <Contact> contacts =
        [
            SELECT Id, Birthdate
            FROM Contact
            ORDER BY Birthdate DESC
            LIMIT 3
        ];
        return contacts; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List <Case> cases =
        [
            SELECT Id, Status, CreatedDate
            FROM Case
            WHERE Status = 'Open'
            ORDER BY CreatedDate
            LIMIT 10
            OFFSET 5
        ];
        return cases; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set <Id> caseIds = new Set <Id>();
        // Query the Cases
        List <Case> cases = 
        [
            SELECT Id
            FROM Case
            WHERE AccountId = :accountId
        ];
        // Loop through each Case and add the Id to the set
        for (Case c : cases) {
            caseIds.add(c.Id);
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        List <Account> accts =
        [
            SELECT Id, Name, BillingCountry
            FROM Account
            WHERE BillingCountry != :country
        ];
        // Loop through each Account and add the Id and Name to the map
        for(Account a : accts){
            accountIdsToNames.put(a.Id, a.Name);
        }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        String accountName;
        Contact contact = 
        [
            SELECT Account.Name 
            FROM Contact 
            WHERE Id = :contactId 
            LIMIT 1
        ];
        accountName = contact.Account.Name;
        return accountName; // Replace null with the variable you used to store the result
    }    
    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getOpportunityAndAccountNamesForLineItem('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getOpportunityAndAccountNamesForLineItem(Id accountId) {
        List <Account> acctList =
        [
            SELECT Id, Name, 
            (SELECT Id, Name FROM Opportunities)
            FROM Account
            WHERE Id = :accountId
        ];
        return acctList[0]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        String acctBstate;
        // Query the Account
        Account acct =
        [
            SELECT Id, Name, BillingState
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
        // Store the Account's BillingState
        acctBstate = acct.BillingState;
        // Query the Contacts
        List <Contact> conList =
        [
            SELECT Id, Name, MailingState
            FROM Contact
            WHERE MailingState = :acctBstate
        ];
        return conList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findContactsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findContactsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List <Lead> leads = 
        [
            SELECT Id, Name, Email
            FROM Lead
            WHERE Id = :leadIds
        ];
        System.debug(leads);
        // Create a set of email domains from the Leads
        Set <String> domains = new Set <String>();
        // Loop through each Lead
        for (Lead l : leads){
            // Get the email from the Lead
            domains.add('www.' + l.Email.substringAfter('@'));
            System.debug(domains);
        }
        // Query the Accounts
        List <Account> accounts =
        [
            SELECT Id, Name, Website
            FROM Account
            WHERE Website IN :domains
        ];
        System.debug(accounts);
        return accounts; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List <OpportunityLineItem> origOppLine =
        [
            SELECT Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice
            FROM OpportunityLineItem
            WHERE OpportunityId = :origOppId
        ];
        // Create a list to hold the new line items
        List <OpportunityLineItem> newOppLine = new List <OpportunityLineItem>();
        // Loop through each cloned Opportunity Id
        for (Id clonedOppId : cloneOppIds) {
            // Loop through each original line item
            for (OpportunityLineItem origLineItem : origOppLine) {
                // Clone the original line item
                OpportunityLineItem newLineItem = origLineItem.clone(false, true);
                // Add the random number to the quantity
                newLineItem.Quantity += (Integer)Math.round(Math.random() * 2) + 1;
                // Set the OpportunityId to the cloned Opportunity Id
                newLineItem.OpportunityId = clonedOppId;
                // Add the new line item to the list
                newOppLine.add(newLineItem);
            }
        }
        // Insert the new line items
        insert newOppLine;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {
        List <Opportunity> oppList =
        [
            SELECT Id, Name, Owner.Name, Account.Name
            FROM Opportunity
            WHERE StageName = 'Closed Won'
        ];
        return oppList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List <Opportunity> opps = getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        Set <Id> acctIds = new Set <Id>();
        for(Opportunity o : opps){
            acctIds.add(o.AccountId);
        }
        // Query the Contacts
        List <Contact> conList =
        [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :acctIds
            ORDER BY CreatedDate ASC
        ];
        // Loop through each Contact and add the Account Id and Contact to the map
        Map <Id, Contact> accountToContactMap = new Map <Id, Contact>();
        for(Contact c : conList){
            accountToContactMap.put(c.AccountId, c);
        }
        // Loop through each Opportunity
        List <Opportunity> updatedOpps = new List <Opportunity>();
        for(Opportunity o : opps){
            // Update the Opportunity primary contact from accountToContactMap
            Id accountId = o.AccountId;
            if(accountToContactMap.containsKey(accountId)){
                o.Primary_Contact__c = accountToContactMap.get(accountId).Id;
                updatedOpps.add(o);
            }
            
        }
        // Update the Opportunities
        upsert updatedOpps;
    }
}