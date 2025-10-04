public class CreateAccConOpp {
	
    public Account acclist {get ; set ; }
    public List <Contact> conlist {get ; set ; }
    public List <Opportunity> opplist {get ; set ; }
    
    public CreateAccConOpp(){
        
        acclist = new Account();
        conlist = new List <Contact>{new Contact()};
        opplist = new List <Opportunity>{new Opportunity()};
        
    }
     
    public pagereference save(){
        
        insert acclist; 
        
        for(Contact c : conlist){
            c.AccountId = acclist.id ; 
        }
         insert conlist ; 
        
        for(Opportunity opp : Opplist){
            opp.AccountId = acclist.Id ;
        }
         
        insert Opplist ; 
        return new pagereference('/' + acclist.Id).setRedirect(true);
    }
    
    public pagereference cancle(){
        
        return new pagereference('/'+ acclist.id).setRedirect(true);
    }
    
    
}