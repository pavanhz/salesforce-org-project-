public class triggerOnContactHander {
    
	
    // Send Email When new Contact is Insert 
    public static void SendEmailOnContactCreation(List<Contact> conlist ){
        	
        List<Messaging.Email> EmailList = new List<Messaging.Email>();
        
        for( Contact con : conlist ){
            if( con.Email != null ){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses  = new String[]{ con.Email};
                mail.setToAddresses(toAddresses);
                String disName = 'Pavan Deshmukh ';
                mail.setSenderDisplayName(disName);
                String content = 'Hi '+ con.Salutation + con.FirstName + con.LastName + ',/br' + 
                    			 'Your Contact createted succsefully ! ' + '/br' + 
                    			 'Thank you For Joing To us ! ';
                
                mail.setHtmlBody(content);
                EmailList.add(mail);
            }
        }
        	Messaging.sendEmail(EmailList);
       
        
    }
    // Avoid Duplication of Recoreds 
    public static void DuplicatRecordhandler(List<Contact> conlist){
        
        set<String> phoneset = new set<String>();
        set<String> lastNameset = new set<String>();
        
        for( Contact con : conlist){
            if(con.Phone != null){
                phoneset.add(con.Phone);
            }
            if( con.LastName != null){
                lastNameset.add(con.LastName);
            }
        }
        
        List<Contact> dupconlist = [select id , Phone , LastName from Contact where Phone IN:phoneset OR LastName IN :lastNameset];
        
        Map<String , Contact > conPhoneMap = new Map<String , Contact>();
        Map<String , Contact > conLastNameMap = new Map<String , Contact>();
        
        if(dupconlist != null){
            for( Contact con : dupconlist){
                if(con.Phone != null){
                    conPhoneMap.put(con.Phone , con);
                }
                if( con.LastName != null ){
                   conLastNameMap.put(con.LastName , con); 
                }
            }            
        }
        
        for( Contact con : conlist){
            if(conPhoneMap.containskey(con.Phone) || conLastNameMap.containskey(con.LastName)){
                con.addError( 'Duplicate Contact exit either Phone or LastName ');
            }
        }
        
    }
   
    // Count Releated Contact of Account 
    public static void CountRelatedContact( List<Contact> conlist){
        Set<Id> Ids = new Set<Id>();
        
        for( Contact con : conlist){
            if( con.AccountId != null){
                Ids.add(con.AccountId);
            }
        }
        if(ids.isEmpty()){
            return  ; 
        }
         Map<Id , Integer > ConIdtoCount = new Map<Id , Integer>();
        for( AggregateResult ar : [ select AccountId , COUNT(Id) cnt From Contact where AccountId IN : Ids Group by AccountId ]){
            ConIdtoCount.put((Id)ar.get('AccountId') , (Integer)ar.get('cnt'));
        }
        
        List<Account> AcclistToupdate = new List<Account>();
        
        
        for( Id AccountId : Ids  ){		// Update Releated Parent
            Account acc = new Account ( Id = AccountId );
            if(ConIdtoCount.containskey(AccountId)){
                acc.Contact_count__c = ConIdtoCount.get(AccountId);

            }else{
                acc.Contact_count__c = 0 ;
            }
            AcclistToupdate.add( acc );
            
        }
        
        if(!AcclistToupdate.isEmpty()){
			update AcclistToupdate ; 	
        }
        
    }
    
    public static void updateCountsOnAccount( list<Contact> contactlist ){
        Set<Id> accIds = new Set<Id>();
        
        for( Contact con : contactlist ){
            if( con.AccountId != null ){
                accIds.add(con.AccountId);
            }
        }
        
        triggerOnAccountHandler.UpdateCountOnAccount(accIds);
        
    }
    
    
    
    
    
    
    
    
    
    
    	
}