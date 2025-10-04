public class FetchRelatedContact {

    public String ids {get ; set ; }
    public List <Contact> conlist {get ; set ;}
    public List<Contact> newconlist {get ; set ;}
    public Integer deleteIndex {get ; set ; }
    public Integer deletecon { get ; set ;}
    
    public FetchRelatedContact(){
        conlist = new List<Contact>();
        newconlist = new List<Contact>();
       // ids =Apexpages.currentPage().getparameters().get('id');
         ids =  ApexPages.currentPage().getParameters().get('id');
        System.debug(ids);
        conlist = [select id , firstName , lastname , phone , Email from Contact where AccountId =:ids ];
        System.debug('conlist ===> ' + conlist);
        
        AddContact();
       
    }
    
            public void AddContact(){  
              newconlist.add(new Contact());
			}
            
    public pagereference updateconlist (){
       	
        for( Contact con : newconlist){
            con.AccountId = ids ; 
        }
         insert newconlist ;        
       	 update conlist ;  
        
       return new pagereference('/'+ ids).setRedirect(true);
    }
    
    public pagereference cancelconlist(){
        
        return new pagereference('/'+ ids);
    }
    
		public pagereference deletecon(){
            	
            delete conlist[deleteIndex];
			return new pagereference('/apex/FetchRelatedContact_vfp?id' + ids).setRedirect(true);            
        }
    
    // New Delete Button 
    public PageReference DeleteContact() {
    Id contactId = ApexPages.currentPage().getParameters().get('contactId');
    if (contactId != null) {
        delete [SELECT Id FROM Contact WHERE Id = :contactId];
    }
    return new PageReference('/apex/FetchRelatedContact_vfp?id=' + ids).setRedirect(true);
}
  
    
    
}