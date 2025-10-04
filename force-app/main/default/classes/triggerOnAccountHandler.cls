public class triggerOnAccountHandler{
    public static void UpdateCountOnAccount( Set<Id> accIds){
        if( accIds.isEmpty()){
            return ; 
        }
        
        // Count Contact 
        Map<Id , Integer > countContactMap = new Map<Id , Integer>();
        for( AggregateResult ar : [ Select AccountId , COUNT(Id) cnt 
                                   from Contact 
                                   where AccountId IN : accIds 
                                   GROUP By AccountId 
                                  	]){
            countContactMap.put((Id)ar.get('AccountId') , (Integer)ar.get('cnt'));
        }
        
        // Count Opportunity 
         Map<Id , Integer > CountOppMap = new Map<Id , Integer >();
        for( AggregateResult ar : [ select AccountId  , COUNT(Id) cnt 
                                  from Opportunity 
                                  where AccountId IN : accIds 
                                  GROUP By AccountId 
                                  ]){
            CountOppMap.put((Id)ar.get('AccountId') , (Integer)ar.get('cnt'));
        }
        
        //Bulid To Account to Update 
        List<Account> AccountToUpdate = new List<Account>();
        for( Id accId : accIds ){
		Account acc = new Account(Id = accId);
            
        Integer Countcon = countContactMap.containsKey(accId) ? countContactMap.get(accId) : 0;
        Integer CountOpp = CountOppMap.containsKey(accId) ? CountOppMap.get(accId) : 0;

        acc.Description = 'Total Contacts: ' + Countcon + ', Total Opportunities: ' + CountOpp;


            AccountToUpdate.add(acc);

        }
        
        if(!AccountToUpdate.isEmpty()){
            update AccountToUpdate ; 
        }
    }
    
    public static void PopulateRating(List<Account> AccountList){
        for( Account acc : AccountList){
            if( acc.Industry == 'Education' || acc.Industry == 'Government'){
                acc.CustomerPriority__c = 'High';
                acc.Rating = 'Hot';
                acc.Type = 'Prospect';
            }
        }
    }  
    
    public static void BeforeAccountInsert(List <Account > acclist){
        for(Account acc : acclist){
            acc.Rating = 'Hot';
            acc.Active__c = 'true' ; 
            acc.Industry = 'Goverment';
            acc.Description = 'Account has been create by the triggerOnAccountinsertion ' + acc.Name ;
            
        }
    }
    
    public static void CreateRealtedOpporunity(List<Account> Accountlist){
        List<Opportunity> Opplist = new List<Opportunity>();
        
        for( Account acc : Accountlist){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name+'Opportunity' ; 
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today().addMonths(1);
            opp.Description = 'you Opportunity Name is '+ acc.Name+'Opportunity' ;
            opp.AccountId = acc.Id ; 
            
            Opplist.add(opp);
        }
        if(!Opplist.isEmpty()){
            insert Opplist ; 
        }
    }
    
    public static void CreateRealtedContact( List<Account> Accountlist){
        List<Contact> contlist = new List<Contact>();
        
        for( Account acc : Accountlist){
            Contact con = new Contact();
            con.LastName = acc.Name ; 
            con.Phone = acc.Phone ; 
            con.AccountId = acc.Id ;
            
            contlist.add(con);
        }
            if(!contlist.isEmpty()){
                 insert contlist ; 
            }
    }
    
    // To update realted Opportunity 
   
/*    public static void UpdateRealtedOpportunity(List<Account> Accountlist , Map<Id , Account> OldAcccountlist){
        Map<Id , Account> accMaptoId = new Map<Id , Account >();
        List<Opportunity> Opplist = new List<Opportunity>();
        
        for( Account acc : Accountlist){
            Account oldAccId = OldAcccountlist.get(acc.id);
        		if( OldAcccountlist != null && acc.Phone!= oldAccId.Phone ){
                 accMaptoId.put(acc.id , acc );
           	 }
            for( Opportunity opp : [ select id , AccountId , StageName From Opportunity where AccountId IN :accMaptoId.keyset()]){
				Opportunity newOppitem = new Opportunity();
                if(accMaptoId.containskey(opp.AccountId)){
                    newOppitem.Id = opp.Id ; 
                    newOppitem.Description = OldAcccountlist.get(acc.id).Phone ; 
                    
                    Opplist.add(newOppitem);                
                }

            }
        }
        
        if(!Opplist.isEmpty()){
            update Opplist ; 
        }
        
    } */
    
    public static void UpdateRealtedOpportunity( List<Account> NewAccount , Map<Id , Account > oldAccount){
        Map<Id , Account> AccToUpdateIds = new Map<Id , Account>();
        List<Opportunity> opplist = new List<Opportunity>();
        List<Opportunity> Opportunitylist = new List<Opportunity>();
        
        for(Account acc : NewAccount ){
            if( oldAccount != null && acc.Phone != oldAccount.get(acc.id).Phone){
                
                AccToUpdateIds.put(acc.id , acc);
            }
         opplist = [select id , Name, AccountId from Opportunity where AccountId =:AccToUpdateIds.keyset() ];
           
            
            for( Opportunity op : opplist){

                if(AccToUpdateIds.containskey(op.AccountId)){ 
                    op.Description = AccToUpdateIds.get(acc.Id).Phone ;
                   
                }
            }
        }
        
        Update opplist ; 
        
        
    }
    
    // To  Update Realted Contact 
    public static void UpdateRealtedContact(List<Account> Accountlist , Map<id , Account> OldAccount){
        List<Contact> conList = new List<Contact>();
        set<Id> AccIds = new set<Id>();
        Map<id , Account > AccountToUpdate = new Map<id , Account>();
        
        for( Account acc : Accountlist){
            if( OldAccount != null && acc.Phone != OldAccount.get(acc.Id).Phone){
                AccIds.add(acc.id);
                AccountToUpdate.put(acc.id , acc);
            }
            
            conList = [select id , Name , Phone , AccountId from Contact where AccountId =:AccIds];
                    for( Contact con : conList){
                        if(AccountToUpdate.containskey(con.AccountId)){
                          con.Phone = AccountToUpdate.get(con.AccountId).Phone ; 
                        }
                    }
       }
        if(!conList.isEmpty()){
           update conList ;
        }
                
    }
    
    // Prevent Delatetion of Account if User is Not System admminstatore 
    // Code is Working fine 
  /*  public static void CheckUser(List<Account> AccountList){
		profile ProfileUser = [ select id , Name from Profile where Name =:'System Adminstator'];
        if( UserInfo.getProfileId()!= ProfileUser.id){
            for( Account acc : AccountList){
                acc.addError(' User Is Not System adminstator ');
            }
        }
    }
    */
    
    // Prevent Dealtion of Account if Their is any Realted Opportunity found 
    
   /* public static void PreventAccountDeletation(List<Account>Oldaccount){
        List<Opportunity> opplist = new List<Opportunity>();
        set<Id> AccIds = new set<Id>();
       
        for( Account Acc : Oldaccount){
            AccIds.add(Acc.id);
        }
        
        set<Id> AccWithOppIds = new set <Id>();
       
        opplist = [ select id , AccountId , StageName , CloseDate From Opportunity where AccountId =: AccIds];
        for(Opportunity opp : opplist ){
            AccWithOppIds.add(opp.AccountId);
           
        }
        	
        for(Account acc : Oldaccount){
            if(AccWithOppIds.contains(Acc.Id)){
                acc.addError('you can not delete this Accouun' + 'It Has a '  );
            } 
        }
    }
    */
    
    //Prevent Inssertion of Duplicate Account Records by Phone or Name 
    public static void DuplicateAccount(List<Account> Accountlist){
        set<String> Phoneset = new set<String>();
        set<String> Nameset = new set<String>();
        
        for( Account acc : Accountlist){
            if( acc.Phone != null){
                Phoneset.add(acc.Phone);
            }
            if( acc.Name != null){
                Nameset.add(acc.Name);
            }
        }
        
        List<Account> dupliAccount = [select id , Name , Phone from Account where Phone IN: Phoneset OR Name IN: Nameset];
        
        Map<String , Account > PhoneMap = new Map<String, Account>();
        Map<String , Account > NameMap = new Map<String , Account >();
        
        if( dupliAccount != null){
            for( Account acc : dupliAccount){
                if( acc.Phone != null){
                    PhoneMap.put( acc.Phone , acc);
                }
                if( acc.Name != null ){
                    NameMap.put( acc.Name , acc );
                }
            }
        }
        
        for( Account acc : Accountlist){
            if( PhoneMap.containskey(acc.Phone) || NameMap.containskey(acc.Name)){
				acc.addError('Duplicate Account fetch by either Phone or Name ');
            }
        }
        
    }
    	
    
    }