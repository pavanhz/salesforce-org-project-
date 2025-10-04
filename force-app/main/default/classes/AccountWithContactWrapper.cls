public class AccountWithContactWrapper {
    public List<AccWrapper> wrapperlist { get ;set ; }
    public List<AccWrapper> selectlist {get ;set ;}
    
    public AccountWithContactWrapper(){
        wrapperlist = new List<AccWrapper>();
        selectlist = new List<AccWrapper>();
        for( Account ac : [select id , Name , phone , Industry from Account]){
            wrapperlist.add(new AccWrapper(ac));
        }        
    }
    public void selectContact(){
        for( AccWrapper wrap : wrapperlist){
            if(wrap.ischeck == true ){
                wrap.conlist = [ select Id , lastName , phone , email FROM Contact WHERE AccountId = : wrap.acc.id ];
                wrap.opplist = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE AccountId = :wrap.acc.id ];
                selectlist.add(wrap);
            }
            wrap.ischeck = false ; 
        } 
    }	
    
    public class AccWrapper{
        public Account acc {get; set ; }
        public Boolean ischeck {get ;set ; }
        public List<Contact> conlist { get ;set ;}
        public Boolean conischeck {get ;set ;}
        public List<Opportunity> opplist { get ;set ; }
        public Boolean oppischeck { get ; set ; }
        
        public AccWrapper( Account acc){
            this.acc = acc ; 
            this.ischeck = false ; 
            this.conlist = new List<Contact>();
            this.conischeck = false ; 
            this.opplist = new List<Opportunity>();
            this.oppischeck = false ; 
            
            
        }
    }

}