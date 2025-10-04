public class CreateAccountContactOpportunity {
    
    public Account acc {get ; set ;}
    public List<Contact> conlist {get ; set ; }
    public List<Opportunity> opplist {get ; set ; }
    
    public CreateAccountContactOpportunity(){
        
        acc = new Account();
        conlist = new List<Contact>{ new Contact ()};
        opplist = new List<Opportunity>{ new Opportunity()};
        
    }
    
    public PageReference saveAcc(){
        
        insert acc ; 
       
        for(Contact con : conlist ){
            con.AccountId = acc.Id ; 
            
        }
         insert conlist ; 
        
        for( Opportunity opp : opplist ){
            
            opp.AccountId = acc.Id ; 
        }
        
        insert opplist ; 
        
        return new PageReference('/'+acc.Id).setRedirect(true);
        
        
    }
    
    public PageReference cancleAcc(){
        
        return new PageReference('/'+ acc.Id).setRedirect(true);
        
    }

}