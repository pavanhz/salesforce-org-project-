public class triggerOnOpportunityaHandler {
    
    public static void UpdateCountOnAccount( List<Opportunity> Oppolist ){
         Set<Id> accIds = new Set<Id>();
        
        for( Opportunity op : Oppolist){
            if( op.AccountId != null){
                accIds.add( op.AccountId);
            }
        }
        triggerOnAccountHandler.UpdateCountOnAccount(accIds);
        
    }
    
	// Avoid Duplication  insertion of Account 
    public static void AvoidDuplicateRecords( List<Opportunity> OpportunityList ){
         Set< String > Nameset = new Set< String >();
		 Set< String > ParentAccount = new Set <String>();
        
        for( Opportunity Opplist : OpportunityList){
            if( Opplist.AccountId != null ){
               ParentAccount.add(Opplist.AccountId); 
            }
            if( Opplist.Name != null ){
                Nameset.add(Opplist.Name);
            }
        }
        
       List<Opportunity> UpdateOppotunity = [ select id , Name , AccountId from Opportunity where Name IN: Nameset OR AccountId IN:ParentAccount];
       
        Map<String , Opportunity> NameMap = new Map<String , Opportunity >();
        Map<String , Opportunity> ParentMap = new Map<String , Opportunity >();
        
        if(!UpdateOppotunity.isEmpty()){
            for( Opportunity updateOp : UpdateOppotunity){
                if( updateop.Name != null){
                    NameMap.put(updateop.Name,updateop );
                }
                if( updateop.AccountId != null){
                    ParentMap.put(updateop.AccountId , updateop);
                }
        	} 
        }
        
        for( Opportunity op : OpportunityList){
            
            if( op.Name != null &&  NameMap.containskey(op.Name) && op.Id != NameMap.get(op.Name).Name) {
                op.addError('Opporunity Duplicate  record Found ! ' + op.Name );
            }
            if( op.AccountId != null && ParentMap.containskey(op.AccountId) && op.Id !=ParentMap.get(op.AccountId).Id){
                op.addError(' Related Recored alredy exit in under This AccountId  ');
            }
        }
        

        
    }
    	
    // Coount The Numbers Of Opportunity realted to Account 
     public static void CountOpporunityOnAccount( List<Opportunity> Opplist){
         Set<Id> AccIds = new Set<Id>();
         
         for( Opportunity Opp : Opplist ){
             AccIds.add(Opp.AccountId);
		}
         if(AccIds.isEmpty()){
             return ; 
         }
       
         Map< Id , Integer > CountOfOpp = new Map<Id , Integer>();
         
         for( AggregateResult  ar : [ select AccountId , COUNT(Id)cnt
                                   from Opportunity
                                   where AccountId IN : AccIds 
                                   GROUP BY AccountId  ]){
             CountOfOpp.put((Id)ar.get('AccountId') , (Integer)ar.get('cnt'));
         }
         
         List<Account> AccountTOupdate = new List<Account>();
         for( Id AccountId : Accids ){
             Account acc = new Account(Id = AccountId);
             
             if( CountOfOpp.containskey(AccountId)){
                 acc.Opportunity_count__c = CountOfOpp.get(AccountId);
             }else{
                 acc.Opportunity_count__c = 0 ;
             }
             
             AccountTOupdate.add( acc );
			}
       
         if(!AccountTOupdate.isEmpty()){
             update AccountTOupdate ; 
         }
     }
    
    
    
    
    
    
    
    
    
}