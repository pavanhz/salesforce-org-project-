public class FetchRelatedOpp {
    
    public String ids {get ; set ;}
    public List<Opportunity> opplist {get ; set ;}
    public List<Opportunity> newopplist {get ; set ;}
    
    public FetchRelatedOpp(){
        
        ids = Apexpages.currentPage().getparameters().get('id');
        System.debug(ids);
        opplist = new List<Opportunity>();
        System.debug(opplist);
        newopplist = new List<Opportunity>();
        
        System.debug(newopplist);
        
        opplist = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE AccountId = :ids];

        
        System.debug(opplist);
        
        
       
                
    }
    
   
    
    public PageReference AddOpportunity(){
        newopplist.add(new Opportunity());
        return null ; 
    }
    
	    public PageReference updateopp(){
            for(Opportunity o : newopplist){
                o.AccountId = ids ;                 
            }
            insert newopplist ;          
            update opplist ; 
            AddOpportunity();
            return new PageReference('/'+ids).setRedirect(true);
          
 	   }
    
    public PageReference cancelopp(){
        
        return new PageReference('/'+ids).setRedirect(true);
    }
    
    	
    	
		
}